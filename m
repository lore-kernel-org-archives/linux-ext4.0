Return-Path: <SRS0=xLGb=PZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:45046 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfAQLRV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2019 06:17:21 -0500
MIME-Version: 1.0
References: <20190102174736.GB29127@quack2.suse.cz> <20190108100500.GA15801@quack2.suse.cz>
 <20190115092414.GA4138@quack2.suse.cz> <CAHk-=wiW=4k3iBkDzz5_LuyCRcduZJuk-Vwhz9vqrUMML6WVkg@mail.gmail.com>
 <20190115180156.GB6310@bombadil.infradead.org> <CAHk-=whor678X0A4Mz95KSoG2f0O_F8a5PEQNXLqPxDehs+7Fg@mail.gmail.com>
 <20190116120754.GF26069@quack2.suse.cz> <CAA=Fs0mrvr2mErpG-DBLW7Kg2xUXU_1+J4Eg4Fi+T=x5sH7BDQ@mail.gmail.com>
 <20190116165147.GI26069@quack2.suse.cz> <CAOQ4uxipOf-MH3eC8fbV6ZrF63thq0+PyBpoNMzv=WWF_=vs2w@mail.gmail.com>
 <20190117093555.GC9378@quack2.suse.cz>
In-Reply-To: <20190117093555.GC9378@quack2.suse.cz>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 17 Jan 2019 13:17:08 +0200
Message-ID: <CAOQ4uxgrTnuP7bVx1Ssv__R0cX9Ayzjx5Uc+6cq4XSp-Qa95CA@mail.gmail.com>
Subject: Re: [GIT PULL] dtype handling cleanup for v4.21-rc1
To: Phillip Potter <phil@philpotter.co.uk>
Cc: Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "cc: Matthew Wilcox" <willy@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 17, 2019 at 11:35 AM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 16-01-19 18:56:17, Amir Goldstein wrote:
> > On Wed, Jan 16, 2019 at 6:51 PM Jan Kara <jack@suse.cz> wrote:
> > >
> > > On Wed 16-01-19 16:34:36, Phillip Potter wrote:
> > > > Dear Jan,
> > > >
> > > > I am happy to rework the patches, all fair comment. Slight problem
> > > > being my computer is in a box right now as I've just moved house. I
> > > > will get this done in the next few days if that's ok?
> > >
> > > Sure, no problem. Patches won't make it in this release cycle so we have
> > > like three weeks to get them ready for the next merge window.
> > >
> >
> > Also, and Jan will correct me if I am wrong.
> > I think that reworking only the common and ext2 patches would
> > be sufficient for this cycle.
>
> Yes, that's also true.
>
> > You can prepare the rest of the patches for next cycle after
> > the common patch has landed.
>
> Correct, since the plan is for these to land through other maintainers'
> trees. But still it would be nice if we had them earlier just to see of
> other maintainers don't seriously oppose the idea. To that end it is
> probably good to reference the discussion with Linus in the cover letter
> and the email with common infrastructure, explaining why converting to
> common defines instead of keeping filesystem specific ones was done.
>

Phillip,

While I see no problem with Linus' proposal to get rid of EXT2_FT_*
completely. That may be practical for EXOFS_FT_*, F2FS_FT_*, ...
But some fs maintainers may prefer to define (not re-define) the
fs specific constants, e.g.:

#define EXT4_FT_DIR FT_DIR

If for no other reason, it will result in slightly less code churn.

However, note that you may NOT get rid of defines in uapi headers:
BTRFS_FT_*, NILFS_FT_*
and defining them to the common constant will require exporting
common constants to uapi headers.
That is one mess you do not want to get yourself into.

So I'm afraid for btrfs/nilfs, the "disgusting" BUILD_BUG_ON()
statements in the only practical outlet if they want to use the common
conversions code.

If you prepare the patch series with several options as described
above (choose one option per fs), then later maintainers can use
either option when applying the individual patches.

Thanks,
Amir.
