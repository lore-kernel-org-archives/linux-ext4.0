Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792959497;
	b=Jh1GntkF9vQVQL7uBmjV4VVcdNC4g0BC1z4g949pKHlkwHr4rKXzIeu13Hs0jCZoLalO
	 jKaMg7pmD4u+9E+4rC+PLtY0l5LFp4Dg/6W4N9jD6pV4ovNLrQtOWMcK4aAbzms7BBro0
	 IqZmvcXoVM52kvI9S8vR4LN0aC+nV9uH6YGJCpcTig++5dO5wL3AnbfwJGN+uYyz+GRob
	 TG79eSQTRHCNGFWpIPMiCoykuCs/jGKjXEY9zhIbtlBUK4XJCJi7YjqJBBKbh8uir5Vk0
	 xeLuAmNleI8FbsOWVD1lvBJ3eHNgwPTqPFmg2I9zDPkEkphvSR3t/vpk9/vV2MOyFSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792959497;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DHlUVOi3iarS8nYbZzwV//jWi6wFez1FyVoFZR0pXcg=;
	b=JPyK5P9MnWfjvVelrXBm+V4gKh5E/W8xtHuxHD/kgzCJkupIALbSkA2K9OVgvuruOZPW
	 WM9nbLmxh6FbD1UdNQwmJ1/3rT/xqnUTkxTnOPtiyzQ5O5Hv5Kcjojxsza8WYVm21tlGG
	 uYKWTSi4eMCv3KOhw7iD6DOBDSQYeN6A9h2Wfyw+JDcz5Vs4WethobWfpqIGEybojN+VF
	 rQUxH1NbRXs+o7Wa6bSushkTjPj0LK1hsPaNCuyD7jJL0Y5kCuu6okvZ2tbKIJVdWBmD+
	 XQ14QF/DS8qNgACJxQOSjAWFTsTR1W59N6TRYGogIgNq1aPVlZ9yl7HaZCD+2eWjmCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=czerner.cz;
	spf=pass smtp.mailfrom=czerner.cz;
	dkim=pass header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=fEeZ6aD9;
	arc=none smtp.remote-ip=79.135.106.113
Received: from mail-106113.protonmail.ch (mail-106113.protonmail.ch [79.135.106.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B56606A320
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 20:18:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60B56606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=czerner.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=czerner.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=fEeZ6aD9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=czerner.cz;
	s=protonmail3; t=1792959494; x=1793218694;
	bh=DHlUVOi3iarS8nYbZzwV//jWi6wFez1FyVoFZR0pXcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=fEeZ6aD9pP3U1u2wEuSeLLUEcqnWfXN8wmH/hpU7RVf0WiK8RPFPXVM1UqoucAMzq
	 dlO5m9HKhBrqN3Mexfej7WUGbJeMWeC9GJno6BfJmRa3WpFjOWWNv21ayelIcloArR
	 J/UxVmgRniZAIBrroLDiL6CnODtr5OdlYqgtTGUy28KTkjK7Zh2/bBfKnLHWb2wttI
	 N9eqPg5BJ2hOxCekGTKZ8I7ohSPCbG7letGVIBYCPWBb0nfi/UnDAQW+RWyd2ngzoS
	 Sf+pu8xHQIDOcVJeqVeoRoXeRmiriN7rwgyljD7uaipOTKgilQHLoaMnMTBGrdb20y
	 BninbVowwICnw==
X-Pm-Submission-Id: 4jCSkF2YQnz1DDnY
From: Lukas Czerner <lukas@czerner.cz>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lukas@czerner.cz>
Subject: [PATCH 2/2] ext4: don't lose the error of a failed migration
Date: Sun, 25 Oct 2026 21:18:03 +0100
Message-ID: <20261025201803.3043712-3-lukas@czerner.cz>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261025201803.3043712-1-lukas@czerner.cz>
References: <20261025201803.3043712-1-lukas@czerner.cz>
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

ext4_journal_ensure_credits() overwrites whatever error the migration
might have run into previously. As a result EXT4_IOC_MIGRATE ioctl will
report success, while the actual migration failed.

Fix it by using a separate variable to store return value from
ext4_journal_ensure_credits().

Signed-off-by: Lukas Czerner <lukas@czerner.cz>
---
 fs/ext4/migrate.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 0d32cfa55785..d2f8f2b6206b 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -419,7 +419,7 @@ static int free_ext_block(handle_t *handle, struct inode *inode)
 int ext4_ext_migrate(struct inode *inode)
 {
 	handle_t *handle;
-	int retval = 0, i;
+	int retval = 0, retval2, i;
 	__le32 *i_data;
 	struct ext4_inode_info *ei;
 	struct inode *tmp_inode = NULL;
@@ -578,9 +578,12 @@ int ext4_ext_migrate(struct inode *inode)
 	}
 
 	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
-	retval = ext4_journal_ensure_credits(handle, 1, 0);
-	if (retval < 0)
+	retval2 = ext4_journal_ensure_credits(handle, 1, 0);
+	if (retval2 < 0) {
+		if (retval == 0)
+			retval = retval2;
 		goto out_stop;
+	}
 	/*
 	 * Mark the tmp_inode as of size zero
 	 */
-- 
2.56.0

