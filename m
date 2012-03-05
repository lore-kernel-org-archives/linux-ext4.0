From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 10/11] ext4: ignore mount options supported by ext2/3 (but have since been removed)
Date: Sun,  4 Mar 2012 22:08:24 -0500
Message-ID: <1330916905-5976-10-git-send-email-tytso@mit.edu>
References: <1330916905-5976-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Tom Gundersen <teg@jklm.no>,
	Thomas Baechler <thomas@archlinux.org>,
	Tobias Powalowski <tobias.powalowski@googlemail.com>,
	Dave Reisner <d@falconindy.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41877 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab2CEDI0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Mar 2012 22:08:26 -0500
In-Reply-To: <1330916905-5976-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Users who tried to use the ext4 file system driver is being used for
the ext2 or ext3 file systems (via the CONFIG_EXT4_USE_FOR_EXT23
option) could have failed mounts if their /etc/fstab contains options
recognized by ext2 or ext3 but which have since been removed in ext4.

So teach ext4 to recognize them and give a warning that the mount
option was removed.

Report: https://bbs.archlinux.org/profile.php?id=33804

Signed-off-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Thomas Baechler <thomas@archlinux.org>
Cc: Tobias Powalowski <tobias.powalowski@googlemail.com>
Cc: Dave Reisner <d@falconindy.com>
---
 fs/ext4/super.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 27d490d..960681f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1249,6 +1249,11 @@ static const match_table_t tokens = {
 	{Opt_init_itable, "init_itable=%u"},
 	{Opt_init_itable, "init_itable"},
 	{Opt_noinit_itable, "noinit_itable"},
+	{Opt_removed, "check=none"},	/* mount option from ext2/3 */
+	{Opt_removed, "nocheck"},	/* mount option from ext2/3 */
+	{Opt_removed, "reservation"},	/* mount option from ext2/3 */
+	{Opt_removed, "noreservation"}, /* mount option from ext2/3 */
+	{Opt_removed, "journal=%u"},	/* mount option from ext2/3 */
 	{Opt_err, NULL},
 };
 
-- 
1.7.9.107.g97f9a

