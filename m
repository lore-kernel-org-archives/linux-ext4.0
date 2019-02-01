Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9DEC282D8
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 08:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6A1E20815
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 08:54:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YKeVtUal"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfBAIyL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Feb 2019 03:54:11 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37931 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfBAIyL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2019 03:54:11 -0500
Received: by mail-oi1-f195.google.com with SMTP id a77so5194273oii.5
        for <linux-ext4@vger.kernel.org>; Fri, 01 Feb 2019 00:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o9HfNIUBMaqVI4QlVasLaCIuWmwyDOQTMDyf+qvVydk=;
        b=YKeVtUal+VyJ07SXIZ7s1x2IEYJW9BLJcBW3NMJfk7qwR9onMceRDEqk4NLkUxOIf/
         iy4yvJe7A7pdqQXJr4R8oM3BssCE0szpjC328cGVG74u34DQCUd64c6PXaaG8siUkUbl
         9arnAlU0yrbeaNgyJsAVXQCmDixYaw+6UxttdYncsi8S7tZDZNWGLMO898+c6m8drlMP
         KBOpT9BjPPGFW7zn/92IA/3+eObHxD+4HxDCLzyPRZj4KyUUF9kSHIAP4qWT4MqPWnko
         lxeiJPhS1bhXTje2GkDiBYF08SootjWk90qCT+XQkgxcxeO5Qct3lQ+Ude0SoQeaozdr
         zjaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o9HfNIUBMaqVI4QlVasLaCIuWmwyDOQTMDyf+qvVydk=;
        b=NXsFYpKaG5mMVXQgFfM9KLKKbjTnFnNVJ0/cwjalCq2KVPzDyDhvf5czfBgGQG4VAa
         thdTDjkWpIinOp82+qH1FNkO+BiVvNFFVJRRnOTC7tNAeV/mkiyZ8BT3fOYQ2yTxEsiD
         FFSG/mSa9HER7cz5gN5xG01qzmWEujHy76wb7hfbdU5eg4Gn+leIDPyoqFxj/18IeTnP
         DoNKJ4K0uhyVmP0lKq4xodLFNEmW3N908oI97w8X4p7atwQ5fREInBll+6ibmJE1mjOL
         pD5n9RtMLktvF8ek+95X8JjYmagqgRVy03PolncUVID13QILC7WN23X+SCXQ6hIHJS0B
         iuXA==
X-Gm-Message-State: AHQUAubbLMWxzpV/BHhrRj7gdLoYLnWq6Jb6irQJMnF6/K6Jnl150PL0
        w3uScZA2Vh7LqSFhbCaz0gIX1Z0UNc44+zSzyuY=
X-Google-Smtp-Source: AHgI3IYJPUV6tA25vOnkdV1HSZcM0Y4Iv7X0E7n+5PU7zb/blImewKET7DsdAqiikgQR4vUKEOoXyANKqw5/lYGfpmg=
X-Received: by 2002:aca:100b:: with SMTP id 11mr17111986oiq.303.1549011250250;
 Fri, 01 Feb 2019 00:54:10 -0800 (PST)
MIME-Version: 1.0
References: <CAD+ocbwgH6bHrPqB0ERM2YA703nASqRzLYCu-eJQn1uFgh1ivg@mail.gmail.com>
 <20190123183245.154246-1-harshadshirwadkar@gmail.com> <949C18DE-F36E-4D7E-897A-FFC5865EF79C@dilger.ca>
In-Reply-To: <949C18DE-F36E-4D7E-897A-FFC5865EF79C@dilger.ca>
From:   harshad shirwadkar <harshadshirwadkar@gmail.com>
Date:   Fri, 1 Feb 2019 00:53:58 -0800
Message-ID: <CAD+ocbwuDQ3aFRywovKqD9pxvSePSn=AiPsrQsf+_0Q7NWidgA@mail.gmail.com>
Subject: Re: [PATCH] ext4: shrink directory when last block is empty
To:     Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu
Cc:     Alexey Lyashkov <umka@cloudlinux.com>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Thank you Andreas and Ted for reviewing the patch. Ted, thank you for
pointing out about the subject line when sending a new patch - I'll be
careful next time. I have handled all the review comments. I will send
out a patch with handled comments. About testing this patch, I have
created a new xfstest that verifies that directory shrinks after
deleting files in it. I'll send that patch out too.

On Tue, Jan 29, 2019 at 5:58 PM Andreas Dilger <adilger@dilger.ca> wrote:
>
> On Jan 23, 2019, at 11:32 AM, harshadshirwadkar@gmail.com wrote:
> >
> > From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
> >
> > This patch is the first step towards shrinking htree based directories
> > when files are deleted. We truncate directory inode when a directory
> > entry removal causes last directory block to be empty. This patch just
> > removes the last block. We may end up in a situation where many
> > intermediate dirent blocks in directory inode are empty. Removing
> > those blocks would be handled later.
> >
> > Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
> > ---
> > fs/ext4/namei.c | 130 ++++++++++++++++++++++++++++++++++++++++--------
> > 1 file changed, 109 insertions(+), 21 deletions(-)
> >
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index 2a4c25c4681d..79cb88ba898a 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -273,7 +273,8 @@ static int ext4_htree_next_block(struct inode *dir, __u32 hash,
> >                                __u32 *start_hash);
> > static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
> >               struct ext4_filename *fname,
> > -             struct ext4_dir_entry_2 **res_dir);
> > +             struct ext4_dir_entry_2 **res_dir,
> > +             struct dx_frame *dx_frame);
>
> (style) these should align after '(' on the first line
>
> > @@ -380,6 +381,7 @@ static void ext4_dirent_csum_set(struct inode *inode,
> >                                          (void *)t - (void *)dirent);
> > }
> >
> > +
> > int ext4_handle_dirty_dirent_node(handle_t *handle,
> >                                 struct inode *inode,
> >                                 struct buffer_head *bh)
>
> (style) No need for this hunk.
>
> > @@ -866,6 +868,42 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
> >       return ret_err;
> > }
> >
> > +static void
> > +ext4_dx_delete_entry(handle_t *handle, struct inode *dir,
> > +                  struct dx_frame *dx_frame, __le64 block)
> > +{
> > +     struct dx_entry *entries;
> > +     unsigned int count, limit;
> > +     int err, i;
> > +
> > +     entries = dx_frame->entries;
> > +     count = dx_get_count(entries);
> > +     limit = dx_get_limit(entries);
> > +
> > +     for (i = 0; i < count; i++)
> > +             if (entries[i].block == block)
> > +                     break;
> > +
> > +     if (i >= count)
> > +             return;
> > +
> > +     err = ext4_journal_get_write_access(handle, dx_frame->bh);
> > +     if (err) {
> > +             ext4_std_error(dir->i_sb, err);
> > +             return;
> > +     }
> > +
> > +     for (; i < count - 1; i++)
> > +             entries[i] = entries[i + 1];
> > +
> > +     dx_set_count(entries, count - 1);
> > +     dx_set_limit(entries, limit);
>
> I don't think you need to update the limit just because of the count changing?
> This is just setting it back to the same value that dx_get_limit() returned earlier.
>
> > @@ -1309,6 +1347,14 @@
> > +static int is_empty_dirent_block(struct inode *dir, struct buffer_head *bh)
>
> (style) this function should be type bool.  The older "is_*" functions were written
> before "bool" was available in the kernel, though a separate cleanup patch to convert
> them to bool would be welcome.
>
> > +{
> > +     struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)bh->b_data;
> > +
> > +     return (ext4_rec_len_from_disk(de->rec_len, dir->i_sb->s_blocksize)
> > +             == dir->i_sb->s_blocksize);
>
> (style) no need for () around return value.
>
> >
> > @@ -1339,7 +1385,8 @@ static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
> > static struct buffer_head * ext4_find_entry (struct inode *dir,
> >                                       const struct qstr *d_name,
> >                                       struct ext4_dir_entry_2 **res_dir,
> > -                                     int *inlined)
> > +                                     int *inlined,
> > +                                     struct dx_frame *dx_frame)
>
> (style) this can fit on the previous line, and they can all align after '(' on
> the first line.  Please also remove the space after '*' in the function declaration.
>
> > @@ -1486,9 +1533,10 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
> >       return ret;
> > }
> >
> > -static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
> > -                     struct ext4_filename *fname,
> > -                     struct ext4_dir_entry_2 **res_dir)
> > +static struct buffer_head *ext4_dx_find_entry(
> > +                     struct inode *dir, struct ext4_filename *fname,
>
> (style) it isn't clear why you moved "struct inode *dir" from the previous line?
> The continued lines look like they can properly align after '(' on the previous line.
>
> > @@ -2337,9 +2389,13 @@ int ext4_generic_delete_entry(handle_t *handle,
> > static int ext4_delete_entry(handle_t *handle,
> >                            struct inode *dir,
> >                            struct ext4_dir_entry_2 *de_del,
> > -                          struct buffer_head *bh)
> > +                          struct buffer_head *bh,
> > +                          struct dx_frame *dx_frame)
> > {
> > +     struct ext4_map_blocks map;
> >       int err, csum_size = 0;
> > +     int should_truncate = 0;
>
> (style) bool should_truncate
>
> > @@ -2363,11 +2419,35 @@ static int ext4_delete_entry(handle_t *handle,
> >       if (err)
> >               goto out;
> >
> > +     if (dx_frame && dx_frame->bh && is_empty_dirent_block(dir, bh)) {
> > +
>
> (style) no blank line here.
>
> > +             map.m_lblk = (dir->i_size - 1) >>
> > +                          (dir->i_sb->s_blocksize_bits);
>
> (style) no need for parenthesis around dir->i_sb->s_blocksize_bits.
> (style) this can fit on the previous line and still be under 80 columns.
>
> > +             map.m_len = 1;
> > +             err = ext4_map_blocks(handle, dir, &map, 0);
> > +
> > +             if ((err > 0) && (bh->b_blocknr == map.m_pblk)) {
>
> (style) no need for extra parenthesis around "err > 0" and "b_blocknr == m_pblk".
>
> > +                     ext4_dx_delete_entry(handle, dir, dx_frame,
> > +                                          cpu_to_le64(map.m_lblk));
> > +                     should_truncate = 1;
> > +             }
> > +     }
> > +
> >       BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
> > +
> >       err = ext4_handle_dirty_dirent_node(handle, dir, bh);
> >       if (unlikely(err))
> >               goto out;
> >
> > +     if (should_truncate) {
> > +             dir->i_size -= dir->i_sb->s_blocksize;
> > +             ext4_truncate(dir);
>
> Since we have already mapped the last block above, I wonder if we can do something
> lighter weight than calling ext4_truncate() here?  Maybe moving the ext4_truncate()
> guts into a helper function like ext4_truncate_internal() that avoids all of the
> complexity (orphan list, resizing the transaction, inline data, etc).
>
> > +             if (dir->i_size == dir->i_sb->s_blocksize) {
> > +                     ext4_clear_inode_flag(dir, EXT4_INODE_INDEX);
> > +                     ext4_mark_inode_dirty(handle, dir);
>
> Are there any places in the code that assume an indexed directory will remain as such?
> The tricky part here is that any valid htree directory will have 3 blocks (dx_root,
> plus two leaf blocks), so it might be problematic to go back to a single non-htree
> block, especially since this doesn't look like it has any locking.  It is probably
> worthwhile to check the code for this.

After handling Ted's comment about not deleting the last block if it
makes intermediate node empty, this patch will never result in a
situation where dir->i_size == blocksize. So, this hunk is not needed
anymore.

>
> > @@ -2985,6 +3065,9 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
> >       struct buffer_head *bh;
> >       struct ext4_dir_entry_2 *de;
> >       handle_t *handle = NULL;
> > +     struct dx_frame dx_frame;
> > +
> > +     memset(&dx_frame, 0, sizeof(dx_frame));
>
> Rather than an explicit memset(), this can use a struct initializer when it is declared:
>
>         struct dx_frame dx_frame = { NULL };
>
> Are there existing xfstests that cover this case?  Certainly deleting files from a
> directory, but it would be useful to have something that checks whether the directory
> size is shrinking and this code is working.
>
> Cheers, Andreas
>
>
>
>
>
