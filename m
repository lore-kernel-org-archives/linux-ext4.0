Return-Path: <SRS0=vryG=PX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58638 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727273AbfAOJYP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 15 Jan 2019 04:24:15 -0500
Date: Tue, 15 Jan 2019 10:24:14 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [GIT PULL] dtype handling cleanup for v4.21-rc1
Message-ID: <20190115092414.GA4138@quack2.suse.cz>
References: <20190102174736.GB29127@quack2.suse.cz>
 <20190108100500.GA15801@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190108100500.GA15801@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Linus,

On Tue 08-01-19 11:05:00, Jan Kara wrote:
> On Wed 02-01-19 18:47:36, Jan Kara wrote:
> >   could you please pull from
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git dtype_for_v4.21-rc1
> > 
> > to get a patch to provide generic functions for dtype handling and use those
> > for ext2. Other filesystems (ext4, btrfs, ocfs2, ...) can then merge the
> > cleanup patches through their trees.
> 
> I didn't get any reply WRT this pull request and you didn't pull yet. I
> guess you just wanted to have a deeper look and didn't get to it yet? Or do
> you have some problem with the patches?

What has happened to this pull request? It may be too late for this to be
merged now but I'd like to understand why it was not merged or rejected...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
