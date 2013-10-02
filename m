From: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH 0/2] fs/ext4: increase parallelism in updating ext4 orphan list
Date: Wed,  2 Oct 2013 09:38:02 -0600
Message-ID: <1380728283-61038-1-git-send-email-tmac@hp.com>
References: <y>
Cc: aswin@hp.com, aswin_proj@lists.hp.com,
	T Makphaibulchoke <tmac@hp.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:30666 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab3JBPi0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Oct 2013 11:38:26 -0400
In-Reply-To: <y>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Instead of allowing only a single atomic update (both in memory and on disk
orphan lists) of an ext4's orphan list via the s_orphan_lock mutex, this patch
allows multiple updates of the orphan list, while still maintaing the
integrity of both the in memory and on disk orphan lists of each update.

This is accomplished by using a per inode mutex to serialize the oprhan
list update of a single inode, and a mutex and a spinlock to serailize
the on disk and in memory orphan list respectively.

Here are some of the becnhmark results with the changes.

On a 90 core machine:

Here are the performance improvements in some of the aim7 workloads,

---------------------------
|             | % increase |
---------------------------
| alltests    |      9.56  |
---------------------------
| custom      |     12.20  |
---------------------------
| fserver     |     15.99  |
---------------------------
| new_dbase   |      1.73  |
---------------------------
| new_fserver |     17.56  |
---------------------------
| shared      |      6.24  |
---------------------------
For Swingbench dss workload,

-------------------------------------------------------------------------
| Users         | 100  | 200  | 300  | 400  | 500  | 600  | 700  | 800  |
-------------------------------------------------------------------------
| % imprvoment  | 7.67 | 9.43 | 7.30 | 0.58 | 0.53 |-2.62 |-3.72 | 3.77 |
| without using |      |      |      |      |      |      |      |      |
| shared memory |      |      |      |      |      |      |      |      |
-------------------------------------------------------------------------

On a 8 core machine:

Here are the performance date from some of the aim7 workloads,

---------------------------
|             | % increase |
---------------------------
| alltests    |      3.90  |
---------------------------
| custom      |      1.66  |
---------------------------
| dbase       |     -2.00  |
---------------------------
| fserver     |      1.80  |
---------------------------
| new_dbase   |     -1.90  |
---------------------------
| new_fserver |      2.18  |
---------------------------
| shared      |      7.46  |
---------------------------
For Swingbench dss workload,

-------------------------------------------------------------------------
| Users         | 100  | 200  | 300  | 400  | 500  | 600  | 700  | 800  |
-------------------------------------------------------------------------
| % imprvoment  |-1.32 | 6.45 | 1.18 |-3.13 |-1.13 | 4.68 | 5.75 |-0.37 |
| without using |      |      |      |      |      |      |      |      |
| shared memory |      |      |      |      |      |      |      |      |
-------------------------------------------------------------------------

T Makphaibulchoke (2):
  fs/ext4: adding and initalizing new members of ext4_inode_info and
    ext4_sb_info
  fs/ext4/namei.c: reducing contention on s_orphan_lock mmutex

 fs/ext4/ext4.h  |   5 +-
 fs/ext4/inode.c |   1 +
 fs/ext4/namei.c | 139 ++++++++++++++++++++++++++++++++++++++++----------------
 fs/ext4/super.c |   4 +-
 4 files changed, 108 insertions(+), 41 deletions(-)

-- 
1.7.11.3

