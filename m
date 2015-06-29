From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Mon, 29 Jun 2015 11:38:26 +0200
Message-ID: <20150629093826.GE28471@dhcp22.suse.cz>
References: <20150625133138.GH14324@thunk.org>
 <558C06F7.9050406@kyup.com>
 <20150625140510.GI17237@dhcp22.suse.cz>
 <558C116E.2070204@kyup.com>
 <20150625151842.GK17237@dhcp22.suse.cz>
 <558C1DCE.1010705@kyup.com>
 <20150629083243.GB28471@dhcp22.suse.cz>
 <55910AEA.2030205@kyup.com>
 <20150629091629.GC28471@dhcp22.suse.cz>
 <55910E84.3000106@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Marian Marinov <mm@1h.com>
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbbF2Ji2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jun 2015 05:38:28 -0400
Content-Disposition: inline
In-Reply-To: <55910E84.3000106@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 29-06-15 12:23:16, Nikolay Borisov wrote:
> 
> 
> On 06/29/2015 12:16 PM, Michal Hocko wrote:
> > On Mon 29-06-15 12:07:54, Nikolay Borisov wrote:
> >>
> >>
> >> On 06/29/2015 11:32 AM, Michal Hocko wrote:
> >>> On Thu 25-06-15 18:27:10, Nikolay Borisov wrote:
> >>>>
> >>>>
> >>>> On 06/25/2015 06:18 PM, Michal Hocko wrote:
> >>>>> On Thu 25-06-15 17:34:22, Nikolay Borisov wrote:
> >>>>>> On 06/25/2015 05:05 PM, Michal Hocko wrote:
> >>>>>>> On Thu 25-06-15 16:49:43, Nikolay Borisov wrote:
> >>>>>>> [...]
> >>>>>>>> How would you advise to rectify such situation?
> >>>>>>>
> >>>>>>> As I've said. Check the oom victim traces and see if it is holding any
> >>>>>>> of those locks.
> >>>>>>
> >>>>>> As mentioned previously all OOM traces are identical to the one I've
> >>>>>> sent - OOM being called form the page fault path.
> >>>>>  
> >>>>> By identical you mean that all of them kill the same task? Or just that
> >>>>> the path is same (which wouldn't be surprising as this is the only path
> >>>>> which triggers memcg oom killer)?
> >>>>
> >>>> The code path is the same, the tasks being killed are different
> >>>
> >>> Is the OOM killer triggered only for a singe memcg or others misbehave
> >>> as well?
> >>
> >> Generally OOM would be triggered for whichever memcg runs out of
> >> resources but so far I've only observed that the D state issue happens
> >> in a single containers.
> > 
> > It is not clear whether it is the OOM memcg which has tasks in the D
> > state. Anyway I think it all smells like one memcg is throttling others
> > on another shared resource - journal in your case.
> 
> Be that as it may, how do I find which cgroup is the culprit?

Ted has already described that. You have to check all the running tasks
and try to find which of them is doing the operation which blocks
others. Transaction commit sounds like the first one to check.
-- 
Michal Hocko
SUSE Labs
