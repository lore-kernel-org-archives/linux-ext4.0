From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
	carefully
Date: Tue, 9 Sep 2008 07:51:05 -0400
Message-ID: <20080909115105.GB14052@infradead.org>
References: <20080905210652.GE11569@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ralf.hildebrandt@charite.de, akpm@osdl.org,
	linux-ext4@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42261 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYIILvM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 07:51:12 -0400
Content-Disposition: inline
In-Reply-To: <20080905210652.GE11569@x200.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 06, 2008 at 01:06:52AM +0400, Alexey Dobriyan wrote:
> Ralf, please confirm.
> 
> 
> 
> [PATCH] ext4: fix #11321: create /proc/ext4/*/stats more carefully
> 
> ext4 creates per-suberblock directory in /proc/ext4/ . Name used as
> basis is taken from bdevname, which, surprise, can contain slash.
> 
> However, proc while allowing to use proc_create("a/b", parent) form of
> PDE creation, assumes that parent/a was already created.
> 
> bdevname in question is 'cciss/c0d0p9', directory is not created and all
> this stuff goes directly into /proc (which is real bug).
> 
> Warning comes when _second_ partition is mounted.

Two issues with this.  First filesystems should never call
bdevname(sb->s_bdev, ...), but alwasy us s->s_id which has this
pre-calculated and avoids the big on-stack array.  Second this
conversion really isn't extN specific, so I'd rather do it in
get_sb_bdev so one places takes care of all uses, instead of
re-inventing it in lots of places.

