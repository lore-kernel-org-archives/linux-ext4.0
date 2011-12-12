From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2] ext4: ext4_discard_partial_page_buffers_no_lock()
 wrong parameters
Date: Mon, 12 Dec 2011 11:17:54 +0800
Message-ID: <CAGBYx2YTiHq4mkY5uh3ZawOAz1hbdzfgV2faBDEYZz-k9bySAA@mail.gmail.com>
References: <1323656828-24465-1-git-send-email-aarcange@redhat.com>
	<1323656828-24465-3-git-send-email-aarcange@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: Andrea Arcangeli <aarcange@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38803 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1LLDRz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Dec 2011 22:17:55 -0500
Received: by ggdk6 with SMTP id k6so563307ggd.19
        for <linux-ext4@vger.kernel.org>; Sun, 11 Dec 2011 19:17:55 -0800 (PST)
In-Reply-To: <1323656828-24465-3-git-send-email-aarcange@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrea,

The code you are testing are removed in recent patches,  the patches
have not been merged.

Please try following patches:
[PATCH 1/2] ext4: let mpage_submit_io works well when blocksize < pages=
ize
[PATCH 2/2] ext4: let ext4_discard_partial_buffers handle pages
without buffers correctly

and

[PATCH 1/2] ext4: remove a wrong BUG_ON in ext4_ext_convert_to_initiali=
zed
[PATCH 2/2] ext4: let ext4_bio_write_page handle EOF correctly

Yongqiang.

On Mon, Dec 12, 2011 at 10:27 AM, Andrea Arcangeli <aarcange@redhat.com=
> wrote:
> If "copied" is zero (it can happen if the pte is unmapped before the
> atomic copy_user that does the data copy runs) the "from" passed to
> ext4_discard_partial_page_buffers_no_lock() points to pos-1, which
> would correspond to a logical page index before the page->index
> leading to ext4_discard_partial_page_buffers_no_lock() returning
> -EINVAL (because index !=3D page->index). In such a case write() retu=
rns
> -EINVAL and userland gets a failure and filemap.c doesn't retry the
> copy_user anymore.
>
> I'm not certain of why exactly
> ext4_discard_partial_page_buffers_no_lock() is run here, so it's hard
> to tell if this is the correct fix. But it that functions clears data
> starting from the "from" parameter, so regardless of the -EINVAL
> retval, the right "from" to start clearing data should be pos+copied,
> not pos+copied-1. If this assumption is correct, it could mean that
> this bug in addition to the -EINVAL error, could also zero out 1 byte
> by mistake. I'm not sure what the implications for that are (not sure
> if data corruption is possible in some circumstances because of
> that). I guess normally this functions runs on unmapped buffers and
> the EXT4_DISCARD_PARTIAL_PG_ZERO_UNMAPPED makes it a noop on those.
>
> After fixing the hang in ext4_da_should_update_i_disksize, this write
> -EINVAL error becomes trivially reproducible with experimental knumad
> autonuma code running at heavy frequency (not the normal case). But
> like for the ext4_da_should_update_i_disksize hang, it should not be
> impossible to reproduce it with legacy swapping behavior.
>
> After dropping all caches a md5sum is successful and I can't find
> errors anymore with this patch, the -EINVAL stops, but it's not
> conclusive (and I haven't run e2fsck -f yet but I doubt this affects
> metadata coherency, seems more like a delayalloc data issue).
>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
> =A0fs/ext4/inode.c | =A0 =A06 +++---
> =A01 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 63f9541..528c4c5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2534,11 +2534,11 @@ static int ext4_da_write_end(struct file *fil=
e,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page, fsdata);
>
> =A0 =A0 =A0 =A0page_len =3D PAGE_CACHE_SIZE -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((pos + copied - 1) & (=
PAGE_CACHE_SIZE - 1));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((pos + copied) & (PAGE=
_CACHE_SIZE - 1));
>
> - =A0 =A0 =A0 if (page_len > 0) {
> + =A0 =A0 =A0 if (page_len < PAGE_CACHE_SIZE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D ext4_discard_partial_page_buff=
ers_no_lock(handle,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode, page, pos + copi=
ed - 1, page_len,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode, page, pos + copi=
ed, page_len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_DISCARD_PARTIAL_P=
G_ZERO_UNMAPPED);
> =A0 =A0 =A0 =A0}
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
