import { useState } from "react"

const API = import.meta.env.VITE_API || "http://127.0.0.1:8000"

export default function App() {
  const [prompt, setPrompt] = useState("Salut AiMax!")
  const [out, setOut] = useState("")
  const [loading, setLoading] = useState(false)

  async function send() {
    setLoading(true)
    try {
      const r = await fetch(`${API}/chat`, {
        method: "POST",
        headers: {"Content-Type":"application/json"},
        body: JSON.stringify({ provider: "openai", prompt })
      })
      const j = await r.json()
      setOut(j.output ?? JSON.stringify(j))
    } catch (e) {
      setOut(String(e))
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{maxWidth:760, margin:"40px auto", fontFamily:"system-ui, sans-serif"}}>
      <h1>AiMax Dashboard</h1>
      <p>Test rapid: API local FastAPI pe <code>http://127.0.0.1:8000</code></p>
      <div style={{display:"flex", gap:8}}>
        <input value={prompt} onChange={e=>setPrompt(e.target.value)}
               style={{flex:1, padding:12, border:"1px solid #ccc", borderRadius:8}} />
        <button onClick={send} disabled={loading}
                style={{padding:"10px 16px", borderRadius:8, border:"1px solid #888"}}>
          {loading ? "..." : "Send"}
        </button>
      </div>
      <pre style={{marginTop:16, background:"#0b1020", color:"#a7ffb7", padding:12, borderRadius:8, minHeight:120}}>
{out}
      </pre>
    </div>
  )
}
