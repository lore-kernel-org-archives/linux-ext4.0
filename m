Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA38213E9C;
	Thu,  2 Jul 2026 15:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783005791; cv=none; b=VzTUEh9YVb2pbAQWV8EljC17ZiPn0WzzAIn+N59wVq162DgArTHWENEZKXK4neEdsoLqqMqnxk44jH/aRgia46c4csSYZ/4cTdy61+HWVyhOODXWNXQIU8xJy74XkyfV66O7IlhJMRotiRfZZXKrhrSgXCMAilev0B4/5EeIEJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783005791; c=relaxed/simple;
	bh=yxzGMgqoSZA9yPq43a1QVOF+byYEaf/sD7O8OmIhn0E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jDEyKko4wKFeZij/MPxMo1smzMT0otzI2HV1wdVR/C41CVmDzdWupfi6jU7lElWfbYaoyt4BeCkpJnwJJc7IeZUeWXXeCx6pT07ODCzWWvr5mrJ2ZlMNKiKd2KHSmO+Ikshdgf6Uq1DgYEM2upIHYKWwQM2T2dsQyXNinzcaOg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=QRc5oFBg; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="QRc5oFBg"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 662E2RHh2007659;
	Thu, 2 Jul 2026 08:22:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=ZXSseWQlcD8T7J5F6cBcRHQf5mWABbCBt69AehAV5qs=; b=
	QRc5oFBg/1NHLN4NHZix6PCg9KqZ7uzNengex0dUKtZtgdt6GvTsQie9ZUVxYDzr
	mPJiJR6yl5vkQMYxFix5ue5dJH/mGTXCMgWSff9QxyjbAUQ06UDhUi4znxiFYZg5
	8DcjRp7gl+fn+R7oIpHCmDRygtISGgMekDg4eH5KnYu4uun0KiPW6ADGwGjG83yh
	L3gxxzI8nNRz6DQYUCTHpYOkRCleRSECyo8tVq9s0wmlTjmv7N9h9vEg/Fc8Kppk
	MgsSWj3kzyxUT/umInxEB+iVSyFbCO6hh39HTPjNkVUZj6FshTEr3ctHLWRaUFx2
	+q/o8ogz21lUOlZrcvhQyg==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f2e1gyn4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 02 Jul 2026 08:22:32 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 2 Jul 2026 08:22:32 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 2 Jul 2026 08:22:29 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v13 1/4] fs: add iput_if_not_last() helper
Date: Thu, 2 Jul 2026 23:22:21 +0800
Message-ID: <20260702152225.4071746-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702152225.4071746-1-yun.zhou@windriver.com>
References: <20260702152225.4071746-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 1V9AeZccal3YAliDPBzgANqlMLadfeZQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDE2MSBTYWx0ZWRfX1+hJz+924FaI
 st4p9jM/Pd1Tv7kaX+A8qnvJ6S4StvAPYnYNBZz7y+QQnhVhjyoj+80AREIEu3eSqCMqlST7IxB
 +enKkSeSPr+voDB4i9CwdJZ/7w2SDbjC2e8372W29Z1XLcR61OQz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDE2MSBTYWx0ZWRfXwE6UsaeRtj0p
 KLd8JREfzp3v+AxHRGyTGPrAbKPghlNekfEVTJdaREr7O7mPAxzW3x7UFkIG6vKawKKXfHnDH08
 uUgwuKXCwDwOZChJvhcyNc8X+6VAC2DErsa6XelM58Uy3iPy3zb3CqjjSPEaC4IoEdYt6m+85uU
 +ETcGiCulemWuKqhW7j7o/PoN62Qv7M/3TTME5HSF31RbTaVO0fRbp8JqMZ+30AHnjYcQPOVORo
 VVT9sh00lQffT4oxgSrjhgv7HQ6fwEUX+n3qlsjzTE9krFDIbHyo3EOLtQfKfWVFxzb9Yzfvuw2
 q7BOe7uHXTFHRSSg0ptqLW0z6/byxjq6jezy63eblQZ+uEu2cE6+8yAwlq2MNqw23Z3+7egMGN0
 BgnVrwRL82xdeHuAaA9nHuebU1V5WKmyddIstAgUVyO1l2NgbKCl7BNuGRx5MeI/2tdNhUxPpWI
 wchPCyTaFKNurlcd+gw==
X-Proofpoint-GUID: 1V9AeZccal3YAliDPBzgANqlMLadfeZQ
X-Authority-Analysis: v=2.4 cv=GsByPE1C c=1 sm=1 tr=0 ts=6a468238 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=t7CeM3EgAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=vCr0if_IiwaKUNF-nsEA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020161

Add a helper that drops an inode reference only if the caller does not
hold the last one.  Returns true if the reference was dropped, false
otherwise.

This is useful for filesystems that need to release inode references
in contexts where triggering final iput (and thus eviction) would be
unsafe due to lock ordering constraints.  The caller can check the
return value and defer the final iput to a safe context.

Unlike iput_not_last() which BUG_ON's if called with the last ref,
this variant is designed to be called speculatively.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/fs.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index d10897b3a1e3..030d7877f23a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2413,6 +2413,21 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
 extern void ihold(struct inode * inode);
 extern void iput(struct inode *);
 void iput_not_last(struct inode *);
+
+/**
+ * iput_if_not_last - drop an inode reference only if it is not the last one
+ * @inode: inode to put
+ *
+ * Returns true if the reference was dropped, false if this was the last
+ * reference and the caller must arrange for final iput() in a safe context.
+ */
+static inline bool __must_check iput_if_not_last(struct inode *inode)
+{
+	VFS_BUG_ON_INODE(inode_state_read_once(inode) & (I_FREEING | I_CLEAR), inode);
+	VFS_BUG_ON_INODE(icount_read_once(inode) < 1, inode);
+	return atomic_add_unless(&inode->i_count, -1, 1);
+}
+
 int inode_update_time(struct inode *inode, enum fs_update_time type,
 		unsigned int flags);
 int generic_update_time(struct inode *inode, enum fs_update_time type,
-- 
2.43.0

