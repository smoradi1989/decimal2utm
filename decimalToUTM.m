function [easting, northing, zone, hemi] = decimalToUTM(lat, lon)
    % Constants
    a = 6378137; % Semi-major axis of WGS84 ellipsoid (meters)
    f = 1 / 298.257223563; % Flattening of WGS84 ellipsoid
    e2 = 2 * f - f^2; % First eccentricity squared
    k0 = 0.9996; % Scale factor

    % Determine UTM zone
    zone = floor((lon + 180) / 6) + 1;
    if lat < 0
        hemi = 'S'; % Southern hemisphere
    else
        hemi = 'N'; % Northern hemisphere
    end

    % Central meridian of the UTM zone
    lambda0 = deg2rad((zone - 1) * 6 - 180 + 3);

    % Convert latitude and longitude to radians
    phi = deg2rad(lat);
    lambda = deg2rad(lon);

    % Eccentricity terms
    esq = e2 / (1 - e2);
    v = a / sqrt(1 - e2 * sin(phi)^2);
    psi = v / (1 - e2) * (1 + esq * cos(phi)^2);

    % Intermediate calculations
    t = tan(phi)^2;
    eta2 = esq * cos(phi)^2;

    % Calculate easting and northing
    A = (lambda - lambda0) * cos(phi);
    M = a * ((1 - e2 / 4 - 3 * e2^2 / 64 - 5 * e2^3 / 256) * phi ...
             - (3 * e2 / 8 + 3 * e2^2 / 32 + 45 * e2^3 / 1024) * sin(2 * phi) ...
             + (15 * e2^2 / 256 + 45 * e2^3 / 1024) * sin(4 * phi) ...
             - (35 * e2^3 / 3072) * sin(6 * phi));

    easting = 500000 + k0 * v * (A + (1 - t + eta2) * A^3 / 6 + (5 - 18 * t + t^2 + 72 * eta2 - 58 * esq) * A^5 / 120);
    northing = k0 * (M + v * tan(phi) * (A^2 / 2 + (5 - t + 9 * eta2 + 4 * eta2^2) * A^4 / 24 + (61 - 58 * t + t^2 + 600 * eta2 - 330 * esq) * A^6 / 720));

    % Adjust northing for southern hemisphere
    if strcmp(hemi, 'S')
        northing = northing + 10000000;
    end
end

