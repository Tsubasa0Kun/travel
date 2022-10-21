

airline_info_container <- tabPanel(title = "Flight", 
                          value = "airline_info_container",
                          hr(),
                          fluidPage(
                            style = "border-style: solid; border-width: 1px;border-color: #D3D3D3",
                            h2("Overall Information for Airline"),
                            hr(style = "width: 400px"),
                            
                            HTML(paste("<div class='tableauPlaceholder' id='viz1666197602266' style='position: relative'>
                                  <noscript><a href='#'>
                                  <img alt='Flight To Melbourne ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Ai&#47;Airline_16657631426410&#47;FlightToMelbourne&#47;1_rss.png' style='border: none' />
                                  </a>
                                  </noscript>
                                  <object class='tableauViz'  style='display:none;'>
                                  <param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' />
                                  <param name='embed_code_version' value='3' />
                                  <param name='site_root' value='' />
                                  <param name='name' value='Airline_16657631426410&#47;FlightToMelbourne' />
                                  <param name='tabs' value='no' />
                                  <param name='toolbar' value='yes' />
                                  <param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Ai&#47;Airline_16657631426410&#47;FlightToMelbourne&#47;1.png' /> 
                                  <param name='animate_transition' value='yes' />
                                  <param name='display_static_image' value='yes' />
                                  <param name='display_spinner' value='yes' />
                                  <param name='display_overlay' value='yes' />
                                  <param name='display_count' value='yes' />
                                  <param name='language' value='en-US' />
                                  <param name='filter' value='publish=yes' />
                                  </object>
                                  </div>     
                                  <script type='text/javascript'>        
                                  var divElement = document.getElementById('viz1666197602266');          
                                  var vizElement = divElement.getElementsByTagName('object')[0];     
                                  if ( divElement.offsetWidth > 800 ) { vizElement.style.width='1324px';vizElement.style.height='895px';} 
                                  else if ( divElement.offsetWidth > 500 ) { vizElement.style.width='1324px';vizElement.style.height='895px';} 
                                  else { vizElement.style.width='100%';vizElement.style.height='950px';}               
                                  var scriptElement = document.createElement('script');             
                                  scriptElement.src = 'https://public.tableau.com/javascripts/api/viz_v1.js';        
                                  vizElement.parentNode.insertBefore(scriptElement, vizElement);        
                                  </script>")),
                            br(),
                            h2("Detail Information For Airline"),
                            hr(style = "width: 400px"),
                            dataTableOutput("mytable")
                          )
)