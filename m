From: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH 0/2] ext4: increase mbcache scalability
Date: Wed, 17 Jul 2013 18:55:34 -0600
Message-ID: <1374108934-50550-1-git-send-email-tmac@hp.com>
Cc: aswin@hp.com
To: viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tmakph@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch intends to improve the scalability of an ext4 filesystem by
introducing higher degree of parallelism to the usages of its mb_cache and
mb_cache_entries.

Here are some of the benchmark results with the changes. 

On a 90 core machine:

Here are the performance improvements in some of the aim7 workloads,

---------------------------
|             | % increase |
---------------------------
| custom      |     13.30  |
---------------------------
| disk        |      5.00  |  
---------------------------
| new_fserver |      6.73  |  
---------------------------
| shared      |      7.12  |  
---------------------------

For Swingbench dss workload,

-------------------------------------------------------------------------------
| Users        | 100  | 200  | 300  | 400  | 500  | 600  | 700  | 800  | 900  |
-------------------------------------------------------------------------------
| % imprvoment | 9.14 | 9.26 | 19.9 | 5.31 | 7.79 | 0.23 |-4.39 |-4.48 |-4.36 |
-------------------------------------------------------------------------------

For SPECjbb2013, composite run,

--------------------------------------------
|               | max-jOPS | critical-jOPS |
--------------------------------------------
| % improvement |   6.73   |     16.37     |
--------------------------------------------



On an 80 core machine:

Here are the improvments in some of the aim7 workloads,
 
---------------------------
|             | % increase |
---------------------------
| fserver     |      6.47  |
---------------------------
| new_fserver |      4.62  |  
---------------------------

For Swingbench dss workload,

-------------------------------------------------------------------------------
| Users        | 100  | 200  | 300  | 400  | 500  | 600  | 700  | 800  | 900  |
-------------------------------------------------------------------------------
| % imprvoment | 4.29 | 2.28 | 3.25 | 1.45 |-0.84 | 3.11 |-0.61 | 3.80 | 2.58 |
-------------------------------------------------------------------------------

For SPECjbb2013, composite run,

--------------------------------------------
|               | max-jOPS | critical-jOPS |
--------------------------------------------
| % improvement |   0.49   |      3.21     |
--------------------------------------------

The changes have been tested with ext4 xfstests to verify that no regression
has been introduced.  


 fs/ext4/ext4.h          |   1 +
 fs/ext4/super.c         |   8 ++
 fs/ext4/xattr.c         |  41 +++++---
 fs/ext4/xattr.h         |   3 +
 fs/mbcache.c            | 432 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
 include/linux/mbcache.h |   5 +
 6 files changed, 385 insertions(+), 105 deletions(-)

