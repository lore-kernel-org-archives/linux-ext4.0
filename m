Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792677437;
	b=kVgDWk0EEEweDuEGOdHi2GRrNqq6FKjkKaJtKKhR+ZZXzGzGq+LfH0/NWxnoGXx53yTk
	 bT/NyF7afJuRZy3TsoNi14HKpPaGX9oV+kz5JVrPo30z0AggV9Ied1oe+eS3ytAu+AZSS
	 rlt1keP4Jzvjirb97O42go716z/l27E9zLixF3H9WZ5WBO01iwikZx3U70Cw3+vDhUFEG
	 AAXLNlrFdTyN1x5QSmo4HFB3kpib1s4TUkForAuY9oDZiP8rs5p18skmyvIs3boVcQv/d
	 swekqkIHz/oUm8olJUOTpbMUubVFsfkIf7LG8Dg4fMDh3UWSV04gPGc6C6fqfag3uFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792677437;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition;
	bh=4g4nl85uQ+oqe5lEbYHv075zDMEI+YwtCB8bjQcYNuc=;
	b=Bwg2p1Aw0CkgWQmmuQwqWiQor4KjUD1ABNgEU6FWyVCZjJnIWGtrPPO74tT3LygrbA9p
	 vwN0t7sbVEFcApuSXz4OnQi3ZCX8ecBCYUA1BVEgvCqJUmr8CGAE//mearEXjzrI5BCui
	 oshRpkwOR5f11DslPT+Q7uFQhkGpJpqeo/n1mme2kGHEjXs3Giwqm2SbezLZPcqIeArXL
	 AQFpPKVRIDZaZmSPz/H4Giavql6vXas0dxhNuyum5ee7euwuVZbv9Nei4Gv4DszlUN8de
	 SAs3+vuZ6uBL81QFhdJ/XEHOXXr5IhMzK6cDZF6cVH4LzhVCD8EXsjgjZI8v5RBfCXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b="HgO/1FxQ";
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2641606A31E
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 13:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2641606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=HgO/1FxQ
Received: from trampoline.thunk.org (pool-108-26-156-23.bstnma.fios.verizon.net [108.26.156.23])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 69MDux9g003881
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 09:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1792677425; bh=4g4nl85uQ+oqe5lEbYHv075zDMEI+YwtCB8bjQcYNuc=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=HgO/1FxQ0sLg+xMOb1xqaUZ7HsAOJnl9pqX6CqfrQ5vxFx9p5AOwA/GXgoIOgzW0/
	 Rvhz39/yB/pPhh3AxoHnWCKrodM6C7aaXIfYfTufK1WElOXXANiz6l6tDAwh++bECy
	 /7Voc/jOjAikb9zwk3YnSudNtN6pHs3UHDe0bVvhKKvidVCxfzw8/cld4gdqGizS0a
	 6LsmPdW4b91ZKaz0Fek5QUKd6cwfZwKkcidYWtANhE29BR4NnPQbxVQvsWmScbp4F8
	 piPbwkRXpzR5M0fVnSQxS5Drs+gbFU/gqzpT/nNCrWP2lE6jFhyz+xbwsC4yXMWCQ9
	 fPjA53YfaGp3Q==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 5BDB42E00B9; Thu, 22 Oct 2026 09:56:59 -0400 (EDT)
Date: Thu, 22 Oct 2026 09:56:59 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ext4 updates for 7.4-rc1
Message-ID: <atoWDJDx6sFovvjp@mit.edu>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 93f51579e7df248780214094418f205253383cc5:

  Linux 7.3-rc4 (2026-09-20 13:48:15 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.4-rc1

for you to fetch changes up to 8c4f6e3376348fc3162eed86a05b933921c8f9ed:

  ext4: introduce a mount option for iomap buffered I/O path (2026-10-15 10:53:14 -0400)

----------------------------------------------------------------
Add support for buffered iomap support in ext4.  This is not enabled
by default, but requires the buffered_iomap mount option, as this mode
does not support online defragmentation, inline data, fsverify,
fscrypt, non-extent inodes, and data=journal mode.  If buffered_iomap
is enabled, ext4 will fall back to the original I/O code path
automatically if necessary.  Large writes show significant performance
improvements when buffered iomap is enabled.

There are also miscellaneous bug fixes and improvements, including for
fast commit and avoiding deadlocks and out-of-bound reads when
handling corner cases involving corrupted file systems.

----------------------------------------------------------------
Daejun Park (2):
      jbd2: don't advance j_fc_off before the buffer is recorded
      ext4: don't report delalloc data as a hole on indirect-mapped inodes

Hemanth Selam (1):
      ext4: skip extra isize expansion while unmounting

Hsiu-Hsien Lee (1):
      ext4: fix fast commit replay failing on a read-only mount

Jinjie Ruan (2):
      ext4: fix out-of-bounds read in ext4_get_group_info()
      ext4: convert group-count barrier protocol to acquire/release

JonasZhou-oc (1):
      jbd2: avoid false sharing with j_state_lock

Sergey Senozhatsky (1):
      ext4: fix ABBA deadlock in ext4_rmdir()

Zhang Yi (31):
      ext4: simplify size updating in ext4_setattr()
      ext4: factor out ext4_truncate_[up|down]()
      ext4: set EXT4_MAP_NEW flag for delayed allocated blocks
      ext4: recheck extent status tree before block allocation
      ext4: fix orig_mlen initialization in ext4_map_blocks()
      ext4: allow ext4_map_blocks() to start its own transaction handle
      ext4: avoid unnecessary transaction in ext4_map_blocks() for unwritten extents
      ext4: skip block allocation for holes in the data submission path
      ext4: add iomap address space operations for buffered I/O
      ext4: implement buffered read path using iomap
      ext4: pass out extent seq counter when mapping da blocks
      ext4: do not use data=ordered mode for inodes using buffered iomap path
      ext4: implement buffered write path using iomap
      ext4: rework handle credit accounting for unwritten extent conversion
      ext4: implement writeback path using iomap
      ext4: implement mmap path using iomap
      ext4: implement partial block zero range path using iomap
      ext4: drain writeback before removing extents on the iomap path
      ext4: add block mapping tracepoints for iomap buffered I/O path
      ext4: disable online defrag when inode using iomap buffered I/O path
      ext4: add EXT4_STATE_DISKSIZE_GROW_PENDING state bit and helpers
      ext4: submit and wait for pending disksize-grow I/O on writeback
      ext4: advance i_disksize to i_size upon disksize-grow I/O completion
      ext4: defer i_disksize update while DISKSIZE_GROW_PENDING is set
      ext4: submit and wait for disksize-grow I/O in fallocate paths
      ext4: clear DISKSIZE_GROW_PENDING on truncate or error
      ext4: set DISKSIZE_GROW_PENDING after zeroing unaligned EOF block
      ext4: add tracepoints for DISKSIZE_GROW_PENDING set, clear, and wait
      ext4: add tracepoints for EOF block zeroing and disksize-grow I/O
      ext4: partially enable iomap for the buffered I/O path of regular files
      ext4: introduce a mount option for iomap buffered I/O path

guzebing (2):
      ext4: only update tune mount options when requested
      ext4: reject delalloc to nodelalloc before applying remount options

 fs/ext4/balloc.c            |    2 +-
 fs/ext4/ext4.h              |   96 ++-
 fs/ext4/ext4_jbd2.c         |    8 +-
 fs/ext4/ext4_jbd2.h         |    7 +-
 fs/ext4/extents.c           |  131 ++--
 fs/ext4/file.c              |   20 +-
 fs/ext4/ialloc.c            |    1 +
 fs/ext4/indirect.c          |   17 +
 fs/ext4/inode.c             | 1448 +++++++++++++++++++++++++++++++++++++--------
 fs/ext4/ioctl.c             |    3 +-
 fs/ext4/mballoc.c           |    6 +-
 fs/ext4/migrate.c           |    2 +
 fs/ext4/move_extent.c       |   11 +
 fs/ext4/namei.c             |   11 +-
 fs/ext4/page-io.c           |  201 +++++++
 fs/ext4/resize.c            |   19 +-
 fs/ext4/super.c             |   67 ++-
 fs/jbd2/journal.c           |    2 +-
 include/linux/jbd2.h        |    2 +-
 include/trace/events/ext4.h |  209 +++++++
 20 files changed, 1927 insertions(+), 336 deletions(-)
