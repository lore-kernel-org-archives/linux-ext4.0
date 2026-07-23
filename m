Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D409F3C9EE5
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812151; cv=none; b=Ye0TU7Ttz7LIWJZFeefYm9Pi2W5RBFRx3cn8E1K4GQRHJRVO5sCaSRgfCHWiJqqPkv/JbT+UBHv61A8T9HtgWYj5zKgE/uji00hnbwcCaCulDNQFVcXive3Fu+7AA9QiAK+Is+ExP8GEhwHikO+KZH7BVog3x+kvtHZlWNo7zHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812151; c=relaxed/simple;
	bh=uP7q1FuchmLSRZWa9SvbhnByjfDdtnHSJB0bDaT59IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pfks9wDwcGU7Hi+CTUNS5xM9VnIDBggC4ASXPDFg8lDYBMmJAg9eDyME5Pvp0fHSRZFtnBsxz9eSVvc5bv7bGVODaI7H14n4vEesnhn6hM2aEeE0rn1Tc3Z1oHrSUZTLN88o6PyU09+TgBaxqjM9X9hAQUT+Y2Df5W0dEhqZcRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=QreKFbdQ; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="QreKFbdQ"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND93j3017929
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812144; bh=lFjgDWICe1upf1wyNiAcvVpdaROvC2nVGVtJyojpF0c=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=QreKFbdQ5/yqwu2hZlPHj7x5OlUSYX9ZhXbtDpdYYrIw5tqJus9SF7scQ/99GOvKs
	 Us9Y2oKO7DUPFkrwhJ1hgtuWbMccMrqH/nbWusXKjXNh/g7bKhrf5e3+GgugaBW/ko
	 a/hsnfKDf89xiOwAuXgcc4ZgTqzXTduPuSgxcsBab89QzTCoX0QatzgmyU41JzB1zB
	 vbibLUCNK8ssMb7SmQyWijuChf85NEoFpfcpD4eUV8+4Yw12+sBmmL7i1VEEdyQgIs
	 InlOc6eqbisrvyHj44oARxgAwRZVNIrGKxBipNmYcHKMwmZtbJeSTFFDY3xCwEpiBo
	 ZecAIekChEckQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id C8CB02E3F1E; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: jack@suse.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Kellermann <max.kellermann@ionos.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 0/2] jbd2: bound j_list_lock hold time in the checkpoint shrinker
Date: Thu, 23 Jul 2026 09:08:46 -0400
Message-ID: <178481171751.796182.9505970402806048472.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260713102229.1598812-1-max.kellermann@ionos.com>
References: <20260713102229.1598812-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 13 Jul 2026 12:22:27 +0200, Max Kellermann wrote:
> We hit recurring RCU stalls / soft lockups on a busy ext4 filesystem
> that serves as the CacheFiles backing store for a Ceph (fscache)
> client.  The stall is always the journal commit thread spinning on
> journal->j_list_lock:
> 
>   rcu: INFO: rcu_sched self-detected stall on CPU
>   rcu:   106-....: (2099 ticks this GP) ... (t=2100 jiffies)
>   CPU: 106 Comm: jbd2/nvme1n1p1-
>   RIP: 0010:queued_spin_lock_slowpath+0x20a/0x240
>   Call Trace:
>    jbd2_journal_write_metadata_buffer+0x1c0/0x310
>    jbd2_journal_commit_transaction+0x5e2/0x16e0
>    kjournald2+0xa1/0x220
>    kthread+0xe4/0x1d0
> 
> [...]

Applied, thanks!

[1/2] jbd2: check need_resched() when skipping busy checkpoint buffers
      commit: f213e12ff5c9590b1034ae8da0e6d09665c772d0
[2/2] jbd2: bound shrinker scans by examined checkpoint buffers
      commit: 15cb16496446b94e67f7abcb049b8e2c75cd3d02

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
