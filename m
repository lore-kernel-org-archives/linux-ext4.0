Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2306A1F7569;
	Wed, 22 Apr 2026 01:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776822758; cv=none; b=ZIYEEyCmOT7sratqcLjt+ko+WFpRSOzBqNANfZCeIoRow4Qgwgqwe5YA7hoSu8VL1b/Vh1CBfhn4YJ6ytOBCDa2vy/FEQwffbqBJnrJsRBX27xcjqwNt2vAT97OCvZ2l2c3+oieDZcK3MjGfyxpgJr4euJmgTO2kv0fYKjAPX5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776822758; c=relaxed/simple;
	bh=ftU0pkjzD92uR0tcaubK3MTDTY2QqG2rjunbDUkhfzk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p9flt4c4uA5O1S2xPW2HDnLOgM/gAHW1nOUYk9l/pda8uc/jbUhKz4sI6xAqQwKTyl0AdWlLn6ZHMrslCHpGhDNBR3ry6Rj/IHLklQNjz65UlSk4yP4K/X0iJZSKbIhGlNDTQ2wpGqsXdE1OHf7gCqwclqBy+JlKQECUhY3TTtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=n92B+gcd; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="n92B+gcd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=uZ
	OQvsAhtMHbN0G81xfphgVgEyBZSWryzko4yQvKaC0=; b=n92B+gcdgatNL7ROyO
	XoLrVzs6JeV2OmVtb4FIkJZqk+4iLlxtYDaDKAx6GRcpTLVQWFiSSIWSro1QJhc1
	E0pjeFVR67CiVMg3fIB03bwA6U77HHPZGI3AgsIrBJ3L7BlZfrZwrO8eqoeo7DO7
	48wnZV0YMMxODP8Mal9g0eZTQ=
Received: from liubaolin-VMware-Virtual-Platform.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wA3Hx+uKehpOCzjAw--.387S2;
	Wed, 22 Apr 2026 09:51:44 +0800 (CST)
From: Baolin Liu <liubaolin12138@163.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wangguanyu@vivo.com,
	liubaolin12138@163.com
Subject: [PATCH v3 v3 0/2] add blocks_allocated to mb_stats and clear mb_stats
Date: Wed, 22 Apr 2026 09:50:23 +0800
Message-ID: <20260422015026.7170-1-liubaolin12138@163.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3Hx+uKehpOCzjAw--.387S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GryxJF4rWrWrAFyrWw4xtFb_yoWxCwc_X3
	40qryrAry3JF1UCFy8Jan5JryjkFWrJF1UCFn8Jr4fZa45JrWDAa4DGrnxAF1xur4akrn8
	CF9rW348Arn2qjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRNv31JUUUUU==
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6hEL1WnoKbGUgQAA3p

The series contains two patches:
 - add blocks_allocated to /proc/fs/ext4/<dev>/mb_stats
 - allow writing 0 to /proc/fs/ext4/<dev>/mb_stats to clear the current
   mballoc statistics

Changes since v2: 
 - Add mb_stats documentation to patch 2
 - Add Reviewed-by tags

Baolin Liu (2):
  ext4: add blocks_allocated to mb_stats output
  ext4: allow clearing mballoc stats through mb_stats

 Documentation/admin-guide/ext4.rst |  5 ++++
 Documentation/filesystems/proc.rst |  3 +++
 fs/ext4/ext4.h                     |  1 +
 fs/ext4/mballoc.c                  | 31 +++++++++++++++++++++++
 fs/ext4/sysfs.c                    | 40 ++++++++++++++++++++++++++++--
 5 files changed, 78 insertions(+), 2 deletions(-)

-- 
2.51.0

