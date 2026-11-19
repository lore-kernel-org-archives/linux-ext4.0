Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099740;
	b=NFOuNiDBEA55XclAVSgOKF1Aof4QQlToEmJ8kxZfogD5dMl5Ie/WUfctudnz8L6MezEG
	 ysSgZLdBjffBvFUB4OtyGcftzbok9tPSAt7iaGrOMB2ynXa5OZCXAYkbG+CbSMfZrfQzP
	 NOqi7XW3WKk1JyK/cq6f1XljfhOaNDholpC58yBKvQQEq6cVRyHBhHEEOeOlPqfTVYPLO
	 oCvV5g2zev32997dQHZhXLEICDf2vFkdIToMqleX1xDYnnbrMHzjddv4WjVLogDUYq5sY
	 H9xzL10XYGJo93pSkvTUAI4AQqwsSz6Z74DXyS3Dt07M9jb9xD1NTc2f6xCAXhFVwYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099740;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=oMkuw+hMy2gSnPh64gOC7wDKQssPZ6Aa/q3hrCIrw7M=;
	b=fkCWpnHV49cZy7EtQa2zLBI13kXJdxK87KoBFDTwGF7RBFgnL+uZN5GUrePPO9LPHgzI
	 GRiRhxQTnELEZRR2IvfcI18psDkdAtqgPkWmMAORsv+VYhE8SWUCYKl7mJy7n7P3Adbjy
	 +0pnVDF6XjRv067GamXmuWnSGscm8D7FVnwaFDUEMLGmW4izRemiJWqNraIfvvm0RMAnj
	 tqRD992Q82JexxCvlqG4EQ3uZ3PNdaCEXo/y+vOALUatTy5MZbMFIjX0dC6xtmLGFs8Dy
	 sTsJdT7aUek8WBKdJowhQJwFaFO3AKiJaTdDOa1JMJBsEkzofGI/gLCuOfxi3YAgEjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=D967QIkC;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502BD606A330
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:49:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 502BD606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=D967QIkC
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElgdQ018239
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099664; bh=oMkuw+hMy2gSnPh64gOC7wDKQssPZ6Aa/q3hrCIrw7M=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=D967QIkCRCghWTXmupi5NHAA/EGFS/h9qRBBPqZE5W4DBv9v2bgN4s9Z6GF8IX1X2
	 He/sEAs48lQeHSAFFMhz5c0RimfGXraBzhGJBcRcrJ5hmb6tiFKJt4P1N+/K/9CZD9
	 NUyqOywaZw0JizAwZmk2QBbhOqlXV9hmEgjowLoYAw/8QfAg7A42YB8ngWw41nPU96
	 zagYvqkzuHCq1WOMHCFliKBGDvTezQTwQ/NsxXirpY368zWkC/z+iqdzEHdNUTusl+
	 EE3uuec/oZd8PalQFVDbbLPLaZqOE5wLVR07ovAx7smQI30/GXOdiF6xVLiLeBlwTK
	 t3th6gvjXn9Lg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 6CC412E0199; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Hsiu-Hsien Lee <swinds24@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: don't fail journal recovery on an incomplete fast commit
Date: Thu, 19 Nov 2026 09:47:22 -0500
Message-ID: <179509948697.1938961.17601249050249774915.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261007040829.2074386-1-swinds24@gmail.com>
References: <20261007040829.2074386-1-swinds24@gmail.com>
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


On Wed, 07 Oct 2026 12:08:29 +0800, Hsiu-Hsien Lee wrote:
> If the system crashes while the first fast commit after a full commit is
> being written, the fast commit area can hold the head of that fast
> commit without a valid tail.  ext4_fc_replay_scan() treats this as an
> error as long as no valid tail has been seen: an invalid tag length or
> an unknown tag returns -ECANCELED, a tail with a wrong tid or checksum
> returns -EFSBADCRC.  jbd2_journal_recover() then fails, the file system
> can be mounted neither read-write nor read-only, and the regular journal
> transactions committed before the fast commit are not replayed either:
> 
> [...]

Applied, thanks!

[1/1] ext4: don't fail journal recovery on an incomplete fast commit
      commit: fab1852d655a962cfc59782ad7efd9bf5691b95c

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
