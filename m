Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA26C433B4
	for <linux-ext4@archiver.kernel.org>; Fri, 21 May 2021 02:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32E496108B
	for <linux-ext4@archiver.kernel.org>; Fri, 21 May 2021 02:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238720AbhEUCoC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 20 May 2021 22:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbhEUCoC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 20 May 2021 22:44:02 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEAEC061574;
        Thu, 20 May 2021 19:42:40 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id BAB551F43D3C
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     amir73il@gmail.com
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel@collabora.com, "Darrick J . Wong" <djwong@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>, jack@suse.com,
        dhowells@redhat.com, khazhy@google.com,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [PATCH 11/11] Documentation: Document the FAN_ERROR event
Date:   Thu, 20 May 2021 22:41:34 -0400
Message-Id: <20210521024134.1032503-12-krisman@collabora.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210521024134.1032503-1-krisman@collabora.com>
References: <20210521024134.1032503-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 .../admin-guide/filesystem-monitoring.rst     | 52 +++++++++++++++++++
 Documentation/admin-guide/index.rst           |  1 +
 2 files changed, 53 insertions(+)
 create mode 100644 Documentation/admin-guide/filesystem-monitoring.rst

diff --git a/Documentation/admin-guide/filesystem-monitoring.rst b/Documentation/admin-guide/filesystem-monitoring.rst
new file mode 100644
index 000000000000..81e632f8e1de
--- /dev/null
+++ b/Documentation/admin-guide/filesystem-monitoring.rst
@@ -0,0 +1,52 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================================
+File system Monitoring with fanotify
+====================================
+
+fanotify supports the FAN_ERROR mark for file system-wide error
+reporting.  It is meant to be used by file system health monitoring
+daemons who listen on that interface and take actions (notify sysadmin,
+start recovery) when a file system problem is detected by the kernel.
+
+By design, A FAN_ERROR notification exposes sufficient information for a
+monitoring tool to know a problem in the file system has happened.  It
+doesn't necessarily provide a user space application with semantics to
+verify an IO operation was successfully executed.  That is outside of
+scope of this feature. Instead, it is only meant as a framework for
+early file system problem detection and reporting recovery tools.
+
+At the time of this writing, the only file system that emits this
+FAN_ERROR notifications is ext4.
+
+A user space example code is provided at ``samples/fanotify/fs-monitor.c``.
+
+Usage
+=====
+
+Notification structure
+======================
+
+A FAN_ERROR Notification has the following format::
+
+  [ Notification Metadata (Mandatory) ]
+  [ Generic Error Record  (Mandatory) ]
+
+With the exception of the notification metadata and the generic
+information, all information records are optional.  Each record type is
+identified by its unique ``struct fanotify_event_info_header.info_type``.
+
+Generic error Location
+----------------------
+
+The Generic error record provides enough information for a file system
+agnostic tool to learn about a problem in the file system, without
+requiring any details about the problem.::
+
+  struct fanotify_event_info_error {
+	struct fanotify_event_info_header hdr;
+	int error;
+	__kernel_fsid_t fsid;
+	unsigned long inode;
+	__u32 error_count;
+  };
diff --git a/Documentation/admin-guide/index.rst b/Documentation/admin-guide/index.rst
index dc00afcabb95..1bedab498104 100644
--- a/Documentation/admin-guide/index.rst
+++ b/Documentation/admin-guide/index.rst
@@ -82,6 +82,7 @@ configure specific aspects of kernel behavior to your liking.
    edid
    efi-stub
    ext4
+   filesystem-monitoring
    nfs/index
    gpio/index
    highuid
-- 
2.31.0

