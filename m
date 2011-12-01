From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 10/14] crc32: Add note about this patchset to crc32.c
Date: Thu, 01 Dec 2011 12:14:50 -0800
Message-ID: <20111201201450.5876.83785.stgit@elm3c44.beaverton.ibm.com>
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Some final changes
	- added a comment at the top of crc32.c

From: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
[djwong@us.ibm.com: Minor changelog tweaks]
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/crc32.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/lib/crc32.c b/lib/crc32.c
index 2c8e8c0..d56516d 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -1,4 +1,8 @@
 /*
+ * Aug 8, 2011 Bob Pearson with help from Joakim Tjernlund and George Spelvin
+ * cleaned up code to current version of sparse and added the slicing-by-8
+ * algorithm to the closely similar existing slicing-by-4 algorithm.
+ *
  * Oct 15, 2000 Matt Domsch <Matt_Domsch@dell.com>
  * Nicer crc32 functions/docs submitted by linux@horizon.com.  Thanks!
  * Code was from the public domain, copyright abandoned.  Code was
