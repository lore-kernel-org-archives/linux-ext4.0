Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE663DD532
	for <linux-ext4@vger.kernel.org>; Mon,  4 May 2026 23:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777937608; cv=none; b=GiwKfprx5YcCefbv0HDhOcJqcKT+qlfVvDz2o06WvbWjMxuXZLdgJMiO/PPbD9aHIHmbqI4ySOGhQAVs86gME5jnpNlnz23FWcxyhdNu/yusYrCMMqXgiF/LX2rRjKMhESPqugJtxgyY1bmZTg4ci1bIfcF95R1tsse/vBo4RWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777937608; c=relaxed/simple;
	bh=b6jDV5Vm5F5t7MvbeJhT8PYYRtSxPUW3uCHy0iAlIHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLvP4QxAafn9YXZyBaETj9aKgSm+8ZLp6wnTwsC652xb0VPVZLR4HRLGCYAvg2S9ldYwNKS8awOKJ5XOl1YD10VT3ieKfiSMO8ascPeG0nPuiUrnXCLhksXacnEecbZZp3iaF895K4glpTSUEESTzhxdcPS+M0LkPkXIKbNJ6YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=MfKd2FcZ; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="MfKd2FcZ"
Received: from trampoline.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 644NX8gA019535
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 4 May 2026 19:33:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1777937589; bh=KDBmMJRTOM6msgF/6HTbg3X/mw0HReUZ2sfaRVgq2us=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=MfKd2FcZQ/SWBsBwA+OHLY7ifPHbX6U3GuIJ2BrqT3wEkmzCgZws4NHiyovazx4yv
	 ItESDTTCZq+dmXB6ykSleIM31Rt8Dz6yDGoWXbjZR1qf4hNj2Kc10RTazZkDaZBuja
	 ZqDPJtx+GyXGUDHM5jvxAdLm2BvGmO8feDu9V4WYLzMxjxcGmuDwZqbSg51KdUZCWj
	 w8HK8mXHsFQid/Cff+7udpHSApejaBD9Qct7E6/bhnlpkfCudxDbDSRiYOS+EfIoQx
	 +tze/WvK+VylCIzFIO2HBNf0Mna9HrGV9cgabINVtnoLOguwxz20SF4VvTOWkVq0w6
	 9VbHiU9LiXiKA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id F1C6D2E00D0; Mon, 04 May 2026 19:33:07 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 2/7] configure.ac: fix disable fuse2fs/fuse4fs by default path
Date: Mon,  4 May 2026 19:32:56 -0400
Message-ID: <20260504233301.2345652-3-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260504233301.2345652-1-tytso@mit.edu>
References: <20260504233301.2345652-1-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the fuse.h header file is not present, fix the "Disabling
fuse[24]fs by default" codepath to actually disable trying to build
fuse2fs or fuse4fs.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Fixes: 239f4b7ac05b ("fuse2fs: separate libfuse3 and fuse2fs detection in configure")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 configure    | 2 ++
 configure.ac | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/configure b/configure
index a1a270e63..d941ff1f1 100755
--- a/configure
+++ b/configure
@@ -14737,6 +14737,7 @@ else case e in #(
 		{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: Enabling fuse2fs by default" >&5
 printf "%s\n" "Enabling fuse2fs by default" >&6; }
 	else
+		FUSE2FS_CMT="#"
 		{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: Disabling fuse2fs by default" >&5
 printf "%s\n" "Disabling fuse2fs by default" >&6; }
 	fi
@@ -14804,6 +14805,7 @@ else case e in #(
 		{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: Enabling fuse4fs by default" >&5
 printf "%s\n" "Enabling fuse4fs by default" >&6; }
 	else
+		FUSE4FS_CMT="#"
 		{ printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: Disabling fuse4fs by default" >&5
 printf "%s\n" "Disabling fuse4fs by default" >&6; }
 	fi
diff --git a/configure.ac b/configure.ac
index abce79594..d8f40f5df 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1459,6 +1459,7 @@ AS_HELP_STRING([--disable-fuse2fs],[do not build fuse2fs]),
 	then
 		AC_MSG_RESULT([Enabling fuse2fs by default])
 	else
+		FUSE2FS_CMT="#"
 		AC_MSG_RESULT([Disabling fuse2fs by default])
 	fi
 ]
@@ -1496,6 +1497,7 @@ AS_HELP_STRING([--disable-fuse4fs],[do not build fuse4fs]),
 	then
 		AC_MSG_RESULT([Enabling fuse4fs by default])
 	else
+		FUSE4FS_CMT="#"
 		AC_MSG_RESULT([Disabling fuse4fs by default])
 	fi
 ]
-- 
2.53.0

