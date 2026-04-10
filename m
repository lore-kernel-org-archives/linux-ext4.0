Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5583DDDDF
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834343; cv=none; b=T9UVuZKbwLptrJD9RYZXqY0aYEUfLZgOFg/xZRjG/uD/8FPgrsffrYJj31JSO5FNVx1IPzb6pSVJFCJ68zmIdrSSYKBDap8R4BaDBVoqFZyNxKS42frszKFRCq6EbpQ7InKOK95TUdzWiPayrO2hURCFs2R+isdcmqQZfG4WzVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834343; c=relaxed/simple;
	bh=xnjHLMcfgpDVx/kdMup4TPS0YUUNepuNMtlV9r+6zJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CPz+KDa1mbQwyOI5rhk1qfKD9iUH1JL7lXzkdBM55MTbdKhLN4XoTYAtykXKX9yRmnAM1XsOYV/0Tf5r4IbrxubRT8/XSffO+1txpGPp3VbHI/lRmh5g6QTC58+WY8RoMpnzybGvhquiOV22AUQn2BfkNy5anwKWwGrJeqotgzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=O6WAbJWD; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="O6WAbJWD"
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFIoAd015841
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834331; bh=W99+w/CQJUD6o9AyfEzrfWUD9WDm0z6vtxJ6n9HXAYA=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=O6WAbJWDTjTsu9WxYTUHUUO075cDsoeFQQs9p9ZTjUX9yQy1MTOUUOzX/F7gZQFTx
	 RNSZAwAe5KKRULAB5dbmBB3+yvWtB2aSC5BvolWqrxns8PU+EU+2Swh85DKdgeAMh9
	 XLPZ4WCaaxdthq8w6vLiM4t9s6taxhyuvbLjHbUuAHsxMwG955cZ2vkJt55yiH2rbY
	 nevzMq5HkdeJs84joFIRSqQopa6avjcR4CR5M6tHnXVADnOjhv+Rdp3LoMcL/YhKap
	 0TYIOEj9mKICVAnRaV8adGhbKuGWfJ7fCB8byYBkZfNinVZ/f5AKS6tpxebfDz8vFV
	 l63oavy4Z+hBg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 08CEF2E00E0; Fri, 10 Apr 2026 11:18:48 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: jack@suse.cz, Milos Nikic <nikic.milos@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/2] jbd2: audit and convert legacy J_ASSERT usage
Date: Fri, 10 Apr 2026 11:18:39 -0400
Message-ID: <177583430857.2758959.2629586609147783650.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260304172016.23525-1-nikic.milos@gmail.com>
References: <20260304172016.23525-1-nikic.milos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 04 Mar 2026 09:20:14 -0800, Milos Nikic wrote:
> This patch series follows up on the previous discussion regarding
> converting hard J_ASSERT panics into graceful journal aborts.
> 
> In v1, we addressed a specific panic on unlock. Per Jan's suggestion,
> I have audited fs/jbd2/transaction.c for other low-hanging fruit
> where state machine invariants are enforced by J_ASSERT inside
> functions that natively support error returns.
> 
> [...]

Applied, thanks!

[1/2] jbd2: gracefully abort instead of panicking on unlocked buffer
      commit: 64924362f833fd15d75d2b8fc771eff9646c0933
[2/2] jbd2: gracefully abort on transaction state corruptions
      commit: f7fc28b014ebb00796f99f12f0583caab23276e3

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
