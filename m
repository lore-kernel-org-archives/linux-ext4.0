From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: [PATCH 2/8] exofs: remove lock/unlock super
Date: Thu, 16 Aug 2012 12:00:10 +0200
Message-ID: <502CC4AA.6040702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: bharrosh@panasas.com, bhalevy@tonian.com, jack@suse.cz,
	Andrew Morton <akpm@linux-foundation.org>,
	adilger.kernel@dilger.ca, tytso@mit.edu,
	hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
	Al Viro <viro@ZenIV.linux.org.uk>, hch@infradead.org,
	dushistov@mail.ru, osd-dev@open-osd.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Remove lock and unlock super operation.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-3.6-rc1-orig/fs/exofs/super.c linux-3.6-rc1/fs/exofs/super.c
--- linux-3.6-rc1-orig/fs/exofs/super.c	2012-08-16 09:37:31.000000000 +0200
+++ linux-3.6-rc1/fs/exofs/super.c	2012-08-16 09:45:31.000000000 +0200
@@ -384,8 +384,6 @@ static int exofs_sync_fs(struct super_bl
 	if (unlikely(ret))
 		goto out;
 -	lock_super(sb);
-
 	ios->length = offsetof(struct exofs_fscb, s_dev_table_oid);
 	memset(fscb, 0, ios->length);
 	fscb->s_nextid = cpu_to_le64(sbi->s_nextid);
@@ -403,8 +401,6 @@ static int exofs_sync_fs(struct super_bl
 	else
 		sb->s_dirt = 0;
 -
-	unlock_super(sb);
 out:
 	EXOFS_DBGMSG("s_nextid=0x%llx ret=%d\n", _LLU(sbi->s_nextid), ret);
 	ore_put_io_state(ios);
