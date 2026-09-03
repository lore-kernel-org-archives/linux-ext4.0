Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B84612417D1;
	Thu,  3 Sep 2026 02:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788401939; cv=none; b=XUSW6IWIC+FHfw7EVvxmpxlC3cSRcyf+Q3y4+QPnu5dNY8PEsGMME/y4+UhimLG6HuLUixj010i3acnHWEk9QW+/fKZfUj8q/n4x2hvtHS6fSAjoghKN7oWVL7IqpWW/yyyu0OZBDMXPeIlLfXiKEXFcOXoESP0FGYb6He3sT6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788401939; c=relaxed/simple;
	bh=eEOoUvUVndZuacKGAmUUg9p/ojZXQ0ExLjhIXV/pIps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FIh13BsIeYngvBTxqphDXdye2IjMe3tokqmccZ18sMe+bzIH+zraBpOtCggNkieiiQ7Wy+krq/XC864lkbSuxZkjVvaL+cEzfo5YpDHiRiJZoaJEPmWg8Da6lY/i8preR8BgHkIq4yp+BU6u22+z4dUDvzXCChVm6tBNYbAmvYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
Received: from zhaoxin.com (unknown [127.0.0.1])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hb3Dj2X3Fzb0tjx;
	Thu,  3 Sep 2026 10:18:45 +0800 (CST)
Received: from zhaoxin.com (unknown [10.28.208.166])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hb3Dh4svczb0tjx;
	Thu,  3 Sep 2026 10:18:44 +0800 (CST)
Received: from zjh-os.zhaoxin.com (zjh-os.zhaoxin.com [10.28.24.13])
	by zhaoxin.com (8.30) with ESMTP87fa4cd775cc3305984f7158c71e50db
	Thu, 03 Sep 2026 10:18:44 +0800
X-Eyou-Smtpauth: jonaszhou-oc@zhaoxin.com
X-Eyou-EnvelopeSender: jonaszhou-oc@zhaoxin.com
X-Eyou-From: JonasZhou <jonaszhou-oc@zhaoxin.com>
From: "=?UTF-8?B?Sm9uYXNaaG91LW9j?=" <jonaszhou-oc@zhaoxin.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-kernel@vger.kernel.org,
	jonaszhou@zhaoxin.com,
	louisqi@zhaoxin.com,
	jianhuizzzzz@gmail.com
Subject: [PATCH] ext4: isolate s_orphan_lock from read-mostly fields
Date: Thu,  3 Sep 2026 10:18:35 +0800
Message-ID: <20260903021836.962624-1-jonaszhou-oc@zhaoxin.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Eyou-Sender: <jonaszhou-oc@zhaoxin.com>

From: Jonas Zhou <jonaszhou@zhaoxin.com>

s_orphan_lock is modified by orphan-list operations, but currently shares
a cache line with s_journal and s_ext4_flags.  The latter fields are read
from common ext4 paths, so unrelated accesses can cause the line containing
the lock to bounce between CPUs.

On a two-socket Intel Xeon Silver 4208 system with 16 workers, throughput
improved by 4.6% for stress-ng.dnotify and 1.7% for stress-ng.unlink.  Perf
c2c showed that HITM events on the affected fields decreased from 3,699 to
3,125 (-15.5%) for stress-ng.dnotify and from 1,368 to 571 (-58.3%) for
stress-ng.unlink.  Remote HITM events decreased by 45.1% and 65.5%,
respectively.  The journal/flags line had no remote HITM events after the
change; the remaining remote HITM events were on the orphan-lock line.

Signed-off-by: Jonas Zhou <jonaszhou@zhaoxin.com>
---
 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 724a27e8be61..a3f16a981664 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1644,7 +1644,7 @@ struct ext4_sb_info {
 	/* Journaling */
 	struct journal_s *s_journal;
 	unsigned long s_ext4_flags;		/* Ext4 superblock flags */
-	struct mutex s_orphan_lock;	/* Protects on disk list changes */
+	struct mutex s_orphan_lock ____cacheline_aligned_in_smp;
 	struct list_head s_orphan;	/* List of orphaned inodes in on disk
 					   list */
 	struct ext4_orphan_info s_orphan_info;
-- 
2.25.1


