function deferred_acceptance(prop_prefs,resp_prefs,caps)

    m = size(prop_prefs,2)
    n = size(resp_prefs,2)
    prop_matches = zeros(Int64,m)
    L = sum(caps)
    resp_matches = zeros(Int64,L)
    unchanged_counter = 0
    next_m_approach = ones(Int64,m)
    
    indptr = Array(Int,n+1)
    indptr[1] = 1
    for i in 1:n
        indptr[i+1] = indptr[i] + caps[i]
    end
    
    while unchanged_counter < m
        unchanged_counter = 0
        for h in 1:m
            if prop_matches[h] == 0
                d = prop_prefs[next_m_approach[h],h]
                if d == 0
                    prop_matches[h] = 0
                    unchanged_counter += 1
                    
                else
                    a=resp_matches[indptr[d]:indptr[d+1]-1]
                    b=zeros(Int64,caps[d])
                    for i in 1:caps[d]
                        b[i] = findfirst(resp_prefs[:,d],a[i])
                    end
                    c = maximum(b)
                    if c > findfirst(resp_prefs[:,d],h)
                        prop_matches[h] = d
                        r = findfirst(a,resp_prefs[c,d])
                        if resp_matches[indptr[d]-1+r] != 0
                            prop_matches[resp_prefs[c,d]] = 0
                            next_m_approach[resp_prefs[c,d]] += 1
                        end
                        resp_matches[indptr[d]-1+r] = h
                    else #Žó‚¯“ü‚ê‚È‚¢‚Æ‚«
                        next_m_approach[h] += 1
                    end
                end
            else unchanged_counter += 1 
            end
        end
    end
    return prop_matches,resp_matches,indptr
end

function deferred_acceptance(prop_prefs,resp_prefs)
    caps = ones(Int, size(resp_prefs, 2))
    prop_matches, resp_matches, indptr =
        deferred_acceptance(prop_prefs, resp_prefs, caps)
    return prop_matches, resp_matches
end