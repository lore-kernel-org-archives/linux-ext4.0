Received: from embla.dev.snart.me (embla.dev.snart.me [54.252.183.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BC639098C
	for <linux-ext4@vger.kernel.org>; Tue,  3 Mar 2026 11:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.252.183.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772539016; cv=none; b=uv4r/1Wy5G+9nh/9LoWxTEnDaWF14MSVJY4HHwP0qwhfcOul56OgEzdTnyRY3KSjwI9+V/O17Lao+dGn7I7bX8wenM8zgBtz1eCE9owcdyWwQnhvU+RRvY1SqPvgjMABMk6U7NB171N+hAFM0E8OGSJcvX3vSxzEThwDTL79fEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772539016; c=relaxed/simple;
	bh=7OdGOjjK+EcRmoSIMjFZY0SJ97jrlO5mjEQhVek+PD0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IGV5uLWrADqd4Q64367s4NFbwFNYp9cl7cN7fHN5VzlIKoLGKNpOxohUgkDU7Km2ouSoKyllOeLDXabu0s/wwDuzNq7/b81cRFVieOc9nrh8fyMY0YB5PU+YUAYHzA8+BfkX57njiG2liAKgIprAmAWNqJJCs/RYdMPagZNo+ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.snart.me; spf=pass smtp.mailfrom=dev.snart.me; dkim=pass (1024-bit key) header.d=dev.snart.me header.i=@dev.snart.me header.b=dfyrvWP9; arc=none smtp.client-ip=54.252.183.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.snart.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.snart.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=dev.snart.me header.i=@dev.snart.me header.b="dfyrvWP9"
Received: from embla.dev.snart.me (localhost [IPv6:::1])
	by embla.dev.snart.me (Postfix) with ESMTP id CD9CF1D490;
	Tue,  3 Mar 2026 11:56:47 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 embla.dev.snart.me CD9CF1D490
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dev.snart.me; s=00;
	t=1772539008; bh=7OdGOjjK+EcRmoSIMjFZY0SJ97jrlO5mjEQhVek+PD0=;
	h=From:To:Cc:Subject:Date:From;
	b=dfyrvWP9gDZ0UD5AmRJqEjgEL+lzQWZjNjlyJsqWgwDlOYuV2eEPNAI/ssHv78Ryv
	 OYItxmTx705Z6fZ0chsA6PDLIc0xdzc3M6vLiYPktg9rgncrONL0WPYzsX7+AZFcD4
	 m5+CIAqaUL9TCy1cj7gs/KjHugwX9V00+6QMEb7U=
Received: from maya.d.snart.me ([182.226.25.243])
	by embla.dev.snart.me with ESMTPSA
	id 41s7IH/MpmkwQgEA8KYfjw
	(envelope-from <dxdt@dev.snart.me>); Tue, 03 Mar 2026 11:56:47 +0000
From: David Timber <dxdt@dev.snart.me>
To: linux-ext4@vger.kernel.org
Cc: David Timber <dxdt@dev.snart.me>
Subject: [PATCH 0/1] filefrag: fix fibmap error message
Date: Tue,  3 Mar 2026 20:55:37 +0900
Message-ID: <20260303115637.453629-1-dxdt@dev.snart.me>
X-Mailer: git-send-email 2.53.0.1.ga224b40d3f.dirty
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's a silly mistake in misc/filefrag.c. It's a single character
change.

get_block() of various fs can return any errno at all. FUSE is
especially wild west out there and the fact that POSIX allowing NULL
and Musl simply refusing to snprintf() doesn't really help either...

David Timber (1):
  filefrag: fix fibmap error message

 misc/filefrag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.53.0.1.ga224b40d3f.dirty

