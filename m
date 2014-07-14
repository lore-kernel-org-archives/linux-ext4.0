From: Rui Xiang <rui.xiang@huawei.com>
Subject: testing result of loop-aio patchset on ext3
Date: Mon, 14 Jul 2014 17:34:38 +0800
Message-ID: <53C3A42E.40000@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Li Zefan <lizefan@huawei.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>,
	<linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Dave,

We export a container image file as a block device via loop device, but we
found it's very easy that the container rootfs gets corrupted due to power
loss.

Your early version of loop-aio patchset said the patchset can make loop
mounted filesystems recoverable(lkml.org/lkml/2012/3/30/317), but we found
it doesn't help.

Both the guest fs and host fs are ext3.

The loop-aio patchset is from:
git://github.com/kleikamp/linux-shaggy.git aio_loop

Steps:
1. dd a 10G image, mkfs.ext3,
  # dd if=/dev/zero of=./raw_image bs=1M count=10000
  # echo y | mkfs.ext3 raw_image

2. losetup a loop device, mount at ./test_dir
  # losetup /dev/loop1 raw_image
  # mount /dev/loop1 ./test_dir

3. copy fs_mark into test_dir and run
  # ./fs_mark -d ./tmp/ -s 102400000 -n 80

4. during runing fs_mark, make systerm reboot indirectly.
  # echo b > /proc/sysrq-trigger

After systerm booted up, sometimes fsck reported raw_image fs has been damaged.

# fsck.ext3 -n raw_image
e2fsck 1.41.9 (22-Aug-2009)
Warning: skipping journal recovery because doing a read-only filesystem check.
raw_image contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (2481348, counted=2480577).
Fix? no
Free inodes count wrong (640837, counted=640835).
Fix? no
raw_image: ********** WARNING: Filesystem still has errors **********
raw_image: 11/640848 files (0.0% non-contiguous), 78652/2560000 blocks


With a specific script, I can almost 100% reproduce this issue.

And it seems the corruption can only happen when reboot happens at the
time loop is calling vfs_fsync().

Do you have any idea why the loop-aio patchset doesn't help?

Thanks.

