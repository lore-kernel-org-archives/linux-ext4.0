Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6281C1991D4
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 04:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775189021; cv=none; b=g+FAVfxOZi7R0jHh7yuOxT0aZBTpZ6vjD9o3sovYxml3tCa0v/kAdH2VDtI7ImNKtPlOVtwvOqtXoLSkETvQJYMEHiFheqS3by+L9e1++soJ8uHLIOgfzCELNwHUD2ip2KkpHCA41X26iZCLNsDViPgG6SftRANjEmzXJl6WAn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775189021; c=relaxed/simple;
	bh=SI1Dw4e1LIWHqDwsUQg9Wu32N7tCPj6+AjZd1TgXTDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glU3bJvspN032jYGaKI1CPEZMf/rHBaUfNLpiQsyDs0SYxmz6R/NutapePbZO7sleVYPWUvfegs3yaNF1cPwbCBVIg5i3jl1lbyJWe9M7Drvoa5ZwNfeG4C89Xo8KYVKCencwGOGKWqDIKuUbG4vmOBiFmMbH6daU2STwYo0qjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=VUzEbQhP; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="VUzEbQhP"
Received: from trampoline.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63343Xej005244
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Apr 2026 00:03:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775189015; bh=IWd78onahs7a8oXzAR+uFTyc2wkrAT4ZgLNx8ZuNOmY=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=VUzEbQhP1+kt8e2pmQCs02jLWo0rlgV6p0ZNjCSutiCJozX6J0ISaqhTFgTVB+qd8
	 2XQGhqWK+eHme3NprS6iojDItpJu7hjFUElMM5W/l6wTpAp+UZ1jJv0e+c+ZTsWYOG
	 e0+FHIV6EhtEjFJvKjgMuoHLxwXsW36uDAw/cn/wQABj/MZ2F1gTp0OPtjWYy40y2x
	 /bHYfq83tq+5JLci0M339v7LiNpMaK69r3CU+CqbiJWww3phT3P2mRqhQRuivXp/RM
	 1SLD75SsXk1gGFOgyMM4xMsFzDdsNkceVpPax81I/NBGUiL12Kyt8ucl0RmkjYe8Wp
	 IPQr20iDES2Jw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 7B5E82E00DA; Fri, 03 Apr 2026 00:03:33 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 3/3] fuse2fs: fix build failure on systems which don't define EUCLEAN
Date: Fri,  3 Apr 2026 00:03:28 -0400
Message-ID: <20260403040328.2385083-4-tytso@mit.edu>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260403040328.2385083-1-tytso@mit.edu>
References: <20260403040328.2385083-1-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MacOS doesn't have EUCLEAN, so we use EIO as the closest error code.
But then we need to avoid a compile error caused by a duplicate case
labels of EUCLEAN and EIO.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/fuse2fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index dfbc98636..94e289fab 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -5870,7 +5870,9 @@ static int __translate_error(ext2_filsys fs, ext2_ino_t ino, errcode_t err,
 #ifdef EILSEQ
 	case EILSEQ:
 #endif
+#if EUCLEAN != EIO
 	case EUCLEAN:
+#endif
 		/* these errnos usually denote corruption or persistence fail */
 		is_err = 1;
 		ret = -err;
-- 
2.51.0

