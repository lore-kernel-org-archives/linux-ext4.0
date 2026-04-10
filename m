Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9313DA5C7
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834356; cv=none; b=Zu1ibnLgi2/I9WZnSL+nWHlS4rdPEKLGpY3fVAiEuOCGLLtP/yoQ+YJJn8P0vgfwkx9NpNhGzgaRpX0iXadt55T29PYPOWnYbptfSHnc6z3/2ZCigdXirallZaj7VXccKR4I9s/UzW/UcnLa31DTmvcAE+/I+ccrZFkj3hGc44o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834356; c=relaxed/simple;
	bh=2FKYpzsdVhCQa1RSMNhjNFn8nSXHgmMQ4Y7xPVtpfxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cIlvhz2iSFqISkRfEIDoUSkB5iTcc9W5CBIU7y9m6eIYXU2JnSrz3Bfx0SwEeFORvQQjiEcusp86FWWNwY/hNfQGF6Iss61xb/q1WImERmpVjv58CJGXZAe22RZ7ct1kn7g8+2/1rALf2JPRndhX0AKs+lQxroMJIidanJzwg9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=estaqHUk; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="estaqHUk"
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFIo9J015829
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834333; bh=ALSl/fv8jDicKjoZxoOyt5olPy72N95UDRq8RlX6k00=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=estaqHUkslxpucSgKtPRLbMMI58oQkDa4uY6M6npp6JhaPbdlh7kgwu2/XumobtwR
	 vtz3B4sy45ze3yZESGZx10gzly6l22GrBPdQFbs/pB6SD2oCUMGzGd/N9PH0uAE48t
	 8sZWIwVsNbibjgpikWqzNHeVGHErDrbfyRQUBxLgfNJW6frcRbGEs9msPL2XMb7jMG
	 dReATirIgI+aaQ9oa4Cd0Kdm4pzd9+ITToLAnpewLwqMneE6YL0juPKlCCfla41lP0
	 RuWKAYriWo1SlxDLQguFgMxO7OLJCrN8/ugBoT0qvk9ixMsd6oldByIm6PtlQjxYkp
	 k/A6nVORCHJYQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 032F82E00DE; Fri, 10 Apr 2026 11:18:48 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>, Mark Fasheh <mark@fasheh.com>,
        linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev,
        Li Chen <me@linux.beauty>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] jbd2/ext4/ocfs2: lockless jinode dirty range
Date: Fri, 10 Apr 2026 11:18:37 -0400
Message-ID: <177583430859.2758959.1360360211440803917.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306085643.465275-1-me@linux.beauty>
References: <20260306085643.465275-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 06 Mar 2026 16:56:38 +0800, Li Chen wrote:
> This series makes the jbd2_inode dirty range tracking safe for lockless
> reads in jbd2 and filesystem callbacks used by ext4 and ocfs2.
> 
> Some paths access jinode fields without holding journal->j_list_lock
> (e.g. fast commit helpers and ordered truncate helpers). v1 used READ_ONCE()
> on i_dirty_start/end, but Matthew pointed out that loff_t can be torn on
> 32-bit platforms, and Jan suggested storing the dirty range in PAGE_SIZE
> units as pgoff_t.
> 
> [...]

Applied, thanks!

[1/4] jbd2: add jinode dirty range accessors
      commit: 5267f6ef49cb5fba426f2d286817b1355fde31da
[2/4] ext4: use jbd2 jinode dirty range accessor
      commit: 660d23669982202c99798658e2a15ccdd001f82b
[3/4] ocfs2: use jbd2 jinode dirty range accessor
      commit: be81084e032c2d74f51173e30f687ce13476cb73
[4/4] jbd2: store jinode dirty range in PAGE_SIZE units
      commit: 4edafa81a1d6020272d0c6eb68faeb810dd083c1

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
