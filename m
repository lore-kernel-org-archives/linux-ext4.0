From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/3] ext4: export iov_shorten from kernel for ext4's use
Date: Tue, 04 Dec 2007 09:59:12 -0600
Message-ID: <47557950.60306@redhat.com>
References: <47557870.9060405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbXLDP7O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2007 10:59:14 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lB4FxDol017741
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 10:59:13 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB4FxDmP024959
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 10:59:13 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB4FxCug027060
	for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2007 10:59:12 -0500
In-Reply-To: <47557870.9060405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Export iov_shorten() from kernel so that ext4 can
truncate too-large writes to bitmapped files.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc3/fs/read_write.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/read_write.c
+++ linux-2.6.24-rc3/fs/read_write.c
@@ -451,6 +451,8 @@ unsigned long iov_shorten(struct iovec *
 	return seg;
 }
 
+EXPORT_SYMBOL(iov_shorten);
+
 ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
 		unsigned long nr_segs, size_t len, loff_t *ppos, iov_fn_t fn)
 {
