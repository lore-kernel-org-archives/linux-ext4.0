Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8943E3D99
	for <linux-ext4@vger.kernel.org>; Mon,  4 May 2026 23:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777937610; cv=none; b=n7F0C5c8SY/b7otChv9Vr7iB+su2DaDJUd1nEpbD4i1dmRiei0j4kTerqOrw4xfl0cAK9XXSyf53nfQ6uU8TTJXUjks9LGxjuSYv34eukiHQEgyrlU2jUR7HYEUWcomIapRTkUnuCAJr3etOh1aC2x23bmLjxLG/XuRPTzJHI58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777937610; c=relaxed/simple;
	bh=Q/imJGLMZIBZLTYsrQsq6LbsKYRF6A1UJ6q2qFMKU68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqXlhPKjDQW2/K3QY5T2g44Jc+jO4vjYVrpDSj+/w4+4ksPovP5jcD/0lnuhd34JZPLmkvBug79FpOtxgiC/onAAznay3EgWrpHdNV42jKklLZwhOiiScz+4OmI9PyRHZHMM3oQc4e4AC50iiaEWgrgPwlVgjHJ1rPHSk2MZ16A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=JSzaioJu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="JSzaioJu"
Received: from trampoline.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 644NX9I3019586
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 4 May 2026 19:33:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1777937591; bh=B3t63z5PERYiwWoafEj2kuIkGpgvcawA2QYLEAY/3MM=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=JSzaioJuLjU+nthFRc78t1TbralOmVaeJFzfddo7WnfuiW1kC+slE1ljfDfZ8Ir4j
	 28LwLWpnS4RplZfeaTR9+kzHTam0nYEYZwwAn7FWgK95NtVSpKpNcpbbLg05n3/V00
	 09w4xzsZqC4F32DABiHR9ffc5mA7C0VDaVmkxwepkHr3gDBC4pkqre6dZu2uUeb+sM
	 ivURIe3GDP5NqMWpXdvii9WqVDlzMqcTbZ4jtaRrfLfTfh5Cq0zhW2806/geBh7hc2
	 M4jwn70HGdzFLdfY4qST6+Bhn2l/Z4/fUcfOhvY3+ZTGYfO7J3dGjG1N6eYIH74ypA
	 DdBHbB19k7d7A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 066792E00D5; Mon, 04 May 2026 19:33:08 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 5/7] libsupport: remove the LIST_HEAD macro from list.h
Date: Mon,  4 May 2026 19:32:59 -0400
Message-ID: <20260504233301.2345652-6-tytso@mit.edu>
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

The LIST_HEAD macro is defined by both the Linux kernel's list.h and
<sys/queue.h> (originally from BSD).  The problem is that on MacOS,
some system header file pulls in <sys/queue.h> leading to a macro
redefiniction conflict.  Since we don't use LIST_HEAD in e2fsprogs,
the simplest mitigation is to just comment out the definition of LIST_HEAD.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Fixes: 37dafcc0894b ("libsupport: port the kernel list.h to libsupport")
---
 lib/support/list.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/lib/support/list.h b/lib/support/list.h
index 0e00e446d..0ec8de525 100644
--- a/lib/support/list.h
+++ b/lib/support/list.h
@@ -36,8 +36,17 @@ static inline void list_head_destroy(struct list_head *list)
 
 #define LIST_HEAD_INIT(name) { &(name), &(name) }
 
+#if 0
+/*
+ * This conflicts with the LIST_HEAD defined in <sys/queue.h>.  We
+ * don't include it in e2fsprogs, but some systems' header files might
+ * pull it in, leading to the macro redefinition conflict.
+ * Fortunately, we also don't need LIST_HEAD in e2fsprogs, so just
+ * drop this convenience macro.
+ */
 #define LIST_HEAD(name) \
 	struct list_head name = LIST_HEAD_INIT(name)
+#endif
 
 /**
  * INIT_LIST_HEAD - Initialize a list_head structure
-- 
2.53.0

