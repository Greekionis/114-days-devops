from http.server import HTTPServer, BaseHTTPRequestHandler

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'Hello from a custom container\n')

    def log_message(self, format, *args):
        pass  # silence default logging

HTTPServer(('0.0.0.0', 8000), Handler).serve_forever()
