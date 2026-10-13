Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BB6414434;
	Tue, 13 Oct 2026 01:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791855667; cv=none; b=VRiLuiVH8fN8kTfQfQA3+R5ao1AWUO6D4cs9KOISyC5sTcisunBTIIQ+Etpid0vVVjZhT2F3g2weTmo1lbNvaLUc+0s3VhXUO7Wnq16zaTTQBS1rQd2EIW9B08woOWimHsRBHRP7BRw1Iufe3jyLOpiDGi3/vhkPJe8kFzRv63w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791855667; c=relaxed/simple;
	bh=4RHc8AoMeI2EBVTbSwjiwqLin4bvilt4wAqGoAXkcl0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gYGBdKrzw5sEjYn/f4x3QPCrP4Da5cs9GcsSOfqfSorZcmfpAsK0PHo6WjG4rw1cApco2IeselXjvXv3QOkWqghS46/uHyWRFD+pbsZyuBZJMxJA6QEgdhcoQ4/S8tgLmTgMZ+NWRa09gwylLxsRyEuPPoGNlxvKCaALhD+EY0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=r+L92GD6; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="r+L92GD6"
Received: from localhost (gy-adaptive-ssl-proxy-4-entmail-virt151.gy.ntes [IPV6:240e:471:430:37de:7ca5:8deb:704c:6197])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50cb20ab1;
	Tue, 13 Oct 2026 09:40:55 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>
Subject: [PATCH v2 0/3] jbd2: check return value of blkdev_issue_flush()
Date: Tue, 13 Oct 2026 01:40:25 +0000
Message-Id: <20261013014028.1152277-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa132eb7b7a03a2kunmfffc7bd849bad7
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDTx0YVk1MQktKTBlIHkhMSVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0seQU9MSkFPSEtBSEwfHkFMGBpOQUMfHhlBTEtPGEFNSk
	JMWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ01CVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=r+L92GD67xvK1xQsGTsZnZX9k5GLK8yat8w6bpcvJirs9qQyeJV6sFAogY/n+1yj9tw98SDj9CsYoirgHBRtHaGmnvmXQl8SAEjevhX3DBUqtNZYLO9X5LiQRqJi3Vttd424V+LjiiBtRMkAImKiFKcC13C+9Q5iw0fYxTJ1+tU=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=qAXSoJZ47erUStmk5wRaH16aZCVBlptfkUGszcq20Jg=;
	h=date:mime-version:subject:message-id:from;

Check the return value of blkdev_issue_flush() in three JBD2 paths
where it was ignored, and abort the journal on failure. This prevents
journal tail updates or successful transaction completion from
proceeding without the required cache flush succeeding.

Changes since v1:
- 1/3: collected Reviewed-by from Jan Kara.
- 2/3: reuse the existing err variable instead of declaring a new
  one that shadows it, per review from Jan Kara.
- 3/3: use flush_err to avoid shadowing err, preserve any earlier
  commit-record error, and reuse the existing abort handling,
  as suggested by Jan Kara.

guolingxing (3):
  jbd2: check return value of blkdev_issue_flush() when checkpointing
  jbd2: check return value of blkdev_issue_flush() when committing
  jbd2: check return value of blkdev_issue_flush() for async commits

 fs/jbd2/checkpoint.c | 10 ++++++++--
 fs/jbd2/commit.c     | 13 ++++++++++---
 2 files changed, 18 insertions(+), 5 deletions(-)

-- 
2.34.1

