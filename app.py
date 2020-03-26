import time, json, io, datetime
from quart import Quart

app = Quart(__name__)

@app.route('/')
def get_index():
    count = 0
    return 'v1\n'.format(count)

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)

