Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B593A370ADB
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 08:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536203; cv=none; b=s+qKP71khTV5OdcL7hjiVZCUDQDLaAYgzkxdTecbEVtidzpQb6dS6sYAnVYhFVI/NrjmDZtxHLLYLNonlKTkxN8H2Bi9vIILPcfgTMN0W7Ewf2I1zkA27UqOzXtHNE13UMv9ATLk4wvrDvAsYQpAE64aB9OhCUmRslNxYA7v0VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536203; c=relaxed/simple;
	bh=eBvDkdxMdHtvNtZ9slRT16ZqOjnFraq6yNEwxbXJC/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TbdS6r6IF0cxadmmaIS3dOMztAHWhBFSMGYDeET3V7u0Wco4/7/XUdzZd0r2cT3865bb2XGhZl13KrARafmYHKmy+CqNWrl9D93d0ErSEtdK1A7lM0fqEByEMT7/rWk1MXnUlZCiSY7CHOOC8aYDeKExX19bDoqPcD0c+ErLx+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=NguWjxuB; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="NguWjxuB"
Received: from trampoline.thunk.org (pool-173-48-119-87.bstnma.fios.verizon.net [173.48.119.87])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6998uXRc014183
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 9 Oct 2026 04:56:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791536196; bh=nrZE4Hh5kui1Tt7uuyinZgrtOab8QOFpFfgZl29YvkE=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=NguWjxuB08FHYedtK98+CY8I0lMK1OT4BsNmVSmz9r74WPzL4MAA7TTPpK6mRbcbT
	 zh+d3ZRbzOiHuoqeGru4pcGO2E6kyoascKLtyyg3aMZw/DNPMkvB6D8cgqZN4dU996
	 hBQhxMFGHs3d20JDBELqHrJPb2YLEAccA7eO+BA/9LTAvI8SIxVsaDHttDSZCqic+V
	 LNYkTBEToe2yiidH7iRsgb9YppxYQnTHJQ2MTtwxEUTjLY4/8nNYnd/WV1wZCz0KPt
	 MqyQEF6YIB5t/lq+bpsARc9JtrcXBaBh4bGz9vKBA9+R30TBB17II5/ZSiH3Xb4GsL
	 e2FXFvh2DDB3Q==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 5AD6A2E0146; Fri, 09 Oct 2026 04:56:31 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: jack@suse.com, JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, jianhuizzzzz@gmail.com
Subject: Re: [PATCH] jbd2: avoid false sharing with j_state_lock
Date: Fri,  9 Oct 2026 04:56:21 -0400
Message-ID: <179153611739.860602.9394723567844076744.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902070331.820322-1-jonaszhou-oc@zhaoxin.com>
References: <20260902070331.820322-1-jonaszhou-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 02 Sep 2026 15:03:31 +0800, JonasZhou-oc wrote:
> is_journal_aborted() reads journal->j_flags from ext4 and JBD2 hot
> paths. At the same time, transaction start and stop paths repeatedly
> acquire and release j_state_lock. read_lock() and read_unlock() update
> the lock word, so this traffic invalidates the cache line containing
> j_flags.
> 
> On the tested x86-64 build, j_flags, j_errno, and j_state_lock occupy
> the same 64-byte cache line. j_flags starts at offset 0, j_errno at
> offset 8, and j_state_lock at offset 56.
> 
> [...]

Applied, thanks!

[1/1] jbd2: avoid false sharing with j_state_lock
      commit: b5501f970dbc039df1f7c720b7a481b62de125cd

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
