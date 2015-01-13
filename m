From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [LSF/MM TOPIC] [ATTEND] [RESEND] Generic defragmentation strategies
Date: Tue, 13 Jan 2015 15:36:55 +0300
Message-ID: <87wq4q3li0.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-fsdevel@vger.kernel.org,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>
To: lsf-pc@lists.linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:50535 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbbAMMhu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jan 2015 07:37:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Sorry, previous message was refused by lsf-pc@'s spam filter (probably due to gpg
mime signature), this is second attempt.

I would like to submit a topic about generic defragmentation strategies.

FS fragmentation is long standing and well known problem, there are
a lot of studies about single file fragmentation, for this case
terms are well defined and most file systems have effective tools for
that issue (e4defrag(8), xfs_fsr(8)). But fragmentation of a directory
lacks of good researches, even the term 'fragmentation of a directory'
is not a well defined statement.

This issue has much in common with filesystem aging. Most filesystems
try to minimize aging issues on block allocator level, but can not avoid
it completely. Sooner or later aging effect becomes significant and can
not be neglected. Generic filesystem lacks of useful utilities which can
fix this issues once it happens. At the same time this issue greatly
affects many use-cases, especially the ones where consumed space matters:
 - Thin-Provision storage containers (LVM, qcow2, ploop, etc)
 - Thin-Provision environments (qemu/kvm, Docker, VMware, OpenVZ, LXC, etc)
 - Cloud storage solutions (Mail, News, Photo-collection, etc)
 - Non fully-random access devices (SMR, etc)

OpenVZ team has done research [fn:1] which allowed to implement online
defragmetation utility e4defrag2 [fn:2] for EXT4 which support various
defragment strategies for IntA and InetEr fragmenration issues (used
terminology from [fn:3]). We found that using this strategies it's possible
to fix issues caused by fs aging which allows both optimize IO
performance and improve space usage efficiency.

Core kernel API has been already merged [fn:4], but user-space implementation
requires a number of hacks around block allocator (~700 LOC or 30% of total code).

We would like to present our findings and discuss future evolution of kernel API
we need to make userspace-tools more efficient. The talk is not EXT4 specific,
We want to discuss generic fine grain block allocator interface which can provide
advantages for many existing filesystems.

Previous works: [fn:3] [fn:5]

*Other discussion I would like to visit*
 - nvram/mutli-queue related performance bottleneck for existing
   filesystems (mq flush optimization)
 - SMR related topics
 - Various Thin-Provision topics
 - Block/FS layer replication/deduplication topics
 - Range locking (topic from Jan Kara)
 - EXT4 related issues: datachecksumming, performance, block allocator.

* Footnotes

[fn:1] http://lists.openwall.net/linux-ext4/2014/04/28/3

[fn:2] https://github.com/dmonakhov/e2fsprogs/tree/e4defrag2

[fn:3] http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.220.3450

[fn:4] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/ext4/move_extent.c?id=fcf6b1b729bcd23f2b49a84fb33ffbb44712ee6a

[fn:5] https://events.linuxfoundation.org/slides/2010/linuxcon_japan/linuxcon_jp2010_fujita.pdf
