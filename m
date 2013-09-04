From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Wed, 4 Sep 2013 14:00:44 -0600
Message-ID: <FDD6EB21-7C40-4F4D-904C-8514535CC7C3@dilger.ca>
References: <1374108934-50550-1-git-send-email-tmac@hp.com> <1378312756-68597-1-git-send-email-tmac@hp.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
	aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
	aswin_proj@groups.hp.com
To: T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1378312756-68597-1-git-send-email-tmac@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2013-09-04, at 10:39 AM, T Makphaibulchoke wrote:
> This patch intends to improve the scalability of an ext filesystem,
> particularly ext4.

In the past, I've raised the question of whether mbcache is even
useful on real-world systems.  Essentially, this is providing a
"deduplication" service for ext2/3/4 xattr blocks that are identical.
The question is how often this is actually the case in modern use?
The original design was for allowing external ACL blocks to be
shared between inodes, at a time when ACLs where pretty much the
only xattrs stored on inodes.

The question now is whether there are common uses where all of the
xattrs stored on multiple inodes are identical?  If that is not the
case, mbcache is just adding overhead and should just be disabled
entirely instead of just adding less overhead.

There aren't good statistics on the hit rate for mbcache, but it
might be possible to generate some with systemtap or similar to
see how often ext4_xattr_cache_find() returns NULL vs. non-NULL.

Cheers, Andreas

> The patch consists of two parts.  The first part introduces higher
> degree of parallelism to the usages of the mb_cache and
> mb_cache_entries and impacts all ext filesystems.
> 
> The second part of the patch further increases the scalablity of
> an ext4 filesystem by having each ext4 fielsystem allocate and use
> its own private mbcache structure, instead of sharing a single
> mcache structures across all ext4 filesystems
> 
> Here are some of the benchmark results with the changes. 
> 
> On a 90 core machine:
> 
> Here are the performance improvements in some of the aim7 workloads,
> 
> ---------------------------
> |             | % increase |
> ---------------------------
> | alltests    |     11.85  |
> ---------------------------
> | custom      |     14.42  |
> ---------------------------
> | fserver     |     21.36  |  
> ---------------------------
> | new_dbase   |      5.59 |  
> ---------------------------
> | new_fserver |     21.45  |  
> ---------------------------
> | shared      |     12.84  |  
> ---------------------------
> For Swingbench dss workload, with 16 GB database,
> 
> -------------------------------------------------------------------------------
> | Users        | 100  | 200  | 300  | 400  | 500  | 600  | 700  | 800  | 900  |
> -------------------------------------------------------------------------------
> | % imprvoment | 8.46 | 8.00 | 7.35 | -.313| 1.09 | 0.69 | 0.30 | 2.18 | 5.23 |
> -------------------------------------------------------------------------------
> | % imprvoment |45.66 |47.62 |34.54 |25.15 |15.29 | 3.38 | -8.7 |-4.98 |-7.86 |
> | without using|      |      |      |      |      |      |      |      |      |
> | shared memory|      |      |      |      |      |      |      |      |      |
> -------------------------------------------------------------------------------
> For SPECjbb2013, composite run,
> 
> --------------------------------------------
> |               | max-jOPS | critical-jOPS |
> --------------------------------------------
> | % improvement |   5.99   |     N/A       |
> --------------------------------------------
> 
> 
> On an 80 core machine:
> 
> The aim7's results for most of the workloads turn out to the same.
> 
> Here are the results of Swingbench dss workload,
> 
> -------------------------------------------------------------------------------
> | Users        | 100  | 200  | 300  | 400  | 500  | 600  | 700  | 800  | 900  |
> -------------------------------------------------------------------------------
> | % imprvoment |-1.79 | 0.37 | 1.36 | 0.08 | 1.66 | 2.09 | 1.16 | 1.48 | 1.92 |
> -------------------------------------------------------------------------------
> 
> The changes have been tested with ext4 xfstests to verify that no regression
> has been introduced. 
> 
> Changed in v3:
> 	- New diff summary
> 
> Changed in v2:
> 	- New performance data
> 	- New diff summary
> 
> T Makphaibulchoke (2):
>  mbcache: decoupling the locking of local from global data
>  ext4: each filesystem creates and uses its own mb_cache
> 
> fs/ext4/ext4.h          |   1 +
> fs/ext4/super.c         |  24 ++--
> fs/ext4/xattr.c         |  51 ++++----
> fs/ext4/xattr.h         |   6 +-
> fs/mbcache.c            | 306 +++++++++++++++++++++++++++++++++++-------------
> include/linux/mbcache.h |  10 +-
> 6 files changed, 277 insertions(+), 121 deletions(-)
> 
> -- 
> 1.7.11.3
> 


Cheers, Andreas
