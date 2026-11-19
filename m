Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115856;
	b=hbu23Oj0iNeN5iMwmULrLbeqoNxsogr4x/JJ1CzU9FqKG1PsOTRub5U9Mr9sAjxShU73
	 d12egP4jlWMA5n/amPUDxauH+eNJMzeq43E2YOq0sZSeU1PXhS8vC5H9+sfBQ99ijPj5i
	 EvNu4tjcVDbOuotKDBqfuTJ8S72AvQgFdpWE3TuJFxNCF35JUYZj/+yowCJZWdNTOkvB2
	 TwFbEjaQulpmrn/lauHstrHOWsQheAAiucLDaqiKBslUZ+X8hzGLOAKEyv9r0/kTZeUS1
	 X7f92nsxjKLmZe28uNfSTe2CCVil8mU3ufr8ByAgjHOz6N0mcjHocgaDnlDat9h+9tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115856;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FCzYoGt6qqCFzH2OUT/MQQNC4E3Z3NIZWPGxSE3W3WU=;
	b=MnGvjh7SFChBTCReO2n3cWFkKsZ/sLkwdEgtVRlEXnRfYdfTr+M6A0plTLEXi3/weQH9
	 ERW292bd99z3xxfbDTmRZlrUc9J2UyymOHq7gEoM1HOHBjBPvl4rm6IMBuOKJaz+odDvc
	 gWvOfLDqvb8fTw6a+venUkfcPMySWMMb28tX/PZDkEWV2YdXRyRTes3YLfYmrXGgNz71o
	 V8ksu1l2qD6zGSQaLY3bFGu3ZvnxnMI6yOwokXrveamxpNOroGvDG2qjemAEsKIFseueB
	 xzITHc6bIyShoHH3liqOqELjwU7/vZZnwJdf+KhP7oGjJ9y+TkiPVWHaYEK3nBjhXqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=hXKqXkuf;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3182606A335
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3182606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=hXKqXkuf
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHWsj029862
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115853; bh=FCzYoGt6qqCFzH2OUT/MQQNC4E3Z3NIZWPGxSE3W3WU=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=hXKqXkufyYf+TZuO9m0qOcAgitJydhHx+H3fSx9UEDQEMbqm9SKdMEP1U/ie5ohR6
	 hm4baHlkdfOUqIV5rkAbxpadhRjVpxP/BWSRLOxBpUbIkM4hnVH1d+HTuPgJaNmRxV
	 RuakaowWMW67pivlKgRFtPIa4yYvUhxqE7WdoVeVN2ezl36vNuXgBp/tGQQUBnrEtr
	 JcygKwM7FCKUhxCbid0YBR4USx8JRybZKNS9fqc5T1pCKs68qiWrTjeNkkUL2z7nfz
	 nfnmw76gZJmkaMXTg6RbS5Z1YtGpFJfLDFFyGNV8vpQ0dDdYoH+alxb4FMkR/HbvcD
	 9uAlAlso00a8A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 26FAC2E0149; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 07/32] ext4: pass missing ioctls through ext4_compat_ioctl
Date: Thu, 19 Nov 2026 14:16:54 -0500
Message-ID: <20261119191719.1943298-8-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119191719.1943298-1-tytso@mit.edu>
References: <20261119191719.1943298-1-tytso@mit.edu>
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
index ea91b8827e96..f24102f8dbd9 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -1452,6 +1452,25 @@ static void test_force_shutdown_and_ioctl_dispatch(struct kunit *test)
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
index f296a5ee1f45..b279ffe1d621 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -2066,6 +2066,11 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
2.56.1.708.g77570a6a1d-goog

