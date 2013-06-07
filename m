From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] tests: add new test f_extent_oobounds
Date: Thu, 06 Jun 2013 23:04:16 -0500
Message-ID: <51B15BC0.2020308@redhat.com>
References: <51B158C4.8070000@redhat.com> <1370577376-2875-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab3FGEES (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Jun 2013 00:04:18 -0400
In-Reply-To: <1370577376-2875-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/6/13 10:56 PM, Theodore Ts'o wrote:
> This tests creates a file system where the last entry in one leaf
> block overlaps with logical block range in the first entry of the next
> leaf block.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Looks good to me, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/f_extent_oobounds/expect.1 | 24 +++++++++++++++++++++++
>  tests/f_extent_oobounds/expect.2 |  7 +++++++
>  tests/f_extent_oobounds/script   | 42 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 73 insertions(+)
>  create mode 100644 tests/f_extent_oobounds/expect.1
>  create mode 100644 tests/f_extent_oobounds/expect.2
>  create mode 100644 tests/f_extent_oobounds/script
> 
> diff --git a/tests/f_extent_oobounds/expect.1 b/tests/f_extent_oobounds/expect.1
> new file mode 100644
> index 0000000..3164ea0
> --- /dev/null
> +++ b/tests/f_extent_oobounds/expect.1
> @@ -0,0 +1,24 @@
> +Pass 1: Checking inodes, blocks, and sizes
> +Inode 12, end of extent exceeds allowed value
> +	(logical block 15, physical block 200, len 30)
> +Clear? yes
> +
> +Inode 12, i_blocks is 154, should be 94.  Fix? yes
> +
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +Block bitmap differences:  -(200--229)
> +Fix? yes
> +
> +Free blocks count wrong for group #0 (156, counted=186).
> +Fix? yes
> +
> +Free blocks count wrong (156, counted=186).
> +Fix? yes
> +
> +
> +test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
> +test_filesys: 12/32 files (8.3% non-contiguous), 70/256 blocks
> +Exit status is 1
> diff --git a/tests/f_extent_oobounds/expect.2 b/tests/f_extent_oobounds/expect.2
> new file mode 100644
> index 0000000..22c4f2c
> --- /dev/null
> +++ b/tests/f_extent_oobounds/expect.2
> @@ -0,0 +1,7 @@
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +test_filesys: 12/32 files (8.3% non-contiguous), 70/256 blocks
> +Exit status is 0
> diff --git a/tests/f_extent_oobounds/script b/tests/f_extent_oobounds/script
> new file mode 100644
> index 0000000..31ac6c9
> --- /dev/null
> +++ b/tests/f_extent_oobounds/script
> @@ -0,0 +1,42 @@
> +if test -x $DEBUGFS_EXE; then
> +
> +SKIP_GUNZIP="true"
> +TEST_DATA="$test_name.tmp"
> +
> +dd if=/dev/zero of=$TMPFILE bs=1k count=256 > /dev/null 2>&1
> +mke2fs -Ft ext4 $TMPFILE > /dev/null 2>&1
> +debugfs -w $TMPFILE << EOF  > /dev/null 2>&1
> +write /dev/null testfile
> +extent_open testfile
> +  insert_node 0 15 100
> +  insert_node --after 15 15 115
> +  insert_node --after 30 15 130
> +  insert_node --after 45 15 145
> +  split
> +  down
> +  split
> +  root
> +  down
> +  next
> +  replace_node 15 30 200
> +  extent_close
> +set_inode_field testfile i_size 61400
> +set_inode_field testfile i_blocks 154
> +setb 100 15
> +setb 130 30
> +setb 200 30
> +set_bg 0 free_blocks_count 156
> +set_bg 0 bg_checksum calc
> +set_super_value free_blocks_count 156
> +q
> +EOF
> +
> +. $cmd_dir/run_e2fsck
> +
> +rm -f $TEST_DATA
> +
> +unset E2FSCK_TIME TEST_DATA
> +
> +else #if test -x $DEBUGFS_EXE; then
> +	echo "$test_name: $test_description: skipped"
> +fi
> 

