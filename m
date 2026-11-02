Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793585543;
	b=MAkAi2gSbmWdu6lcLZ/xF6sLrpiuZMP71ihU2Doh6JQz4oDyoMFJIcFQ96ZZXF78GCed
	 Q+gLpWsEREQVd/Z1g7svsR0be8+SWjAdlxogf0xXMPdLa/HpIFdV66UjKRfdsOG//7kUq
	 oYapSYajcweCnAsCK+lac6DC1i3rPyJuEaWVwzGOxrDRQhwhcnYKPS7LkNzN0CyC5HMdq
	 t8xYM1Qsma2v4XLJ16oRlA7Pgssvz46T4zuLY5t0l6WYS6VEaZI7O/rOfdZKsSkOgk+8w
	 zJ9nTZOOgpGSWcPxFFa3Zg5IvRDcGJ/FE/07OlbVyBDAp8GYvAxKniKSIw9TBfnS5bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793585543;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=CSYmATn8AFrh/YDbQDhDjm5wcC9gMv5q+GhjxbuJqaw=;
	b=Z5jwoHwzimrDkK+dOMcyOfGSrZkd0rom5f0Llv227QsZctuRvwzx0BvR8Bm2BGCHR0Vq
	 GVUh0ywRcnK48LcDEIwKa80/MXc8YrTQMD/hX1phyPtlgJMXCKWWY/P6huoql8aXbyAcy
	 hfLQrBDN3FW7QJ3KpU5q50+68YzpQXUAA8raPmLQ/5jfeZAVGtd+LQyMotSdUKFwx4jb1
	 s/WjxprHvbDNyHyqIAzi7gc5KmtnI+JBi4+vAEnd8rm4M8WdnA4VY2HI1OxJiZe14oikR
	 goiSyLc3lDT1zj8vue6/g8ZabWVehh9Vl2daGsoOf1JGYfqVQlxqKFbm/ob1+AVcbpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2E2606A324;
	Mon,  2 Nov 2026 02:12:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C2E2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4jHwF15P1Sz1c0qf;
	Mon,  2 Nov 2026 10:11:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F2BAA4056B;
	Mon,  2 Nov 2026 10:12:12 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCXzex78edqPqz7Cg--.46735S3;
	Mon, 02 Nov 2026 10:12:12 +0800 (CST)
Message-ID: <0ba396c9-1881-4ce9-a84e-6b96c2445228@huaweicloud.com>
Date: Mon, 2 Nov 2026 10:12:10 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [ext4?] WARNING in ext4_do_writepages
To: syzbot <syzbot+97fbc97fdd4e4fa2ed3a@syzkaller.appspotmail.com>,
 adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 syzkaller-bugs@googlegroups.com, tytso@mit.edu
References: <6ae4c600.0c1d3ab6.e3d48.0072.GAE@google.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <6ae4c600.0c1d3ab6.e3d48.0072.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCXzex78edqPqz7Cg--.46735S3
X-Coremail-Antispam: 1UD129KBjvdXoW7JFy7GrW8GrW8try8Cr4kWFg_yoW3Cwb_Ga
	4fJr48tr4Yvw4fur4DJr15JF9YkF4IgrySq3Z5Ja15AFW2vrs5ArZ7Zr1avF1kGwsIgFnI
	vr98Gr10kFy8ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

#syz test

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66482b..b630e56815bb5 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1905,8 +1905,12 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 		 * the extent status cache must be cleared to avoid leaving
 		 * behind stale delayed allocated extent entries
 		 */
-		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
-			ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
+		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+			ext4_lblk_t lblk = EXT4_B_TO_LBLK(inode, i_size);
+
+			ext4_es_remove_extent(inode, lblk,
+					      EXT_MAX_BLOCKS - lblk);
+		}

 		/* Clear the content in the xattr space. */
 		if (inline_size > EXT4_MIN_INLINE_DATA_SIZE) {

