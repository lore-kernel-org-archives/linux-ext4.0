From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 7/9] tune2fs: confirm dangerous operations
Date: Sun, 14 Feb 2016 17:49:42 -0700
Message-ID: <D0778787-FF4B-440B-919B-84430E48EFE8@dilger.ca>
References: <20160213223725.25381.20929.stgit@birch.djwong.org> <20160213223811.25381.24546.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34545 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbcBOAtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Feb 2016 19:49:41 -0500
Received: by mail-pa0-f65.google.com with SMTP id yy13so6509048pab.1
        for <linux-ext4@vger.kernel.org>; Sun, 14 Feb 2016 16:49:40 -0800 (PST)
In-Reply-To: <20160213223811.25381.24546.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 13, 2016, at 3:38 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> Give admins a short amount of time to confirm that they want to
> proceed with a dangerous operation.  Refuse to perform the op
> unless the filesystem is freshly checked.
> 
> Cc: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> misc/tune2fs.c           |   40 +++++++++-----
> tests/t_dangerous/expect |   97 +++++++++++++++++++++++++++++++++
> tests/t_dangerous/name   |    1 
> tests/t_dangerous/script |  134 ++++++++++++++++++++++++++++++++++++++++++++++
> 4 files changed, 259 insertions(+), 13 deletions(-)
> create mode 100644 tests/t_dangerous/expect
> create mode 100644 tests/t_dangerous/name
> create mode 100644 tests/t_dangerous/script
> 
> 
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index f9e654f..457e9e5 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -405,14 +405,24 @@ static int update_mntopts(ext2_filsys fs, char *mntopts)
> 	return 0;
> }
> 
> -static int check_fsck_needed(ext2_filsys fs)
> +static void check_fsck_needed(ext2_filsys fs, const char *prompt)
> {
> -	if (fs->super->s_state & EXT2_VALID_FS)
> -		return 0;
> -	printf("\n%s\n", _(please_fsck));
> -	if (mount_flags & EXT2_MF_READONLY)
> -		printf("%s", _("(and reboot afterwards!)\n"));
> -	return 1;
> +	/* Refuse to modify anything but a freshly checked valid filesystem. */
> +	if (!(fs->super->s_state & EXT2_VALID_FS) ||
> +	    (fs->super->s_state & EXT2_ERROR_FS) ||
> +	    (fs->super->s_lastcheck < fs->super->s_mtime)) {
> +		printf("\n%s\n", _(please_fsck));
> +		if (mount_flags & EXT2_MF_READONLY)
> +			printf("%s", _("(and reboot afterwards!)\n"));
> +		exit(1);
> +	}
> +
> +	/* Give the admin a few seconds to bail out of a dangerous op. */
> +	if (!getenv("TUNE2FS_FORCE_PROMPT") && (!isatty(0) || !isatty(1)))

One option would be to allow TUNE2FS_FORCE_PROMPT to contain the delay interval
instead of hard-coding this to 5s below?  IMHO, 5s is only long enough for
"oh sh**" and not enough to actually interrupt it unless you are watching the
output closely...

> +		return;
> +
> +	puts(prompt);
> +	proceed_question(5);
> }
> 
> static void request_dir_fsck_afterwards(ext2_filsys fs)
> @@ -1145,8 +1155,8 @@ mmp_error:
> 
> 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
> 		       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
> -		if (check_fsck_needed(fs))
> -			exit(1);
> +		check_fsck_needed(fs,
> +			_("Enabling checksums could take some time."));
> 		if (mount_flags & EXT2_MF_MOUNTED) {
> 			fputs(_("Cannot enable metadata_csum on a mounted "
> 				"filesystem!\n"), stderr);
> @@ -1186,8 +1196,8 @@ mmp_error:
> 			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
> 		__u32	test_features[3];
> 
> -		if (check_fsck_needed(fs))
> -			exit(1);
> +		check_fsck_needed(fs,
> +			_("Disabling checksums could take some time."));

Does disabling checksums actually take more time than just turning off the
feature in the superblock?  Without the feature flag all of the checksum
fields should be ignored (whether they contain 0 or stale checksums), and
they would be rewritten if/when the checksum feature is re-enabled.

> 		if (mount_flags & EXT2_MF_MOUNTED) {
> 			fputs(_("Cannot disable metadata_csum on a mounted "
> 				"filesystem!\n"), stderr);
> @@ -2784,6 +2794,8 @@ retry_open:
> 			rc = 1;
> 			goto closefs;
> 		}
> +		check_fsck_needed(fs,
> +			_("Resizing inodes could take some time."));
> 		/*
> 		 * If inode resize is requested use the
> 		 * Undo I/O manager
> @@ -2999,8 +3011,10 @@ retry_open:
> 				try_confirm_csum_seed_support();
> 				exit(1);
> 			}
> -			if (check_fsck_needed(fs))
> -				exit(1);
> +			if (!ext2fs_has_feature_csum_seed(fs->super))
> +				check_fsck_needed(fs,
> +					_("Setting UUID on a checksummed "
> +					  "filesystem could take some time."));

Wouldn't it make sense to enable the checksum seed feature in this case
instead of rewriting the checksums for the whole filesystem?

Cheers, Andreas

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
> +Allocating group tables:      done                            
> +Writing inode tables:      done                            
> +Creating journal (16384 blocks): done
> +Creating 445 huge file(s) with 1024 blocks each: done
> +Writing superblocks and filesystem accounting information:      done
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
> +Allocating group tables:      done                            
> +Writing inode tables:      done                            
> +Creating journal (16384 blocks): done
> +Creating 445 huge file(s) with 1024 blocks each: done
> +Writing superblocks and filesystem accounting information:      done
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
> +
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
> +-Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
> +-Inode size:	          256
> ++Filesystem UUID:          f0f0f0f0-f0f0-f0f0-f0f0-f0f0f0f0f0f0
> ++Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
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
> index 0000000..dc70ad2
> --- /dev/null
> +++ b/tests/t_dangerous/script
> @@ -0,0 +1,134 @@
> +FSCK_OPT=-fn
> +OUT=$test_name.log
> +EXP=$test_dir/expect
> +CONF=$TMPFILE.conf
> +
> +cat > $CONF << ENDL
> +[fs_types]
> +	ext4h = {
> +		features = has_journal,extent,huge_file,^flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,64bit
> +		blocksize = 1024
> +		inode_size = 256
> +		make_hugefiles = true
> +		hugefiles_dir = /
> +		hugefiles_slack = 32M
> +		hugefiles_name = aaaaa
> +		hugefiles_digits = 4
> +		hugefiles_size = 1M
> +		zero_hugefiles = false
> +	}
> +ENDL
> +
> +echo "tune2fs dangerous prompts test" > $OUT
> +
> +MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h -U 6fc3daa4-180d-4f2b-a6f2-f7a5efb79bcf $TMPFILE 524288 >> $OUT 2>&1
> +
> +# trigger a filesystem check
> +$DEBUGFS -w -R 'ssv mtime now' $TMPFILE > /dev/null 2>&1
> +$DEBUGFS -w -R 'ssv lastcheck 20000' $TMPFILE > /dev/null 2>&1
> +
> +# add mcsum
> +echo "tune2fs -O metadata_csum test.img" >> $OUT
> +$TUNE2FS -O metadata_csum $TMPFILE >> $OUT 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT
> +
> +# check fs
> +$FSCK -f -y -N test_filesys $TMPFILE > /dev/null 2>&1
> +
> +# add mcsum
> +echo "tune2fs -O metadata_csum test.img" >> $OUT
> +$TUNE2FS -O metadata_csum $TMPFILE >> $OUT 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT
> +
> +MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h -U 6fc3daa4-180d-4f2b-a6f2-f7a5efb79bcf $TMPFILE 524288 >> $OUT 2>&1
> +
> +# dump and check
> +$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.before
> +$FSCK $FSCK_OPT -f -N test_filesys $TMPFILE >> $OUT 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT
> +
> +# add mcsum
> +echo "tune2fs -O metadata_csum test.img" >> $OUT
> +echo 'n' | TUNE2FS_FORCE_PROMPT=1 $TUNE2FS -O metadata_csum $TMPFILE >> $OUT 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT
> +
> +# change inode size
> +echo "tune2fs -I 512 test.img" >> $OUT
> +echo 'n' | TUNE2FS_FORCE_PROMPT=1 $TUNE2FS -I 512 $TMPFILE >> $OUT 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT
> +
> +# change uuid
> +echo "tune2fs -U random test.img" >> $OUT
> +echo 'n' | TUNE2FS_FORCE_PROMPT=1 $TUNE2FS -U random $TMPFILE >> $OUT 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT
> +
> +# check
> +$FSCK -yD -N test_filesys $TMPFILE >> $OUT 2>&1
> +
> +# dump and check
> +$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.after
> +echo "Change in FS metadata:" >> $OUT
> +diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
> +$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT
> +
> +$DUMPE2FS $TMPFILE 2> /dev/null | egrep '^(Filesystem features:|Filesystem UUID:|Inode size:)' > $OUT.before
> +
> +# add mcsum
> +echo "tune2fs -O metadata_csum test.img" >> $OUT
> +echo 'y' | TUNE2FS_FORCE_PROMPT=1 $TUNE2FS -O metadata_csum $TMPFILE >> $OUT 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT
> +$FSCK -yD -N test_filesys $TMPFILE >> $OUT 2>&1
> +
> +# change inode size
> +echo "tune2fs -I 512 test.img" >> $OUT
> +echo 'y' | TUNE2FS_FORCE_PROMPT=1 $TUNE2FS -I 512 $TMPFILE >> $OUT 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT
> +
> +# change uuid
> +echo "tune2fs -U f0f0f0f0-f0f0-f0f0-f0f0-f0f0f0f0f0f0 test.img" >> $OUT
> +echo 'y' | TUNE2FS_FORCE_PROMPT=1 $TUNE2FS -U f0f0f0f0-f0f0-f0f0-f0f0-f0f0f0f0f0f0 $TMPFILE >> $OUT 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT
> +
> +# check
> +$FSCK -yD -N test_filesys $TMPFILE >> $OUT 2>&1
> +
> +# dump and check
> +$DUMPE2FS $TMPFILE 2> /dev/null | egrep '^(Filesystem features:|Filesystem UUID:|Inode size:)' > $OUT.after
> +echo "Change in FS metadata:" >> $OUT
> +diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
> +$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT
> +
> +rm $TMPFILE $OUT.before $OUT.after $CONF
> +
> +#
> +# Do the verification
> +#
> +
> +sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
> +mv $OUT.new $OUT
> +
> +cmp -s $OUT $EXP
> +status=$?
> +
> +if [ "$status" = 0 ] ; then
> +	echo "$test_name: $test_description: ok"
> +	touch $test_name.ok
> +else
> +	echo "$test_name: $test_description: failed"
> +	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
> +fi
> +
> +unset IMAGE FSCK_OPT OUT EXP CONF
> 


Cheers, Andreas





