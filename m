From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Re: ext4 metadata corruption bug?
Date: Wed, 6 Aug 2014 10:53:45 +0200
Message-ID: <20140806085345.GM25902@dot.freshdot.net>
References: <20140420163211.GT10985@gradx.cs.jhu.edu>
 <20140423072311.GD10163@dot.freshdot.net>
 <20140423143642.GA29925@thunk.org>
 <20140501162503.GL5136@gradx.cs.jhu.edu>
 <20140506154239.GA5012@thunk.org>
 <20140506155159.GY5136@gradx.cs.jhu.edu>
 <20140731023744.GA17375@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dot.freshdot.net ([213.154.236.176]:32995 "EHLO
	dot.freshdot.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaHFJjB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Aug 2014 05:39:01 -0400
Content-Disposition: inline
In-Reply-To: <20140731023744.GA17375@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quoting Theodore Ts'o (tytso@mit.edu):

> Are you folks still seeing ext4_mb_generate_buddy or
> ext4_mb_release_inode_pa EXT4-fs errors?
> 
> I think I may have found a fix for this problem.  Or at least, I've
> found one of the causes.  If we get a memory allocation failure from
> ext4_mb_new_inode_pa(), it can cause these errors.

Good to hear a probable cause was found. Unfortunately for this bug's
progress, i've switched to a newer kernel altogether since the 3.13
tree in Ubuntu has had a lot of other problems besides this
EXT4 ext_mb_generate_buddy issue.

With 3.15.0 i have not experienced any ext4 issues at all.

If you want me to, i would be willing to boot that VM in 3.13 with this
patch, but as said, it can take ages before the bug was triggered...

Thanks for your hard work.

-Sndr.
-- 
| > Because we read from top to bottom.
| > > Why should i start my email reply *below* the quoted text?
| 4096R/20CC6CD2 - 6D40 1A20 B9AA 87D4 84C7  FBD6 F3A9 9442 20CC 6CD2
