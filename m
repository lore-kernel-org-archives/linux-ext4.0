Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14264E534A
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 15:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791473487; cv=none; b=Hn30b09ZHp9zulBqUVhh6dcpaX0/eIYKrIKt7LaYEXoMLJ4v6gqmlFbqK9Zt3Ef3mRecgLq7B9IvlL38CrrpovALwjGDTKxwadXNmP3Wws+bCX4sTxYLFiraLwHMsAh/rJxGZqKhsG6/0wMkDCixrNWTiC4k7W7SC8mfgv+c0gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791473487; c=relaxed/simple;
	bh=oDaSEX/pIqfKV5uj9IYzUN7B+7DRkmqbgpoK8ZZOe58=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YzO+V25zlDEZrGijB/yFsRrYAGrZbqvYKNsqzN5a06dLcJg9Zo0Q81UvIf8OKTC9UPhoxvBeIbO/ZVN2taIMmhMlshrzFxHzDHxMyUTyX14vMO6mfQNGA5KqOFQyTN8HySGMcnWH8Mt/sNYmwjfp2JV2zdoTqQyQqFiQFbK2T4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=G7kxtx87; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="G7kxtx87"
Received: from trampoline.thunk.org (pool-173-48-119-87.bstnma.fios.verizon.net [173.48.119.87])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 698FVE7Y005074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 8 Oct 2026 11:31:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791473476; bh=TDgPycyAuELHd+uKktXGNGhoNcYyqXzCo38wWDsNrqI=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=G7kxtx87eBv2P/4KJtGCNlRiD07Vg+fwAta92mhwDxuJvlr2PBgPSUaHkghiGd5t3
	 he57cYefmoEHnOVJCBxZJop/7oxpIbKYUfxSEZpmo1EKXSAh2r11byPIiEvbZoucbk
	 Vy+P6AAjFKn+I5dW6zwZLZpDToCf2Iulo0ifr8aj7MeR7vQQqWuDD++ZsAaKIhA39G
	 wn2dDYCYg0N1H2xf6JmahWU/2evltGhSQdhNYwoBEL+hAEQrgKD/zpDTy3aJqSdxig
	 OJShO6RjiKdUtmlsaWnyEnDmZt40H3IUZRYwaPSyvegnFKk1en/OmKwjVZo/nFqeZl
	 P1TjdThPZm2EQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 24C672E00B9; Thu, 08 Oct 2026 11:31:14 -0400 (EDT)
Date: Thu, 8 Oct 2026 11:31:14 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: [GIT PULL] last minute changes for ext4
Message-ID: <ase1cbY1IuELJ7jQ@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 93f51579e7df248780214094418f205253383cc5:

  Linux 7.3-rc4 (2026-09-20 13:48:15 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.3-rc7

for you to fetch changes up to 3e78d7b063230d39ffc42e80ee665b6c32a6adeb:

  ext4: mark data=journal as deprecated and will be removed in January 2028. (2026-10-08 11:21:30 -0400)

----------------------------------------------------------------
Mark the ext4 data=journal feature as being deprecated and will be
removed in 2028.

Also designate the primary branch that Sashiko and other tools use to
find the primary development branch in the ext4 tree.

----------------------------------------------------------------
Matthias Goergens (1):
      MAINTAINERS: name the ext4 dev branch

Theodore Ts'o (1):
      ext4: mark data=journal as deprecated and will be removed in January 2028.

 Documentation/admin-guide/ext4.rst | 6 ++++--
 MAINTAINERS                        | 2 +-
 fs/ext4/super.c                    | 1 +
 3 files changed, 6 insertions(+), 3 deletions(-)
