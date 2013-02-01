From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 7/9 v4] ext4: remove single extent cache
Date: Fri, 1 Feb 2013 11:08:23 +0800
Message-ID: <20130201030823.GB10176@gmail.com>
References: <1359609477-29845-1-git-send-email-wenqing.lz@taobao.com>
 <1359609477-29845-8-git-send-email-wenqing.lz@taobao.com>
 <20130131170543.GG4612@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f51.google.com ([209.85.210.51]:62794 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab3BACy3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jan 2013 21:54:29 -0500
Received: by mail-da0-f51.google.com with SMTP id i30so1534675dad.38
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jan 2013 18:54:29 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130131170543.GG4612@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 31, 2013 at 06:05:43PM +0100, Jan Kara wrote:
> On Thu 31-01-13 13:17:55, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Single extent cache could be removed because we have extent status tree
> > as a extent cache, and it would be better.
>   Just one note: The original extent cache has a capability of containing
> information "there's a hole in range x-y" so we don't have to walk the tree
> again only to find there's nothing for given block. It might be useful to
> put this extent type in extent status tree as well for caching purposes...

Yes, when I removed extent cache, I hesitated whether or not a new status
for a hole is added because that might occupies too much memory.  Let me
consider what happens after adding this status.  If we have a fragmented
file that has 2048 extents, we will cost double spaces to track these
holes in memory when a grep(1) is run.  *But* now I think maybe you are
right because extent status tree has ability to reclaim memory when we
are under a high memory pressure.  Meanwhile tracking all holes for a
file let us avoid to walk the extent tree in disk.

FWIW, I revise the patch (ext4: Remove bogus wait for unwritten extents
in ext4_ind_direct_IO) and I have an idea that let us not flush
unwritten io using extent status tree, and I will try it.

Thanks,
                                                - Zheng
