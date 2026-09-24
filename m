Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A92353A80
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790261975; cv=none; b=Li6Y5s0H3CCnR9kv9xdaEE37aR0zH6sUCYHDlPgREktmfVTGIQQ7FSpEsiZMm1mHaufesJ+Bb8l6Hsdr0u1U+kCZuxy2NlEmlpa3qRUl8FB/E20cp6mSv5F+s/5QUWJAR4eUX2/IN0f71T0thrwNzgaYb72zXgrIJ8WfMOIqSQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790261975; c=relaxed/simple;
	bh=2PujQuqFvgeqmil7HqSDs66X+zBvJPq7gjvaIsGIRn4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MJqDgkZIKQD0iNSzWjZe8IxFbxLxA7PJM1Oo9ZpsX+XrRdVtMjKuZghX/PfHaw0JH7IpZ8TwbkCPdrT8x2FEoOPDZ0gWNAky7m4XJTBckqLLbCPW1VggFL8HQr/adKG0rzUkqvKj1R9kx1w96p/8/1n4ESewr+cAMgwjzBu4Pvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=hzhHLmPu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="hzhHLmPu"
Received: from trampoline.thunk.org (pool-108-26-156-67.bstnma.fios.verizon.net [108.26.156.67])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 68OExSEU002323
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 10:59:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1790261970; bh=e1jC8DUEo13QAUUBdzju+UTCCyLyVzWr7JK1yhA0IwA=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=hzhHLmPuW36eIkdpd8VyQF3EyTAsEgWuwy2DshkTQAe2r8F9Hi4LmMQJDrM3/vFMj
	 SOPxjd9e5B4Q07TP9Lh6Tgj7MxoOFIawZ2MglQteZi1E4A6fi210r+/kFXaYAPP4Aw
	 DVfhhLQQ2J6DI0sTLPBZWNcPZYtvOWZjyEEDWLjoxIgaSAqEkQ8AjaOalBvBaUuvw/
	 GEUPjcoQ96JpDembUVvwWTCAzTSewX+6r+jtQODx1E9xHZVlmJw3Q9u/nmUVqmxCOv
	 UodTc3sSfwcShztC7eFQ5wg9T00mhyCiOYdQU/JnN7vdMxkw3yQ62bKWhW7l10nOHv
	 Hv1kpglDtCY+A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id C5DAC2E00B9; Thu, 24 Sep 2026 10:59:28 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext4: mark data=journal as deprecated and will be removed in January 2028.
Date: Thu, 24 Sep 2026 10:59:24 -0400
Message-ID: <20260924145924.341425-1-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 Documentation/admin-guide/ext4.rst | 6 ++++--
 fs/ext4/super.c                    | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/ext4.rst b/Documentation/admin-guide/ext4.rst
index ac0c709ea9e7..7aa586c27e37 100644
--- a/Documentation/admin-guide/ext4.rst
+++ b/Documentation/admin-guide/ext4.rst
@@ -172,7 +172,8 @@ When mounting an ext4 filesystem, the following option are accepted:
   data=journal
         All data are committed into the journal prior to being written into the
         main file system.  Enabling this mode will disable delayed allocation
-        and O_DIRECT support.
+        and O_DIRECT support.  This feature is deprecated and support
+	will be removed in January 2028.
 
   data=ordered	(*)
         All data are forced directly out to the main file system prior to its
@@ -420,7 +421,8 @@ There are 3 different data modes:
   consistent state.  This mode is the slowest except when data needs to be read
   from and written to disk at the same time where it outperforms all others
   modes.  Enabling this mode will disable delayed allocation and O_DIRECT
-  support.
+  support.  The data=journal feature is deprecated and support will be
+  removed in January 2028.
 
 /proc entries
 =============
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a187112cafaf..8da79cc8593f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5049,6 +5049,7 @@ static int ext4_load_and_init_journal(struct super_block *sb,
 static int ext4_check_journal_data_mode(struct super_block *sb)
 {
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
+		printk(KERN_WARNING "EXT4-fs: The data=journal mount option is deprecated and support will be removed in January 2028\n");
 		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting with "
 			    "data=journal disables delayed allocation, "
 			    "dioread_nolock, O_DIRECT and fast_commit support!\n");
-- 
2.53.0

