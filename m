From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] tune2fs: confirm slow/dangerous operations
Date: Fri, 4 Dec 2015 15:12:53 -0700
Message-ID: <ADF3DE2C-3BAF-4678-8B9B-7220F3333FE1@dilger.ca>
References: <20151203204024.GI10580@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_B9060D5E-34FF-43FC-B7FB-7D79F9B9B6F7"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36415 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbbLDWM7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2015 17:12:59 -0500
Received: by iofh3 with SMTP id h3so130963946iof.3
        for <linux-ext4@vger.kernel.org>; Fri, 04 Dec 2015 14:12:59 -0800 (PST)
In-Reply-To: <20151203204024.GI10580@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_B9060D5E-34FF-43FC-B7FB-7D79F9B9B6F7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 3, 2015, at 1:40 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> Give admins a short amount of time to confirm that they want to
> proceed with a dangerous operation.  Refuse to perform the op
> unless the filesystem is freshly checked.
>=20
> Cc: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> misc/tune2fs.c           |   41 ++++++++++----
> tests/t_dangerous/expect |   97 +++++++++++++++++++++++++++++++++
> tests/t_dangerous/name   |    1
> tests/t_dangerous/script |  134 =
++++++++++++++++++++++++++++++++++++++++++++++
> 4 files changed, 260 insertions(+), 13 deletions(-)
> create mode 100644 tests/t_dangerous/expect
> create mode 100644 tests/t_dangerous/name
> create mode 100644 tests/t_dangerous/script
>=20
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index af7d73c..aaa1597 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -405,14 +405,25 @@ static int update_mntopts(ext2_filsys fs, char =
*mntopts)
> 	return 0;
> }
>=20
> -static int check_fsck_needed(ext2_filsys fs)
> +static void check_fsck_needed(ext2_filsys fs, const char *prompt)
> {
> -	if (fs->super->s_state & EXT2_VALID_FS)
> -		return 0;
> -	printf("\n%s\n", _(please_fsck));
> -	if (mount_flags & EXT2_MF_READONLY)
> -		printf("%s", _("(and reboot afterwards!)\n"));
> -	return 1;
> +	/* Refuse to modify anything but a freshly checked valid =
filesystem. */
> +	if (!(fs->super->s_state & EXT2_VALID_FS) ||
> +	    (fs->super->s_state & EXT2_ERROR_FS) ||
> +	    (fs->super->s_lastcheck < fs->super->s_mtime)) {
> +		printf("\n%s\n", _(please_fsck));
> +		if (mount_flags & EXT2_MF_READONLY)
> +			printf("%s", _("(and reboot afterwards!)\n"));
> +		exit(1);
> +	}

Should this explicitly check for NEEDS_RECOVERY, or force journal replay
directly?  It would be a sad thing if the filesystem was modified and =
then
journal replay clobbered it.

> +
> +	/* Give the admin a few seconds to bail out of a dangerous op. =
*/
> +	if (!getenv("TUNE2FS_FORCE_PROMPT") && (!isatty(0) || =
!isatty(1)))
> +		return;
> +
> +	puts(prompt);
> +	proceed_question(5);
> +	return;
> }
>=20
> static void request_dir_fsck_afterwards(ext2_filsys fs)
> @@ -1145,8 +1156,8 @@ mmp_error:
>=20
> 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
> 		       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
> -		if (check_fsck_needed(fs))
> -			exit(1);
> +		check_fsck_needed(fs,
> +			_("Enabling checksums could take some time."));
> 		if (mount_flags & EXT2_MF_MOUNTED) {
> 			fputs(_("Cannot enable metadata_csum on a =
mounted "
> 				"filesystem!\n"), stderr);
> @@ -1186,8 +1197,8 @@ mmp_error:
> 			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
> 		__u32	test_features[3];
>=20
> -		if (check_fsck_needed(fs))
> -			exit(1);
> +		check_fsck_needed(fs,
> +			_("Disabling checksums could take some time."));
> 		if (mount_flags & EXT2_MF_MOUNTED) {
> 			fputs(_("Cannot disable metadata_csum on a =
mounted "
> 				"filesystem!\n"), stderr);
> @@ -2784,6 +2795,8 @@ retry_open:
> 			rc =3D 1;
> 			goto closefs;
> 		}
> +		check_fsck_needed(fs,
> +			_("Resizing inodes could take some time."));
> 		/*
> 		 * If inode resize is requested use the
> 		 * Undo I/O manager
> @@ -2999,8 +3012,10 @@ retry_open:
> 				try_confirm_csum_seed_support();
> 				exit(1);
> 			}
> -			if (check_fsck_needed(fs))
> -				exit(1);
> +			if (!ext2fs_has_feature_csum_seed(fs->super))
> +				check_fsck_needed(fs,
> +					_("Setting UUID on a checksummed =
"
> +					  "filesystem could take some =
time."));
>=20
> 			/*
> 			 * Determine if the block group checksums are
> diff --git a/tests/t_dangerous/expect b/tests/t_dangerous/expect
> new file mode 100644
> index 0000000..353bd57
> --- /dev/null
> +++ b/tests/t_dangerous/expect
> @@ -0,0 +1,97 @@
> +tune2fs dangerous prompts test
> +Creating filesystem with 524288 1k blocks and 65536 inodes
> +Superblock backups stored on blocks:
> +	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
> +
> +Allocating group tables:      =08=08=08=08=08done
> +Writing inode tables:      =08=08=08=08=08done
> +Creating journal (16384 blocks): done
> +Creating 445 huge file(s) with 1024 blocks each: done
> +Writing superblocks and filesystem accounting information:      =
=08=08=08=08=08done
> +
> +tune2fs -O metadata_csum test.img
> +
> +Please run e2fsck on the filesystem.
> +
> +Exit status is 1
> +tune2fs -O metadata_csum test.img
> +Exit status is 0
> +Creating filesystem with 524288 1k blocks and 65536 inodes
> +Superblock backups stored on blocks:
> +	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
> +
> +Allocating group tables:      =08=08=08=08=08done
> +Writing inode tables:      =08=08=08=08=08done
> +Creating journal (16384 blocks): done
> +Creating 445 huge file(s) with 1024 blocks each: done
> +Writing superblocks and filesystem accounting information:      =
=08=08=08=08=08done
> +
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +
> +Exit status is 0
> +tune2fs -O metadata_csum test.img
> +Enabling checksums could take some time.
> +Proceed anyway (or wait 5 seconds) ? (y,n)
> +Exit status is 1
> +tune2fs -I 512 test.img
> +Resizing inodes could take some time.
> +Proceed anyway (or wait 5 seconds) ? (y,n)
> +Exit status is 1
> +tune2fs -U random test.img
> +Setting UUID on a checksummed filesystem could take some time.
> +Proceed anyway (or wait 5 seconds) ? (y,n)
> +Exit status is 1

Hmm, but shouldn't the "proceed anyway" prompt actually continue
if there is no input so that scripts don't break?  Why do these
questions even get printed in the first place when running a script?

Cheers, Andreas

> +Change in FS metadata:
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +
> +Exit status is 0
> +tune2fs -O metadata_csum test.img
> +Enabling checksums could take some time.
> +Proceed anyway (or wait 5 seconds) ? (y,n)
> +Please run e2fsck -D on the filesystem.
> +
> +Exit status is 0
> +test_filesys was not cleanly unmounted, check forced.
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 3A: Optimizing directories
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +
> +
> +
> +tune2fs -I 512 test.img
> +Resizing inodes could take some time.
> +Proceed anyway (or wait 5 seconds) ? (y,n) Setting inode size 512
> +Exit status is 0
> +tune2fs -U f0f0f0f0-f0f0-f0f0-f0f0-f0f0f0f0f0f0 test.img
> +Setting UUID on a checksummed filesystem could take some time.
> +Proceed anyway (or wait 5 seconds) ? (y,n) Exit status is 0
> +Backing up journal inode block information.
> +
> +
> +Change in FS metadata:
> +@@ -1,3 +1,3 @@
> +-Filesystem UUID:          6fc3daa4-180d-4f2b-a6f2-f7a5efb79bcf
> +-Filesystem features:      has_journal ext_attr resize_inode =
dir_index filetype extent 64bit sparse_super large_file huge_file =
uninit_bg dir_nlink extra_isize
> +-Inode size:	          256
> ++Filesystem UUID:          f0f0f0f0-f0f0-f0f0-f0f0-f0f0f0f0f0f0
> ++Filesystem features:      has_journal ext_attr resize_inode =
dir_index filetype extent 64bit sparse_super large_file huge_file =
dir_nlink extra_isize metadata_csum
> ++Inode size:	          512
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +
> +Exit status is 0
> diff --git a/tests/t_dangerous/name b/tests/t_dangerous/name
> new file mode 100644
> index 0000000..c9a1030
> --- /dev/null
> +++ b/tests/t_dangerous/name
> @@ -0,0 +1 @@
> +dangerous tune2fs operation prompts
> diff --git a/tests/t_dangerous/script b/tests/t_dangerous/script
> new file mode 100644
> index 0000000..ee6e90c
> --- /dev/null
> +++ b/tests/t_dangerous/script
> @@ -0,0 +1,134 @@
> +FSCK_OPT=3D-fn
> +OUT=3D$test_name.log
> +EXP=3D$test_dir/expect
> +CONF=3D$TMPFILE.conf
> +
> +cat > $CONF << ENDL
> +[fs_types]
> +	ext4h =3D {
> +		features =3D =
has_journal,extent,huge_file,^flex_bg,uninit_bg,dir_nlink,extra_isize,spar=
se_super,filetype,dir_index,ext_attr,resize_inode,64bit
> +		blocksize =3D 1024
> +		inode_size =3D 256
> +		make_hugefiles =3D true
> +		hugefiles_dir =3D /
> +		hugefiles_slack =3D 32M
> +		hugefiles_name =3D aaaaa
> +		hugefiles_digits =3D 4
> +		hugefiles_size =3D 1M
> +		zero_hugefiles =3D false
> +	}
> +ENDL
> +
> +echo "tune2fs dangerous prompts test" > $OUT
> +
> +MKE2FS_CONFIG=3D$CONF $MKE2FS -F -T ext4h -U =
6fc3daa4-180d-4f2b-a6f2-f7a5efb79bcf $TMPFILE 524288 >> $OUT 2>&1
> +
> +# trigger a filesystem check
> +$DEBUGFS -w -R 'ssv mtime 300000000' $TMPFILE > /dev/null 2>&1
> +$DEBUGFS -w -R 'ssv lastcheck 20000' $TMPFILE > /dev/null 2>&1
> +
> +# add mcsum
> +echo "tune2fs -O metadata_csum test.img" >> $OUT
> +$TUNE2FS -O metadata_csum $TMPFILE >> $OUT 2>&1
> +status=3D$?
> +echo Exit status is $status >> $OUT
> +
> +# check fs
> +$FSCK -f -y -N test_filesys $TMPFILE > /dev/null 2>&1
> +
> +# add mcsum
> +echo "tune2fs -O metadata_csum test.img" >> $OUT
> +$TUNE2FS -O metadata_csum $TMPFILE >> $OUT 2>&1
> +status=3D$?
> +echo Exit status is $status >> $OUT
> +
> +MKE2FS_CONFIG=3D$CONF $MKE2FS -F -T ext4h -U =
6fc3daa4-180d-4f2b-a6f2-f7a5efb79bcf $TMPFILE 524288 >> $OUT 2>&1
> +
> +# dump and check
> +$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f =
$cmd_dir/filter.sed > $OUT.before
> +$FSCK $FSCK_OPT -f -N test_filesys $TMPFILE >> $OUT 2>&1
> +status=3D$?
> +echo Exit status is $status >> $OUT
> +
> +# add mcsum
> +echo "tune2fs -O metadata_csum test.img" >> $OUT
> +echo 'n' | TUNE2FS_FORCE_PROMPT=3D1 $TUNE2FS -O metadata_csum =
$TMPFILE >> $OUT 2>&1
> +status=3D$?
> +echo Exit status is $status >> $OUT
> +
> +# change inode size
> +echo "tune2fs -I 512 test.img" >> $OUT
> +echo 'n' | TUNE2FS_FORCE_PROMPT=3D1 $TUNE2FS -I 512 $TMPFILE >> $OUT =
2>&1
> +status=3D$?
> +echo Exit status is $status >> $OUT
> +
> +# change uuid
> +echo "tune2fs -U random test.img" >> $OUT
> +echo 'n' | TUNE2FS_FORCE_PROMPT=3D1 $TUNE2FS -U random $TMPFILE >> =
$OUT 2>&1
> +status=3D$?
> +echo Exit status is $status >> $OUT
> +
> +# check
> +$FSCK -yD -N test_filesys $TMPFILE >> $OUT 2>&1
> +
> +# dump and check
> +$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f =
$cmd_dir/filter.sed > $OUT.after
> +echo "Change in FS metadata:" >> $OUT
> +diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
> +$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
> +status=3D$?
> +echo Exit status is $status >> $OUT
> +
> +$DUMPE2FS $TMPFILE 2> /dev/null | egrep '^(Filesystem =
features:|Filesystem UUID:|Inode size:)' > $OUT.before
> +
> +# add mcsum
> +echo "tune2fs -O metadata_csum test.img" >> $OUT
> +echo 'y' | TUNE2FS_FORCE_PROMPT=3D1 $TUNE2FS -O metadata_csum =
$TMPFILE >> $OUT 2>&1
> +status=3D$?
> +echo Exit status is $status >> $OUT
> +$FSCK -yD -N test_filesys $TMPFILE >> $OUT 2>&1
> +
> +# change inode size
> +echo "tune2fs -I 512 test.img" >> $OUT
> +echo 'y' | TUNE2FS_FORCE_PROMPT=3D1 $TUNE2FS -I 512 $TMPFILE >> $OUT =
2>&1
> +status=3D$?
> +echo Exit status is $status >> $OUT
> +
> +# change uuid
> +echo "tune2fs -U f0f0f0f0-f0f0-f0f0-f0f0-f0f0f0f0f0f0 test.img" >> =
$OUT
> +echo 'y' | TUNE2FS_FORCE_PROMPT=3D1 $TUNE2FS -U =
f0f0f0f0-f0f0-f0f0-f0f0-f0f0f0f0f0f0 $TMPFILE >> $OUT 2>&1
> +status=3D$?
> +echo Exit status is $status >> $OUT
> +
> +# check
> +$FSCK -yD -N test_filesys $TMPFILE >> $OUT 2>&1
> +
> +# dump and check
> +$DUMPE2FS $TMPFILE 2> /dev/null | egrep '^(Filesystem =
features:|Filesystem UUID:|Inode size:)' > $OUT.after
> +echo "Change in FS metadata:" >> $OUT
> +diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
> +$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
> +status=3D$?
> +echo Exit status is $status >> $OUT
> +
> +rm $TMPFILE $OUT.before $OUT.after $CONF
> +
> +#
> +# Do the verification
> +#
> +
> +sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e =
's/test_filesys:.*//g' < $OUT > $OUT.new
> +mv $OUT.new $OUT
> +
> +cmp -s $OUT $EXP
> +status=3D$?
> +
> +if [ "$status" =3D 0 ] ; then
> +	echo "$test_name: $test_description: ok"
> +	touch $test_name.ok
> +else
> +	echo "$test_name: $test_description: failed"
> +	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
> +fi
> +
> +unset IMAGE FSCK_OPT OUT EXP CONF


Cheers, Andreas






--Apple-Mail=_B9060D5E-34FF-43FC-B7FB-7D79F9B9B6F7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVmIP5nKl2rkXzB/gAQgPKA/9HNskCnNKYMaO+SBx396nVV7CHj+ncKaK
TMA9rRMihWSbCIm4hXBVeKMxi5gikXqYkwvSv330zW6EylYehx1sVEnmOMnmyc1I
8Vpzvso0zUWb41ny0GXkziC7uzFjY48pBXoFPy9PyTvXGPs2VWmyiCJnnGXONsQy
Um+fiH0/LquCpEUShZ5/VJ+lqfpIqFRW97Vxb9BHZURgdVD3VwVFCUqVQVHf8uM4
/QZB1SbnadGY1MmDnRJpL/ILNjj3Kq4JAEl0v5ieaoDHoZfvDhdzN0UkuNX1QHn/
yHUQU36crg9A9dX4XQgpAKpGkQJDvD6V2q0Jondp3v7fhjhut1abjfGNnYgHk1Nc
fNtvYPUofCy5ryBAZ9dXUD6uEPTGnUhSWg7A2UijRSs2kk7pnK1sb2glYcmqKlS7
CmVtaQU6czBd9rKhNWdjCZjzi3UoV1SASGbQbhr80ttZFE2Kv3S/tyZIPEQlV4rt
wsuekVEhveSnWKgl3wxeL3IAn3j0h3/KYq6PEjXIUvOCSuXdXF+hiV2P1lBkZvG7
PxbedwRIuXoCzn4yy9dp1XaTGSUEJC1redpqYOXdaL3YWG2r1NtoIDvt5Opdyi+l
FmkM6H/J3PN0wkOidoM1+FejyZEr7xMc2if1eczTl5qsKbvmtoLUn2kRxmFxf9qg
W7r9ioh0xOc=
=o3Si
-----END PGP SIGNATURE-----

--Apple-Mail=_B9060D5E-34FF-43FC-B7FB-7D79F9B9B6F7--
