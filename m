From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Thu, 25 Jun 2015 15:05:00 +0300
Message-ID: <558BEE6C.9090604@kyup.com>
References: <558BD447.1010503@kyup.com> <558BD507.9070002@kyup.com> <20150625112116.GC17237@dhcp22.suse.cz> <558BE96E.7080101@kyup.com> <20150625115025.GD17237@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Marian Marinov <mm@1h.com>
To: Michal Hocko <mhocko@suse.cz>, Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.siteground.com ([67.19.240.234]:52105 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbbFYMFD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jun 2015 08:05:03 -0400
In-Reply-To: <20150625115025.GD17237@dhcp22.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Unfortunately the system is not in this state, the server had to be
rebooted, however I've got the syslog from that time frame and the pids
which were OOM'ed. I will sift through the logs for anything useful.

On 06/25/2015 02:50 PM, Michal Hocko wrote:
> On Thu 25-06-15 14:43:42, Nikolay Borisov wrote:
>> I do have several OOM reports unfortunately I don't think I can
>> correlate them in any sensible way to be able to answer the question
>> "Which was the process that was writing prior to the D state occuring".
>> Maybe you can be more specific as to what am I likely looking for?
> 
> Is the system still in this state? If yes I would check the last few OOM
> reports which will tell you the pid of the oom victim and then I would
> check sysrq+t whether they are still alive. And if yes check their stack
> traces to see whether they are still in the allocation path or they got
> stuck somewhere else or maybe they are not related at all...
> 
> sysrq+t might be useful even when this is not oom related because it can
> pinpoint the task which is blocking your waiters.
> 
