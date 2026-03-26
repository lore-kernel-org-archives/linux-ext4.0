Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D293344D91
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 04:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774501141; cv=none; b=NeUUOksoG/uFi1gAms/l3yRfw2MYmti1R2SLkGoG+EtK4EDh+aV8Tcs+ePORJPIcgJaGWve/Ga1Uf19y32n9tgIPsZMvH9flmM9rVWMawUknUUP18A7digcG/5Em6xM1/5diFsjrReZGCIhh/a78YYZQtU8zckUIDa1xz2dV4cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774501141; c=relaxed/simple;
	bh=pVLm3wyomm0JxZ2OcXvlagzyLKYA2/ATLisfqGP0cJY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B1ej8OzMFiTUtAEYbo2UEb3ppcI63RxqBBqnPZ/r65ud/y9V/S4Pa3MkMYxv6O3JpSbvueMzEm9wdQ/XcStEiKnYhbhiF7BQ38VNckz5dzln4SukKLym9YWmS/wCZFKDHRSysm65r9S0R5U0gy873u43uEHR61hDZlExqL+kCoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=fPT4lTkU; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="fPT4lTkU"
Received: from trampoline.thunk.org (pool-173-48-82-49.bstnma.fios.verizon.net [173.48.82.49])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62Q4wdPD028233
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 00:58:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774501121; bh=egKqHTesdGfdY0/Gnd7vq1Ungvvo7iWfU84mdR64Sa0=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=fPT4lTkU7se14rlPj3720rdZeGw/MUQT3HE7bokASROf5ALTCw8OOPx2V1UsnNdFe
	 qRm+bC4/RbPJwQIW02wKnhWwgtxnJEQnNnjtZ06vjZCXO4tfGnc4mvnYouj38pSK2i
	 r3ewK1iGxAGXXUGdQd2fdru8C6vyu17lw2yI8oUhmfGprCncqZlqUqnsmN5wwimcgU
	 jV0W3d9v+NQ+09fvLg6NwF4TXqtl3RH9ybGTjwFJvoA9VECMjk6kLxpQXRZZQmo6RQ
	 V0GbRRpU/xnW9GCYdzq9zOYHf9s4FgGrqK+g4BzmkqzQZlqF4vvmhGJCzap1GJ/9Fp
	 +O81s7O3I5W9Q==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 5FBD22E00D6; Thu, 26 Mar 2026 00:58:39 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH -v2] ext4: handle wraparound when searching for blocks for indirect mapped blocks
Date: Thu, 26 Mar 2026 00:58:34 -0400
Message-ID: <20260326045834.1175822-1-tytso@mit.edu>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 4865c768b563 ("ext4: always allocate blocks only from groups
inode can use") restricts what blocks will be allocated for indirect
block based files to block numbers that fit within 32-bit block
numbers.

However, when using a review bot running on the latest Gemini LLM to
check this commit when backporting into an LTS based kernel, it raised
this concern:

   If ac->ac_g_ex.fe_group is >= ngroups (for instance, if the goal
   group was populated via stream allocation from s_mb_last_groups),
   then start will be >= ngroups.

   Does this allow allocating blocks beyond the 32-bit limit for
   indirect block mapped files? The commit message mentions that
   ext4_mb_scan_groups_linear() takes care to not select unsupported
   groups. However, its loop uses group = *start, and the very first
   iteration will call ext4_mb_scan_group() with this unsupported
   group because next_linear_group() is only called at the end of the
   iteration.

After reviewing the code paths involved and considering the LLM
review, I determined that this can happen when there is a file system
where some files/directories are extent-mapped and others are
indirect-block mapped.  To address this, add a safety clamp in
ext4_mb_scan_groups().

Fixes: 4865c768b563 ("ext4: always allocate blocks only from groups inode can use")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
---
v2:
  * Remove extra checks that were not needed once we add the clamp
    in ext4_mb_scan_groups().

 fs/ext4/mballoc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 20e9fdaf4301..b10db5d7545b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1199,6 +1199,8 @@ static int ext4_mb_scan_groups(struct ext4_allocation_context *ac)
 
 	/* searching for the right group start from the goal value specified */
 	start = ac->ac_g_ex.fe_group;
+	if (start >= ngroups)
+		start = 0;
 	ac->ac_prefetch_grp = start;
 	ac->ac_prefetch_nr = 0;
 
-- 
2.51.0

