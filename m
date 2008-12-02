From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH v4] ext3, ext4: make i signed in do_split()
Date: Tue, 02 Dec 2008 22:01:14 +0100
Message-ID: <4935A21A.60509@gmail.com>
References: <49310E1A.60105@gmail.com> <20081202120751.8b0226ca.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:17196 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYLBVBN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 16:01:13 -0500
Received: by ug-out-1314.google.com with SMTP id 39so3185195ugf.37
        for <linux-ext4@vger.kernel.org>; Tue, 02 Dec 2008 13:01:11 -0800 (PST)
In-Reply-To: <20081202120751.8b0226ca.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton wrote:
> On Sat, 29 Nov 2008 04:40:42 -0500
> roel kluin <roel.kluin@gmail.com> wrote:
> 
>> unsigned i >= 0 is always true

>> -	for (i = count-1; i >= 0; i--) {
>> +	for (i = count-1; i < count; i--) {
			break;

> A local variable called `i' should always have signed type.  In fact,
> it should have `int' type.

You are right. although count is unsigned, dx_make_map() returns int, which is
assigned to count, so this should fit in an int. (If you ack this, make sure to
get this patch, and not one of the others.)
--------------->8----------------8<--------------------
Make i signed, otherwise the loop will not end when it becomes negative.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 3e5edc9..4846327 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1156,9 +1156,9 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	u32 hash2;
 	struct dx_map_entry *map;
 	char *data1 = (*bh)->b_data, *data2;
-	unsigned split, move, size, i;
+	unsigned split, move, size;
 	struct ext3_dir_entry_2 *de = NULL, *de2;
-	int	err = 0;
+	int	err = 0, i;
 
 	bh2 = ext3_append (handle, dir, &newblock, &err);
 	if (!(bh2)) {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 63adcb7..bca90c1 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1166,9 +1166,9 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	u32 hash2;
 	struct dx_map_entry *map;
 	char *data1 = (*bh)->b_data, *data2;
-	unsigned split, move, size, i;
+	unsigned split, move, size;
 	struct ext4_dir_entry_2 *de = NULL, *de2;
-	int	err = 0;
+	int	err = 0, i;
 
 	bh2 = ext4_append (handle, dir, &newblock, &err);
 	if (!(bh2)) {
