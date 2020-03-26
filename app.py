import time, json, io, datetime
from flask import Flask, request, render_template

app = Flask(__name__)

@app.route('/')
def get_index():
    count = 0
    return 'v2\n'.format(count)

@app.route('/ad')
def get_ad():
    return 'ad\n'.format()

@app.route("/ad-event", methods=['GET', 'POST'])
def submit():
    if request.method == 'POST':
        return 'Hello ' + request.form.get('adname')    
    return render_template('post_ad.html')

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)

