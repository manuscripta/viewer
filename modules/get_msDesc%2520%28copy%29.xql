xquery version "3.0";

import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";

let $doc := ...



     : //titleStmt/title/text()


return

    <msform>
        <Tabs>
            <Tab name="Header">
                <fieldset>
                    <legend>File description</legend>
                    <MsTitle id='title'/>
                    
                    <fieldset>
                        <legend>respStmt</legend>
                        <ZeroOrMore>
                            <RespStmt />
                        </ZeroOrMore>
                    </fieldset>
                </fieldset>
            </Tab>
            <Tab name="Binding">
            </Tab>
            ...
        </Tabs>
    </msform>
