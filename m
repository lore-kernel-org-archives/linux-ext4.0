Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296EE360ED8
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2026 14:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784642525; cv=none; b=sr6mwnKEMuY4G98ucCAgBecmpRZAqSdl3gC/i5G6GRw0yKRk+p0bjDGjc0fmv1spVmwKULnCs99rf8Qyph29sxa5/SCCnj0dQrgNNNq/UgFxfvCsfc7xkSzgo1g5jkoHUyEPaPDEgCq0yRReRbqbRHGnEGHnGeTKQbNNZed16aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784642525; c=relaxed/simple;
	bh=ZqsBUUWfTpH3HteN+XirsWj9J+l+B3pyKxBBY82NweI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l1D03doSDOPLuecxTY2Ap549ELhXLOtvhPMaXkTCUE0bvvHl5BFOxfj/Nm7DI2pxEivpPKW773OEVZ/lBgl9RLId41OtDn9s9zOSD9VJlTkYejPekE+8blKUu04cvoilw/Q0SdpNURluLcklud4iGA7vI6TeI9P4bYfSYof+aRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=W7wSLoXf; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="W7wSLoXf"
Received: from trampoline.thunk.org (pool-108-49-65-18.bstnma.fios.verizon.net [108.49.65.18])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66LE1vp2010189
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 10:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784642519; bh=3+89HKjb8VXjFdthN40TIPghOxwdzDyH39t9rL72Ph4=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=W7wSLoXfQvdsVEWxv0rqOGmNRmWpWHPqxaQRQIIAcJbulN2N1aW8TUA9d1rstle1e
	 VFfdyIOV5e9I3jK2X/djbk2AM9kDTdZpjYh7WRmgyHVeKNdFsaFSbx4aeYGTAZfejz
	 JZeP6aVmahzj2AdQX+GnOKVG1PRulLqc1YOZ69EnWkjd0gzc49e2c4GUzjOSK3vK1Q
	 GT73iZP5v1YaOhDgILL/Knq0/IHPYXcdXUL8DcTgWfYHW6sJnId8dbzPEaB5bx64/u
	 3QqrOEQ37hiPAKSJuBjpT/Op3c3r3csTW/o73OnXYCDa/CB+oby7hRv24+9A1rIGUV
	 rKC2+G9LxbbCQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 989122E3F13; Tue, 21 Jul 2026 10:01:57 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 0/2 -v3] ext4: scoped NOFS for the handle in nojournal mode
Date: Tue, 21 Jul 2026 10:01:34 -0400
Message-ID: <20260721140152.461286-1-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series makes it safe to remove the GFP_NOFS flag when an
active is handle and slightly optimized the data layout of the jbd2
handle.

Theodore Ts'o (2):
  ext4: enable scoped NOFS when starting a handle in nojournal mode
  jbd2: align h_type and h_line_no in the handle structure on byte
    boundaries

 fs/ext4/ext4_jbd2.c  | 36 ++++++++++++++++++++++--------------
 fs/ext4/ext4_jbd2.h  |  6 +-----
 fs/jbd2/journal.c    |  1 +
 include/linux/jbd2.h | 11 ++++++-----
 4 files changed, 30 insertions(+), 24 deletions(-)

Changes in v3:
  * Export ext4_handle_cache to fix a build break when ext4 is
    compiled as module
  * Add an optimization in how h_type and h_line_no is laid out
    in the jbd2_journal_handle structure.
Link to v2: https://lore.kernel.org/r/20260716144831.41290-1-tytso@mit.edu

Changes in v2:
  * Remove an unused variable in ext4_get_nojournal()
  * Add a safety check in case ext4_handle_valid() is passed a NULL
    pointer, even though the fucntion is documented that the caller
    must not be called with a NULL handle.
Link to v1: https://lore.kernel.org/r/20260625172223.88878-1-tytso@mit.edu

-- 
2.53.0

