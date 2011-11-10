From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 0/8] Filesystem io types statistic
Date: Thu, 10 Nov 2011 18:34:46 +0800
Message-ID: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65483 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1KJKdV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Nov 2011 05:33:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

v1->v2: totally redesign this mechanism

This patchset implements an io types statistic mechanism for filesystem
and it has been added into ext4 to let us know how the ext4 is used by
applications. It is useful for us to analyze how to improve the filesystem
and applications. Nowadays, I have added it into ext4, but other filesytems
also can use it to count the io types by themselves.

A 'Issue' flag is added into buffer_head and will be set in submit_bh().
Thus, we can check this flag in filesystem to know that a request is issued
to the disk when this flag is set. Filesystems just need to check it in
read operation because filesystem should know whehter a write request hits
cache or not, at least in ext4. In filesystem, buffer needs to be locked in
checking and clearing this flag, but it doesn't cost much overhead.

In ext4, a per-cpu counter is defined and some functions are added to count
the io types of buffered/direct io. An exception is __breadahead() due to
this function doesn't need a buffer_head as argument or return value. So now
we cannot handle these requests calling __breadahead().

The IO types in ext4 have shown as following:
Metadata:
 - super block
 - group descriptor
 - inode bitmap
 - block bitmap
 - inode table
 - extent block
 - indirect block
 - dir index and entry
 - extended attribute
Data:
 - regular data block

The result is shown in sysfs. We can read from /sys/fs/ext4/$DEVICE/io_stats
to see the result. We can understand how much metadata or data requests are
issued to the disk according to the result.

I have finished some benchmarks to test its overhead that calling lock_buffer()
brings. The following fio script is used to run on a SSD. The result shows that
the ovheread can be ignored.

FIO config file:
[global]
ioengineshortync
bs=4k
filename=/mnt/sda1/testfile
size=64G
runtime=300
group_reporting
loops=500

[read]
rw=randread
numjobs=4

[write]
rw=randwrite
numjobs=1

The result (iops):
        w/o         w/
READ:  16304      15906 (-2.44%)
WRITE:  1332       1353 (+1.58%)

Any comments or suggestions are welcome.

Regards,
Zheng
