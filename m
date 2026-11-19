Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099704;
	b=nABAxoAmVZ5El5y2Cfv9wt6299iKH9u4PHrwury0TRzca7p1aITgvqOXqUQuZr6Jjdor
	 Z63DQOen52XnKmx9DABEbntjijXafPo/HZmjBnJqAoT3LGVpDgAqjYGQJ+KjrNyrwGJd4
	 w2RjS2CLeSYmJm8mbzwzfM5WHVz421MlcaROAgVi4rIdOfmb1GAoXmSie8Ujd/WpXvvkS
	 IlpR0EbogV+0MvzdGgkgeCTrpbQjbQoKT18dL1638pgW14OwVHYkO27IsdBtgdc6jBe15
	 /m+C9RiuqwLrOZWn+TdNDN9Dr7ohXMiKZLIf8gDWwbh294pKd43NlHxfBe4rMFn1yvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099704;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=4tnq2Hdh7E3VeaKv+fKdOHyprapKSgAhpLdWJ55xp0o=;
	b=m50JTYzq/Le1anrUIpVKZUD+Jn69wNYjT6+2JeNzOai2AMmr8nbXKoLtHWnAZpxtnZcA
	 Sa5b2jQ6psQZrJ2V3kr/F8AArQ3uphruWtFnOAv58j+/ihjkKamBMPXz+0TTWuzNlYjHJ
	 8dZLmhjlPaFwsk5J0In8mKa8Gm1r/thYKIThylObdwyoQKLpn6hhKZUyq8xXUTxn4C/iX
	 oQa7Sb+zdNjYtS5QTBSbpSmMYdW4zELPA1iIs8fp+DL+IY701UmmqL2HDJM+y/oRclRiG
	 HKhxH0/Oj4tzWIrFTzPK3meHvpioExoe/1SKNO1RiEJWz+wBKQgURhMwWS7hK0UQayw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=bLKdetIX;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB4A606F4FB
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEB4A606F4FB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=bLKdetIX
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElcqZ017940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099661; bh=4tnq2Hdh7E3VeaKv+fKdOHyprapKSgAhpLdWJ55xp0o=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=bLKdetIXX9itNfU9RiNaDjOEc13IdFSpIYQWKjm52f8iz3mlP1oRMiYbziz24twrI
	 De3Z38fu8+UQWDhUCaRBROL80IzyJ9OmL9Njhddn2GZ2/htwPYfKm7JVdnQCNZ4lgN
	 bVhcQ8F3rMY2DZhXf6+NyWS2JcQGAgAFV+cKxRWF3MtAzva1ckW13L8NaKZXOPXisI
	 WV4J7sRalpq3rUQB06ArKeApZVvMZ1iGE9jlpKwPnB/BtdsIOFRyT9cBmDUcNUrOr8
	 4kI2tbd7C6YF8hzA0+VQrMIRSJVT7nkA9VOQE7wfwHnNSu4qbSCi6BSD0jojyjAqi+
	 xjvO+vzPSD2hw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id E48852E0155; Thu, 19 Nov 2026 09:47:32 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.com>, Jan Kara <jack@suse.cz>,
        Daejun Park <daejun7.park@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Li Chen <me@linux.beauty>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] jbd2: don't start a fast commit while the journal is marked empty
Date: Thu, 19 Nov 2026 09:46:46 -0500
Message-ID: <179509948695.1938961.4716581614065222142.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261007-jbd2-fc-after-flush-v1-1-548bd91cd959@samsung.com>
References: <20261007-jbd2-fc-after-flush-v1-1-548bd91cd959@samsung.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 07 Oct 2026 09:41:09 +0900, Daejun Park wrote:
> jbd2_journal_flush() checkpoints everything, and
> jbd2_mark_journal_empty() then writes the journal superblock with
> s_start == 0 and the fast commit feature cleared. It sets JBD2_FLUSHED
> so that the next commit writes the log tail and the feature back, but
> only jbd2_journal_commit_transaction() looks at that flag. A fast commit
> started before the next full commit writes its blocks while the
> superblock on disk still says the log is empty: jbd2_journal_recover()
> returns at once and the fast commit is never replayed.
> 
> [...]

Applied, thanks!

[1/1] jbd2: don't start a fast commit while the journal is marked empty
      commit: 18d8d4b5d1b5fbbe6da96610e5c1d4853c46d441

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
