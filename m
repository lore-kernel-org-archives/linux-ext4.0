From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/8 v2] ext4: extent status tree (step 1)
Date: Thu, 20 Sep 2012 10:41:26 -0400
Message-ID: <20120920144126.GA22334@thunk.org>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51718 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab2ITOli (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2012 10:41:38 -0400
Content-Disposition: inline
In-Reply-To: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Zheng,

I've applied your patches to the ext4 patch queue, and so they have
shown up in the dev branch of the ext4 git tree.

One thing I've noticed in my regression tests is that there is a new
test failure with this patch series applied.  It is xfstests #230,
when bigalloc is enabled:

FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.6.0-rc1-00043-ga3229f7
MKFS_OPTIONS  -- -q -O bigalloc /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc

230	       - output mismatch (see 230.out.bad)
--- 230.out    2012-09-19 01:15:44.000000000 -0400
+++ 230.out.bad		  2012-09-20 10:37:05.143728890 -0400
@@ -5,7 +5,9 @@
 ### create files, setting up ownership (type=u)
 ### some buffered IO (type=u)
 Write 900k...
+pwrite64: Disk quota exceeded
 Rewrite 1001k...
+pwrite64: Disk quota exceeded
 Write 1000k...
 pwrite64: Disk quota exceeded
 Write 4096...
@@ -21,7 +23,9 @@
 ### create files, setting up ownership (type=g)
 ### some buffered IO (type=g)
 Write 900k...
+pwrite64: Disk quota exceeded
 Rewrite 1001k...
+pwrite64: Disk quota exceeded
 Write 1000k...
 pwrite64: Disk quota exceeded
 Write 4096...
Ran: 230
Failures: 230
Failed 1 of 1 tests

I haven't had time to take a look at this, and it's only failing when
bigalloc is enabled.  If you could take a look I would greatly
appreciate it.

Thanks!!

					- Ted
