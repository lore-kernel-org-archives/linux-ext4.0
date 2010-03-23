From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/18] ext4: Provide config options for enabling ext4 and jbd2 tracing
Date: Tue, 23 Mar 2010 01:32:09 +0100
Message-ID: <1269304340-25372-8-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/ext4.h |    2 ++
 include/trace/events/jbd2.h |    2 ++
 kernel/trace/Kconfig        |   23 +++++++++++++++++++++++
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 2aa6aa3..f1ad2e3 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -1,5 +1,7 @@
 #undef TRACE_SYSTEM
+#undef TRACE_CONFIG
 #define TRACE_SYSTEM ext4
+#define TRACE_CONFIG CONFIG_EXT4_TRACER
 
 #if !defined(_TRACE_EXT4_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_EXT4_H
diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
index bf16545..37e442b 100644
--- a/include/trace/events/jbd2.h
+++ b/include/trace/events/jbd2.h
@@ -1,5 +1,7 @@
 #undef TRACE_SYSTEM
+#undef TRACE_CONFIG
 #define TRACE_SYSTEM jbd2
+#define TRACE_CONFIG CONFIG_JBD2_TRACER
 
 #if !defined(_TRACE_JBD2_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_JBD2_H
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 13e13d4..e696314 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -438,6 +438,29 @@ config BLK_DEV_IO_TRACE
 
 	  If unsure, say N.
 
+config EXT4_TRACER
+	bool "Support for tracing EXT4 events"
+	depends on EXT4_FS
+	select GENERIC_TRACER
+	select TRACE_ANY_MODULE if EXT4_FS=m
+	help
+	  Provide tracing for various functions in ext4 filesystem
+	  such as block allocation, delayed allocation, or writeback
+	  handling. This trace points can help with debugging allocation
+	  algorithms or writeback performance.
+
+	  If unsure, say N.
+
+config JBD2_TRACER
+	bool "JBD2 tracing"
+	depends on JBD2
+	select GENERIC_TRACER
+	help
+	  Provide tracing for several functions in JBD2 commit and
+	  checkpointing code.
+
+	  If unsure, say N.
+
 config KPROBE_EVENT
 	depends on KPROBES
 	depends on HAVE_REGS_AND_STACK_ACCESS_API
-- 
1.6.4.2
