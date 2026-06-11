Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516D226ACC;
	Thu, 11 Jun 2026 00:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781138735; cv=none; b=PxIbf0VEB5xjn5YUV/EZaP+oXwO6ZQOjwMSMMrleELqPNRK6vaRdRcyaj8aRnZqWvJTPqzdl3pkarA4TgNLnYoTC+DHQFqzpk7GK5jOvPZ02s2pfEpyRFwypqh3N09Q2PjgNOoN991fzSnDf/lqWe0EQdMxibtuug8IcB77pn4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781138735; c=relaxed/simple;
	bh=hwXwjiQT15eBwFE5mDnQ6aoYNv6u8J6wc6EtSAC5lAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyAChZeBmb8V2JxMgPzUk4PQ98LAq3CFfP+j2i+YmPIZUxuXeWpPZFGEPuc3REyTauLRYyNPW8G7V8XMNXtDB/HI1CXtVfK2ibQ+T68UMHHUqj/05n0CyggJL1KW6zkTcsDchGzeIXMZNCywiR0/Gy+V/ghFB/4F25rLbMcP0II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QS07DJNY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QS07DJNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468DE1F00899;
	Thu, 11 Jun 2026 00:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781138734;
	bh=hwXwjiQT15eBwFE5mDnQ6aoYNv6u8J6wc6EtSAC5lAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QS07DJNYJu5hqeh/Zb0LIPX5iRjohZUadtsQN5+NwZ6qIIBbl713/iKM9A0qxx4m2
	 8BWG0LARy2eVt4Ne43Xw0de5RkpVtQqOUd7apbR2K6KAB71ZqzQilWo3blj55GdDh3
	 3cQ8Nv+mK8ZcucqYHXMClnG8ypys/TVd4QIflIwIj68KsAzPm0+FLDmklPOi2vmMFW
	 ekjKY7Q+/c2Chl3LZWx/gnoM+hRnYC6Uxe7qB962w9aPPhICCWmuxV/Jir+bCuQ+lQ
	 cSWJWNbI7yzPVdVgTCWU1haP13CTJ6xphqtG98fTg1yMyQ5KieaoG6rLAgDJ6czGDn
	 AQgXQTEMZ6+nA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Alexey Panov <apanov@astralinux.ru>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	lvc-project@linuxtesting.org,
	syzbot+04c4e65cab786a2e5b7e@syzkaller.appspotmail.com,
	Tejas Bharambe <tejas.bharambe@outlook.com>,
	stable@kernel.org
Subject: Re: [PATCH 5.10/5.15] ext4: validate p_idx bounds in ext4_ext_correct_indexes
Date: Wed, 10 Jun 2026 20:45:19 -0400
Message-ID: <20260610-stable-reply-0003@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260609164430.29988-1-apanov@astralinux.ru>
References: <20260609164430.29988-1-apanov@astralinux.ru>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Jun 09, 2026 at 07:44:30PM +0300, Alexey Panov wrote:
> [PATCH 5.10/5.15] ext4: validate p_idx bounds in ext4_ext_correct_indexes

Queued for 5.15 and 5.10, thanks.

--
Thanks,
Sasha
