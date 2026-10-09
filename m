Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E12370ADB
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 08:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536207; cv=none; b=DGoIiSp5gBL3XNmxgtM7LxU7Wt2HeWSno8v9OCVOesaqTa5368fSWxWMCiXhUGYa/3qCPfEkR+0LOtsFirCk1988OSPSLV7sj3aUNRJNmJVe1JtDhb4aEnrUC4uxf9E/FQ8RiRRX71wwYWizIHvkLQVlUD0+qpbsKYBB7tAMUcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536207; c=relaxed/simple;
	bh=Cy7gGHD/H/08X8aMbVUL8mxAmHRsS+dceL6vc3afE6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GionFzwB67pePOZvzR9dJp8/yA5Z4TPdUZV6jU71FQRNW2iOBixJi8nP1QJrET8b1ZAuEW8gt5JUWVIAdHlFYgp3vF8uRX/FxxmwJa65a9G5FLzSSYmi7dUFD8UdiDHmxOsdlZI3wVMOxpxMM/yJbVuBRhlOO0NkHTa2cWNbDpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=S2eGTPvs; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="S2eGTPvs"
Received: from trampoline.thunk.org (pool-173-48-119-87.bstnma.fios.verizon.net [173.48.119.87])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6998uVd1014136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 9 Oct 2026 04:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791536193; bh=V7wOOHwhyOCTY8wMYr4LGS/FRsnJOVxvNjuixw8M61Q=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=S2eGTPvs33ZTc24Y+ac9fwtpzHoWHvQePcD6Qp5b/QQL8gyUNKalEo7oY8+3HuOOB
	 ZJjKAnKNrzguA1SriJzmGEZh/MiW4JQQ9KKskr2jrK57J1A7dze95oiYhTQUL41m5S
	 opRfcz8rmThzFcoz13FEcYxMGy9Cp92IE0s9uJD3/14iaxtzOOjt9s8x5z8l+4c61C
	 hJ+7jA965QcLAANQ48tvETTJZWubly7xDrWIaReUi9jrxYowNTwG/7HSyw8IbC3gYv
	 07hrQ7oc7ktGY7tEOBbTxlZL7XUeVlmcldH5Ian/gUfVAQgu0s/9PK3PJPKG84rYk9
	 8gP7olqVyKoxg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4A7602E00B9; Fri, 09 Oct 2026 04:56:31 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: jack@suse.cz, jack@suse.com, Daejun Park <daejun7.park@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, junzheyu1@gmail.com
Subject: Re: [PATCH] jbd2: don't advance j_fc_off before the buffer is recorded
Date: Fri,  9 Oct 2026 04:56:16 -0400
Message-ID: <179153611726.860602.5064225109015872158.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3>
References: <20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 19 Aug 2026 15:09:39 +0900, Daejun Park wrote:
> jbd2_fc_get_buf() increments journal->j_fc_off before jbd2_journal_bmap()
> and __getblk() have had a chance to fail.  When either does, the slot
> j_fc_wbuf[fc_off] is never assigned, but j_fc_off already counts it.
> 
> ext4 then fails the fast commit and falls back, and the fallback path
> reaches jbd2_fc_release_bufs() via ext4_fc_commit ->
> jbd2_fc_end_commit_fallback -> __jbd2_fc_end_commit -> ext4_fc_cleanup.
> That walks down from j_fc_off - 1 and put_bh()es every slot until it
> sees NULL, so it also touches the slot that was never written.
> j_fc_wbuf comes from a plain kmalloc() and is never zeroed, so a slot
> used for the first time holds uninitialised heap data.
> 
> [...]

Applied, thanks!

[1/1] jbd2: don't advance j_fc_off before the buffer is recorded
      commit: 9f359c031885bb50add7d23c7a5a0e9755b134c9

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
