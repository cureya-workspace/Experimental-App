export function preparedFetchRequest({
  url,
  method,
  includeCredentials,
  headers,
}: {
  url: string;
  method: "GET" | "PUT" | "POST" | "DELETE";
  includeCredentials: boolean;
  headers?: any;
}) {
  return async (body?: any) => {
    const response = await fetch(`${url}`, {
      body: method === 'POST' || method === 'PUT' ? JSON.stringify(body) || undefined : undefined,
      credentials: includeCredentials ? "include" : undefined,
      method: method,
      headers: {
        "Content-Type": "application/json",
        ...headers,
      },
    });

    const resJson = await response.json();

    if (!response.ok) {
      throw new Error(resJson.message);
    }

    return resJson;
  };
}
