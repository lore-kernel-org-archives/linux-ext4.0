From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH] fix for consistency errors after crash
Date: Wed, 23 Jun 2010 22:27:41 +0300
Message-ID: <AANLkTimYavpuyNiaKYqUe3LFp0uzix_-ITV9ao0VagLs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40961 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab0FWT1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jun 2010 15:27:43 -0400
Received: by bwz7 with SMTP id 7so128064bwz.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jun 2010 12:27:41 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry, posting the patch again with a better title.
This bug needs to be fixed also in Ext3.
just need to move the ext3_forget() line down to ext3_free_blocks() lin=
e.

Amir.

On Wed, Jun 23, 2010 at 10:01 PM, Amir G.
<amir73il@users.sourceforge.net> wrote:
> Hi,
>
> We have experienced bitmap inconsistencies after crash during file
> delete under heavy load.
> The crash is not file system related and I the following patch in
> ext4_free_branches() fixes the recovery problem.
>
> If the transaction is restarted and there is a crash before the new
> transaction is committed,
> then after recovery, the blocks that this indirect block points to
> have been freed, but the indirect block itself
> has not been freed and may still point to some of the free blocks
> (because of the ext4_forget()).
>
> So ext4_forget() should be called inside ext4_free_blocks() to avoid
> this problem.
> Are there any consequences to this patch that I am not aware of?
>
> Amir.
>
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 42272d6..682e2fa 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4458,6 +4458,7 @@ static void ext4_free_branches(handle_t *handle=
,
> struct inode *inode,
> =A0{
> =A0 =A0 =A0 =A0ext4_fsblk_t nr;
> =A0 =A0 =A0 =A0__le32 *p;
> + =A0 =A0 =A0 int =A0 =A0 flags;
>
> =A0 =A0 =A0 =A0if (ext4_handle_is_aborted(handle))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> @@ -4520,7 +4521,7 @@ static void ext4_free_branches(handle_t *handle=
,
> struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * revoke records must=
 be emitted *before* clearing
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * this block's bit in=
 the bitmaps.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_forget(handle, 1, =
inode, bh, bh->b_blocknr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags =3D
> EXT4_FREE_BLOCKS_METADATA|EXT4_FREE_BLOCKS_FORGET;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Everything below th=
is this pointer has been
> @@ -4546,8 +4547,7 @@ static void ext4_free_branches(handle_t *handle=
,
> struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0blocks_for_truncate(inode));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_free_blocks(handle=
, inode, 0, nr, 1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0EXT4_FREE_BLOCKS_METADATA);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_free_blocks(handle=
, inode, 0, nr, 1, flags);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (parent_bh) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
