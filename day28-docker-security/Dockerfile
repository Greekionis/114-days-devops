FROM nginx:alpine

# Create non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Change both IPv4 and IPv6 listen ports to 8090
RUN sed -i 's/80;/8090;/g' /etc/nginx/conf.d/default.conf

# Move the PID file to /tmp so non-root user never hits permission issues
RUN sed -i 's|/run/nginx.pid|/tmp/nginx.pid|g' /etc/nginx/nginx.conf

# Give appuser ownership of Nginx directories
RUN chown -R appuser:appgroup /var/cache/nginx /var/log/nginx /usr/share/nginx/html /etc/nginx/conf.d

COPY index.html /usr/share/nginx/html/index.html

# Switch to non-root user
USER appuser

EXPOSE 8090
