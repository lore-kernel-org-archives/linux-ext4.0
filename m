From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] tune2fs: disable csum verification before resizing inode
Date: Tue, 2 Dec 2014 21:39:51 -0800
Message-ID: <20141203053951.GB10059@birch.djwong.org>
References: <1415785780-3832-3-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1415956537-11212-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1415956537-11212-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <20141114231010.GK10043@birch.djwong.org>
 <20141117191039.GL10043@birch.djwong.org>
 <20141203034649.GS13618@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48323 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaLCFkC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Dec 2014 00:40:02 -0500
Content-Disposition: inline
In-Reply-To: <20141203034649.GS13618@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 02, 2014 at 10:46:49PM -0500, Theodore Ts'o wrote:
> On Mon, Nov 17, 2014 at 11:10:39AM -0800, Darrick J. Wong wrote:
> > When we're turning on metadata checksumming /and/ resizing the inode
> > at the same time, disable checksum verification during the
> > resize_inode() call because the subroutines it calls will try to
> > verify the checksums (which have not yet been set), causing the
> > operation to fail unnecessarily.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The t_iexpand_mcsum test is failing when I try applying this patch:
> 
> --- /usr/projects/e2fsprogs/e2fsprogs/tests/t_iexpand_mcsum/expect	2014-12-03 03:33:08.359025380 +0000
> +++ t_iexpand_mcsum.log	2014-12-03 03:38:42.519031358 +0000
> @@ -26,9 +26,388 @@
>  
>  Pass 1: Checking inodes, blocks, and sizes
>  Pass 2: Checking directory structure
> +Directory inode 2, block #0, offset 1004: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #116, offset 1000: directory passes checks but fails checksum.
> +Fix? yes

Arrrgh.  The fun of maintaining the test suite when the patches go into -next
in a different order from where they are in my tree... :)

The patches "e2fsck: only complain about no-checksum directory blocks once" and
"e2fsck: don't complain about root dir csum failures when getting lnf" fix fsck
not to print these unnecessary error messages.  They both pre-date the creation
of this patch, which is why the test is failing.  You can safely amend the
/expect file, but it'll be necessary to un-amend it if you take those two older
patches.

:)

--D

> +
> +Directory inode 2, block #117, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #118, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #119, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #120, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #121, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #122, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #123, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #1, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #2, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #3, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #4, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #5, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #6, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #7, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #8, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #9, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #10, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #11, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #12, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #13, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #14, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #15, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #16, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #17, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #18, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #19, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #20, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #21, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #22, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #23, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #24, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #25, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #26, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #27, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #28, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #29, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #30, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #31, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #32, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #33, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #34, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #35, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #36, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #37, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #38, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #39, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #40, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #41, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #42, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #43, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #44, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #45, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #46, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #47, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #48, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #49, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #50, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #51, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #52, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #53, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #54, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #55, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #56, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #57, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #58, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #59, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #60, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #61, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #62, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #63, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #64, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #65, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #66, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #67, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #68, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #69, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #70, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #71, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #72, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #73, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #74, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #75, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #76, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #77, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #78, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #79, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #80, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #81, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #82, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #83, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #84, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #85, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #86, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #87, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #88, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #89, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #90, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #91, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #92, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #93, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #94, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #95, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #96, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #97, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #98, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #99, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #100, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #101, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #102, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #103, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #104, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #105, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #106, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #107, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #108, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #109, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #110, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #111, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #112, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #113, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #114, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
> +Directory inode 2, block #115, offset 1000: directory passes checks but fails checksum.
> +Fix? yes
> +
>  Pass 3: Checking directory connectivity
> +Error while trying to find /lost+found: Directory block checksum does not match directory block
> +/lost+found not found.  Create? yes
> +
> +Error creating /lost+found directory (ext2fs_link): Directory block checksum does not match directory block
>  Pass 3A: Optimizing directories
>  Pass 4: Checking reference counts
> +Unattached inode 6346
> +Connect to /lost+found? yes
> +
>  Pass 5: Checking group summary information
>  
>  
> @@ -37,9 +416,11 @@
>  @@ -5 +5 @@
>  -Filesystem features:      has_journal ext_attr dir_index filetype extent 64bit sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
>  +Filesystem features:      has_journal ext_attr dir_index filetype extent 64bit sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
> -@@ -13 +13 @@
> --Free blocks:              16280
> -+Free blocks:              3958
> +@@ -13,2 +13,2 @@
> +-Free blocks:              16282
> +-Free inodes:              91959
> ++Free blocks:              3970
> ++Free inodes:              91958
>  @@ -22 +22 @@
>  -Inode blocks per group:   128
>  +Inode blocks per group:   256
> @@ -51,7 +432,17 @@
>  Pass 1: Checking inodes, blocks, and sizes
>  Pass 2: Checking directory structure
>  Pass 3: Checking directory connectivity
> +'..' in /lost+found/#6346 (6346) is / (2), should be /lost+found (11).
> +Fix? no
> +
>  Pass 4: Checking reference counts
> +Inode 2 ref count is 3, should be 4.  Fix? no
> +
> +Inode 6346 ref count is 3, should be 2.  Fix? no
> +
>  Pass 5: Checking group summary information
>  
> -Exit status is 0
> +
> +
> +
> +Exit status is 4
> 
> 
> > ---
> >  misc/tune2fs.c               |    7 +++-
> >  tests/t_iexpand_mcsum/expect |   57 ++++++++++++++++++++++++++++++
> >  tests/t_iexpand_mcsum/name   |    1 +
> >  tests/t_iexpand_mcsum/script |   80 ++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 144 insertions(+), 1 deletion(-)
> >  create mode 100644 tests/t_iexpand_mcsum/expect
> >  create mode 100644 tests/t_iexpand_mcsum/name
> >  create mode 100644 tests/t_iexpand_mcsum/script
> > 
> > diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> > index b510c49..f01b05b 100644
> > --- a/misc/tune2fs.c
> > +++ b/misc/tune2fs.c
> > @@ -2961,8 +2961,13 @@ retry_open:
> >  		 * We want to update group descriptor also
> >  		 * with the new free inode count
> >  		 */
> > +		if (rewrite_checksums)
> > +			fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
> >  		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
> > -		if (resize_inode(fs, new_inode_size) == 0) {
> > +		retval = resize_inode(fs, new_inode_size);
> > +		if (rewrite_checksums)
> > +			fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
> > +		if (retval == 0) {
> >  			printf(_("Setting inode size %lu\n"),
> >  							new_inode_size);
> >  			rewrite_checksums = 1;
> > diff --git a/tests/t_iexpand_mcsum/expect b/tests/t_iexpand_mcsum/expect
> > new file mode 100644
> > index 0000000..2bebc9f
> > --- /dev/null
> > +++ b/tests/t_iexpand_mcsum/expect
> > @@ -0,0 +1,57 @@
> > +tune2fs test
> > +Creating filesystem with 786432 1k blocks and 98304 inodes
> > +Superblock backups stored on blocks: 
> > +	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553
> > +
> > +Allocating group tables:      done                            
> > +Writing inode tables:      done                            
> > +Creating journal (16384 blocks): done
> > +Creating 6334 huge file(s) with 117 blocks each: done
> > +Writing superblocks and filesystem accounting information:      done
> > +
> > +Pass 1: Checking inodes, blocks, and sizes
> > +Pass 2: Checking directory structure
> > +Pass 3: Checking directory connectivity
> > +Pass 4: Checking reference counts
> > +Pass 5: Checking group summary information
> > +
> > +Exit status is 0
> > +tune2fs -I 256 -O metadata_csum test.img
> > +Setting inode size 256
> > +
> > +Please run e2fsck -D on the filesystem.
> > +
> > +Exit status is 0
> > +Backing up journal inode block information.
> > +
> > +Pass 1: Checking inodes, blocks, and sizes
> > +Pass 2: Checking directory structure
> > +Pass 3: Checking directory connectivity
> > +Pass 3A: Optimizing directories
> > +Pass 4: Checking reference counts
> > +Pass 5: Checking group summary information
> > +
> > +
> > +
> > +Change in FS metadata:
> > +@@ -5 +5 @@
> > +-Filesystem features:      has_journal ext_attr dir_index filetype extent 64bit sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
> > ++Filesystem features:      has_journal ext_attr dir_index filetype extent 64bit sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
> > +@@ -13 +13 @@
> > +-Free blocks:              16280
> > ++Free blocks:              3958
> > +@@ -22 +22 @@
> > +-Inode blocks per group:   128
> > ++Inode blocks per group:   256
> > +@@ -28 +28 @@
> > +-Inode size:	          128
> > ++Inode size:	          256
> > +@@ -31,0 +32 @@
> > ++Checksum type:            crc32c
> > +Pass 1: Checking inodes, blocks, and sizes
> > +Pass 2: Checking directory structure
> > +Pass 3: Checking directory connectivity
> > +Pass 4: Checking reference counts
> > +Pass 5: Checking group summary information
> > +
> > +Exit status is 0
> > diff --git a/tests/t_iexpand_mcsum/name b/tests/t_iexpand_mcsum/name
> > new file mode 100644
> > index 0000000..e767715
> > --- /dev/null
> > +++ b/tests/t_iexpand_mcsum/name
> > @@ -0,0 +1 @@
> > +expand inodes and turn on metadata_csum
> > diff --git a/tests/t_iexpand_mcsum/script b/tests/t_iexpand_mcsum/script
> > new file mode 100644
> > index 0000000..cb424ed
> > --- /dev/null
> > +++ b/tests/t_iexpand_mcsum/script
> > @@ -0,0 +1,80 @@
> > +if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
> > +
> > +FSCK_OPT=-fn
> > +OUT=$test_name.log
> > +EXP=$test_dir/expect
> > +CONF=$TMPFILE.conf
> > +
> > +#gzip -d < $EXP.gz > $EXP
> > +
> > +cat > $CONF << ENDL
> > +[fs_types]
> > +	ext4h = {
> > +		features = has_journal,extent,huge_file,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,^resize_inode,^meta_bg,^flex_bg,^metadata_csum,64bit
> > +		blocksize = 1024
> > +		inode_size = 256
> > +		make_hugefiles = true
> > +		hugefiles_dir = /
> > +		hugefiles_slack = 16000K
> > +		hugefiles_name = aaaaa
> > +		hugefiles_digits = 4
> > +		hugefiles_size = 117K
> > +		zero_hugefiles = false
> > +	}
> > +ENDL
> > +
> > +echo "tune2fs test" > $OUT
> > +
> > +MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h -I 128 $TMPFILE 786432 >> $OUT 2>&1
> > +rm -rf $CONF
> > +
> > +# dump and check
> > +($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2>&1 | sed -f $cmd_dir/filter.sed -e '/^Checksum:.*/d' >> $OUT.before 2> /dev/null
> > +$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
> > +status=$?
> > +echo Exit status is $status >> $OUT
> > +
> > +# convert it
> > +echo "tune2fs -I 256 -O metadata_csum test.img" >> $OUT
> > +dd if=/dev/zero of=$TMPFILE conv=notrunc bs=1 count=1 seek=3221225471 2> /dev/null
> > +$TUNE2FS -I 256 -O metadata_csum $TMPFILE >> $OUT 2>&1
> > +status=$?
> > +echo Exit status is $status >> $OUT
> > +$FSCK -N test_filesys -y -f -D $TMPFILE >> $OUT 2>&1
> > +
> > +# dump and check
> > +($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2>&1 | sed -f $cmd_dir/filter.sed -e '/^Checksum:.*/d' >> $OUT.after 2> /dev/null
> > +echo "Change in FS metadata:" >> $OUT
> > +diff -u0 $OUT.before $OUT.after | sed -e '/^---.*/d' -e '/^+++.*/d' >> $OUT
> > +$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
> > +status=$?
> > +echo Exit status is $status >> $OUT
> > +
> > +rm $TMPFILE
> > +
> > +#
> > +# Do the verification
> > +#
> > +
> > +sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
> > +mv $OUT.new $OUT
> > +
> > +cmp -s $OUT $EXP
> > +status=$?
> > +
> > +if [ "$status" = 0 ] ; then
> > +	echo "$test_name: $test_description: ok"
> > +	touch $test_name.ok
> > +else
> > +	echo "$test_name: $test_description: failed"
> > +	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
> > +fi
> > +
> > +rm $OUT.before $OUT.after
> > +
> > +unset IMAGE FSCK_OPT OUT EXP CONF
> > +
> > +else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
> > +	echo "$test_name: $test_description: skipped"
> > +fi
> > +
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
