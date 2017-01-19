From: "George Spelvin" <linux@sciencehorizons.net>
Subject: Re: Ext4 deadlock (+lockdep splat) during rsync
Date: 19 Jan 2017 18:38:24 -0500
Message-ID: <20170119233824.10435.qmail@ns.sciencehorizons.net>
References: <20170119231931.bxnltnlwinjdzvxa@thunk.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, linux@sciencehorizons.net
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.sciencehorizons.net ([71.41.210.147]:59772 "HELO
        ns.sciencehorizons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1751944AbdASXi1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jan 2017 18:38:27 -0500
In-Reply-To: <20170119231931.bxnltnlwinjdzvxa@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I think the inline_data patches I posted should have taken care of
> George's initial set of bug reports?

Er, the two I posted most recently were on a kernel with your 4-patch
deadlock series applied:

98a9e36a ext4: propagate error values from ext4_inline_data_truncate()
50c39f0d ext4: avoid calling ext4_mark_inode_dirty() under unneeded semaphores
f321034b ext4: fix deadlock between inline_data and ext4_expand_extra_isize_ea()
5283ac14 ext4: add debug_want_extra_isize mount option

Are you referring to some other patches I should be looking for?

> (And George, the reason why you're seeing lots of problems is because
> inline_data isn't enabled by default yet, and as the old joke goes,
> the Early Christians get the best Lions.  :-)

Yes, I know I'm tempting fate by keeping data I actaully care about (I
have backups of most of it, but reassembling it from those backups would
be most unpleasant) on a file system with experimental features enabled.

But *somebody* has to debug new features, and I've noticed that the fickle
goddess Glitch is most likely to make an appearance when She sees such
an offering.
