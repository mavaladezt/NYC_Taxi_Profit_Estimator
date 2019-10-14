<h2>NYC Yellow Taxi Estimator</h2>
<p>This Shiny App is meant for estimating the profit of the NYC Yellow Taxis.</p>
<p>I am not claiming that the model is accurate but it is a tool for determining fare increases/cost analysis.</p>
<p>&nbsp;</p>
<h3>Data</h3>
<p>Data was obtained from:&nbsp;<a href="https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page">https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page</a></p>
<p>Working with 2019 data (Jan-Jun).</p>
<ul>
<li>Filtered transactions that had duration of more than 2 hrs.</li>
<li>Filtered trips with 'zero' fare.</li>
<li>Filtered transactions that were not paid by Credit Card or Cash.</li>
<li>If driver didn't captured number of passengers I assumed there was only 1 passenger.</li>
</ul>
<h3>&nbsp;</h3>
<h3>Model Assumptions</h3>
<p>All the main variables are contained in the "Model" section and can be modified by the user in a simulation-like form.</p>
<ul>
<li>Profit is an estimation of Fare + Extra - costs. Tips in some cases can be included too as a total profit in the system but I decided not to include it for now.</li>
<li>Estimated profit excludes tolls, MTA and improvement fees since the Taxi company transfers its to the State or City.</li>
<li>There is a replacement of the net car cost (purchase price - estimated resale value) so that the Taxi company is able to renew cars.</li>
<li>Cost of Medallion is not included since the basic assumption of the model is that the medallion price doesn't increase/decrease over time.</li>
</ul>
<p>&nbsp;</p>
<h3>Takeaways</h3>
<p>The main takeaways of the App is that labor cost is the main deciding factor in taxi business.</p>
