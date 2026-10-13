from pprint import pprint

from services.routing_service import (
    get_both_route_options,
)

user_location = (
    24.4683,
    39.6108,
)


dar_al_madinah = (
    24.47676,
    39.68768,
)


print("\nخيارات التنقل")
print("=" * 50)

result = get_both_route_options(
    origin=user_location,
    destination=dar_al_madinah,
)

pprint(result)
