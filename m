From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 14/25] subst: Fix free of uninit pointers
Date: Fri, 16 Sep 2011 15:49:29 -0500
Message-ID: <1316206180-6375-15-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46749 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab1IPUtp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:45 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

in add_subst(), if the malloc of ent->name fails, we goto fail;
which will free ent->name (which is null, so OK) but also free
ent->value (which is uninitialized).  There is no case where
we must free ent->value on an error (it is allocated last, and
if it fails it of course doesn't need to be freed) so just
remove it.

Also "retval" is only assigned once to the constant ENOMEM,
so we can just return that explicitly in the failure case.

Signed-off-by: Eric Saneeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 util/subst.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/util/subst.c b/util/subst.c
index b55f54b..8544b6d 100644
--- a/util/subst.c
+++ b/util/subst.c
@@ -35,9 +35,7 @@ struct subst_entry *subst_table = 0;
 static int add_subst(char *name, char *value)
 {
 	struct subst_entry	*ent = 0;
-	int	retval;
 
-	retval = ENOMEM;
 	ent = (struct subst_entry *) malloc(sizeof(struct subst_entry));
 	if (!ent)
 		goto fail;
@@ -55,10 +53,9 @@ static int add_subst(char *name, char *value)
 fail:
 	if (ent) {
 		free(ent->name);
-		free(ent->value);
 		free(ent);
 	}
-	return retval;
+	return ENOMEM;
 }
 
 static struct subst_entry *fetch_subst_entry(char *name)
-- 
1.7.4.1

