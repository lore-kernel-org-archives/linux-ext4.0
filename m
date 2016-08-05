From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] ext4/022: Test expansion of inode size
Date: Fri, 5 Aug 2016 13:52:09 +0800
Message-ID: <20160805055209.GV27776@eguan.usersys.redhat.com>
References: <1470326975-13087-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbcHEFwN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Aug 2016 01:52:13 -0400
Content-Disposition: inline
In-Reply-To: <1470326975-13087-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 04, 2016 at 06:09:35PM +0200, Jan Kara wrote:
> ext4 supports dynamic expansion of inode size via inode's i_extra_size
> field. Test the code performing the expansion in the kernel.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  tests/ext4/022     | 183 +++++++++++++++++++++++
>  tests/ext4/022.out | 432 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ext4/group   |   1 +
>  3 files changed, 616 insertions(+)
>  create mode 100755 tests/ext4/022
>  create mode 100644 tests/ext4/022.out
> 
> diff --git a/tests/ext4/022 b/tests/ext4/022
> new file mode 100755
> index 000000000000..2d2452469e24
> --- /dev/null
> +++ b/tests/ext4/022
> @@ -0,0 +1,183 @@
> +#! /bin/bash
> +# FS QA Test 022
> +#
> +# Test extending of i_extra_isize code
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Fujitsu.  All Rights Reserved.

Wrong copyright? I can change it to "SUSE Linux Products GmbH." (grabbed
from your previous new tests)

> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +setfattr()

I'd like to rename it to something like do_setfattr, I found it not so
obvious that setfattr is a helper in this test, not a bare command.

> +{
> +	$SETFATTR_PROG $@ 2>&1 | _filter_scratch
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs ext4
> +_supported_os Linux
> +_require_scratch
> +_require_dumpe2fs
> +_require_command "$DEBUGFS_PROG" debugfs
> +_require_attrs
> +
> +# Use large inodes to have enough space for experimentation
> +INODE_SIZE=1024
> +# Block size
> +BLOCK_SIZE=4096
> +# We leave this amount of bytes for xattrs
> +XATTR_SPACE=256
> +# We grow extra_isize by this much
> +GROW_EXTRA_ISIZE=80
> +# We grow minimum requested isize by this much
> +GROW_MIN_EXTRA_ISIZE=16
> +
> +export MKFS_OPTIONS="-I $INODE_SIZE -b $BLOCK_SIZE"
> +_scratch_mkfs >> $seqres.full 2>&1
> +
> +ISIZE=$($DUMPE2FS_PROG -h $SCRATCH_DEV 2>/dev/null |
> +	grep "^Desired extra isize:" | awk '{print $4}')
> +# 32 bytes for header and 4 bytes for terminator
> +BLOCK_XATTR_SPACE=$(($BLOCK_SIZE - 36))
> +GOOD_OLD_ISIZE=128
> +WANT_ISIZE=$(($INODE_SIZE-$GOOD_OLD_ISIZE-$XATTR_SPACE))
> +NEW_ISIZE=$(($WANT_ISIZE+$GROW_EXTRA_ISIZE))
> +NEW_MIN_ISIZE=$(($WANT_ISIZE+$GROW_MIN_EXTRA_ISIZE))
> +
> +if [ $WANT_ISIZE -lt $ISIZE ]; then
> +	_notrun "This test requires at least $XATTR_SPACE free in the inode"
> +fi
> +
> +$DEBUGFS_PROG -w -R "ssv want_extra_isize $WANT_ISIZE" $SCRATCH_DEV >> $seqres.full 2>&1
> +$DEBUGFS_PROG -w -R "ssv min_extra_isize $WANT_ISIZE" $SCRATCH_DEV >> $seqres.full 2>&1
> +
> +_scratch_mount
> +
> +FNAMES=("empty" "couple_xattrs" "just_enough_xattrs" "one_extra_xattr"
> +	"full_xattrs" "one_extra_xattr_ext" "full_xattrs_ext"
> +	"full_xattrs_almost_full_ext" "full_xattrs_full_ext")
> +create_xattr_file()
> +{
> +	FILE=$SCRATCH_MNT/${FNAMES[$1]}
> +	touch $FILE
> +	for (( i = 0; i < $2; i++ )); do
> +		setfattr -n "user.$i" -v "aa" $FILE || break
> +	done
> +}
> +
> +# Test file without xattrs
> +create_xattr_file 0 0
> +
> +# Test file with couple of xattrs but which still has enough space
> +# One xattr consumes 24 bytes + 4 bytes for header + 4 bytes for terminator
> +# => 104 bytes consumed (152 bytes still free)
> +create_xattr_file 1 4
> +
> +# Test file with xattrs which still has just enough space
> +# One xattr consumes 24 bytes + 4 bytes for header + 4 bytes for terminator
> +# => 176 bytes consumed (80 bytes still free)
> +create_xattr_file 2 7
> +
> +# Test file with xattrs which has one xattr which needs moving
> +# One xattr consumes 24 bytes + 4 bytes for header + 4 bytes for terminator
> +# => 200 bytes consumed (56 bytes still free)
> +create_xattr_file 3 8
> +
> +# Test file with xattrs which has xattr space almost full
> +# One xattr consumes 24 bytes + 4 bytes for header + 4 bytes for terminator
> +# => 248 bytes consumed (8 bytes still free)
> +create_xattr_file 4 10
> +
> +# Test file with xattrs which has one xattr which needs moving and external
> +# xattr block allocated
> +# One xattr consumes 24 bytes + 4 bytes for header + 4 bytes for terminator
> +# => 200 bytes consumed (56 bytes still free)
> +create_xattr_file 5 8
> +setfattr -n "user.e0" -v "01234567890123456789012345678901234567890123456789" "$SCRATCH_MNT/${FNAMES[5]}"
> +
> +# Test file with xattrs which has xattr space in inode almost full and external
> +# xattr block allocated
> +# One xattr consumes 24 bytes + 4 bytes for header + 4 bytes for terminator
> +# => 248 bytes consumed (8 bytes still free)
> +create_xattr_file 6 11
> +
> +# Test file with xattrs which has xattr space in inode almost full and external
> +# xattr block allocated and almost full so that inode can still expand to
> +# s_min_extra_isize
> +# 10 xattrs fit into inode, rest goes into xattr block (one xattr consumes
> +# 24 bytes)
> +create_xattr_file 7 $((10 + ($BLOCK_XATTR_SPACE - $GROW_MIN_EXTRA_ISIZE) / 24))
> +
> +# Test file with xattrs which has xattr space in inode almost full and external
> +# xattr block allocated and full
> +# 10 xattrs fit into inode, rest goes into xattr block (one xattr consumes
> +# 24 bytes)
> +create_xattr_file 8 $((10 + $BLOCK_XATTR_SPACE / 24))
> +
> +umount $SCRATCH_MNT

Use _scratch_unmount helper?

> +
> +# Filesystem prepared, update extra_isize
> +
> +$DEBUGFS_PROG -w -R "ssv want_extra_isize $NEW_ISIZE" $SCRATCH_DEV >> $seqres.full 2>&1
> +$DEBUGFS_PROG -w -R "ssv min_extra_isize $NEW_MIN_ISIZE" $SCRATCH_DEV >> $seqres.full 2>&1
> +
> +_scratch_mount
> +
> +# Dirty each inode to force expansion of extra_isize
> +for FILE in ${FNAMES[@]}; do
> +	echo "aaaa" >$SCRATCH_MNT/$FILE
> +done
> +
> +# Dump all xattrs to see whether nothing broke
> +for FILE in ${FNAMES[@]}; do
> +	getfattr -h -d --absolute-names $SCRATCH_MNT/$FILE 2>/dev/null | \
> +		_filter_scratch | sort
> +done
> +
> +umount $SCRATCH_MNT

Same here.

> +
> +# Dump everything via debugfs to check whether sizes got extended as expected
> +for FILE in ${FNAMES[@]}; do
> +	$DEBUGFS_PROG -R "stat $FILE" $SCRATCH_DEV 2>/dev/null | \
> +		grep "^Size of extra inode fields:"
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/ext4/022.out b/tests/ext4/022.out
> new file mode 100644
> index 000000000000..af0d82737e07
> --- /dev/null
> +++ b/tests/ext4/022.out
> @@ -0,0 +1,432 @@
> +QA output created by 022
> +
> +# file: SCRATCH_MNT/couple_xattrs
> +user.0="aa"
> +user.1="aa"
> +user.2="aa"
> +user.3="aa"
> +
> +# file: SCRATCH_MNT/just_enough_xattrs
> +user.0="aa"
> +user.1="aa"
> +user.2="aa"
> +user.3="aa"
> +user.4="aa"
> +user.5="aa"
> +user.6="aa"
> +
> +# file: SCRATCH_MNT/one_extra_xattr
> +user.0="aa"
> +user.1="aa"
> +user.2="aa"
> +user.3="aa"
> +user.4="aa"
> +user.5="aa"
> +user.6="aa"
> +user.7="aa"
> +
> +# file: SCRATCH_MNT/full_xattrs
> +user.0="aa"
> +user.1="aa"
> +user.2="aa"
> +user.3="aa"
> +user.4="aa"
> +user.5="aa"
> +user.6="aa"
> +user.7="aa"
> +user.8="aa"
> +user.9="aa"
> +
> +# file: SCRATCH_MNT/one_extra_xattr_ext
> +user.0="aa"
> +user.1="aa"
> +user.2="aa"
> +user.3="aa"
> +user.4="aa"
> +user.5="aa"
> +user.6="aa"
> +user.7="aa"
> +user.e0="01234567890123456789012345678901234567890123456789"
> +
> +# file: SCRATCH_MNT/full_xattrs_ext
> +user.0="aa"
> +user.10="aa"
> +user.1="aa"
> +user.2="aa"
> +user.3="aa"
> +user.4="aa"
> +user.5="aa"
> +user.6="aa"
> +user.7="aa"
> +user.8="aa"
> +user.9="aa"
> +
> +# file: SCRATCH_MNT/full_xattrs_almost_full_ext
> +user.0="aa"
> +user.100="aa"
> +user.101="aa"
> +user.102="aa"
> +user.103="aa"
> +user.104="aa"
> +user.105="aa"
> +user.106="aa"
> +user.107="aa"
> +user.108="aa"
> +user.109="aa"
> +user.10="aa"
> +user.110="aa"
> +user.111="aa"
> +user.112="aa"
> +user.113="aa"
> +user.114="aa"
> +user.115="aa"
> +user.116="aa"
> +user.117="aa"
> +user.118="aa"
> +user.119="aa"
> +user.11="aa"
> +user.120="aa"
> +user.121="aa"
> +user.122="aa"
> +user.123="aa"
> +user.124="aa"
> +user.125="aa"
> +user.126="aa"
> +user.127="aa"
> +user.128="aa"
> +user.129="aa"
> +user.12="aa"
> +user.130="aa"
> +user.131="aa"
> +user.132="aa"
> +user.133="aa"
> +user.134="aa"
> +user.135="aa"
> +user.136="aa"
> +user.137="aa"
> +user.138="aa"
> +user.139="aa"
> +user.13="aa"
> +user.140="aa"
> +user.141="aa"
> +user.142="aa"
> +user.143="aa"
> +user.144="aa"
> +user.145="aa"
> +user.146="aa"
> +user.147="aa"
> +user.148="aa"
> +user.149="aa"
> +user.14="aa"
> +user.150="aa"
> +user.151="aa"
> +user.152="aa"
> +user.153="aa"
> +user.154="aa"
> +user.155="aa"
> +user.156="aa"
> +user.157="aa"
> +user.158="aa"
> +user.159="aa"
> +user.15="aa"
> +user.160="aa"
> +user.161="aa"
> +user.162="aa"
> +user.163="aa"
> +user.164="aa"
> +user.165="aa"
> +user.166="aa"
> +user.167="aa"
> +user.168="aa"
> +user.169="aa"
> +user.16="aa"
> +user.170="aa"
> +user.171="aa"
> +user.172="aa"
> +user.173="aa"
> +user.174="aa"
> +user.175="aa"
> +user.176="aa"
> +user.177="aa"
> +user.17="aa"
> +user.18="aa"
> +user.19="aa"
> +user.1="aa"
> +user.20="aa"
> +user.21="aa"
> +user.22="aa"
> +user.23="aa"
> +user.24="aa"
> +user.25="aa"
> +user.26="aa"
> +user.27="aa"
> +user.28="aa"
> +user.29="aa"
> +user.2="aa"
> +user.30="aa"
> +user.31="aa"
> +user.32="aa"
> +user.33="aa"
> +user.34="aa"
> +user.35="aa"
> +user.36="aa"
> +user.37="aa"
> +user.38="aa"
> +user.39="aa"
> +user.3="aa"
> +user.40="aa"
> +user.41="aa"
> +user.42="aa"
> +user.43="aa"
> +user.44="aa"
> +user.45="aa"
> +user.46="aa"
> +user.47="aa"
> +user.48="aa"
> +user.49="aa"
> +user.4="aa"
> +user.50="aa"
> +user.51="aa"
> +user.52="aa"
> +user.53="aa"
> +user.54="aa"
> +user.55="aa"
> +user.56="aa"
> +user.57="aa"
> +user.58="aa"
> +user.59="aa"
> +user.5="aa"
> +user.60="aa"
> +user.61="aa"
> +user.62="aa"
> +user.63="aa"
> +user.64="aa"
> +user.65="aa"
> +user.66="aa"
> +user.67="aa"
> +user.68="aa"
> +user.69="aa"
> +user.6="aa"
> +user.70="aa"
> +user.71="aa"
> +user.72="aa"
> +user.73="aa"
> +user.74="aa"
> +user.75="aa"
> +user.76="aa"
> +user.77="aa"
> +user.78="aa"
> +user.79="aa"
> +user.7="aa"
> +user.80="aa"
> +user.81="aa"
> +user.82="aa"
> +user.83="aa"
> +user.84="aa"
> +user.85="aa"
> +user.86="aa"
> +user.87="aa"
> +user.88="aa"
> +user.89="aa"
> +user.8="aa"
> +user.90="aa"
> +user.91="aa"
> +user.92="aa"
> +user.93="aa"
> +user.94="aa"
> +user.95="aa"
> +user.96="aa"
> +user.97="aa"
> +user.98="aa"
> +user.99="aa"
> +user.9="aa"
> +
> +# file: SCRATCH_MNT/full_xattrs_full_ext
> +user.0="aa"
> +user.100="aa"
> +user.101="aa"
> +user.102="aa"
> +user.103="aa"
> +user.104="aa"
> +user.105="aa"
> +user.106="aa"
> +user.107="aa"
> +user.108="aa"
> +user.109="aa"
> +user.10="aa"
> +user.110="aa"
> +user.111="aa"
> +user.112="aa"
> +user.113="aa"
> +user.114="aa"
> +user.115="aa"
> +user.116="aa"
> +user.117="aa"
> +user.118="aa"
> +user.119="aa"
> +user.11="aa"
> +user.120="aa"
> +user.121="aa"
> +user.122="aa"
> +user.123="aa"
> +user.124="aa"
> +user.125="aa"
> +user.126="aa"
> +user.127="aa"
> +user.128="aa"
> +user.129="aa"
> +user.12="aa"
> +user.130="aa"
> +user.131="aa"
> +user.132="aa"
> +user.133="aa"
> +user.134="aa"
> +user.135="aa"
> +user.136="aa"
> +user.137="aa"
> +user.138="aa"
> +user.139="aa"
> +user.13="aa"
> +user.140="aa"
> +user.141="aa"
> +user.142="aa"
> +user.143="aa"
> +user.144="aa"
> +user.145="aa"
> +user.146="aa"
> +user.147="aa"
> +user.148="aa"
> +user.149="aa"
> +user.14="aa"
> +user.150="aa"
> +user.151="aa"
> +user.152="aa"
> +user.153="aa"
> +user.154="aa"
> +user.155="aa"
> +user.156="aa"
> +user.157="aa"
> +user.158="aa"
> +user.159="aa"
> +user.15="aa"
> +user.160="aa"
> +user.161="aa"
> +user.162="aa"
> +user.163="aa"
> +user.164="aa"
> +user.165="aa"
> +user.166="aa"
> +user.167="aa"
> +user.168="aa"
> +user.169="aa"
> +user.16="aa"
> +user.170="aa"
> +user.171="aa"
> +user.172="aa"
> +user.173="aa"
> +user.174="aa"
> +user.175="aa"
> +user.176="aa"
> +user.177="aa"
> +user.178="aa"
> +user.17="aa"
> +user.18="aa"
> +user.19="aa"
> +user.1="aa"
> +user.20="aa"
> +user.21="aa"
> +user.22="aa"
> +user.23="aa"
> +user.24="aa"
> +user.25="aa"
> +user.26="aa"
> +user.27="aa"
> +user.28="aa"
> +user.29="aa"
> +user.2="aa"
> +user.30="aa"
> +user.31="aa"
> +user.32="aa"
> +user.33="aa"
> +user.34="aa"
> +user.35="aa"
> +user.36="aa"
> +user.37="aa"
> +user.38="aa"
> +user.39="aa"
> +user.3="aa"
> +user.40="aa"
> +user.41="aa"
> +user.42="aa"
> +user.43="aa"
> +user.44="aa"
> +user.45="aa"
> +user.46="aa"
> +user.47="aa"
> +user.48="aa"
> +user.49="aa"
> +user.4="aa"
> +user.50="aa"
> +user.51="aa"
> +user.52="aa"
> +user.53="aa"
> +user.54="aa"
> +user.55="aa"
> +user.56="aa"
> +user.57="aa"
> +user.58="aa"
> +user.59="aa"
> +user.5="aa"
> +user.60="aa"
> +user.61="aa"
> +user.62="aa"
> +user.63="aa"
> +user.64="aa"
> +user.65="aa"
> +user.66="aa"
> +user.67="aa"
> +user.68="aa"
> +user.69="aa"
> +user.6="aa"
> +user.70="aa"
> +user.71="aa"
> +user.72="aa"
> +user.73="aa"
> +user.74="aa"
> +user.75="aa"
> +user.76="aa"
> +user.77="aa"
> +user.78="aa"
> +user.79="aa"
> +user.7="aa"
> +user.80="aa"
> +user.81="aa"
> +user.82="aa"
> +user.83="aa"
> +user.84="aa"
> +user.85="aa"
> +user.86="aa"
> +user.87="aa"
> +user.88="aa"
> +user.89="aa"
> +user.8="aa"
> +user.90="aa"
> +user.91="aa"
> +user.92="aa"
> +user.93="aa"
> +user.94="aa"
> +user.95="aa"
> +user.96="aa"
> +user.97="aa"
> +user.98="aa"
> +user.99="aa"
> +user.9="aa"
> +Size of extra inode fields: 720
> +Size of extra inode fields: 720
> +Size of extra inode fields: 720
> +Size of extra inode fields: 720
> +Size of extra inode fields: 720
> +Size of extra inode fields: 720
> +Size of extra inode fields: 720
> +Size of extra inode fields: 656
> +Size of extra inode fields: 640
> diff --git a/tests/ext4/group b/tests/ext4/group
> index bbdbe1dd0a24..e4e6d41f9a04 100644
> --- a/tests/ext4/group
> +++ b/tests/ext4/group
> @@ -24,6 +24,7 @@
>  019 fuzzers
>  020 auto quick ioctl rw
>  021 auto quick
> +022 auto quick dangerous

Add it to 'attr' group as well?

If you're OK with all the changes, I can fix them at commit time, if
there's no new review comments from others.

Thanks,
Eryu

>  271 auto rw quick
>  301 aio auto ioctl rw stress
>  302 aio auto ioctl rw stress
> -- 
> 2.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
