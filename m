Return-Path: <SRS0=njA7=PY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37636 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729188AbfAPQes (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jan 2019 11:34:48 -0500
Received: by mail-ot1-f66.google.com with SMTP id s13so8274165otq.4
        for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2019 08:34:48 -0800 (PST)
MIME-Version: 1.0
References: <20190102174736.GB29127@quack2.suse.cz> <20190108100500.GA15801@quack2.suse.cz>
 <20190115092414.GA4138@quack2.suse.cz> <CAHk-=wiW=4k3iBkDzz5_LuyCRcduZJuk-Vwhz9vqrUMML6WVkg@mail.gmail.com>
 <20190115180156.GB6310@bombadil.infradead.org> <CAHk-=whor678X0A4Mz95KSoG2f0O_F8a5PEQNXLqPxDehs+7Fg@mail.gmail.com>
 <20190116120754.GF26069@quack2.suse.cz>
In-Reply-To: <20190116120754.GF26069@quack2.suse.cz>
From: Phillip Potter <phil@philpotter.co.uk>
Date: Wed, 16 Jan 2019 16:34:36 +0000
Message-ID: <CAA=Fs0mrvr2mErpG-DBLW7Kg2xUXU_1+J4Eg4Fi+T=x5sH7BDQ@mail.gmail.com>
Subject: Re: [GIT PULL] dtype handling cleanup for v4.21-rc1
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "cc: Matthew Wilcox" <willy@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 16 Jan 2019 at 12:07, Jan Kara <jack@suse.cz> wrote:
>
> [Added Phillip and Amir to CC (authors)]
>
> On Wed 16-01-19 07:25:01, Linus Torvalds wrote:
> > On Wed, Jan 16, 2019 at 6:01 AM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > The ext2/ext4 patches don't show much improvement.  The other patches show
> > > more:
> > >
> > >  fs/nilfs2/dir.c                    | 52 ++++++++++--------------------
> > >  include/uapi/linux/nilfs2_ondisk.h |  1 +
> > >  2 files changed, 18 insertions(+), 35 deletions(-)
> > >
> > > (for example).
> > >
> > > UFS ends up benefiting the most.  You can see the whole diffstat here:
> > >
> > > https://lore.kernel.org/lkml/20181023201952.GA15676@pathfinder/
> >
> > Well, even with _all_ the filesystems converted, you actually have
> > more lines added than removed by this "cleanup".
> >
> > Sharing code just isn't a win here.
> >
> > That said, it's not really the number of lines per se that make me
> > question this, I think that's really more of a symptom than the root
> > cause. The root cause for the newly adde lines is that this whole
> > approach requires that all the numbers are in sync, but then they have
> > different *names*.
> >
> > Honestly, my gut feel is that I should not pull this in this form.
> >
> > I have a suggestion: if people want to do this, and actually share the
> > transformation, then the filesystems that use this common code should
> > simply *NOT* have their own private names for the enumerations. They
> > should actually use those standard names.
> >
> > So if the patch for ext2 (for example) were to entirely get rid of the
> > whole EXT2_FT_DIR define entirely, and ext2 would just use the actual
> > FT_DIR define, than I'd be ok with it. At that point you don't add a
> > pointless and expensive abstraction. At that point you say "ext2 uses
> > the standard values, so ext2 can just use the standard #defines
> > directly".
>
> OK, I'm fine with that. We just have to have a big fat warning at FT_
> definitions that these are on-disk values for several filesystems and thus
> cannot ever change. As Amir mentioned in another email, the original
> motivation for this is that quite a few filesystems copy-pasted ext2 code
> and that is slightly buggy. So I still do think there's value in this
> cleanup excercise.
>
> > See my argument?
> >
> > I think it is completely disgsting to have stuff like this:
> >
> > + BUILD_BUG_ON(EXT2_FT_UNKNOWN != FT_UNKNOWN);
> > + BUILD_BUG_ON(EXT2_FT_REG_FILE != FT_REG_FILE);
> > + BUILD_BUG_ON(EXT2_FT_DIR != FT_DIR);
> > + BUILD_BUG_ON(EXT2_FT_CHRDEV != FT_CHRDEV);
> > + BUILD_BUG_ON(EXT2_FT_BLKDEV != FT_BLKDEV);
> > + BUILD_BUG_ON(EXT2_FT_FIFO != FT_FIFO);
> > + BUILD_BUG_ON(EXT2_FT_SOCK != FT_SOCK);
> > + BUILD_BUG_ON(EXT2_FT_SYMLINK != FT_SYMLINK);
> > + BUILD_BUG_ON(EXT2_FT_MAX != FT_MAX);
> >
> > the above is just *garbage*.
> >
> > If you fundamentally need the values to be the same, then you simply
> > shouldn't have two different set of #defines.
> >
> > Get rid of the EXT2_FT_xyz enumeration entirely, and the whole
> > craziness goes away.
> >
> > > We'd see a lot more improvement in line count if Philip weren't quite
> > > so paranoid about checking FOOFS_FT_* == FT_* at build time; eg for btrfs:
> >
> > Exact same issue.
> >
> > So the more I look at this, the less I like it.
> >
> > But if people are actually willing to use *truly* shared code, instead
> > of using their own values and then having the crazy "they need to
> > match", then it would be a different issue. As it is, I think the
> > patch series adds complexity rather than helping anything.
> >
> > More complexity and more lines of code? There is absolutely zero upside.
>
> OK, understood. Phillip, could you please rework the patches as Linus
> suggests? Thanks!
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

Dear Jan,

I am happy to rework the patches, all fair comment. Slight problem
being my computer is in a box right now as I've just moved house. I
will get this done in the next few days if that's ok?

Regards,
Phil
