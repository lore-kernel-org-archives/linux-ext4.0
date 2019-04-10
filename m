Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD91C10F14
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 04:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46DB217D6
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 04:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfDJEK3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 00:10:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbfDJEK3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Apr 2019 00:10:29 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DEBA688AAD;
        Wed, 10 Apr 2019 04:10:28 +0000 (UTC)
Received: from dhcp201-121.englab.pnq.redhat.com (dhcp-10-65-161-59.pnq.redhat.com [10.65.161.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4489B6013A;
        Wed, 10 Apr 2019 04:10:03 +0000 (UTC)
From:   Pankaj Gupta <pagupta@redhat.com>
To:     linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org,
        qemu-devel@nongnu.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org
Cc:     dan.j.williams@intel.com, zwisler@kernel.org,
        vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
        jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net,
        hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu,
        adilger.kernel@dilger.ca, darrick.wong@oracle.com,
        lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com,
        jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com,
        stefanha@redhat.com, aarcange@redhat.com, david@redhat.com,
        david@fromorbit.com, cohuck@redhat.com,
        xiaoguangrong.eric@gmail.com, pbonzini@redhat.com,
        kilobyte@angband.pl, yuval.shaia@oracle.com, pagupta@redhat.com
Subject: [PATCH v5 4/6] dax: check synchronous mapping is supported
Date:   Wed, 10 Apr 2019 09:38:24 +0530
Message-Id: <20190410040826.24371-5-pagupta@redhat.com>
In-Reply-To: <20190410040826.24371-1-pagupta@redhat.com>
References: <20190410040826.24371-1-pagupta@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 10 Apr 2019 04:10:29 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This patch introduces 'daxdev_mapping_supported' helper
which checks if 'MAP_SYNC' is supported with filesystem
mapping. It also checks if corresponding dax_device is
synchronous. Virtio pmem device is asynchronous and
does not not support VM_SYNC. 

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
---
 include/linux/dax.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/dax.h b/include/linux/dax.h
index b896706a5ee9..4a2a60ffec86 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -38,6 +38,24 @@ void kill_dax(struct dax_device *dax_dev);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
 bool dax_synchronous(struct dax_device *dax_dev);
+
+/*
+ * Callers check if synchronous mapping is enabled for DAX file
+ * and attached dax device is also synchronous.
+ *
+ * dax_synchronous function verifies if dax device is synchronous.
+ * Currently, only virtio pmem device supports asynchronous device
+ * flush.
+ */
+static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
+				struct dax_device *dax_dev)
+{
+	if (!(vma->vm_flags & VM_SYNC))
+		return true;
+	if (!IS_DAX(file_inode(vma->vm_file)))
+		return false;
+	return dax_synchronous(dax_dev);
+}
 #else
 static inline struct dax_device *dax_get_by_host(const char *host)
 {
@@ -69,6 +87,11 @@ static inline bool dax_synchronous(struct dax_device *dax_dev)
 {
 	return true;
 }
+static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
+				struct dax_device *dax_dev)
+{
+	return true;
+}
 #endif
 
 struct writeback_control;
-- 
2.20.1

