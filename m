From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] debugfs: add sanity check to make sure we never shift 64 bits right
Date: Mon, 28 Jan 2013 09:06:49 -0500
Message-ID: <1359382009-28651-1-git-send-email-tytso@mit.edu>
Cc: xi.wang@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45836 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991Ab3A1OGw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 09:06:52 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the tables which are used to parse the fields for the set_fields
command, there should never be a entry which has a size set to 8
bytes, and two pointers defined.  Not only would it result in
undefined behavior in the compiled code, it doesn't make any sense and
is definitely a bug.

Reported-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/set_fields.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 08bfd8d..5c86d74 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -389,7 +389,10 @@ static errcode_t parse_uint(struct field_set_info *info, char *field,
 	n = num & mask;
 	switch (size) {
 	case 8:
-		*u.ptr64 = n;
+		/* Should never get here */
+		fprintf(stderr, "64-bit field %s has a second 64-bit field\n"
+			"defined; BUG?!?\n", info->name);
+		*u.ptr64 = 0;
 		break;
 	case 4:
 		*u.ptr32 = n;
-- 
1.7.12.rc0.22.gcdd159b

