From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsck: fix multiply-claimed block quota accounting when
 deleting files
Date: Wed, 10 May 2017 17:05:51 -0600
Message-ID: <6A0785D3-A3D1-45F7-AD67-3C52D7364551@dilger.ca>
References: <20170510220440.GA26875@localhost.localdomain>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_1D0BFE6A-9F94-48C8-A2DD-2CA6C960DB70";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33879 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751820AbdEJXF5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 10 May 2017 19:05:57 -0400
Received: by mail-it0-f67.google.com with SMTP id c26so1640842itd.1
        for <linux-ext4@vger.kernel.org>; Wed, 10 May 2017 16:05:56 -0700 (PDT)
In-Reply-To: <20170510220440.GA26875@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_1D0BFE6A-9F94-48C8-A2DD-2CA6C960DB70
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


> On May 10, 2017, at 4:04 PM, Eric Whitney <enwlinux@gmail.com> wrote:
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

Nice catch.  It would be good to have an e2fsck test case that checks this.
Also, one minor code style nit (or possibly defect) below.

> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
> e2fsck/pass1b.c | 10 ++++++----
> 1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
> index b40f026..8744fad 100644
> --- a/e2fsck/pass1b.c
> +++ b/e2fsck/pass1b.c
> @@ -636,11 +636,13 @@ static int delete_file_block(ext2_filsys fs,
> 	lc = EXT2FS_B2C(fs, blockcnt);
> 	if (ext2fs_test_block_bitmap2(ctx->block_dup_map, *block_nr)) {
> 		n = dict_lookup(&clstr_dict, INT_TO_VOIDPTR(c));
> -		if (n) {
> -			p = (struct dup_cluster *) dnode_get(n);
> -			if (lc != pb->cur_cluster)
> 				decrement_badcount(ctx, *block_nr, p);
> -		} else
> +		if (n)
> +			if (lc != pb->cur_cluster) {
> +				p = (struct dup_cluster *) dnode_get(n);
> 				decrement_badcount(ctx, *block_nr, p);
> +				pb->dup_blocks++;
> +			}
> +		else
> 			com_err("delete_file_block", 0,
> 			    _("internal error: can't find dup_blk for %llu\n"),
> 				*block_nr);

This is tricky to know which "if" the "else" is for without the added braces,
and to be honest I don't even know what the C standard says about this, which
is likely why the braces were there in the first place.  I would instead
recommend to add braces around the "else" clause to make it clear.

Cheers, Andreas






--Apple-Mail=_1D0BFE6A-9F94-48C8-A2DD-2CA6C960DB70
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZE5zQpIg59Q01vtYRAti+AJ4sz/aXwy8b+k2ty8RKynaEqkXx3ACbB8lv
1hjQ9ody1uZ+WOMCdwxuvvw=
=zKXQ
-----END PGP SIGNATURE-----

--Apple-Mail=_1D0BFE6A-9F94-48C8-A2DD-2CA6C960DB70--
