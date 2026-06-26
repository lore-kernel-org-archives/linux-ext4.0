Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F075A1714AA;
	Fri, 26 Jun 2026 05:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782451057; cv=none; b=oH8xJAE6Bu/bbzuC3HV2TXhVn4q81RAOfNnyAWPWSOW2/uJmX7bp5pPTNpeXEqq86EXnquspSZsyCAcqfMmVqCgj6NqleyBlCI/VsCcm+QxRHtAK09iMagztqn5o5bNSN8X49e4NEzTqOP3b9WI4CUk1nLZUmWEOhUxMba0chxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782451057; c=relaxed/simple;
	bh=RgY9J0itKGXfjIELvTkAqHdUDbg8n00R2ervnhnv590=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=YQWmP/g0Ft7AYREpwos/cJX2p0VvNE14NZdAEhszqdAUZuYiuQLKUkmyPBIUU7swt3KjDJuDhTHMHlNH5WLL/K9Iaej0jWxY8YPGluPezjZV08BgL+c2nn4DIAU3lqkKlcdufew2lZRDGcXF41Gc97l9QujOf9cbx3Y7JAGWfuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=BsRvVda1; arc=none smtp.client-ip=43.163.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="BsRvVda1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782451045; bh=9xyAcodPaIp9fe6Bu4EzeRqI/HdJ58NF1ZQ5P0N7lLI=;
	h=From:To:Cc:Subject:Date;
	b=BsRvVda1v9+KXzSC4XCpQ6iAvULR+/wWpOIhjVmP5/2p14lSOmgBa9/bVM/c/Raq6
	 l2vsXPuPQ0MlKuNzx8Ih1zCjXwy0kOGgiL0hQg4V3QGX9B1gZ1oznEmraWCR6FPQlt
	 137VC+c7iXJJyJ/vEog0tqAfd3sjhzWtEN9rJQSg=
Received: from June.localdomain ([123.121.145.35])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 4569DCA8; Fri, 26 Jun 2026 13:17:22 +0800
X-QQ-mid: xmsmtpt1782451042t5nrby4yv
Message-ID: <tencent_C982B0201FE8F041BD5B4FC1ED7D646A740A@qq.com>
X-QQ-XMAILINFO: MO5kPsboTTrq14eCwW8S6usH8slBmt5lDs0fe9ydouHoE74mhd9jQGYakkBYjA
	 TV5B6EHKPY/4dFPvNexQoETC2SbuwTKkF4WtiPd5Z5bX65thS+0Hsi+vsij+W0UzWMNlnHLQe7Q9
	 31VzEXe2z3DfTNaKJ4xed+uWF0Y1N5HFNNntO2aDUEoC9f99lOKWZBrI1bH0ymP+j8BAzXzxNntT
	 1DZKvqdcOAsOLjfbq9WIm63N4dKxy+b3bzIs5Saz7LrNVC5fpTFOUKQHXjfhYN6kR+fo3mMKD9+r
	 1bp3NLuCZThua8DymvBpoaJF7fSG0pKj0hQRLPjIKZ2nhAkD1VMqd7TQJD2YTbSmvfb/chrPBXyn
	 vGjC3tnYM03EDlEoz58Tr0Nx2mUJ+GSEGu1qxX8brLtl+JnXMuvwSeROK85wRYeqzlhGhdjzztej
	 YdMgspOXXQFUHksOs7dRgh4Eimr2yJob0IaTbLsVlDz3GYVcDm9/iYpaWZGJanauPnqkJY7QPNZ+
	 q1c8J3gVdO2LGDgL4+gTstPdv6sYe0L/v38KSCoZ9GBizZgFASTRpJN+7lT4m3MDRhqezYNi0LHQ
	 ne30aNbQ/5ZBLSyQ5vLxG/mQQd+1fW33qPAo9vHPAiUaa5TAPRFXv1TAWAwN3BIjFAnop12js4jH
	 xDIB2DY4g9hwfXyMo3yLA8Wh2wavh4AcRNSNdo4NnDwbI5jQCg4fSM4o9313zhWFqJqMbCbtvSDd
	 5nzCsHi3ZSQeKa5570KLn2bDbInjJtgQZlV6Byvbzko/HBTAUahmiCSYDScXDYxRLk4y5eelQ1ZO
	 Lspr8cOh7uSRBBmD1w1oWAzaeDdVzwN/tVR37juPPFyybQ5loPw+rUILVeD5yeaNqx+F3A0GOdB2
	 MKVRiHL8MqtuTCSI7qb35JMlCKdTNedFDS2f++pUPIUkur60wsU0QGn3pm5HZkWeYMLyV+klN6Df
	 pId+RIivjphay/J14xzdjqpUAjpIs2h2KVc8KpqbN0KQIAq1OQfkXHg8s9eNlDZ+O8zn1Q/+CYg7
	 Wqc69YuD+y7Uc5/apN6JtDOSThj1WymB9TAWZczi0UaiXaCcdlmrut4IIFnd7dYoEnGHCvlUU1jW
	 i4yJ+o5IGET/KF6oGnj9bHDP5Qc4eiE0AxcKjPwF7/Ea3idpTJuCqkf6Ah/JBOy6R7zgp2
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-USESPAMBG: true
From: Wang Jun <1742789905@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	libaokun1@huawei.com,
	25125332@bjtu.edu.cn,
	Wang Jun <1742789905@qq.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: [PATCH] ext4: get rid of ppath in get_ext_path()
Date: Fri, 26 Jun 2026 13:17:21 +0800
X-OQ-MSGID: <20260626051721.15264-1-1742789905@qq.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[ Upstream commit 6b854d552711aa33f59eda334e6d94a00d8825bb ]

The use of path and ppath is now very confusing, so to make the code more
readable, pass path between functions uniformly, and get rid of ppath.

After getting rid of ppath in get_ext_path(), its caller may pass an error
pointer to ext4_free_ext_path(), so it needs to teach ext4_free_ext_path()
and ext4_ext_drop_refs() to skip the error pointer. No functional changes.

Without this fix, ext4_ext_insert_extent() returning ERR_PTR(-ENOSPC) in
ext4_ext_map_blocks() triggers a kernel Oops, observed via SyzKing
fuzzing on v6.6.142:

  BUG: unable to handle page fault for address: ffffffffffffffec
  R15: ffffffffffffffe4  (= ERR_PTR(-ENOSPC))
  RIP: ext4_ext_drop_refs+0x...->ext4_free_ext_path+0x...->
       ext4_ext_map_blocks+0x509/0x53a0

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Wang Jun <1742789905@qq.com>
---
 fs/ext4/extents.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a94798e23..8e23563bb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4510,7 +4510,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	allocated = map->m_len;
 	ext4_ext_show_leaf(inode, path);
 out:
-	ext4_free_ext_path(path);
+	if (!IS_ERR(path))
+		ext4_free_ext_path(path);
 
 	trace_ext4_ext_map_blocks_exit(inode, flags, map,
 				       err ? err : allocated);
-- 
2.43.0

