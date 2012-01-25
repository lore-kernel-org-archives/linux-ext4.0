From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH V2] xfstests: mount other filesystems with selinux context
 as well
Date: Wed, 25 Jan 2012 15:11:39 -0600
Message-ID: <4F20700B.8060307@sandeen.net>
References: <4ECD3262.105@redhat.com> <20111128110228.GC13766@infradead.org> <4F1862FC.1050401@sandeen.net> <20120124174500.GB9853@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60213 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab2AYVLl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jan 2012 16:11:41 -0500
In-Reply-To: <20120124174500.GB9853@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For some reason, non-xfs filesystems aren't getting mounted with
the selinux context; perhaps because none of the xattr tests used
to work on anything but xfs?

Anyway, 062 fails for extN unless we mount with the fs-wide
context.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

ps: eparis says this should work for NFS as well, let's go for
it and if infrequently tested filesystems have trouble we can
exclude them as necessary.

diff --git a/common.rc b/common.rc
index 6231457..602513a 100644
--- a/common.rc
+++ b/common.rc
@@ -72,11 +72,11 @@ _mount_opts()
     # nfs_t is a "liberal" context so we can use it.
     if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
 	SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
+	export SELINUX_MOUNT_OPTIONS
     fi
 
     case $FSTYP in
     xfs)
-	export SELINUX_MOUNT_OPTIONS
 	export MOUNT_OPTIONS=$XFS_MOUNT_OPTIONS
 	;;
     udf)


