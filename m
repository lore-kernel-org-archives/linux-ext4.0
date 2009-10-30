From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 30 Oct 2009 18:05:36 GMT
Message-ID: <200910301805.n9UI5aFH016683@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41943 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741AbZJ3SFc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 14:05:32 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9UI5ac5016685
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2009 18:05:36 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #157 from Linus Torvalds <torvalds@linux-foundation.org>  2009-10-30 18:05:28 ---
On Fri, 30 Oct 2009, bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> Well I've been doing bisects but I'm getting skeptical of the results; 
> either my testcase isn't reliable enough or all the merges are confusing 
> git-bisect (?)  Anyway it keeps ending up on nonsensical commits.

Merges don't confuse git-bisect (lots of merges may make bisection 
slightly less _efficient_, though, because it can be impossible to find 
commits that are nicely "in the middle"), but the way bisection works, 
even a _single_ wrong "git bisect good/bad" statement can - and will - 
make bisection results go off totally in the weeds.

Bisection is designed to be efficient, which is absolutely wonderful when 
you have a 100% unambiguous bug that needs to be found in 10,000 commits. 
It's what gives us that nice log2() behavior.

But the downside of that efficiency is the same as the downside of any 
very efficient data compression with no checksum: there is absolutely zero 
redundancy. So then if even just a single bit of information (in this case 
the "good/bad" info) is wrong, the end result will not just be wrong - it 
will be _disastrously_ wrong, and you won't even be anywhere _close_ to 
the correct end result.

[ In fact, the way bisection works, if you give a single incorrect 
  bisection point, the end result will usually be close to the commit you 
  incorrectly marked, rather than the actual buggy commit you searched 
  for.

  That _can_ be used as a hint when you're unsure - when getting a clearly 
  bogus bisection result, you can look at the bisect log, and try to find 
  the first commit in the log that is close to the clearly bogus result, 
  and you might decide to re-test that commit more carefully. And then if, 
  on re-testing, it turns out that you had been wrong the first time, you 
  might be able to avoid re-doing the whole bisection thing, and instead 
  re-do the log up to the incorrect - and now fixed - entry, and continue 
  from there. ]

That said, if you end up being uncertain about the bisection points, and 
can't give more than a "95% confidence", bisection will almost inevitably 
fail. A bug that is timing-dependent can be almost impossible to bisect. 
Even if you can reliably trigger it _eventually_, you may have to test so 
long at each bisection point that bisection becomes practically useless.

        Linus

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
