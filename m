From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Thu, 25 Jun 2015 13:50:25 +0200
Message-ID: <20150625115025.GD17237@dhcp22.suse.cz>
References: <558BD447.1010503@kyup.com>
 <558BD507.9070002@kyup.com>
 <20150625112116.GC17237@dhcp22.suse.cz>
 <558BE96E.7080101@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Marian Marinov <mm@1h.com>
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbbFYLu0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jun 2015 07:50:26 -0400
Content-Disposition: inline
In-Reply-To: <558BE96E.7080101@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 25-06-15 14:43:42, Nikolay Borisov wrote:
> I do have several OOM reports unfortunately I don't think I can
> correlate them in any sensible way to be able to answer the question
> "Which was the process that was writing prior to the D state occuring".
> Maybe you can be more specific as to what am I likely looking for?

Is the system still in this state? If yes I would check the last few OOM
reports which will tell you the pid of the oom victim and then I would
check sysrq+t whether they are still alive. And if yes check their stack
traces to see whether they are still in the allocation path or they got
stuck somewhere else or maybe they are not related at all...

sysrq+t might be useful even when this is not oom related because it can
pinpoint the task which is blocking your waiters.
-- 
Michal Hocko
SUSE Labs
