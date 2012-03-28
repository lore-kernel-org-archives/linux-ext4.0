From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH] ext3: update documentation with barrier=1 default
Date: Wed, 28 Mar 2012 09:32:32 +0100
Message-ID: <1332923552-9854-1-git-send-email-stefanha@linux.vnet.ibm.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: linux-doc@vger.kernel.org
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Commit 00eacd6 ("ext3: make ext3 mount default to barrier=1") changed
the default barrier mount option for ext3.  The documentation needs to
be updated, so this patch does that.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
 Documentation/filesystems/ext3.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index b100adc..293855e 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -59,9 +59,9 @@ commit=nrsec	(*)	Ext3 can be told to sync all its data and metadata
 			Setting it to very large values will improve
 			performance.
 
-barrier=<0(*)|1>	This enables/disables the use of write barriers in
-barrier			the jbd code.  barrier=0 disables, barrier=1 enables.
-nobarrier	(*)	This also requires an IO stack which can support
+barrier=<0|1(*)>	This enables/disables the use of write barriers in
+barrier	(*)		the jbd code.  barrier=0 disables, barrier=1 enables.
+nobarrier		This also requires an IO stack which can support
 			barriers, and if jbd gets an error on a barrier
 			write, it will disable again with a warning.
 			Write barriers enforce proper on-disk ordering
-- 
1.7.9.1

