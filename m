From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] MAINTAINERS: fscrypto: recommend linux-fsdevel for fscrypto patches
Date: Mon, 24 Oct 2016 13:29:15 -0700
Message-ID: <1477340955-145575-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        richard@nod.at, Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The filesystem level encryption support, currently used by ext4 and f2fs
and proposed for ubifs, does not yet have a dedicated mailing list.
Since no mailing lists were specified in MAINTAINERS, get_maintainer.pl
only recommended to send patches directly to the maintainers and to
linux-kernel.  This patch adds linux-fsdevel as the preferred mailing
list for fscrypto patches for the time being.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ea4fbc9..d3ce20e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5123,6 +5123,7 @@ F:	include/linux/fscache*.h
 FS-CRYPTO: FILE SYSTEM LEVEL ENCRYPTION SUPPORT
 M:	Theodore Y. Ts'o <tytso@mit.edu>
 M:	Jaegeuk Kim <jaegeuk@kernel.org>
+L:	linux-fsdevel@vger.kernel.org
 S:	Supported
 F:	fs/crypto/
 F:	include/linux/fscrypto.h
-- 
2.8.0.rc3.226.g39d4020
