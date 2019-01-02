Return-Path: <SRS0=jZge=PK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44938 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729846AbfABQp2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 2 Jan 2019 11:45:28 -0500
Date: Wed, 2 Jan 2019 17:45:26 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL] Ext2, udf, and quota changes for v4.21-rc1
Message-ID: <20190102164526.GC23089@quack2.suse.cz>
References: <20181220135252.GB15045@quack2.suse.cz>
 <CAHk-=wgagiSgqXu_53p+Dx-aGfU4w6z1xLzqZTqpbKvg=7ahhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgagiSgqXu_53p+Dx-aGfU4w6z1xLzqZTqpbKvg=7ahhg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 27-12-18 17:02:09, Linus Torvalds wrote:
> On Thu, Dec 20, 2018 at 5:52 AM Jan Kara <jack@suse.cz> wrote:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git fs_for_4.21-rc1
> >
> > to get some ext2 cleanups, a fix for UDF crash on corrupted media, and one
> > quota locking fix.
> >
> > Top of the tree is 2aad26fa0a3d.
> 
> This time the tag name was correct, but once again the "Top of tree is
> 2aad26fa0a3d" was entirely untrue.
> 
> Please check and fix your scripting, because it's broken.

Yes, it's broken. I'm really sorry for that (it got confused by me sending
pull requests before you've tagged v4.20). I've fixed it up and will verify
it produced correct output next time I'll send the pull request.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
