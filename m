Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEFB3F7874
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 12:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781181653; cv=none; b=cdzTMhYPO+sFIfPKxB2QHuXABxJKPEClA8YXez3BUrCJ2JKCItdSHPAnwGKoIxcupxbPZlloqVNGr2C5JBnIB+M15AsUQVGPTRveFG9QgnPY1ogRPkSErQhkbnIacaLoDAzPd+1CG4Uszv1J9+GKvazezO/Kp8mT6ef2Qs6we4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781181653; c=relaxed/simple;
	bh=Q3yqYs5n4T78Xnt40cW0x0b2PeVyGinB9Tm+qnZ6ZIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A0+lg1vn8DHYhgohbWkAk0Zhmswgn+X0gqtsgYB3ID1dXjmvL+2GfXPkCKyWHwNhMjIhN3OLvEAT7TylWbAbr/e386rs1GIP7v5rymAvyi/eWnltpr9OyQqxW71ArRZFopL0XkBc14Ie0vjhHIdBQs6J9n5Ibr/S3KlQdosF+MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=O8TivWA8; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="O8TivWA8"
Received: from trampoline.thunk.org (pool-173-48-113-189.bstnma.fios.verizon.net [173.48.113.189])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 65BCZTOU008240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 08:35:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1781181336; bh=IkQOaxYTqMWsoCHCkMFQamLcChR6Ysmsw+2pFuzq+VI=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=O8TivWA86kOJTEy9+3IoUKOhxanB0c6FaFOYOt1444Q+91gad2ten2bh5lBwgEyDn
	 Q4zs8Irma+pZZIdYddg2cibIuUlKQjpQzEcBtq9MWFWu3tKsUEoUvRUjWvtS9OfI+S
	 uPy7LXz60JrlAE9BLvosFQVS4pF891Y0npxHszABwVNFU5nZP25QDOjq6cqPSOjxwK
	 ieGvgBRFDX2DIKaLRg2IdNCU7sffppwZNAJEC0pJ2RXseM2jgtDqx3I5XXuIqZn8kr
	 JRCMKfuN9OJfA8KujMAM42pwo7844ty4o9UlHmguy2f1VnJyxI903Bda313bjwlmuY
	 JJz9w5EnRUQbw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 14D212E00D3; Thu, 11 Jun 2026 08:35:29 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-fsdevel@vger.kernel.org,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Vlastimil Babka <vbabka@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] jbd2: Remove special jbd2 slabs
Date: Thu, 11 Jun 2026 08:35:20 -0400
Message-ID: <178118128403.522716.7095141956919354030.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260528171413.1088143-1-willy@infradead.org>
References: <20260528171413.1088143-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 28 May 2026 18:14:11 +0100, Matthew Wilcox (Oracle) wrote:
> When jbd2 was originally written, kmalloc() would not guarantee memory
> alignment for the requested objects.  Since commit 59bb47985c1d in 2019,
> kmalloc has guaranteed natural alignment for power-of-two allocations.
> We can now remove the jbd2 special slabs and just use kmalloc() directly.

Applied, thanks!

[1/1] jbd2: Remove special jbd2 slabs
      commit: bbe9015f23432bd4f5b8590eb178b3b5b7c29f02

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
