From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 metadata corruption bug?
Date: Wed, 30 Jul 2014 22:37:44 -0400
Message-ID: <20140731023744.GA17375@thunk.org>
References: <20140420163211.GT10985@gradx.cs.jhu.edu>
 <20140423072311.GD10163@dot.freshdot.net>
 <20140423143642.GA29925@thunk.org>
 <20140501162503.GL5136@gradx.cs.jhu.edu>
 <20140506154239.GA5012@thunk.org>
 <20140506155159.GY5136@gradx.cs.jhu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, admins@acm.jhu.edu,
	Sander Smeenk <ssmeenk@freshdot.net>
To: Nathaniel W Filardo <nwf@cs.jhu.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37548 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbaGaChx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jul 2014 22:37:53 -0400
Content-Disposition: inline
In-Reply-To: <20140506155159.GY5136@gradx.cs.jhu.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Are you folks still seeing ext4_mb_generate_buddy or
ext4_mb_release_inode_pa EXT4-fs errors?

I think I may have found a fix for this problem.  Or at least, I've
found one of the causes.  If we get a memory allocation failure from
ext4_mb_new_inode_pa(), it can cause these errors.  Actually
triggering it is a bit tricky, but it looks like we saw it hit when a
task which was running under high memory pressure (because it was
running right against its cgroup memory limit) core dump.

Anyway, if you are still seeing these issues, this patch might help you out:

	http://patchwork.ozlabs.org/patch/375106/

If it works out for you, please let me know.

Cheers,

							- Ted
