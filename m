From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: delete useless comments about ext4_move_extents
Date: Tue, 07 Oct 2014 13:42:09 +0400
Message-ID: <878uks8bda.fsf@openvz.org>
References: <1412670990-12903-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: tytso@mit.edu, Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:51204 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbaJGJmT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2014 05:42:19 -0400
Received: by mail-la0-f43.google.com with SMTP id mc6so5978348lab.2
        for <linux-ext4@vger.kernel.org>; Tue, 07 Oct 2014 02:42:17 -0700 (PDT)
In-Reply-To: <1412670990-12903-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com> writes:

> In patch 'ext4: refactor ext4_move_extents code base',  Dmitry Monakhov h=
as
> refactored ext4_move_extents' implementation, but forgot to update the
> corresponding comments, this patch will try to delete some useless commen=
ts.
>
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Ohh, yes thank you.
You can add reviewed-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/move_extent.c | 59 ++++++---------------------------------------=
------
>  1 file changed, 6 insertions(+), 53 deletions(-)
>
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index 5d78063..9f2311b 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -120,33 +120,12 @@ out:
>  }
>=20=20
>  /**
> - * mext_replace_branches - Replace original extents with new extents
> - *
> - * @handle:		journal handle
> - * @orig_inode:		original inode
> - * @donor_inode:	donor inode
> - * @from:		block offset of orig_inode
> - * @count:		block count to be replaced
> - * @err:		pointer to save return value
> - *
> - * Replace original inode extents and donor inode extents page by page.
> - * We implement this replacement in the following three steps:
> - * 1. Save the block information of original and donor inodes into
> - *    dummy extents.
> - * 2. Change the block information of original inode to point at the
> - *    donor inode blocks.
> - * 3. Change the block information of donor inode to point at the saved
> - *    original inode blocks in the dummy extents.
> - *
> - * Return replaced block count.
> - */
> -
> -/**
>   * mext_page_double_lock - Grab and lock pages on both @inode1 and @inod=
e2
>   *
>   * @inode1:	the inode structure
>   * @inode2:	the inode structure
> - * @index:	page index
> + * @index1:	page index
> + * @index2:	page index
>   * @page:	result page vector
>   *
>   * Grab two locked pages for inode's by inode order
> @@ -266,13 +245,14 @@ out:
>   * @o_filp:			file structure of original file
>   * @donor_inode:		donor inode
>   * @orig_page_offset:		page index on original file
> + * @donor_page_offset:		page index on donor file
>   * @data_offset_in_page:	block index where data swapping starts
>   * @block_len_in_page:		the number of blocks to be swapped
>   * @unwritten:			orig extent is unwritten or not
>   * @err:			pointer to save return value
>   *
>   * Save the data in original inode blocks and replace original inode ext=
ents
> - * with donor inode extents by calling mext_replace_branches().
> + * with donor inode extents by calling ext4_swap_extents().
>   * Finally, write out the saved data in new original inode blocks. Return
>   * replaced block count.
>   */
> @@ -551,41 +531,14 @@ mext_check_arguments(struct inode *orig_inode,
>   *
>   * @o_filp:		file structure of the original file
>   * @d_filp:		file structure of the donor file
> - * @orig_start:		start offset in block for orig
> - * @donor_start:	start offset in block for donor
> + * @orig_blk:		start offset in block for orig
> + * @donor_blk:		start offset in block for donor
>   * @len:		the number of blocks to be moved
>   * @moved_len:		moved block length
>   *
>   * This function returns 0 and moved block length is set in moved_len
>   * if succeed, otherwise returns error value.
>   *
> - * Note: ext4_move_extents() proceeds the following order.
> - * 1:ext4_move_extents() calculates the last block number of moving exte=
nt
> - *   function by the start block number (orig_start) and the number of b=
locks
> - *   to be moved (len) specified as arguments.
> - *   If the {orig, donor}_start points a hole, the extent's start offset
> - *   pointed by ext_cur (current extent), holecheck_path, orig_path are =
set
> - *   after hole behind.
> - * 2:Continue step 3 to step 5, until the holecheck_path points to last_=
extent
> - *   or the ext_cur exceeds the block_end which is last logical block nu=
mber.
> - * 3:To get the length of continues area, call mext_next_extent()
> - *   specified with the ext_cur (initial value is holecheck_path) re-cur=
sive,
> - *   until find un-continuous extent, the start logical block number exc=
eeds
> - *   the block_end or the extent points to the last extent.
> - * 4:Exchange the original inode data with donor inode data
> - *   from orig_page_offset to seq_end_page.
> - *   The start indexes of data are specified as arguments.
> - *   That of the original inode is orig_page_offset,
> - *   and the donor inode is also orig_page_offset
> - *   (To easily handle blocksize !=3D pagesize case, the offset for the
> - *   donor inode is block unit).
> - * 5:Update holecheck_path and orig_path to points a next proceeding ext=
ent,
> - *   then returns to step 2.
> - * 6:Release holecheck_path, orig_path and set the len to moved_len
> - *   which shows the number of moved blocks.
> - *   The moved_len is useful for the command to calculate the file offset
> - *   for starting next move extent ioctl.
> - * 7:Return 0 on success, or a negative error value on failure.
>   */
>  int
>  ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_b=
lk,
> --=20
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUM7VxAAoJEFzOBSYIXfveY+4P/1YvlN0FgQYji4PqRSyORSbT
TyKd2rMh4VpNR78MIbkUmv9O2ngf8wk7tm7RJG9swOA9u1d/KtZzt9QYg5x9yOHm
7ral1il6igYE/Lu0Hl+j9P3ffzNu727D1RHXpPyQ8m9Ps1LN1p7LZl8jR/1/oqbV
sk7AEkQZ++9NThIPnZwa1Vz6MeyGm4Mi/rgI7OnLJfyBC0oXMDK7mzvLUNJqyOXv
a3ButxoGkdd5hfeMwfHXxjdlWODfdcJDtpP+Gkm46C+bW0v/flWyxaw1RJwR7QoA
4vlmBo2V0H6t4QJckqx2LIblXsPZmxihbe4jTMrq40Uqah9wJAo+dRp7xxDcwrOa
tikRLD6JkNVJAL+SfLLI6dn1YuuUOzzI5Tg24J2PhlbTE9A2U72aIdL+OxENuyYM
lV2ISVAEFF7vxm6Vu4DKFa+JdNG+E1nuxk1FzEizcnmbepCKtNFuECgDZPp9uO/s
cPjcq6mgnecdYwj3/lt6TO3Ygv9IcpiUkDjZuUNfPtug+BEXm0MwrJ3/mbRFncEs
6Gaj6giqVwOhJ8pGA3VTGu87lwV3HURRxKn6m13vcAv6hT8owGAgOxIIfa/2mTWE
HJPtb6se3Q4XxETrFwIju9czMs/deKYVxNOBDyfZP+c0ja9td6oPNSuPa1ZMUleT
dAt6sU/HEIWw2dHwI3Z8
=UY7y
-----END PGP SIGNATURE-----
--=-=-=--
