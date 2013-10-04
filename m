From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/2] fs/ext4: increase parallelism in updating ext4 orphan list
Date: Thu, 3 Oct 2013 18:28:10 -0600
Message-ID: <117221D9-7634-4131-95C2-7527C20F1F62@dilger.ca>
References: <y> <1380728283-61038-1-git-send-email-tmac@hp.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	aswin@hp.com
To: T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36913 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3JDA2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Oct 2013 20:28:13 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so3204375pdi.19
        for <linux-ext4@vger.kernel.org>; Thu, 03 Oct 2013 17:28:12 -0700 (PDT)
In-Reply-To: <1380728283-61038-1-git-send-email-tmac@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-10-02, at 9:38 AM, T Makphaibulchoke wrote:
> Instead of allowing only a single atomic update (both in memory and on disk
> orphan lists) of an ext4's orphan list via the s_orphan_lock mutex, this patch allows multiple updates of the orphan list, while still maintaing the
> integrity of both the in memory and on disk orphan lists of each update.
> 
> This is accomplished by using a per inode mutex to serialize the oprhan
> list update of a single inode, and a mutex and a spinlock to serailize
> the on disk and in memory orphan list respectively.

It would also be possible to have a completely contention-free orphan
inode list by only generating the on-disk orphan linked list in a
pre-commit callback hook from an efficient in-memory list.  That would
allow the common "add to orphan list; do something; remove from list"
operations within a single transaction to run with minimal contention,
and only the few rare cases of operations that exceed the lifetime of
a single transaction would need to modify the on-disk list.

For example, a per-cpu list would be quite efficient, or a hash table.
Then, a jbd2 callback run before the transaction commits could modify
the requisite inodes and superblock.  All of those inodes are already
(by definition) part of the transaction, so it won't add new buffers
of the transaction.

I'm not necessarily against the current patch, just thinking aloud about
how it might be improved further.

Cheers, Andreas

> Here are some of the becnhmark results with the changes.
> 
> On a 90 core machine:
> 
> Here are the performance improvements in some of the aim7 workloads,
> 
> ---------------------------
> |             | % increase |
> ---------------------------
> | alltests    |      9.56  |
> ---------------------------
> | custom      |     12.20  |
> ---------------------------
> | fserver     |     15.99  |
> ---------------------------
> | new_dbase   |      1.73  |
> ---------------------------
> | new_fserver |     17.56  |
> ---------------------------
> | shared      |      6.24  |
> ---------------------------
> For Swingbench dss workload,
> 
> -------------------------------------------------------------------------
> | Users         | 100  | 200  | 300  | 400  | 500  | 600  | 700  | 800  |
> -------------------------------------------------------------------------
> | % imprvoment  | 7.67 | 9.43 | 7.30 | 0.58 | 0.53 |-2.62 |-3.72 | 3.77 |
> | without using |      |      |      |      |      |      |      |      |
> | shared memory |      |      |      |      |      |      |      |      |
> -------------------------------------------------------------------------
> 
> On a 8 core machine:
> 
> Here are the performance date from some of the aim7 workloads,
> 
> ---------------------------
> |             | % increase |
> ---------------------------
> | alltests    |      3.90  |
> ---------------------------
> | custom      |      1.66  |
> ---------------------------
> | dbase       |     -2.00  |
> ---------------------------
> | fserver     |      1.80  |
> ---------------------------
> | new_dbase   |     -1.90  |
> ---------------------------
> | new_fserver |      2.18  |
> ---------------------------
> | shared      |      7.46  |
> ---------------------------
> For Swingbench dss workload,
> 
> -------------------------------------------------------------------------
> | Users         | 100  | 200  | 300  | 400  | 500  | 600  | 700  | 800  |
> -------------------------------------------------------------------------
> | % imprvoment  |-1.32 | 6.45 | 1.18 |-3.13 |-1.13 | 4.68 | 5.75 |-0.37 |
> | without using |      |      |      |      |      |      |      |      |
> | shared memory |      |      |      |      |      |      |      |      |
> -------------------------------------------------------------------------
> 
> T Makphaibulchoke (2):
>  fs/ext4: adding and initalizing new members of ext4_inode_info and
>    ext4_sb_info
>  fs/ext4/namei.c: reducing contention on s_orphan_lock mmutex
> 
> fs/ext4/ext4.h  |   5 +-
> fs/ext4/inode.c |   1 +
> fs/ext4/namei.c | 139 ++++++++++++++++++++++++++++++++++++++++----------------
> fs/ext4/super.c |   4 +-
> 4 files changed, 108 insertions(+), 41 deletions(-)
> 
> -- 
> 1.7.11.3
> 


Cheers, Andreas





