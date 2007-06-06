From: Kirk True <kirk@mustardgrain.com>
Subject: [PATCH] Add static to functions local to fs/ext4/balloc.c
Date: Wed, 6 Jun 2007 02:30:48 -0700 (PDT)
Message-ID: <585414.24040.qm@web610.biz.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web610.biz.mail.mud.yahoo.com ([209.191.88.223]:33271 "HELO
	web610.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753921AbXFFJat (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jun 2007 05:30:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4_reserve_local, ext4_rebalance_reservation, and
ext4_reserve_global are all local to balloc.c and can be made
static.

This is against the 2.6.22-rc4-ext4-1 tree that was announced
on:

    http://lists.openwall.net/linux-ext4/2007/06/05/15

Signed-off-by: Kirk True <kirk@mustardgrain.com>

Index: linux-2.6.22-rc4/fs/ext4/balloc.c
===================================================================
diff -uprN linux-2.6.22-rc4-orig/fs/ext4/balloc.c linux-2.6.22-rc4/fs/ext4/balloc.c
--- linux-2.6.22-rc4-orig/fs/ext4/balloc.c      2007-06-06 02:02:29.000000000 -0700
+++ linux-2.6.22-rc4/fs/ext4/balloc.c   2007-06-06 01:59:24.000000000 -0700
@@ -1868,7 +1868,7 @@ struct ext4_reservation_slot {
 } ____cacheline_aligned;

-
-int ext4_reserve_local(struct super_block *sb, int blocks)
+static int ext4_reserve_local(struct super_block *sb, int blocks)
 {
        struct ext4_sb_info *sbi = EXT4_SB(sb);
        struct ext4_reservation_slot *rs;
@@ -1888,8 +1888,7 @@ int ext4_reserve_local(struct super_bloc
        return rc;
 }

-
-void ext4_rebalance_reservation(struct ext4_reservation_slot *rs, __u64 free)
+static void ext4_rebalance_reservation(struct ext4_reservation_slot *rs, __u64 free)
 {
        int i, used_slots = 0;
        __u64 chunk;
@@ -1916,7 +1915,7 @@ void ext4_rebalance_reservation(struct e
        BUG_ON(free);
 }
 
-int ext4_reserve_global(struct super_block *sb, int blocks)
+static int ext4_reserve_global(struct super_block *sb, int blocks)
 {        
        struct ext4_sb_info *sbi = EXT4_SB(sb);
        struct ext4_reservation_slot *rs;
