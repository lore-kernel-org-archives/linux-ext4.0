From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/5 v2] Lazy itable initialization for Ext4
Date: Wed,  8 Sep 2010 18:59:15 +0200
Message-ID: <1283965160-31597-1-git-send-email-lczerner@redhat.com>
Cc: rwheeler@redhat.com, sandeen@redhat.com, tytso@mit.edu,
	adilger@dilger.ca, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab0IHQ7f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Sep 2010 12:59:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, all

I am presenting you second version of my lazy inode table initialization
code for Ext4. The patch set consist of five patches. The first one adds
helper function for blkdev_issue_zeroout called sb_issue_zeroout as I am
using it to zero out inode table. Second patch adds new pair of mount
options (inititable/noinititable), so you can enable or disable this
feature. In default it is off (noinititable), so in order to try the new
code you should moutn the fs like this:

  mount -o noinititable /dev/sda /mnt/

The third patch adds the inode table initialization code itself. Thread
initialization was heavily inspired by nilfs2 segctord. And last two
patched are making use of sb_issue_discard() in other places in Ext4,
where is need to zero out a part of disk space.

To Andreas:
You suggested the approach with reading the table first to
determine if the device is sparse, or thinly provisioned, or trimmed SSD.
In this case the reading would be much more efficient than writing, so it
would be a win. But I just wonder, if we de believe the device, that
when returning zeroes it is safe to no zero the inode table, why not do it
at mkfs time instead of kernel ?

To Ted:
You were suggesting that it would be nice if the thread will not run, or
just quits when the system runs on the battery power. I agree that in that
case we probably should not do this to save some battery life. But is it
necessary, or wise to do this in kernel ? What we should do when the
system runs on battery and user still want to run the lazy initialization
? I would rather let the userspace handle it. For example just remount the
filesystem with -o noinititable.
___________
DESCRIPTION
___________

When lazy_itable_init extended option is passed to mke2fs, it
considerably speed up filesystem creation because inode tables are
not zeroed out, thus contains some old data. When this fs is mounted
filesystem code should initialize (zero out) inode tables.
So far this code was missing for ext4 and this patch adds this feature.

For purpose of zeroing inode tables it introduces new kernel thread
called ext4lazyinit, which is created on demand and destroyed, when it
is no longer needed. There is only one thread for all ext4
filesystems in the system. When the first filesystem with inititable
mount option is mounted, ext4lazyinit thread is created, then the
filesystem can register its request in the request list.

This thread then walks through the list of requests picking up scheduled
requests and invoking ext4_init_inode_table(). Next schedule time for
the request is determined from the time it took to zero out inode table,
so we do not take the whole I/O bandwidth. When the thread is no longer
necessary (request list is empty) it frees the appropriate structures and
exits (it can be invoked later on by another filesystem).

We do not disturb regular inode allocations in any way, it just do not
care whether the inode table is, or is not zeroed. But we when zeroing we
have to skip used inodes, obviously. Also we should prevent new inode
allocations from the group, while zeroing is on the way. For that we
take write alloc_sem lock in ext4_init_inode_table() and read alloc_sem
in the ext4_claim_inode, so when we are unlucky and allocator hits the
group which is currently being zeroed, it just has to wait.
_________________
BENCHMARK RESULTS
_________________

We are trying to avoid performance loss when the ext4lazyinit thread is
working. This is done really simply: just measure the time it takes to
zero out inode table in one group and determine next schedule time from
that number. For example to reach approx. 10% of the I/O bandwidth we
should wait for 9 times the zeroout-time (1 time slice it is woking and 9
time slices it is sleeping). So this multiplier (9 in our example) is
defining how much I/O bandwidth would be used by the thread. It is very
simple method, but I think that it serves our needs.

In my benchmark I have set different values of multipliers
(EXT4_LI_WAIT_MULT) to see how it affects performance. As a tool for
performance measuring I have used postmark (see parameters bellow). I have
created average from five postmark runs to gen more stable results. In
each run I have created ext4 filesystem on the device (with
lazy_itable_init set properly), mounted with inititable/noinititable mount
option and run the postmark measuring the running time and number of
groups the ext4lazyinit thread initializes in one run. There are the
results.

All test was done on 2.6.35 kernel with and without my patches. In tables
below you can see comparison between the performance of the kernel without
my patches and several different settings (see 3rd column).

Graph is attached.

Type                              |NOPATCH      NOITABLEINIT DIFF    |
==================================+==================================+
Total_duration                    |130.00       130.00       -0.00%  |
Duration_of_transactions          |77.80        77.40        -0.51%  |
Transactions/s                    |642.73       646.15       0.53%   |
Files_created/s                   |575.15       575.15       -0.00%  |
Creation_alone/s                  |1024.83      1020.58      -0.41%  |
Creation_mixed_with_transaction/s |318.29       319.99       0.53%   |
Read/s                            |321.03       322.74       0.53%   |
Append/s                          |321.69       323.40       0.53%   |
Deleted/s                         |575.15       575.15       -0.00%  |
Deletion_alone/s                  |1015.03      1010.82      -0.41%  |
Deletion_mixed_with_transaction/s |324.44       326.16       0.53%   |
Read_B/s                          |21179620.40  21179620.40  -0.00%  |
Write_B/s                         |66279880.00  66279880.00  -0.00%  |
==================================+==================================+
RUNTIME:	2m10	GROUPS ZEROED: 0

Type                              |NOPATCH      MULT=10      DIFF    |
==================================+==================================+
Total_duration                    |130.00       132.40       1.85%   |
Duration_of_transactions          |77.80        80.80        3.86%   |
Transactions/s                    |642.73       618.82       -3.72%  |
Files_created/s                   |575.15       564.67       -1.82%  |
Creation_alone/s                  |1024.83      1033.17      0.81%   |
Creation_mixed_with_transaction/s |318.29       306.45       -3.72%  |
Read/s                            |321.03       309.09       -3.72%  |
Append/s                          |321.69       309.72       -3.72%  |
Deleted/s                         |575.15       564.67       -1.82%  |
Deletion_alone/s                  |1015.03      1023.29      0.81%   |
Deletion_mixed_with_transaction/s |324.44       312.37       -3.72%  |
Read_B/s                          |21179620.40  20793522.40  -1.82%  |
Write_B/s                         |66279880.00  65071617.60  -1.82%  |
==================================+==================================+
RUNTIME:	2m13	GROUPS ZEROED: 156

Type                              |NOPATCH      MULT=5       DIFF    |
==================================+==================================+
Total_duration                    |130.00       137.20       5.54%   |
Duration_of_transactions          |77.80        84.60        8.74%   |
Transactions/s                    |642.73       591.04       -8.04%  |
Files_created/s                   |575.15       544.96       -5.25%  |
Creation_alone/s                  |1024.83      1021.09      -0.36%  |
Creation_mixed_with_transaction/s |318.29       292.69       -8.04%  |
Read/s                            |321.03       295.21       -8.04%  |
Append/s                          |321.69       295.81       -8.05%  |
Deleted/s                         |575.15       544.96       -5.25%  |
Deletion_alone/s                  |1015.03      1011.33      -0.36%  |
Deletion_mixed_with_transaction/s |324.44       298.34       -8.04%  |
Read_B/s                          |21179620.40  20067661.60  -5.25%  |
Write_B/s                         |66279880.00  62800096.00  -5.25%  |
==================================+==================================+
RUNTIME:	2m16	GROUPS ZEROED: 324

Type                              |NOPATCH      MULT=2       DIFF    |
==================================+==================================+
Total_duration                    |130.00       148.40       14.15%  |
Duration_of_transactions          |77.80        95.00        22.11%  |
Transactions/s                    |642.73       526.38       -18.10% |
Files_created/s                   |575.15       503.78       -12.41% |
Creation_alone/s                  |1024.83      1004.24      -2.01%  |
Creation_mixed_with_transaction/s |318.29       260.67       -18.10% |
Read/s                            |321.03       262.92       -18.10% |
Append/s                          |321.69       263.45       -18.10% |
Deleted/s                         |575.15       503.78       -12.41% |
Deletion_alone/s                  |1015.03      994.64       -2.01%  |
Deletion_mixed_with_transaction/s |324.44       265.71       -18.10% |
Read_B/s                          |21179620.40  18551581.20  -12.41% |
Write_B/s                         |66279880.00  58055650.40  -12.41% |
==================================+==================================+
RUNTIME:	2m28	GROUPS ZEROED: 748

The benchmark showed, that patch itself does not introduce any performance
loss (at least for postmark), when ext4lazyinit thread is not activated.
However, when it is activated, there is explicit performance loss due to
inode table zeroing, but with EXT4_LI_WAIT_MULT=10 it is just about 1.8%,
which may, or may not be much, so when I think about it now we should
probably make this settable via sysfs. What do you think ?
___________________
POSTMARK PARAMETERS
___________________

set number 50000
set transactions 50000
set read 4096
set write 4096
set bias read 5
set bias create 5
set report terse
set size 1000 200000
set buffering false


Any comments are welcomed.

Thanks!
-Lukas

---
[PATCH 1/5] Add helper function for blkdev_issue_zeroout
[PATCH 2/5] Add inititable/noinititable mount options for ext4
[PATCH 3/5] Add inode table initialization code for Ext4
[PATCH 4/5] Use sb_issue_zeroout in setup_new_group_blocks
[PATCH 5/5] Use sb_issue_discard in ext4_ext_zeroout

 fs/ext4/ext4.h         |   37 +++++
 fs/ext4/extents.c      |   68 +--------
 fs/ext4/ialloc.c       |  108 +++++++++++++
 fs/ext4/resize.c       |   44 ++----
 fs/ext4/super.c        |  405 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    8 +
 6 files changed, 575 insertions(+), 95 deletions(-)
