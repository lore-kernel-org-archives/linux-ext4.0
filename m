Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8EC58596D;
	Tue,  8 Sep 2026 16:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788885842; cv=none; b=WLz1qpf8Xk3fqN8Yqn2eMFeauvp8/DcsDecVe21zlGm6UVA/uuIMZ0R5dhutpJXckL2t3xpA9wnAd0OsS+9lbcl0hDcaLhCnsdZxk2+tAfQDbX3D8D/AVoGa6g+75xzl4mCLj7e0CoiHVp2Z5773Nyi3ni/Lyb+WswibqCEBaBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788885842; c=relaxed/simple;
	bh=wZIS+3LnkdzIwR8qansRVIBIcP5UIkC5CC2tp1hF1W4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xc8eAjTUuvL9i+DQ1pCrsxSRvcwo52gqfYN301Fy3U+Eb7mMjHDXr8WhMqwZXaGBL1WNsNvFBJ15wKTghR4vB8PKMZUYQUPukQt8g68MCL8o4cl76YRWMzdzbY1gXa682wJ44QwSw/8HKySI8SffpVyO8wSDOkRvCxmSNALzrC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=MCvcy749; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="MCvcy749"
Received: from PC-202605011814.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4d003ec4e;
	Wed, 9 Sep 2026 00:43:46 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH] ext4: shut down error report timer on failed mount
Date: Wed,  9 Sep 2026 00:43:15 +0800
Message-Id: <20260908164315.691073-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260904065648.4048108-1-runyu.xiao@seu.edu.cn>
References: <20260904065648.4048108-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa081e77a3a03a1kunm4d950e5d126ace
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDHUIeVk1DHx4fGktCQk9MH1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pOTE5VSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=MCvcy749D3RFejXCbALldDyQfnWE/T/sEWGxDqaMCnGF0LvjRWrfXc1QGUpe72Z+P9X3rLt5Bq4U63Y2PJP+kwlmWHe7i3uuR6MyrB09Dq1N/mwbvdG2wxa9Jtgjb5MFqDfBkTl2YayfHljV+7xhZw30C9AgEOistjLQ+R7Gqck=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=wZIS+3LnkdzIwR8qansRVIBIcP5UIkC5CC2tp1hF1W4=;
	h=date:mime-version:subject:message-id:from;

Hi Ritesh,

Thanks for reviewing this.

On your review, you wrote:
> Did you hit any issue here? Sure timer_shutdown_sync() is safer variant
> against a mod_timer() call by someone later, but I don't see what is the
> issue here (maybe I am missing something).
>
> I don't see why timer_delete_sync() on a failed unmount is not safe?
> ... Do you have any example call stack where we can hit this issue?
>
> OTOH, I think we might have a problem in function err_report_sec_store()
> though.
> ...
> I guess that problem could be due to commit d518215c2719 ...
> Seems like multiple issues in there. Care to look at that path too?

I rechecked the failed-mount path and could not find an independent rearm
path after timer_delete_sync() returns. The timer callback may rearm the
timer while it is running, but timer_delete_sync() waits for the callback to
finish and removes the timer rearmed by that callback before returning. The
failed-mount path also flushes s_sb_upd_work before deleting the timer, and
the ext4 sysfs attributes are registered only after the mount initialization
has completed successfully.

I did not hit a runtime failure here, and I cannot provide a reachable call
stack demonstrating the proposed race. I agree that the original patch does
not have sufficient evidence of a failed-mount timer race. Please consider
the v1 patch withdrawn; I will not send a v2.

I will investigate the err_report_sec_store() state update and the
ext4_update_super() condition separately, using d518215c2719 as the Fixes
commit if the history confirms that attribution.

Thanks for pointing this out.

Regards,
Runyu
