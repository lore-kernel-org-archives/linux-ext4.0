From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] e2fsprogs tests: fix f_bad_disconnected_inode e2fsck output
Date: Wed, 21 Mar 2012 13:34:53 +0100
Message-ID: <1332333293-25028-2-git-send-email-lczerner@redhat.com>
References: <1332333293-25028-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914Ab2CUMfB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2012 08:35:01 -0400
In-Reply-To: <1332333293-25028-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since we removed EOFBLOCKS_FL flag handling, we have to fix the
f_bad_disconnected_inode test so that e2fsck output correspond with the
new version of the code where we do not check for the EOFBLOCKS_FL flag
at all.

Simply remove EOFBLOCKS_FL flag warnings from expect.1 e2fsck output.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 tests/f_bad_disconnected_inode/expect.1 |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/tests/f_bad_disconnected_inode/expect.1 b/tests/f_bad_disconnected_inode/expect.1
index d3920e3..11862f6 100644
--- a/tests/f_bad_disconnected_inode/expect.1
+++ b/tests/f_bad_disconnected_inode/expect.1
@@ -2,21 +2,12 @@ Pass 1: Checking inodes, blocks, and sizes
 Inode 1 has EXTENTS_FL flag set on filesystem without extents support.
 Clear? yes
 
-Inode 9 should not have EOFBLOCKS_FL set (size 0, lblk -1)
-Clear? yes
-
-Inode 10 should not have EOFBLOCKS_FL set (size 0, lblk -1)
-Clear? yes
-
 Inode 15 has EXTENTS_FL flag set on filesystem without extents support.
 Clear? yes
 
 Inode 16 has EXTENTS_FL flag set on filesystem without extents support.
 Clear? yes
 
-Inode 13 should not have EOFBLOCKS_FL set (size 0, lblk -1)
-Clear? yes
