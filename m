From: Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] ext4: Make seq_operations and file_operations const
Date: Fri,  4 Sep 2009 15:49:36 +0200
Message-ID: <1252072176-2931-1-git-send-email-tklauser@distanz.ch>
Cc: linux-ext4@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.zhaw.ch ([160.85.104.51]:36051 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756538AbZIDNtc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Sep 2009 09:49:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 fs/ext4/mballoc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cd25846..a10b1c5 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2205,7 +2205,7 @@ static void ext4_mb_seq_history_stop(struct seq_file *seq, void *v)
 {
 }
 
-static struct seq_operations ext4_mb_seq_history_ops = {
+static const struct seq_operations ext4_mb_seq_history_ops = {
 	.start  = ext4_mb_seq_history_start,
 	.next   = ext4_mb_seq_history_next,
 	.stop   = ext4_mb_seq_history_stop,
@@ -2287,7 +2287,7 @@ static ssize_t ext4_mb_seq_history_write(struct file *file,
 	return count;
 }
 
-static struct file_operations ext4_mb_seq_history_fops = {
+static const struct file_operations ext4_mb_seq_history_fops = {
 	.owner		= THIS_MODULE,
 	.open		= ext4_mb_seq_history_open,
 	.read		= seq_read,
@@ -2366,7 +2366,7 @@ static void ext4_mb_seq_groups_stop(struct seq_file *seq, void *v)
 {
 }
 
-static struct seq_operations ext4_mb_seq_groups_ops = {
+static const struct seq_operations ext4_mb_seq_groups_ops = {
 	.start  = ext4_mb_seq_groups_start,
 	.next   = ext4_mb_seq_groups_next,
 	.stop   = ext4_mb_seq_groups_stop,
@@ -2387,7 +2387,7 @@ static int ext4_mb_seq_groups_open(struct inode *inode, struct file *file)
 
 }
 
-static struct file_operations ext4_mb_seq_groups_fops = {
+static const struct file_operations ext4_mb_seq_groups_fops = {
 	.owner		= THIS_MODULE,
 	.open		= ext4_mb_seq_groups_open,
 	.read		= seq_read,
-- 
1.6.0.4

