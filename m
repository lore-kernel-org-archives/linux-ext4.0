Return-Path: <SRS0=D/JD=QG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81ED2C169C4
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 01:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31DA6207E0
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 01:58:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="L44RIV6y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbfA3B6u (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 20:58:50 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43168 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbfA3B6u (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2019 20:58:50 -0500
Received: by mail-pg1-f196.google.com with SMTP id v28so9616916pgk.10
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 17:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=aRXDkC/Gh4evoSmKoJAyYXBl53kipZatA06N0d6F95k=;
        b=L44RIV6yum1XaLPOcsq+8Iigwu8xjwuw+lViOp9m82Dd+uewIWGWv4ek1e1Mx892/A
         HBRVolgCY3YaLZMNiLFypS9eRP2in/hjpq23Rmb5cj2x9MEShOcUB7KmZl9ojm2v2CCp
         5VkSrWA1abOJuIKtdmqjgMk8GG9jkphW1E7wEoGHEO/+LTY7+ALHVkmid/4VWx9hswsl
         bcRuys/bt4JEQCLSQ9N9IgN0daYG45p+EcAue3mGxTM5yW3yGnaT2MFYr23qIGT/BSYR
         ESVboMJudu7P6K2g2eKOEw7Vq/RKNUidpyrWf1fBGjA6yP408qmkXphOlv7hsZWRygI8
         IBUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=aRXDkC/Gh4evoSmKoJAyYXBl53kipZatA06N0d6F95k=;
        b=CgFi3VEu9RHKLcno2cW68dAzSy6NAuQXxxxS0JurTsQOnFCaxqK6JII9vpGJdqPZX1
         h1/8Ok4IqGWGMfXTt69A/SDT1bP42PfAv+5ONH0Cz9KK8Ni4LGvciAM9a0yJrS56fMM0
         fRXjCiSIIHCljbBsa8u92EZ63qtwJ8sdpyORTOA1TbAQsbqFpJ5xQp9wgRiHHF+HRz5K
         cVVksX1IosIvzyc72bQjITgLHPLbP6qCS3Y3jjjlXBcAleMOt/wd4sksbDsHQsapPt40
         8vzQCTMUUb2ZWqlvMEyY2Ww4OYgHt0ipiPUBWCFOpFmyidNCuuYx0lP21MIdW+ZaB9Lf
         KLlg==
X-Gm-Message-State: AJcUukfnjsK0zC3U5wDu7/RIswmjFNA8gK/qpvE62J10ZSxXnuHUlMwU
        tNDCrh6XvNkgpQAs4heXOjVzeg==
X-Google-Smtp-Source: ALg8bN53C8s7F9wCFZePusuWxLnIbK7K/2ZkHakxx/KCXFcr0Gb9/1ppRr+DWfocLpfdj+kjF5TxNA==
X-Received: by 2002:a63:5c41:: with SMTP id n1mr18558564pgm.1.1548813529371;
        Tue, 29 Jan 2019 17:58:49 -0800 (PST)
Received: from ?IPv6:2605:8d80:4a0:7c8a:14fc:648d:efbb:9e54? ([2605:8d80:4a0:7c8a:14fc:648d:efbb:9e54])
        by smtp.gmail.com with ESMTPSA id 184sm100903pfe.106.2019.01.29.17.58.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 17:58:48 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <949C18DE-F36E-4D7E-897A-FFC5865EF79C@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_8997C47C-7D84-406F-82F8-6EB4D330E8BE";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: shrink directory when last block is empty
Date:   Tue, 29 Jan 2019 18:58:46 -0700
In-Reply-To: <20190123183245.154246-1-harshadshirwadkar@gmail.com>
Cc:     umka@cloudlinux.com, linux-ext4@vger.kernel.org
To:     harshadshirwadkar@gmail.com
References: <CAD+ocbwgH6bHrPqB0ERM2YA703nASqRzLYCu-eJQn1uFgh1ivg@mail.gmail.com>
 <20190123183245.154246-1-harshadshirwadkar@gmail.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_8997C47C-7D84-406F-82F8-6EB4D330E8BE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 23, 2019, at 11:32 AM, harshadshirwadkar@gmail.com wrote:
>=20
> From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
>=20
> This patch is the first step towards shrinking htree based directories
> when files are deleted. We truncate directory inode when a directory
> entry removal causes last directory block to be empty. This patch just
> removes the last block. We may end up in a situation where many
> intermediate dirent blocks in directory inode are empty. Removing
> those blocks would be handled later.
>=20
> Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
> ---
> fs/ext4/namei.c | 130 ++++++++++++++++++++++++++++++++++++++++--------
> 1 file changed, 109 insertions(+), 21 deletions(-)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 2a4c25c4681d..79cb88ba898a 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -273,7 +273,8 @@ static int ext4_htree_next_block(struct inode =
*dir, __u32 hash,
> 				 __u32 *start_hash);
> static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
> 		struct ext4_filename *fname,
> -		struct ext4_dir_entry_2 **res_dir);
> +		struct ext4_dir_entry_2 **res_dir,
> +		struct dx_frame *dx_frame);

(style) these should align after '(' on the first line

> @@ -380,6 +381,7 @@ static void ext4_dirent_csum_set(struct inode =
*inode,
> 					   (void *)t - (void *)dirent);
> }
>=20
> +
> int ext4_handle_dirty_dirent_node(handle_t *handle,
> 				  struct inode *inode,
> 				  struct buffer_head *bh)

(style) No need for this hunk.

> @@ -866,6 +868,42 @@ dx_probe(struct ext4_filename *fname, struct =
inode *dir,
> 	return ret_err;
> }
>=20
> +static void
> +ext4_dx_delete_entry(handle_t *handle, struct inode *dir,
> +		     struct dx_frame *dx_frame, __le64 block)
> +{
> +	struct dx_entry *entries;
> +	unsigned int count, limit;
> +	int err, i;
> +
> +	entries =3D dx_frame->entries;
> +	count =3D dx_get_count(entries);
> +	limit =3D dx_get_limit(entries);
> +
> +	for (i =3D 0; i < count; i++)
> +		if (entries[i].block =3D=3D block)
> +			break;
> +
> +	if (i >=3D count)
> +		return;
> +
> +	err =3D ext4_journal_get_write_access(handle, dx_frame->bh);
> +	if (err) {
> +		ext4_std_error(dir->i_sb, err);
> +		return;
> +	}
> +
> +	for (; i < count - 1; i++)
> +		entries[i] =3D entries[i + 1];
> +
> +	dx_set_count(entries, count - 1);
> +	dx_set_limit(entries, limit);

I don't think you need to update the limit just because of the count =
changing?
This is just setting it back to the same value that dx_get_limit() =
returned earlier.

> @@ -1309,6 +1347,14 @@
> +static int is_empty_dirent_block(struct inode *dir, struct =
buffer_head *bh)

(style) this function should be type bool.  The older "is_*" functions =
were written
before "bool" was available in the kernel, though a separate cleanup =
patch to convert
them to bool would be welcome.

> +{
> +	struct ext4_dir_entry_2 *de =3D (struct ext4_dir_entry_2 =
*)bh->b_data;
> +
> +	return (ext4_rec_len_from_disk(de->rec_len, =
dir->i_sb->s_blocksize)
> +		=3D=3D dir->i_sb->s_blocksize);

(style) no need for () around return value.

>=20
> @@ -1339,7 +1385,8 @@ static int is_dx_internal_node(struct inode =
*dir, ext4_lblk_t block,
> static struct buffer_head * ext4_find_entry (struct inode *dir,
> 					const struct qstr *d_name,
> 					struct ext4_dir_entry_2 =
**res_dir,
> -					int *inlined)
> +					int *inlined,
> +					struct dx_frame *dx_frame)

(style) this can fit on the previous line, and they can all align after =
'(' on
the first line.  Please also remove the space after '*' in the function =
declaration.

> @@ -1486,9 +1533,10 @@ static struct buffer_head * ext4_find_entry =
(struct inode *dir,
> 	return ret;
> }
>=20
> -static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
> -			struct ext4_filename *fname,
> -			struct ext4_dir_entry_2 **res_dir)
> +static struct buffer_head *ext4_dx_find_entry(
> +			struct inode *dir, struct ext4_filename *fname,

(style) it isn't clear why you moved "struct inode *dir" from the =
previous line?
The continued lines look like they can properly align after '(' on the =
previous line.

> @@ -2337,9 +2389,13 @@ int ext4_generic_delete_entry(handle_t *handle,
> static int ext4_delete_entry(handle_t *handle,
> 			     struct inode *dir,
> 			     struct ext4_dir_entry_2 *de_del,
> -			     struct buffer_head *bh)
> +			     struct buffer_head *bh,
> +			     struct dx_frame *dx_frame)
> {
> +	struct ext4_map_blocks map;
> 	int err, csum_size =3D 0;
> +	int should_truncate =3D 0;

(style) bool should_truncate

> @@ -2363,11 +2419,35 @@ static int ext4_delete_entry(handle_t *handle,
> 	if (err)
> 		goto out;
>=20
> +	if (dx_frame && dx_frame->bh && is_empty_dirent_block(dir, bh)) =
{
> +

(style) no blank line here.

> +		map.m_lblk =3D (dir->i_size - 1) >>
> +			     (dir->i_sb->s_blocksize_bits);

(style) no need for parenthesis around dir->i_sb->s_blocksize_bits.
(style) this can fit on the previous line and still be under 80 columns.

> +		map.m_len =3D 1;
> +		err =3D ext4_map_blocks(handle, dir, &map, 0);
> +
> +		if ((err > 0) && (bh->b_blocknr =3D=3D map.m_pblk)) {

(style) no need for extra parenthesis around "err > 0" and "b_blocknr =3D=3D=
 m_pblk".

> +			ext4_dx_delete_entry(handle, dir, dx_frame,
> +					     cpu_to_le64(map.m_lblk));
> +			should_truncate =3D 1;
> +		}
> +	}
> +
> 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
> +
> 	err =3D ext4_handle_dirty_dirent_node(handle, dir, bh);
> 	if (unlikely(err))
> 		goto out;
>=20
> +	if (should_truncate) {
> +		dir->i_size -=3D dir->i_sb->s_blocksize;
> +		ext4_truncate(dir);

Since we have already mapped the last block above, I wonder if we can do =
something
lighter weight than calling ext4_truncate() here?  Maybe moving the =
ext4_truncate()
guts into a helper function like ext4_truncate_internal() that avoids =
all of the
complexity (orphan list, resizing the transaction, inline data, etc).

> +		if (dir->i_size =3D=3D dir->i_sb->s_blocksize) {
> +			ext4_clear_inode_flag(dir, EXT4_INODE_INDEX);
> +			ext4_mark_inode_dirty(handle, dir);

Are there any places in the code that assume an indexed directory will =
remain as such?
The tricky part here is that any valid htree directory will have 3 =
blocks (dx_root,
plus two leaf blocks), so it might be problematic to go back to a single =
non-htree
block, especially since this doesn't look like it has any locking.  It =
is probably
worthwhile to check the code for this.

> @@ -2985,6 +3065,9 @@ static int ext4_unlink(struct inode *dir, struct =
dentry *dentry)
> 	struct buffer_head *bh;
> 	struct ext4_dir_entry_2 *de;
> 	handle_t *handle =3D NULL;
> +	struct dx_frame dx_frame;
> +
> +	memset(&dx_frame, 0, sizeof(dx_frame));

Rather than an explicit memset(), this can use a struct initializer when =
it is declared:

	struct dx_frame dx_frame =3D { NULL };

Are there existing xfstests that cover this case?  Certainly deleting =
files from a
directory, but it would be useful to have something that checks whether =
the directory
size is shrinking and this code is working.

Cheers, Andreas






--Apple-Mail=_8997C47C-7D84-406F-82F8-6EB4D330E8BE
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxRBNYACgkQcqXauRfM
H+DMUg/+LRPeIMARbMkbWU4ygG+ZDFYq3ZsWnj4uCEReebLdG24UvaTjK1k9d+1G
xUp8I4wwxWsUah2wD/MBmWDLAliNsd47O5W7/uyu+L0PEABjc2c9nWWZiTj/bCn2
BmLRrp6xjY9DR7hnlN+sxYyA9PZOL0z+yFXUrTJGrAxERN72d561SgCSiOq825mt
EQ8WBS4iZcxM/Nm+2HycoEyJd3JCnQKBuGDxhBxqxt1VBxRXbPUOpS8AfwcSN5m8
b/GwkJdcKoVkM6SIDtjD3DDsq2CfG5u1hXlXG2Q9/oqtZA4M2kki8IULgA5zuc7M
Fnn8/JXM7qPzbeYO7Z20rmUvvWYwWR8BolRNdym9uBYV5cNZx0Glc4OncHtYyXJM
0lND5EJerhOQTEJEDPIyhdqfHxQyvXilnzdOb8C9DA9HlANlvOCyzCEuuzZ7vMXb
KLoJ7kQDtVW4kaNgaXkOpomMchcSR/oBMzQPEHjxZaN3xZxTPUdKCN7Eoe9wJKEG
u1tDeEbYJ9PetP+pyT4ob48Nud+wnecSV/C9HsMmeLU+f7cgrCYDYBbpgAO67Duf
+V3iwyRd2XcxltG+cr7161SqP6n0vrOBI2WJqtKLF9rHv8D53jZQMna6iePqsul2
SLTE297FMZG84eJbnoB+CV4kcagA4qNFEQtBe0VwgUxuacNA2Fg=
=5rQh
-----END PGP SIGNATURE-----

--Apple-Mail=_8997C47C-7D84-406F-82F8-6EB4D330E8BE--
