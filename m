Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F38D33A6E0;
	Fri,  6 Mar 2026 09:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772787807; cv=pass; b=g2Io6n/SYESaXr3/rMrJufK1Jr6T2H3kiFKQW7F4d6klMnUqNz7HjFprGKAwLpf3o6iXk4YBgDe4GVcyD8fD7T947pFdrulk31QXddppelLT/0lIjLq4jTlT+S6WSjKQIzf5GEkUoeCPZRaf3UlDX2Xby406bt3KLr/imzPdFok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772787807; c=relaxed/simple;
	bh=Hj6lHdXG+HkGViJUite+vsxSD3ZPWd2kPpVXuuduSqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVctIjnPjKJ/vcMtUEFNnEcTDMNjYtR5hpF3ivBsrk5UMPjvh626iYO5odn+QwMzbYIaXIduKjQ45tTgTiUGYuJqr/dsMi86G9MUmPH02ZD6X9f1DKk+2vbHPSL3QoB98FUJvc5TLVfmNq7M1Vtb6mP3K8HCDr5ZgttCdEadfKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=iShS0JlH; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="iShS0JlH"
ARC-Seal: i=1; a=rsa-sha256; t=1772787795; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=A9gsgUZtUaX8N/BexV5xf9oUtj7H72DVWtfzCcWH4DAXpMHNV9pgMqcZYnKs5FGkIS/a7TCW5oaROg0eRhS4r7gLAeoPvc/wrqYhJrxsarEkRiwR0JQq/sKP659BZfORM5Ct1pO1BQ/rX9Gty9ZhI7oVKxZGa5+g8ADcFAOGUak=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772787795; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=SRSTXD9L61Hkaqs6DadL86nW5rdda4EPzuZg39TK760=; 
	b=GAr7r9C2zye2Fb99BtwE4S4QK79bXh76Uk2161SwzZVbz9rUqZ2NC8/lMj9k1Xjnl5lwmoh1rgJOZ8gbqGhALAQHteOVRe2jSylvuqUELDS5hDMV0B3Rc2VO5aEfezZHxMqbbSgucxpaOh9+dUoRDEMt7iA6V9aprhE6/vkxEbk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772787795;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=SRSTXD9L61Hkaqs6DadL86nW5rdda4EPzuZg39TK760=;
	b=iShS0JlHcMx0A6KDYasyJTkmmpOFS5N8MJv9h0C3b4ud/4U+tXEnSYTm2/TB/9N6
	wZATlGa6fHAbvTH5lBnCX8ykIyutcr/6y/Ot550rQUUnWb5iWILB4z7ccfO9pF3O8En
	63apRo6fHiz40xX/yrtjCUIN8/Aop6E+RPqVrSHw=
Received: by mx.zohomail.com with SMTPS id 1772787792428246.8300268629713;
	Fri, 6 Mar 2026 01:03:12 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	Mark Fasheh <mark@fasheh.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org
Cc: Andreas Dilger <adilger@dilger.ca>,
	Li Chen <me@linux.beauty>
Subject: [PATCH v4 1/4] jbd2: add jinode dirty range accessors
Date: Fri,  6 Mar 2026 16:56:39 +0800
Message-ID: <20260306085643.465275-2-me@linux.beauty>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260306085643.465275-1-me@linux.beauty>
References: <20260306085643.465275-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Provide a helper to fetch jinode dirty ranges in bytes. This lets
filesystem callbacks avoid depending on the internal representation,
preparing for a later conversion to page units.

Suggested-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Li Chen <me@linux.beauty>
---
Changes since v3:
- Add Reviewed-by: Jan Kara.

Changes since v2:
- New patch: add jbd2_jinode_get_dirty_range() helper.

 include/linux/jbd2.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index a53a00d36228c..64392baf5f4b4 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -445,6 +445,20 @@ struct jbd2_inode {
 	loff_t i_dirty_end;
 };
 
+static inline bool jbd2_jinode_get_dirty_range(const struct jbd2_inode *jinode,
+					       loff_t *start, loff_t *end)
+{
+	loff_t start_byte = jinode->i_dirty_start;
+	loff_t end_byte = jinode->i_dirty_end;
+
+	if (!end_byte)
+		return false;
+
+	*start = start_byte;
+	*end = end_byte;
+	return true;
+}
+
 struct jbd2_revoke_table_s;
 
 /**
-- 
2.53.0
