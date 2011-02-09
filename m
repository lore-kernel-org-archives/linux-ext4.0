From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] VFS: call rcu_barrier after kill_sb.
Date: Wed, 09 Feb 2011 10:26:46 +0200
Message-ID: <4D524FC6.3020300@panasas.com>
References: <1296896481-3650-1-git-send-email-tm@tao.ma> <4D4FF040.9050707@panasas.com> <87hbceqxax.fsf@linux.vnet.ibm.com> <4D517C98.7060000@panasas.com> <20110209045007.GA29650@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	Tao Ma <tm@tao.ma>, Nick Piggin <npiggin@kernel.dk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:17149 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1BII0v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Feb 2011 03:26:51 -0500
In-Reply-To: <20110209045007.GA29650@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


In fa0d7e3, we use rcu free inode instead of freeing the inode
directly. It causes a crash when we rmmod immediately after
we umount the volume[1].

So we need to call rcu_barrier after we kill_sb so that
the inode is freed before we do rmmod. The idea is inspired
by Aneesh Kumar. rcu_barrier will wait for all callbacks
to end before preceding. The original patch was done by
Tao Ma, but synchronize_rcu() is not enough here.

1. http://marc.info/?l=linux-fsdevel&m=129680863330185&w=2

Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <chris.mason@oracle.com>
Tested-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/super.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 74e149e..7e9dd4c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -177,6 +177,11 @@ void deactivate_locked_super(struct super_block *s)
 	struct file_system_type *fs = s->s_type;
 	if (atomic_dec_and_test(&s->s_active)) {
 		fs->kill_sb(s);
+		/*
+		 * We need to call rcu_barrier so all the delayed rcu free
+		 * inodes are flushed before we release the fs module.
+		 */
+		rcu_barrier();
 		put_filesystem(fs);
 		put_super(s);
 	} else {
-- 
1.7.2.3


