From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: 4.1-rc2 kvm-xfstests regressions for ext3 test config
Date: Tue, 12 May 2015 11:20:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1505121059060.20717@localhost.localdomain>
References: <20150511213731.GA4012@wallace>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, dccitaliano@gmail.com
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbbELJUf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2015 05:20:35 -0400
In-Reply-To: <20150511213731.GA4012@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 11 May 2015, Eric Whitney wrote:

> Date: Mon, 11 May 2015 17:37:31 -0400
> From: Eric Whitney <enwlinux@gmail.com>
> To: linux-ext4@vger.kernel.org
> Cc: tytso@mit.edu, dccitaliano@gmail.com
> Subject: 4.1-rc2 kvm-xfstests regressions for ext3 test config
> 
> I've got six new test failures in the ext3 test configuration when
> running a 4.1-rc2 kernel on x86_64 with the latest version of
> kvm-xfstests.
> 
> The new failures include generic/075, generic/091, generic/112,
> generic/127, generic/231, and generic/263.  All also fail on ARM
> (Pandaboard) when running a 4.1-rc2 kernel on bare metal.
> 
> Reverting an -rc2 patch corrects all these failures:
> ext4: move check under lock scope to close a race (280227a75b56)
> 
> All the failed tests use fsx, all fail when attempting to perform a
> COLLAPSE_RANGE, and fsx uses this statement to determine whether a
> particular fallocate mode is supported (and then doesn't use it if not):
> 
> 	if (fallocate(fd, mode, 0, 1) && errno == EOPNOTSUPP)
> 
> In -rc1, ext4_fallocate()/extents.c returns EOPNOTSUPP, and in -rc2,
> EINVAL.  What's happened is that we no longer immediately fail a
> COLLAPSE_RANGE request for a block-mapped file with EOPNOTSUPP.  Instead,
> we now first check to see if the COLLAPSE_RANGE request is cluster-aligned
> and sized in ext4_collapse_range()/extents.c, and return EINVAL if not.
> (There's still a check for block-mapped files, but it's applied later in
> ext4_collapse_range().)
> 
> I think we'd want to return EOPNOTSUPP first in this case.
> 
> Eric

Thanks for the heads up. Yes, this is a problem and it has been
ported to stable as well. I think that the best solution would
be to have the check at both places to avoid unnecessary work
in most cases.

Something like this untested patch


diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d74e0802..fd2939f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4927,6 +4927,11 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (ret)
 		return ret;
 
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	if (mode & FALLOC_FL_COLLAPSE_RANGE)
 		return ext4_collapse_range(inode, offset, len);
 
@@ -5431,6 +5436,12 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	/* Take mutex lock */
 	mutex_lock(&inode->i_mutex);
 
+	/* Currently just for extent based files */
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
+		ret = -EOPNOTSUPP;
+		goto out_mutex;
+	}
+
 	/*
 	 * There is no need to overlap collapse range with EOF, in which case
 	 * it is effectively a truncate operation
@@ -5440,12 +5451,6 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		goto out_mutex;
 	}
 
-	/* Currently just for extent based files */
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
-		ret = -EOPNOTSUPP;
-		goto out_mutex;
-	}
