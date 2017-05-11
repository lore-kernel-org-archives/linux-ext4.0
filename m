From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V2] e2fsck: fix multiply-claimed block quota accounting
 when deleting files
Date: Thu, 11 May 2017 10:32:17 -0600
Message-ID: <CFF2227D-6CA4-406E-A29F-CABBB20AFD89@dilger.ca>
References: <20170511154632.GB11505@localhost.localdomain>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E8B311E8-EA13-4DFA-9113-517B0F2B52BE";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35348 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757108AbdEKQcX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 May 2017 12:32:23 -0400
Received: by mail-io0-f196.google.com with SMTP id o12so3532469iod.2
        for <linux-ext4@vger.kernel.org>; Thu, 11 May 2017 09:32:23 -0700 (PDT)
In-Reply-To: <20170511154632.GB11505@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_E8B311E8-EA13-4DFA-9113-517B0F2B52BE
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


> On May 11, 2017, at 9:46 AM, Eric Whitney <enwlinux@gmail.com> wrote:
> 
> As e2fsck processes each file in pass1, the actual file system quota is
> increased by the number of blocks discovered in the file.  This can
> include both non-multiply-claimed and multiply-claimed blocks, if the
> latter exist.  However, if a file containing multiply-claimed blocks
> is then deleted in pass1b, those blocks are not taken into account when
> decreasing the actual quota.  In this case, the new quota values written
> to the file system by e2fsck overstate the space actually consumed.
> And, e2fsck must be run twice on the file system to fully correct
> quota.
> 
> Fix this by counting multiply-claimed blocks as a debit to quota when
> deleting files in pass1b.
> 
> [V2] Correct a dangling else bug in the original patch.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> e2fsck/pass1b.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
> index b40f026..d22cffd 100644
> --- a/e2fsck/pass1b.c
> +++ b/e2fsck/pass1b.c
> @@ -637,9 +637,11 @@ static int delete_file_block(ext2_filsys fs,
> 	if (ext2fs_test_block_bitmap2(ctx->block_dup_map, *block_nr)) {
> 		n = dict_lookup(&clstr_dict, INT_TO_VOIDPTR(c));
> 		if (n) {
> -			p = (struct dup_cluster *) dnode_get(n);
> -			if (lc != pb->cur_cluster)
> +			if (lc != pb->cur_cluster) {
> +				p = (struct dup_cluster *) dnode_get(n);
> 				decrement_badcount(ctx, *block_nr, p);
> +				pb->dup_blocks++;
> +			}
> 		} else
> 			com_err("delete_file_block", 0,
> 			    _("internal error: can't find dup_blk for %llu\n"),

My preference would be to have {} around the else clause as well, and I
believe that checkpatch.pl agrees "braces {} should be used on all arms
of this statement".  That said, this is a pre-existing condition and is
only code style, while your patch fixes a real bug.

Cheers, Andreas






--Apple-Mail=_E8B311E8-EA13-4DFA-9113-517B0F2B52BE
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZFJISpIg59Q01vtYRAvDBAKCD4dWwUDdy3rASTPQyt3rLHIpVWwCg7ott
T2vQvmbjHpQOg7pedZw4eiA=
=IUyG
-----END PGP SIGNATURE-----

--Apple-Mail=_E8B311E8-EA13-4DFA-9113-517B0F2B52BE--
