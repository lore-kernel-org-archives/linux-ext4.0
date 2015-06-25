From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Thu, 25 Jun 2015 17:18:42 +0200
Message-ID: <20150625151842.GK17237@dhcp22.suse.cz>
References: <558BD447.1010503@kyup.com>
 <558BD507.9070002@kyup.com>
 <20150625112116.GC17237@dhcp22.suse.cz>
 <558BE96E.7080101@kyup.com>
 <20150625115025.GD17237@dhcp22.suse.cz>
 <20150625133138.GH14324@thunk.org>
 <558C06F7.9050406@kyup.com>
 <20150625140510.GI17237@dhcp22.suse.cz>
 <558C116E.2070204@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Marian Marinov <mm@1h.com>
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbbFYPSo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jun 2015 11:18:44 -0400
Content-Disposition: inline
In-Reply-To: <558C116E.2070204@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 25-06-15 17:34:22, Nikolay Borisov wrote:
> On 06/25/2015 05:05 PM, Michal Hocko wrote:
> > On Thu 25-06-15 16:49:43, Nikolay Borisov wrote:
> > [...]
> >> How would you advise to rectify such situation?
> > 
> > As I've said. Check the oom victim traces and see if it is holding any
> > of those locks.
> 
> As mentioned previously all OOM traces are identical to the one I've
> sent - OOM being called form the page fault path.
 
By identical you mean that all of them kill the same task? Or just that
the path is same (which wouldn't be surprising as this is the only path
which triggers memcg oom killer)?

-- 
Michal Hocko
SUSE Labs
