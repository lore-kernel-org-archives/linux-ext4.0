Return-Path: <SRS0=aByE=NM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbeKBH7Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 2 Nov 2018 03:59:16 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH v2 08/12] fs-verity: add CRC-32C support
Date: Thu,  1 Nov 2018 15:52:26 -0700
Message-Id: <20181101225230.88058-9-ebiggers@kernel.org>
In-Reply-To: <20181101225230.88058-1-ebiggers@kernel.org>
References: <20181101225230.88058-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Add CRC-32C support to fs-verity, to provide a faster alternative to
SHA-256 for users who want integrity-only (not authenticity), i.e. who
want to detect only accidental corruption, not malicious changes.

CRC-32C is chosen over CRC-32 because the CRC-32C polynomial is believed
to provide slightly better error-detection properties; and CRC-32C is
just as fast (or can be just as fast) as CRC-32, or even faster e.g. on
some x86 processors that have a CRC-32C instruction but not CRC-32.

We use "crc32c" from the crypto API, so the polynomial convention is
bitwise little-endian, the digest is bytewise little-endian, and the CRC
bits are inverted at the beginning and end (which is desirable).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/hash_algs.c         | 4 ++++
 include/uapi/linux/fsverity.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/fs/verity/hash_algs.c b/fs/verity/hash_algs.c
index 3174a0c08785d..109afeec60fc9 100644
--- a/fs/verity/hash_algs.c
+++ b/fs/verity/hash_algs.c
@@ -23,6 +23,10 @@ struct fsverity_hash_alg fsverity_hash_algs[] = {
 		.digest_size = 64,
 		.cryptographic = true,
 	},
+	[FS_VERITY_ALG_CRC32C] = {
+		.name = "crc32c",
+		.digest_size = 4,
+	},
 };
 
 /*
diff --git a/include/uapi/linux/fsverity.h b/include/uapi/linux/fsverity.h
index 67ed830ae2ece..a96bbf87077de 100644
--- a/include/uapi/linux/fsverity.h
+++ b/include/uapi/linux/fsverity.h
@@ -29,6 +29,7 @@ struct fsverity_digest {
 /* Supported hash algorithms */
 #define FS_VERITY_ALG_SHA256	1
 #define FS_VERITY_ALG_SHA512	2
+#define FS_VERITY_ALG_CRC32C	3	/* for integrity only */
 
 /* Metadata stored near the end of verity files, after the Merkle tree */
 /* This structure is 64 bytes long */
-- 
2.19.1.568.g152ad8e336-goog
