From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: prevent ext4_quota_write() from failing due to
 ENOSPC
Date: Fri, 26 Jun 2015 19:44:45 -0400
Message-ID: <20150626234445.GA474@thunk.org>
References: <1434864462-24300-1-git-send-email-tytso@mit.edu>
 <20150623142545.GA11771@thunk.org>
 <20150623162917.GQ2427@quack.suse.cz>
 <20150626150041.GI6271@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57322 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbbFZXot (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Jun 2015 19:44:49 -0400
Content-Disposition: inline
In-Reply-To: <20150626150041.GI6271@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 26, 2015 at 05:00:41PM +0200, Jan Kara wrote:
> 
> The attached patch propagates errors from quota creation up into the caller
> so now chown will return ENOSPC... The patch seems to work for me. Can you
> check whether it fixes the failures you are seeing? If yes, I'll merge the
> patch through my tree.

I ran "kvm-xfstests -C 5 generic/270" with this patch applied and I'm
not seeing any failures.  So this seems to solve the issue!

    	       		     	  	- Ted
