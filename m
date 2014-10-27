From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 41/39] mke2fs: warn if enabling metadata_csum on a pre-3.18
 kernel
Date: Mon, 27 Oct 2014 16:32:31 -0700
Message-ID: <20141027233231.GF10057@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46509 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaJ0Xcf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2014 19:32:35 -0400
Content-Disposition: inline
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The metadata_csum feature (really, the journal checksum disk format)
didn't stabilize until the 3.18 kernel, at which point the companion
journal_csum feature was turned on by default if metadata_csum was
enabled.  Therefore, warn the user if they try to create such a
filesystem on a pre-3.18 kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mke2fs.c    |    8 ++++++++
 tests/filter.sed |    1 +
 2 files changed, 9 insertions(+)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 149330c..aeb852f 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2213,6 +2213,14 @@ profile_error:
 			blocksize, sys_page_size);
 	}
 
+	/* Metadata checksumming wasn't totally stable before 3.18. */
+	if (is_before_linux_ver(3, 18, 0) &&
+	    (fs_param.s_feature_ro_compat &
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		fprintf(stderr, _("Suggestion: Use Linux kernel >= 3.18 for "
+			"improved stability of the metadata and journal "
+			"checksum features.\n"));
+
 	/*
 	 * On newer kernels we do have lazy_itable_init support. So pick the
 	 * right default in case ext4 module is not loaded.
diff --git a/tests/filter.sed b/tests/filter.sed
index d9a336c..d07e9b8 100644
--- a/tests/filter.sed
+++ b/tests/filter.sed
@@ -23,3 +23,4 @@ s/\\015//g
 /whichever comes first/d
 s/, csum 0x\([0-9a-f]*\)//g
 s/ csum 0x\([0-9a-f]*\)//g
+/^Suggestion:/d
