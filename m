Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AC42441A6;
	Tue, 17 Mar 2026 14:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773757420; cv=none; b=Wg2xe5M4vz9nU+nQnII8wqMGeM8S/WT2kWFXugfbDRUYxx/omCQjhKtJDNeCqTccihUkC+9B0U2MZzbCRGgxxLn2VvmnXCjGxviK+zQxVinNGcJwEp+qN/xVzqUHg5Pbg6p3z72G+u6noqQguYpvua+9ePL8MZd6KEkktiKe8OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773757420; c=relaxed/simple;
	bh=BZ8GUy2pSWGU6ftZjWFNegZrejoShoYpG7+Q3De8E/k=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UyK89t35PRL7H6JBWfW/Pee0mNze/avgDAx/cqy48cyTh+LgJzXEp3DuNP2Q9JgOReoC2+ukbebnxQ+t2jHNjliLRC2WZoxwcp3Uk8RGqaBVHne7oNw1rqv3bLuxnuW6IR3GEJwk2qBzKyvGdnsbAjP3ss0a2dr5tF+QJx9x58M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=AkA/Ykis; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="AkA/Ykis"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=R9qKTxVmHGGb8OJAUrqM95C/m+9m/6CJuNVE9KujwFs=; b=AkA/YkisOpyqtPxjaG/vC8P71O
	ZPIIRrIPPz16dkyFClQ7D1nOMLEqkeWhOhdlYeRYu4RcdbE4cuq+WoEd+TrpFXJnI/bsISxcR6tht
	3extEeeXRxxauDbPv+RsP+fU+hg25gqfYduRzivC6hyRDF9K5rPH17UMlBXQNHod0mjqvjpowveSD
	rovRC1oX5abUaWdfznMn/HTy+8GSLwxjMQJwFQPfZbInpE8mEEr+UQeZLQJhCEpxy0GIcdhh8tPZ7
	Mxg9A5F8Y7ucP/bSuboZwAoE0ZHVJRcmzto5wQQWpp0JMGsagYuSB5Hpv7K0QZa+DQGLp6BHeTh9e
	eYVRMWvg==;
Received: from [189.115.10.45] (helo=toolbx)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1w2VKX-002JN2-Ry; Tue, 17 Mar 2026 15:23:34 +0100
From: Helen Koike <koike@igalia.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	koike@igalia.com,
	syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com
Subject: [PATCH] ext4: reject mount if bigalloc with s_first_data_block != 0
Date: Tue, 17 Mar 2026 11:23:10 -0300
Message-ID: <20260317142325.135074-1-koike@igalia.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bigalloc with s_first_data_block != 0 is not supported, reject mounting
it.

Signed-off-by: Helen Koike <koike@igalia.com>
Suggested-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b73703b873a33d8eb8f6
---
 fs/ext4/super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 495f99c10085..9f0cc29b718f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3626,6 +3626,13 @@ int ext4_feature_set_ok(struct super_block *sb, int readonly)
 			 "extents feature\n");
 		return 0;
 	}
+	if (ext4_has_feature_bigalloc(sb) &&
+	    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block)) {
+		ext4_msg(sb, KERN_WARNING,
+			 "bad geometry: bigalloc file system with non-zero "
+			 "first_data_block\n");
+		return 0;
+	}
 
 #if !IS_ENABLED(CONFIG_QUOTA) || !IS_ENABLED(CONFIG_QFMT_V2)
 	if (!readonly && (ext4_has_feature_quota(sb) ||
-- 
2.53.0

