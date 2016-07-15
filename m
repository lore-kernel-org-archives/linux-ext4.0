From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4 crypto: migrate into vfs's crypto engine
Date: Thu, 14 Jul 2016 22:45:26 -0400
Message-ID: <20160715024526.GA26465@thunk.org>
References: <1461629736-16523-1-git-send-email-jaegeuk@kernel.org>
 <20160507185250.GD92790@jaegeuk.gateway>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160507185250.GD92790@jaegeuk.gateway>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, May 07, 2016 at 11:52:50AM -0700, Jaegeuk Kim wrote:
> 
> From 593e56e680f962c5e9cc57afa19bda4c654bd841 Mon Sep 17 00:00:00 2001
> From: Jaegeuk Kim <jaegeuk@kernel.org>
> Date: Wed, 10 Feb 2016 16:26:25 -0800
> Subject: [PATCH] ext4 crypto: migrate into vfs's crypto engine
> 
> This patch removes the most parts of internal crypto codes.
> And then, it modifies and adds some ext4-specific crypt codes to use the generic
> facility.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

I've added this patch to the ext4.git tree.  I will also include the
following MAINTAINERS file update.

Thanks,

							- Ted
							
commit 598c7d7abc832e35677b851f6afb93141c09993b
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Jul 14 22:44:13 2016 -0400

    MAINTAINRES: fs-crypto maintainers update
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
    Cc: Jaegeuk Kim <jaegeuk@kernel.org>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7304d2e..b2234f8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4925,6 +4925,13 @@ F:	Documentation/filesystems/caching/
 F:	fs/fscache/
 F:	include/linux/fscache*.h
 
+FS-CRYPTO: FILE SYSTEM LEVEL ENCRYPTION SUPPORT
+M:	Theodore Y. Ts'o <tytso@mit.edu>
+M:	Jaegeuk Kim <jaegeuk@kernel.org>
+S:	Supported
+F:	fs/crypto/
+F:	include/linux/fscrypto.h
+
 F2FS FILE SYSTEM
 M:	Jaegeuk Kim <jaegeuk@kernel.org>
 M:	Changman Lee <cm224.lee@samsung.com>
