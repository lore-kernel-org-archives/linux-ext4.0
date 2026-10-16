Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D79C4508E9;
	Fri, 16 Oct 2026 10:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792145205; cv=none; b=c6pAC2VTkIQc1x+4dVge0ZAYa0PcA77Wus2MsXeP/LYF8flswrSfvV/53IOQt+lrydq2zOlCAR5Kg/AeDVkQIR/LV4EJ0Q88Yq96uqKG7XJs92nOYG372dB+7D2RYZ3fmgtmb20JD4H0OUXP5RbNtvPzxr39KTX0mucXMDYosnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792145205; c=relaxed/simple;
	bh=SfMBzgk7p25AwDDti/OcTTOxuYfNAEw7WDRimDYYnl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANa1GAWeFRQKNym4UpgpnLL3Dpt+HPZPoAAVdDuZudg4HOHeplH/iU5Jjy3fFiwDwJNiXBZ4MARnmIHZ8eoXM140vnwA0Z0x3XD9/Lj0Tz19Ise8IiRj+p406T/Pyy+eKjiLutqN2zgnjbnESop7KxbzBGl0PIYoB+VD2lnx71w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j5gYZ66ZmzYQvcG;
	Fri, 16 Oct 2026 18:05:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1432840B70;
	Fri, 16 Oct 2026 18:06:35 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZPMj99Fq7MSZAg--.19410S4;
	Fri, 16 Oct 2026 18:06:34 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	error27@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH] ext4: return 0 instead of stale ret in ext4_iomap_writepages()
Date: Fri, 16 Oct 2026 17:59:26 +0800
Message-ID: <20261016095927.1762656-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <atHZN9YIl8T2E0tK@stanley.mountain>
References: <atHZN9YIl8T2E0tK@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnZPMj99Fq7MSZAg--.19410S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF1kuw1rKF1UtryDGrWkCrg_yoW8Xw18pF
	W3G34kGr1kWrykua1vga43Zw10yayrGr4UWF15CFn8Z39xXFWFgF40gF12vF47ArWUC3ya
	qF4F9F18uw1jvrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VU1773PUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

smatch reports a "missing error code" warning:

  fs/ext4/inode.c:4518 ext4_iomap_writepages() warn: missing error code? 'ret'

The 'ret' variable has already been consumed by the ext4_emergency_state()
check at the beginning of the function, so its value is always zero at this
point.  Returning it is equivalent to returning 0, but it is misleading
because it looks like an error code is being propagated.

This branch handles the race with ext4_change_inode_journal_flag(), which
flushes the dirty data and drops the page cache before switching the inode
to the buffer_head path, so there is genuinely nothing to write back here.
Return 0 explicitly to make the intent clear.

Fixes: bdcbb0f19e92 ("ext4: partially enable iomap for the buffered I/O path of regular files")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202610160314.PLMEXaOJ-lkp@intel.com/
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1853fbdc2a5af..fb0fdfc43566b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4515,7 +4515,7 @@ static int ext4_iomap_writepages(struct address_space *mapping,
 	 */
 	if (!ext4_inode_buffered_iomap(inode)) {
 		ext4_writepages_up_read(sb, alloc_ctx);
-		return ret;
+		return 0;
 	}
 
 	trace_ext4_writepages(inode, wbc);
-- 
2.52.0

