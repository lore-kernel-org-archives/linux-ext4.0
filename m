From: David Howells <dhowells@redhat.com>
Subject: [PATCH 7/8] statx: Reserve the top bit of the mask for future
 struct expansion
Date: Fri, 31 Mar 2017 18:32:10 +0100
Message-ID: <149098153077.28108.1844719448258566328.stgit@warthog.procyon.org.uk>
References: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
To: viro@zeniv.linux.org.uk
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Reserve the top bit of the mask for future expansion of the statx struct
and give an error if statx() sees it set.  All the other bits are ignored
if we see them set but don't support the bit; we just clear the bit in the
returned mask.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/stat.c                 |    2 ++
 include/uapi/linux/stat.h |    1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/stat.c b/fs/stat.c
index ab27f2868588..0c7e6cdc435c 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -562,6 +562,8 @@ SYSCALL_DEFINE5(statx,
 	struct kstat stat;
 	int error;
 
+	if (mask & STATX__RESERVED)
+		return -EINVAL;
 	if ((flags & AT_STATX_SYNC_TYPE) == AT_STATX_SYNC_TYPE)
 		return -EINVAL;
 
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 51a6b86e3700..0869b9eaa8ce 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -152,6 +152,7 @@ struct statx {
 #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
 #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
 #define STATX_ALL		0x00000fffU	/* All currently supported flags */
+#define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
 /*
  * Attributes to be found in stx_attributes
