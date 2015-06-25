From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Thu, 25 Jun 2015 15:58:59 +0200
Message-ID: <20150625135859.GH17237@dhcp22.suse.cz>
References: <558BD447.1010503@kyup.com>
 <558BD507.9070002@kyup.com>
 <20150625112116.GC17237@dhcp22.suse.cz>
 <558BE96E.7080101@kyup.com>
 <20150625115025.GD17237@dhcp22.suse.cz>
 <558C023B.1040204@kyup.com>
 <20150625134558.GF17237@dhcp22.suse.cz>
 <558C080F.7040104@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Marian Marinov <mm@1h.com>
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbbFYN7A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jun 2015 09:59:00 -0400
Content-Disposition: inline
In-Reply-To: <558C080F.7040104@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 25-06-15 16:54:23, Nikolay Borisov wrote:
> 
> 
> On 06/25/2015 04:45 PM, Michal Hocko wrote:
[...]
> > memcg oom killer ignores oom_kill_allocating_task so the victim might be
> > different from the current task. That means the victim might get stuck
> > behind a lock held by somebody else. If the ext4 journaling code depends
> > on memcg charges and retry endlessly then the waiters would get stuck as
> > well.
> 
> I've patched the cgroup OOM so that it takes into account the
> oom_kill_allocating_task.

I am not very much keen on this configuration because it behaves very
randomly and I am pretty sure it will just paper over the real issue
here.

-- 
Michal Hocko
SUSE Labs
