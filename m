From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsck: set dir_nlink feature if large dir exists
Date: Fri, 18 Aug 2017 12:45:21 -0600
Message-ID: <3016732A-E5AA-4EE7-980A-05323CD346A6@dilger.ca>
References: <1503080382-37376-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_5E84B4BC-E542-4482-98C7-95AECE9244F2";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:38746 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdHRSpa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Aug 2017 14:45:30 -0400
Received: by mail-io0-f195.google.com with SMTP id g71so29480ioe.5
        for <linux-ext4@vger.kernel.org>; Fri, 18 Aug 2017 11:45:30 -0700 (PDT)
In-Reply-To: <1503080382-37376-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_5E84B4BC-E542-4482-98C7-95AECE9244F2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Aug 18, 2017, at 12:19 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>=20
> If there is a directory with more than EXT2_LINK_MAX (65000)
> subdirectories, but the DIR_NLINK feature is not set in the
> superblock, the feature should be set before continuing on
> to change the on-disk directory link count to 1.
>=20
> While most filesystems should have DIR_NLINK set (it was set
> by default for all ext4 filesystems, and the kernel before
> 4.12 automatically set it if the directory link count grew
> too large), it is possible that this flag is lost due to disk
> corruption or for an upgraded filesystem.  We no longer want
> the kernel to automatically enable this feature.
>=20
> Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=3D196405
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> ---

Note that this is using the f_large_dir test for verification,
since it was already creating a directory with 48k entries in
it and already took ages to run because directory processing
in libext2fs is O(n^2) (it took about 2h to finish in my VM).
The alternative is storing a 100MB image file (though it may
be possible to compress it significantly).

I'm working on a patch to improve the debugfs "expand" command
so that it can insert multiple directory blocks at once, rather
than one-at-a-time (after a full directory scan).  That at least
fixes half of the problem.

Cheers, Andreas

> e2fsck/pass4.c           | 12 +++++++++-
> e2fsck/problem.c         |  5 ++++
> e2fsck/problem.h         |  3 +++
> tests/f_large_dir/expect |  7 ++++--
> tests/f_large_dir/script | 60 =
++++++++++++++++++++++++++++++------------------
> 5 files changed, 62 insertions(+), 25 deletions(-)
>=20
> diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
> index 663f87a..d0ff8e9 100644
> --- a/e2fsck/pass4.c
> +++ b/e2fsck/pass4.c
> @@ -170,6 +170,7 @@ void e2fsck_pass4(e2fsck_t ctx)
> #endif
> 	struct problem_context	pctx;
> 	__u16	link_count, link_counted;
> +	int dir_nlink_fs;
> 	char	*buf =3D 0;
> 	dgrp_t	group, maxgroup;
>=20
> @@ -193,6 +194,8 @@ void e2fsck_pass4(e2fsck_t ctx)
> 	if (!(ctx->options & E2F_OPT_PREEN))
> 		fix_problem(ctx, PR_4_PASS_HEADER, &pctx);
>=20
> +	dir_nlink_fs =3D ext2fs_has_feature_dir_nlink(fs->super);
> +
> 	group =3D 0;
> 	maxgroup =3D fs->group_desc_count;
> 	if (ctx->progress)
> @@ -249,8 +252,15 @@ void e2fsck_pass4(e2fsck_t ctx)
> 					    &link_counted);
> 		}
> 		isdir =3D ext2fs_test_inode_bitmap2(ctx->inode_dir_map, =
i);
> -		if (isdir && (link_counted > EXT2_LINK_MAX))
> +		if (isdir && (link_counted > EXT2_LINK_MAX)) {
> +			if (!dir_nlink_fs &&
> +			    fix_problem(ctx, PR_4_DIR_NLINK_FEATURE, =
&pctx)) {
> +				ext2fs_set_feature_dir_nlink(fs->super);
> +				ext2fs_mark_super_dirty(fs);
> +				dir_nlink_fs =3D 1;
> +			}
> 			link_counted =3D 1;
> +		}
> 		if (link_counted !=3D link_count) {
> 			e2fsck_read_inode_full(ctx, i, =
EXT2_INODE(inode),
> 					       inode_size, "pass4");
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index 9706933..25c1de9 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1873,6 +1873,11 @@ static struct e2fsck_problem problem_table[] =3D =
{
> 	  N_("@a @i %i ref count is %N, @s %n. "),
> 	  PROMPT_FIX, PR_PREEN_OK },
>=20
> +	/* directory exceeds max links, but no DIR_NLINK feature in =
superblock*/
> +	{ PR_4_DIR_NLINK_FEATURE,
> +	  N_("@d exceeds max links, but no DIR_NLINK feature in @S.\n"),
> +	  PROMPT_FIX, 0 },
> +
> 	/* Pass 5 errors */
>=20
> 	/* Pass 5: Checking group summary information */
> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> index f30f8f0..07ed0a7 100644
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -1134,6 +1134,9 @@ struct problem_context {
> /* Extended attribute inode ref count wrong */
> #define PR_4_EA_INODE_REF_COUNT		0x040005
>=20
> +/* directory exceeds max links, but no DIR_NLINK feature in =
superblock */
> +#define PR_4_DIR_NLINK_FEATURE		0x040006
> +
> /*
>  * Pass 5 errors
>  */
> diff --git a/tests/f_large_dir/expect b/tests/f_large_dir/expect
> index b099460..4b9ca6f 100644
> --- a/tests/f_large_dir/expect
> +++ b/tests/f_large_dir/expect
> @@ -3,10 +3,13 @@ Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 3A: Optimizing directories
> Pass 4: Checking reference counts
> -Inode 13 ref count is 1, should be 47245.  Fix? yes
> +Directory exceeds max links, but no DIR_NLINK feature in superblock.
> +Fix? yes
> +
> +Inode 12 ref count is 65012, should be 1.  Fix? yes
>=20
> Pass 5: Checking group summary information
>=20
> test.img: ***** FILE SYSTEM WAS MODIFIED *****
> -test.img: 13/115368 files (0.0% non-contiguous), 32817/460800 blocks
> +test.img: 65023/65104 files (0.0% non-contiguous), 96668/100937 =
blocks
> Exit status is 1
> diff --git a/tests/f_large_dir/script b/tests/f_large_dir/script
> index 0b5fdff..a10fe16 100644
> --- a/tests/f_large_dir/script
> +++ b/tests/f_large_dir/script
> @@ -5,43 +5,59 @@ E2FSCK=3D../e2fsck/e2fsck
> NAMELEN=3D255
> DIRENT_SZ=3D8
> BLOCKSZ=3D1024
> +INODESZ=3D128
> DIRENT_PER_LEAF=3D$((BLOCKSZ / (NAMELEN + DIRENT_SZ)))
> HEADER=3D32
> INDEX_SZ=3D8
> INDEX_L1=3D$(((BLOCKSZ - HEADER) / INDEX_SZ))
> INDEX_L2=3D$(((BLOCKSZ - DIRENT_SZ) / INDEX_SZ))
> ENTRIES=3D$((INDEX_L1 * INDEX_L2 * DIRENT_PER_LEAF))
> +DIRBLK=3D$((2 + INDEX_L1 * INDEX_L2))
> +EXT4_LINK_MAX=3D65000
> +[ $ENTRIES -lt $((EXT4_LINK_MAX + 10)) ] && ENTRIES=3D$((EXT4_LINK_MAX =
+ 10))
> +FSIZE=3D$(((DIRBLK + EXT4_LINK_MAX * ((BLOCKSZ + INODESZ) / BLOCKSZ)) =
* 5 / 4))
>=20
> -cp /dev/null $OUT
> -$MKE2FS -b 1024 -O large_dir,uninit_bg,dir_nlink -F $TMPFILE 460800 \
> -	> /dev/null 2>&1
> +> $OUT
> +$MKE2FS -b 1024 -O large_dir,uninit_bg -N $((ENTRIES + 50)) \
> +	-I $INODESZ -F $TMPFILE $FSIZE > $OUT 2>&1
> +RC=3D$?
> +if [ $RC -eq 0 ]; then
> {
> -	echo "feature large_dir"
> +	START=3D$SECONDS
> 	echo "mkdir /foo"
> 	echo "cd /foo"
> -	touch foofile
> -	echo "write foofile foofile"
> +	touch $TMPFILE.tmp
> +	echo "write $TMPFILE.tmp foofile"
> 	i=3D0
> -	while test $i  -lt $ENTRIES ; do
> -	    if test $(( i % DIRENT_PER_LEAF )) -eq 0 ; then
> -		echo "expand ./"
> +	while test $i -lt $ENTRIES ; do
> +	    if test $((i % DIRENT_PER_LEAF)) -eq 0; then
> +	    	echo "expand ./"
> 	    fi
> -	    if test $(( i % 5000 )) -eq 0 -a $i -gt 0 ; then
> -		>&2 echo "$test_name: $i processed"
> +	    if test $((i % 5000)) -eq 0 -a $i -gt 0; then
> +		ELAPSED=3D$((SECONDS - START))
> +		RATE=3D$((i / ELAPSED))
> +		>&2 echo "$test_name: $i processed in ${ELAPSED}s @ =
$RATE/s"
> 	    fi
> -	    printf "ln foofile %0255X\n" $i
> -	    i=3D$(($i + 1))
> +	    if test $i -lt $((EXT4_LINK_MAX + 10)); then
> +		printf "mkdir d%0254u\n" $i
> +	    else
> +		printf "ln foofile f%0254u\n" $i
> +	    fi
> +	    i=3D$((i + 1))
> 	done
> -} | $DEBUGFS -w -f /dev/stdin $TMPFILE > /dev/null 2>&1
> -
> -$E2FSCK -yfD $TMPFILE > $OUT.new 2>&1
> -status=3D$?
> -echo Exit status is $status >> $OUT.new
> -sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
> -rm -f $OUT.new
> +} | $DEBUGFS -w -f /dev/stdin $TMPFILE > $OUT
> +	RC=3D$?
> +fi
> +if [ $RC -eq 0 ]; then
> +	$E2FSCK -yfD $TMPFILE > $OUT.new 2>&1
> +	status=3D$?
> +	echo "Exit status is $status" >> $OUT.new
> +	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new > =
$OUT
> +	rm -f $OUT.new
>=20
> -cmp -s $OUT $EXP
> -RC=3D$?
> +	cmp -s $OUT $EXP
> +	RC=3D$?
> +fi
> if [ $RC -eq 0 ]; then
> 	echo "$test_name: $test_description: ok"
> 	touch $test_name.ok
> --
> 1.8.0
>=20


Cheers, Andreas






--Apple-Mail=_5E84B4BC-E542-4482-98C7-95AECE9244F2
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZlzXEpIg59Q01vtYRAqynAKDVCAHOT8uqdPhgA8wmHc7yPc8GCACgjD7V
CVooJ/iNmbpVjD/PXfodoB8=
=YcMf
-----END PGP SIGNATURE-----

--Apple-Mail=_5E84B4BC-E542-4482-98C7-95AECE9244F2--
