From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Bug 27912] Set 'err' in ext4_init_fs() if kset_create_and_add()
 fails
Date: Tue, 14 Aug 2012 23:03:34 -0400
Message-ID: <20120815030334.GC31873@thunk.org>
References: <bug-27912-13602@https.bugzilla.kernel.org/>
 <20120814155552.9E6C111FC70@bugzilla.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44752 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab2HODDh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2012 23:03:37 -0400
Content-Disposition: inline
In-Reply-To: <20120814155552.9E6C111FC70@bugzilla.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 14, 2012 at 03:55:52PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=27912

Actually, this wasn't quite fixed.  Here's a fix which I'll include in
the ext4 tree....

						- Ted

>From b0f1e9fa10363b60334ba7837080da91de425be0 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 14 Aug 2012 23:02:17 -0400
Subject: [PATCH] ext4: return an error if kset_create_and_add fails in
 ext4_init_fs()

In the very unlikely case that kset_create_and_add() fails when the
ext4.ko module is being loaded (or during kernel startup) set err so
that it's clear that the module load failed.

https://bugzilla.kernel.org/show_bug.cgi?id=27912

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e7ccbe5..603023b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5281,8 +5281,10 @@ static int __init ext4_init_fs(void)
 	if (err)
 		goto out6;
 	ext4_kset = kset_create_and_add("ext4", NULL, fs_kobj);
-	if (!ext4_kset)
+	if (!ext4_kset) {
+		err = -ENOMEM;
 		goto out5;
+	}
 	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
 
 	err = ext4_init_feat_adverts();
-- 
1.7.12.rc0.22.gcdd159b

