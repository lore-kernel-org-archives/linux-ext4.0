From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Thu, 25 Jun 2015 17:34:22 +0300
Message-ID: <558C116E.2070204@kyup.com>
References: <558BD447.1010503@kyup.com> <558BD507.9070002@kyup.com> <20150625112116.GC17237@dhcp22.suse.cz> <558BE96E.7080101@kyup.com> <20150625115025.GD17237@dhcp22.suse.cz> <20150625133138.GH14324@thunk.org> <558C06F7.9050406@kyup.com> <20150625140510.GI17237@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Marian Marinov <mm@1h.com>
To: Michal Hocko <mhocko@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.siteground.com ([67.19.240.234]:53537 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbbFYOe0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jun 2015 10:34:26 -0400
In-Reply-To: <20150625140510.GI17237@dhcp22.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/25/2015 05:05 PM, Michal Hocko wrote:
> On Thu 25-06-15 16:49:43, Nikolay Borisov wrote:
> [...]
>> How would you advise to rectify such situation?
> 
> As I've said. Check the oom victim traces and see if it is holding any
> of those locks.

As mentioned previously all OOM traces are identical to the one I've
sent - OOM being called form the page fault path.

