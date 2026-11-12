Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458844;
	b=XAb7EvAZJMXOBfpD4RznLDjA+vw1T8RMd0BfIEuV6mQUjjkvtNEqg8b1+LWW16Mk0IbY
	 DtL8cf17xC4Zr7VWKBdWB14zBpTfC0DzkxbiWYettS4JOdTe3EaWP8ZNGuK1zqJvW4K0w
	 J8wz9FExw4GGF/7E3pDI6eQR2U6e/md90dYZWiRte462//m0uBXYJTuwxJf9oka4QOwTs
	 FtzyIXPA7xre1fBcCOy8EwwFnwhFxPBroJcQbi5j7qnAyOFEfuukWvn7QeHkiVW5t5DyW
	 aeyfRgZ8SqJtOonATFKJKcp06OEZ/N26E8W3uFCrjaFU3v15sxKbaS0jXMMin2G63ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458844;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hy/kWSaLAkWFfjrUs6iXY2SOe33zEgtNxCzg5XGDGPI=;
	b=AFIJd0iIWdWcYZmB3L4odtynTn3AdMT7r7we39N/z3vi2U+7teMcNKmZQ+gewTl12prU
	 UWtzuPb04kCGr8oivurMtPKD18n2kdRm3hHKWJ2c5ZJOoLKBLnRwFJsITPjX6GDyb/1+4
	 FO2XJwxGsPJ9CuCqYg2EtE3zGntjwHz/FK+oKLeFlmH+0NnTIA0Bp1xxk9PJ3zsI6YoDd
	 txE1oSIqEfSrrsvk+nY7Gi2zCZgtwsowoMTvJY2i3cGOYW9LewFH081y0XRYCTQDDVRib
	 VF8aRiGvih92EpNmneKn+jOhILKOMncjd5+JBP5vT7ltJhtb4R/DPiSPN1HOt934mUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Dl8iLi4B;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3401B60A2608
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3401B60A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Dl8iLi4B
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lKFF031189
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458842; bh=hy/kWSaLAkWFfjrUs6iXY2SOe33zEgtNxCzg5XGDGPI=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=Dl8iLi4BirnCZLKyXTOuLsqXbVvfIqZHismbYv7frRKTikTwMa5Lfv2/6B4xFP7NT
	 9fRbI0VJrPpPqIguoQjBIZ/LNngqPAMwTOVuAQphMLxU6utvIFpIhZ1mYcdaYxD6jh
	 jmLuXbG/7AQakjXKNNPjyVVtxYtcOFXCMJdgpApiP/a95MXqQaaH1Cls6hkA0XPgbG
	 uF21noJouI6onacWrfai2X/YpDB2sSzroos7mPJBkGJPtwVqMDtN0sxlnUlBfWoQXM
	 MiJphkkHxULBXBvej2ZiZtCM+FLswBa5jCaYo0oc7TnZCzNAOPsef2yGaJ+LSZ9zjz
	 oCo9Z5h2c6sMw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 363F72E0149; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 07/23] ext4: pass missing ioctls through ext4_compat_ioctl
Date: Wed, 11 Nov 2026 23:46:56 -0500
Message-ID: <20261112044712.1577296-8-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112044712.1577296-1-tytso@mit.edu>
References: <20261112044712.1577296-1-tytso@mit.edu>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_compat_ioctl() only forwards an explicit allow-list of commands
to ext4_ioctl() and returns -ENOIOCTLCMD for everything else.  Several
commands were never added to that list:

  EXT4_IOC_MIGRATE
  EXT4_IOC_ALLOC_DA_BLKS
  EXT4_IOC_SWAP_BOOT
  EXT4_IOC_GET_TUNE_SB_PARAM
  EXT4_IOC_SET_TUNE_SB_PARAM

As a result, 32-bit userspace running on a 64-bit kernel (for example
a 32-bit tune2fs or e4defrag) gets -ENOTTY for these ioctls, even
though they work for native 64-bit callers.

None of these commands needs any translation: MIGRATE, ALLOC_DA_BLKS
and SWAP_BOOT are _IO() commands that ignore their argument, and
struct ext4_tune_sb_params consists only of fixed-size __u8/__u16/
__u32/__u64 members whose layout is identical for 32-bit and 64-bit
ABIs (its __u64 members are naturally aligned at offsets 16, 24 and
32, and the structure size is 232 bytes on both).  The ioctl numbers
therefore encode the same size, and the commands can simply be passed
through to ext4_ioctl() with compat_ptr() applied to the argument.

Add the missing commands to the pass-through list and extend the
ioctl dispatch KUnit test to check that the compat handler forwards
them (when CONFIG_COMPAT is enabled).

Fixes: c14c6fd5c56a ("ext4: Add EXT4_IOC_MIGRATE ioctl")
Fixes: ccd2506bd431 ("ext4: add EXT4_IOC_ALLOC_DA_BLKS ioctl")
Fixes: 393d1d1d7693 ("ext4: implementation of a new ioctl called EXT4_IOC_SWAP_BOOT")
Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ioctl-test.c | 19 +++++++++++++++++++
 fs/ext4/ioctl.c      |  5 +++++
 2 files changed, 24 insertions(+)

diff --git a/fs/ext4/ioctl-test.c b/fs/ext4/ioctl-test.c
index 831b7e032fad..8afeccc755f6 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -1423,6 +1423,25 @@ static void test_force_shutdown_and_ioctl_dispatch(struct kunit *test)
 				-EBADF);
 		KUNIT_EXPECT_EQ(test, ext4_ioctl(&filp, EXT4_IOC_SWAP_BOOT, 0),
 				-EBADF);
+#ifdef CONFIG_COMPAT
+		/*
+		 * Architecture-neutral commands must be passed through by
+		 * the compat handler instead of failing with -ENOIOCTLCMD.
+		 */
+		KUNIT_EXPECT_EQ(test,
+				ext4_compat_ioctl(&filp, EXT4_IOC_SWAP_BOOT, 0),
+				-EBADF);
+		KUNIT_EXPECT_EQ(test,
+				ext4_compat_ioctl(&filp,
+						  EXT4_IOC_GET_TUNE_SB_PARAM,
+						  0),
+				-EFAULT);
+		KUNIT_EXPECT_EQ(test,
+				ext4_compat_ioctl(&filp,
+						  EXT4_IOC_SET_TUNE_SB_PARAM,
+						  0),
+				-EFAULT);
+#endif
 		filp.f_mode = FMODE_READ | FMODE_WRITE;
 
 		/* EXT4_IOC_CLEAR_ES_CACHE empties inode extent status tree */
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 9e2bde83a033..d6f47ff00e61 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -2064,6 +2064,11 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case FS_IOC_SETFSLABEL:
 	case EXT4_IOC_GETFSUUID:
 	case EXT4_IOC_SETFSUUID:
+	case EXT4_IOC_GET_TUNE_SB_PARAM:
+	case EXT4_IOC_SET_TUNE_SB_PARAM:
+	case EXT4_IOC_MIGRATE:
+	case EXT4_IOC_ALLOC_DA_BLKS:
+	case EXT4_IOC_SWAP_BOOT:
 		break;
 	default:
 		return -ENOIOCTLCMD;
-- 
2.56.0.542.g3ef89b7020-goog

