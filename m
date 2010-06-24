From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH, RFC] ext4: Store basic fs error information in the
	superblock
Date: Thu, 24 Jun 2010 15:09:16 +0300
Message-ID: <AANLkTikT18i8QAWassSdBBqps-nheNdwRNcmLfqtzDAr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45017 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab0FXMJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jun 2010 08:09:19 -0400
Received: by fxm3 with SMTP id 3so334878fxm.19
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jun 2010 05:09:17 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I saw your patch to store fs error information in the superblock.
I think it is a very useful feature and I have implemented something si=
milar in
next3_snapshot_journal_error.patch and e2fs_next3_message_buffer.patch
(attached).

There is one big problem I encountered with this feature:
If the file system error behavior is set to "abort" or "remount-ro",
the journal recovery on the next mount will most likely write over the
superblock with the errors information.

To solve this problem I stored the errors message buffer in the
journal superblock
and copied the message buffer to the filesystem superblock on journal
recovery (both on mount and fsck).
fsck also displays the errors buffer and clears it.

This feature helped me hunt down some rare bugs that happened on beta
sites, which I had to analyse post-mortem.
fsck simply gives me the first few error messages after the last time
fsck was run.

Amir.


On Wed, May 5, 2010 at 9:28 PM, Amir Goldstein <amir73il@users.sf.net> =
wrote:
> Next3 error messages are recorded in a 2K message buffer after the
> journal super block. =A0On journal recovery, the journal message buff=
er
> is copied to the file system message buffer. =A0On fsck, if the messa=
ge
> buffer is not empty, the recorded messages are printed to stdout and
> the buffer is cleared.
> Next3 supports only block size of 4K, so there is always 2K of free
> space for the message buffer after the 1K super block.
>
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
> ---
> =A0e2fsck/journal.c | =A0 14 ++++++++++++++
> =A0e2fsck/super.c =A0 | =A0 42 ++++++++++++++++++++++++++++++++++++++=
++++
> =A02 files changed, 56 insertions(+), 0 deletions(-)
>
> diff --git a/e2fsck/journal.c b/e2fsck/journal.c
> index 57783eb..72d2ea0 100644
> --- a/e2fsck/journal.c
> +++ b/e2fsck/journal.c
> @@ -836,6 +836,20 @@ static errcode_t recover_ext3_journal(e2fsck_t c=
tx)
>
>
> =A0 =A0 =A0 =A0if (journal->j_superblock->s_errno) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* journal message buffer at journal su=
per block + 1K */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *buf =3D ((char *) journal->j_supe=
rblock) +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SUPERBLOCK_OFFSET;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int len =3D ctx->fs->blocksize - 2*SUPE=
RBLOCK_OFFSET;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (len >=3D 2*SUPERBLOCK_OFFSET && *bu=
f) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* write journal messag=
e buffer to super block + 2K */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_channel_set_blksize(=
ctx->fs->io, SUPERBLOCK_OFFSET);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D io_channel_w=
rite_blk(ctx->fs->io, 2, 2, buf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_channel_set_blksize(=
ctx->fs->io, ctx->fs->blocksize);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* clear journal messag=
e buffer */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(buf, 0, len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ctx->fs->super->s_state |=3D EXT2_ERRO=
R_FS;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_mark_super_dirty(ctx->fs);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal->j_superblock->s_errno =3D 0;
> diff --git a/e2fsck/super.c b/e2fsck/super.c
> index f66ce9d..4a830bc 100644
> --- a/e2fsck/super.c
> +++ b/e2fsck/super.c
> @@ -584,6 +584,43 @@ static void e2fsck_fix_dirhash_hint(e2fsck_t ctx=
)
> =A0 =A0 =A0 =A0}
> =A0}
>
> +/*
> + * This function prints the message buffer at the end of super block=
=2E
> + */
> +static void e2fsck_print_message_buffer(e2fsck_t ctx)
> +{
> + =A0 =A0 =A0 char *buf;
> + =A0 =A0 =A0 int len =3D ctx->fs->blocksize - 2*SUPERBLOCK_OFFSET;
> + =A0 =A0 =A0 unsigned offset =3D 0;
> + =A0 =A0 =A0 int retval;
> +#define MSGLEN 256
> +
> + =A0 =A0 =A0 if (len < 2*SUPERBLOCK_OFFSET)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 buf =3D (char *) e2fsck_allocate_memory(ctx, len, "mess=
age buffer");
> +
> + =A0 =A0 =A0 io_channel_set_blksize(ctx->fs->io, SUPERBLOCK_OFFSET);
> + =A0 =A0 =A0 /* read message buffer from super block + 2K */
> + =A0 =A0 =A0 retval =3D io_channel_read_blk(ctx->fs->io, 2, 2, buf);
> + =A0 =A0 =A0 if (retval || !*buf)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 /* print messages in buffer */
> + =A0 =A0 =A0 puts("Error messages recorded in message buffer:");
> + =A0 =A0 =A0 while (offset < len && buf[offset]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(buf+offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset +=3D MSGLEN;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 /* clear message buffer */
> + =A0 =A0 =A0 memset(buf, 0, len);
> + =A0 =A0 =A0 retval =3D io_channel_write_blk(ctx->fs->io, 2, 2, buf)=
;
> + =A0 =A0 =A0 puts("End of message buffer.");
> +out:
> + =A0 =A0 =A0 io_channel_set_blksize(ctx->fs->io, ctx->fs->blocksize)=
;
> + =A0 =A0 =A0 ext2fs_free_mem(&buf);
> +}
> +
>
> =A0void check_super_block(e2fsck_t ctx)
> =A0{
> @@ -998,6 +1035,11 @@ void check_super_block(e2fsck_t ctx)
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0e2fsck_fix_dirhash_hint(ctx);
>
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Print message buffer if necessary
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 e2fsck_print_message_buffer(ctx);
> +
> =A0 =A0 =A0 =A0return;
> =A0}
>
> --
> 1.6.6
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
