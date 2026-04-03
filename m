Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC6322E3F0
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 04:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775189021; cv=none; b=BMl0p/NEuuWL6vws2AvS1xHCeJRv4v9Yrmojuc3sDCVtR9NiBvkifi5ljoruA5eETT0BJvn8UDXIP3sasRdJiOgwKToYkp/hU/y4RMY7I1xbs2e0AwUaNRbA+x3ZpdGwPAQaTUhOGfANYhtzaIO/icJlCJ+KNDWo+wkZEP88Xqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775189021; c=relaxed/simple;
	bh=bJ0xr7Lo6nktN532mLfd+YGrGJnhwdBC5GX58oYIK5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UsUazXS8Pa8Sjnci1Vd+e3ymdZ7PsRfQ/QGz1A3KSdNbMTT0EN1yHEQ45b8+/UM65VUbvJu87GAoUbuyJIWCPggr5V1Ovj3XwQ745xyOur+cWFZRjatC1Phs7M0H2AierMM+fVDdIxVUihdVLZG3YhR9+UiZPrdE76ICFqtwiqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=INKMqw5A; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="INKMqw5A"
Received: from trampoline.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63343Xen005247
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Apr 2026 00:03:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775189015; bh=QIlfLkyH8B/ehrVhS0SM4X0rhNyVTAI2sWgNgw5xloA=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=INKMqw5A/u+nTyocszN99JAtIGgWNg4NH0CGob7rXMWYZr3+z4LlwvTSC34kI68yD
	 h63SpXrxdr08MFD8AS3fcp390F3mWSsTh/6ldA16cmva00U4T4Gpgiw+gILkaSb/8E
	 Xh7yCEUdO/u1c1v/hEZQ1HbRNTgJWSTMTPMm48oQ51Ww0WH/bvJED4Ue+8To6pnYq5
	 yZrS41yPiZDTNXIbBd5KsH3NvimHHzUtoCZjud6ykN/3I0z7h80nciO7H1C5+LynnT
	 2R6HM04+ybbMumUd8AUv5ke5IP+B4xtho+d3MJzfkThmVOs9mITJXAsuYm8ntF+R0o
	 s9oNHeZmkYnBA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 739AC2E00D6; Fri, 03 Apr 2026 00:03:33 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -e2fsprogs 0/3] Fix portability issues on MacOS
Date: Fri,  3 Apr 2026 00:03:25 -0400
Message-ID: <20260403040328.2385083-1-tytso@mit.edu>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The recent fuse2fs changes introduced some portability issues; fix
them so that e2fsprogs can build on MacOS and create a fuse2fs binary
that works on MacOS 26.3.1 using MacFuse.

Note: the f_opt_extent test is failing on Github Actions when testing
on MacOS.  All of the tests are passing clean up my MacOS laptop.  So
I'm not sure where the github action failure is coming from.

Theodore Ts'o (3):
  libsupport: fix portability issues with the bthread.c
  libsupport: add a portable get_thread_id() function
  fuse2fs: fix build failure on systems which don't define EUCLEAN

 configure               | 18 ++++++++++++++++++
 configure.ac            |  3 +++
 lib/config.h.in         | 30 +++++++++++++++++++++---------
 lib/support/Makefile.in | 13 +++++++++++--
 lib/support/bthread.c   | 12 ++++++++++--
 lib/support/thread.c    | 36 ++++++++++++++++++++++++++++++++++++
 lib/support/thread.h    |  5 +++++
 misc/fuse2fs.c          |  5 ++++-
 8 files changed, 108 insertions(+), 14 deletions(-)
 create mode 100644 lib/support/thread.c
 create mode 100644 lib/support/thread.h

-- 
2.51.0

