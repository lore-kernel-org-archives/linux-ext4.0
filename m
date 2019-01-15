Return-Path: <SRS0=vryG=PX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38644 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728780AbfAOTZW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2019 14:25:22 -0500
Received: by mail-lf1-f66.google.com with SMTP id a8so2955827lfk.5
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2019 11:25:21 -0800 (PST)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id m1sm767361lfb.56.2019.01.15.11.25.18
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 11:25:18 -0800 (PST)
Received: by mail-lj1-f174.google.com with SMTP id t9-v6so3349972ljh.6
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2019 11:25:18 -0800 (PST)
MIME-Version: 1.0
References: <20190102174736.GB29127@quack2.suse.cz> <20190108100500.GA15801@quack2.suse.cz>
 <20190115092414.GA4138@quack2.suse.cz> <CAHk-=wiW=4k3iBkDzz5_LuyCRcduZJuk-Vwhz9vqrUMML6WVkg@mail.gmail.com>
 <20190115180156.GB6310@bombadil.infradead.org>
In-Reply-To: <20190115180156.GB6310@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Jan 2019 07:25:01 +1200
Message-ID: <CAHk-=whor678X0A4Mz95KSoG2f0O_F8a5PEQNXLqPxDehs+7Fg@mail.gmail.com>
Subject: Re: [GIT PULL] dtype handling cleanup for v4.21-rc1
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 16, 2019 at 6:01 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> The ext2/ext4 patches don't show much improvement.  The other patches show
> more:
>
>  fs/nilfs2/dir.c                    | 52 ++++++++++--------------------
>  include/uapi/linux/nilfs2_ondisk.h |  1 +
>  2 files changed, 18 insertions(+), 35 deletions(-)
>
> (for example).
>
> UFS ends up benefiting the most.  You can see the whole diffstat here:
>
> https://lore.kernel.org/lkml/20181023201952.GA15676@pathfinder/

Well, even with _all_ the filesystems converted, you actually have
more lines added than removed by this "cleanup".

Sharing code just isn't a win here.

That said, it's not really the number of lines per se that make me
question this, I think that's really more of a symptom than the root
cause. The root cause for the newly adde lines is that this whole
approach requires that all the numbers are in sync, but then they have
different *names*.

Honestly, my gut feel is that I should not pull this in this form.

I have a suggestion: if people want to do this, and actually share the
transformation, then the filesystems that use this common code should
simply *NOT* have their own private names for the enumerations. They
should actually use those standard names.

So if the patch for ext2 (for example) were to entirely get rid of the
whole EXT2_FT_DIR define entirely, and ext2 would just use the actual
FT_DIR define, than I'd be ok with it. At that point you don't add a
pointless and expensive abstraction. At that point you say "ext2 uses
the standard values, so ext2 can just use the standard #defines
directly".

See my argument?

I think it is completely disgsting to have stuff like this:

+ BUILD_BUG_ON(EXT2_FT_UNKNOWN != FT_UNKNOWN);
+ BUILD_BUG_ON(EXT2_FT_REG_FILE != FT_REG_FILE);
+ BUILD_BUG_ON(EXT2_FT_DIR != FT_DIR);
+ BUILD_BUG_ON(EXT2_FT_CHRDEV != FT_CHRDEV);
+ BUILD_BUG_ON(EXT2_FT_BLKDEV != FT_BLKDEV);
+ BUILD_BUG_ON(EXT2_FT_FIFO != FT_FIFO);
+ BUILD_BUG_ON(EXT2_FT_SOCK != FT_SOCK);
+ BUILD_BUG_ON(EXT2_FT_SYMLINK != FT_SYMLINK);
+ BUILD_BUG_ON(EXT2_FT_MAX != FT_MAX);

the above is just *garbage*.

If you fundamentally need the values to be the same, then you simply
shouldn't have two different set of #defines.

Get rid of the EXT2_FT_xyz enumeration entirely, and the whole
craziness goes away.

> We'd see a lot more improvement in line count if Philip weren't quite
> so paranoid about checking FOOFS_FT_* == FT_* at build time; eg for btrfs:

Exact same issue.

So the more I look at this, the less I like it.

But if people are actually willing to use *truly* shared code, instead
of using their own values and then having the crazy "they need to
match", then it would be a different issue. As it is, I think the
patch series adds complexity rather than helping anything.

More complexity and more lines of code? There is absolutely zero upside.

               Linus
