From: fruggeri@arista.com (Francesco Ruggeri)
Subject: mount stuck in infinite loop
Date: Wed, 31 Jan 2018 09:16:53 -0800
Message-ID: <20180131171653.7C66C49841@fruggeri-Arora18_1.sjc.aristanetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: fruggeri@arista.com
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I had a few cases of mount getting stuck in an infinite loop.
This happens when bdev->bd_inode->i_blkbits gets modified (for
example by bd_set_size()) while *_fill_super() is between
sb_min_blocksize() and sb_bread(), and the new value is inconsistent
with the block size used in fill_super().
When this happens one can get into an infinite loop in
__getblk_slow(), if grow_buffers() allocates/finds a page with a
given index, but __find_get_block{_slow}() looks for (and does not
find) a page with a different index.

I can reproduce it in 4.14.15 with the following script.
I can also reproduce it in 4.9 and 3.18.

FILE=/tmp/fsfile
MNT=/tmp/fsmnt
LOOP=`losetup -f`

rm -rf $FILE $MNT

mkdir $MNT
dd if=/dev/zero of=$FILE count=32 bs=1MiB
losetup $LOOP $FILE
mkfs -t ext4 $LOOP
while true; do losetup -D $LOOP; losetup $LOOP $FILE; done \
	2>/dev/null >/dev/null &
for ((i=0; i<100; i++)); do echo ================== $i; \
	mount $LOOP $MNT; umount $MNT; done

The issue is that __find_get_block_slow() and grow_buffers() compute
the page index in different ways.
I am not sure what the correct solution should be here.

Thanks,
Francesco Ruggeri
