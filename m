From: Kevin Liao <kevinlia@gmail.com>
Subject: Re: [PATCH 2/2] resize2fs: fix overhead calculation for meta_bg file systems
Date: Tue, 4 Sep 2012 10:14:11 +0800
Message-ID: <CAF_MivH5Cf=cuWGMgPtbfr-XomhJz05LsnQgGSAfwRHzFPv_Sg@mail.gmail.com>
References: <20120903164525.GD5066@thunk.org>
	<1346690758-21072-1-git-send-email-tytso@mit.edu>
	<1346690758-21072-2-git-send-email-tytso@mit.edu>
	<CAGBYx2a8J1ZvWDjgv3snTCE59nqurF_sGYJ0pxSy2anXjzfBRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:41989 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab2IDCOM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Sep 2012 22:14:12 -0400
Received: by ghrr11 with SMTP id r11so1087525ghr.19
        for <linux-ext4@vger.kernel.org>; Mon, 03 Sep 2012 19:14:11 -0700 (PDT)
In-Reply-To: <CAGBYx2a8J1ZvWDjgv3snTCE59nqurF_sGYJ0pxSy2anXjzfBRg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/9/4 Yongqiang Yang <xiaoqiangnk@gmail.com>
>
> Hi Kevin,
>
>   Ted has sent out the patches on online resizing for meta_bg and
> 64bits, so you can have a try again. It seems that the bug in
> e2fsprogs has been fixed.
>
> Yongqiang.
>

Hi Ted & Yongqiang,

I will try to test the patch as soon as possible. Thanks a lot for your effort.

Regards,
Kevin Liao

> On Tue, Sep 4, 2012 at 12:45 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > The file system overhead calculation in calculate_minimum_resize_size
> > was incorrect meta_bg file systems.  This caused the minimum size to
> > underflow for very large file systems, which threw resize2fs into a
> > loop generally lasted longer than the user's patience.
> >
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  resize/resize2fs.c | 25 ++++++++++++++++++++++++-
> >  1 file changed, 24 insertions(+), 1 deletion(-)
> >
> > diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> > index dc2805d..1dce498 100644
> > --- a/resize/resize2fs.c
> > +++ b/resize/resize2fs.c
> > @@ -1890,6 +1890,8 @@ blk64_t calculate_minimum_resize_size(ext2_filsys
> > fs)
> >         blk64_t grp, data_needed, last_start;
> >         blk64_t overhead = 0;
> >         int num_of_superblocks = 0;
> > +       blk64_t super_overhead = 0;
> > +       int old_desc_blocks;
> >         int extra_groups = 0;
> >         int flexbg_size = 1 << fs->super->s_log_groups_per_flex;
> >
> > @@ -1909,15 +1911,36 @@ blk64_t
> > calculate_minimum_resize_size(ext2_filsys fs)
> >          * we need to figure out how many backup superblocks we have so
> > we can
> >          * account for that in the metadata
> >          */
> > +       if (fs->super->s_feature_incompat &
> > EXT2_FEATURE_INCOMPAT_META_BG)
> > +               old_desc_blocks = fs->super->s_first_meta_bg;
> > +       else
> > +               old_desc_blocks = fs->desc_blocks +
> > +                       fs->super->s_reserved_gdt_blocks;
> > +
> >         for (grp = 0; grp < fs->group_desc_count; grp++) {
> > +               blk64_t super_blk, old_desc_blk, new_desc_blk;
> > +               int has_super;
> > +
> > +               ext2fs_super_and_bgd_loc2(fs, grp, &super_blk,
> > +                                         &old_desc_blk, &new_desc_blk,
> > 0);
> > +               has_super = ((grp == 0) || super_blk);
> > +               if (has_super)
> > +                       super_overhead++;
> > +               if (old_desc_blk)
> > +                       super_overhead += old_desc_blocks;
> > +               else if (new_desc_blk)
> > +                       super_overhead++;
> >                 if (ext2fs_bg_has_super(fs, grp))
> >                         num_of_superblocks++;
> > +
> >         }
> > +       printf("super overhead is %llu, old algorithm was %llu\n",
> > +              super_overhead, SUPER_OVERHEAD(fs) * num_of_superblocks);
> >
> >         /* calculate how many blocks are needed for data */
> >         data_needed = ext2fs_blocks_count(fs->super) -
> >                 ext2fs_free_blocks_count(fs->super);
> > -       data_needed -= SUPER_OVERHEAD(fs) * num_of_superblocks;
> > +       data_needed -= super_overhead;
> >         data_needed -= META_OVERHEAD(fs) * fs->group_desc_count;
> >
> >         if (fs->super->s_feature_incompat &
> > EXT4_FEATURE_INCOMPAT_FLEX_BG) {
> > --
> > 1.7.12.rc0.22.gcdd159b
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Best Wishes
> Yongqiang Yang
