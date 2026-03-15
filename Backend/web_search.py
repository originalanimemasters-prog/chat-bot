from duckduckgo_search import DDGS


def search_web(query, max_results=5):

    results_text = ""

    with DDGS() as ddgs:

        results = ddgs.text(query, max_results=max_results)

        for r in results:

            title = r.get("title", "")
            body = r.get("body", "")
            link = r.get("href", "")

            results_text += f"""
Title: {title}
Snippet: {body}
Source: {link}

"""

    return results_text