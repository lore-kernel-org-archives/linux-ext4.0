Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792896987;
	b=Ry557GWclp6ySAyaWeeQKGiS/C03vCSBlQjpNTfzu7hODljeXEYtaTYvjrz5/b0B3heO
	 mN2aMSq0XWlrpOAU5YLC8sojf++a238Wz3Mxefn6HPqiJPGuIB/LiZ6QWTpH7jQcQy9yW
	 5AlDkcUU88hHOkM1Iv1qGxlhmaZc52aysknHnbsq7mh1sa6W7Je/K8YGPgVgyEYfrVDZr
	 nQBvjTR7MGaUHZ04p+2Wyp3R/ISGpoTOfTw6e8Zd/LNdFbQ0WxsS5U2i0lguqzzwfagp3
	 XMlYWeORRGPqAsi9MiQE6dMwpNcijSC2L6JJJEXelLY6mlkMClCjj3va+SYrzSXkHhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792896987;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=7opuxzGBz+F9df/GYs1w28Q79V+a7Xw/jjIfhK7qCj0=;
	b=wrR7Ls0jO1tUCNdRWTLeMo2TQE4RdQVTJJUmst0vrd5A8meFm7qD+D4Rcqa/21ogE7ct
	 P4az68LVx/gTGk9suOT3caaTkvha/Xc3kzGEKJf+lPwM3o/SMMKKAFNmFd9WQby8iR0t7
	 39mAdKUPDUlwm/YdntSW6W1rcI89EDoqI6gSVtulwzh0IZaCykt9poP14tt3U4n4NjHQR
	 MRvCoc1SgfXtuP55H40HD+F1ZwV94c1nmHhfYtTIg4yRTCQ7fo8c96y0AvVvdbzn18U8+
	 hR9dFtZp5BhSAAEe1LWvSkQBBvnZa+H6Ws9eMFXZYO3Jr6k2C0JUhx5qK9DzTdeIbRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=FHK5PC5q;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE02606A31D
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 02:56:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DE02606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=FHK5PC5q
Received: from macsyma.thunk.org (pool-108-26-156-23.bstnma.fios.verizon.net [108.26.156.23])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 69P2uEBc025655
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 24 Oct 2026 22:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1792896976; bh=7opuxzGBz+F9df/GYs1w28Q79V+a7Xw/jjIfhK7qCj0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=FHK5PC5qjtcNcS9YkS3M6aV28tYp3l7z+uq1KRFWDyPqIE5GUix8DvuOrvoXXcN0k
	 DMYALMmbZWWajARkd+CABn7EHL7Abys1w3GnJtYhDHVIp7sP2BMFkLZrKO30F9hcam
	 6ikPY2U3VONRoxQHuqynBXlI+k90XroqKIcZCeOjSvKDFqWK3hTPvP/M5CzQP/y0C1
	 2uIU913fkzYkrQwk44qc3cDkVkt5ltNVedvEN+JZrqFoAGS6ljmcFvve8vpG1JmSKV
	 0uvCTf05mv12zWqnYjs/GpFKnvYHezHNG25MpZTYjI7oy1AkhRICgSnpiOnEe4BQTK
	 bCftr2iKhtlxA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 577CF22911D4; Sat, 24 Oct 2026 22:55:14 -0400 (EDT)
Date: Sat, 24 Oct 2026 22:55:14 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 updates for 7.4-rc1
Message-ID: <at1viAwYP3bFOkj_@mit.edu>
References: <atoWDJDx6sFovvjp@mit.edu>
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
In-Reply-To: <atoWDJDx6sFovvjp@mit.edu>

Ping?

On Thu, Oct 22, 2026 at 09:56:59AM -0500, Theodore Ts'o wrote:
> The following changes since commit 93f51579e7df248780214094418f205253383cc5:
> 
>   Linux 7.3-rc4 (2026-09-20 13:48:15 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus-7.4-rc1
> 
> for you to fetch changes up to 8c4f6e3376348fc3162eed86a05b933921c8f9ed:
> 
>   ext4: introduce a mount option for iomap buffered I/O path (2026-10-15 10:53:14 -0400)
> 
> ----------------------------------------------------------------
> Add support for buffered iomap support in ext4.  This is not enabled
> by default, but requires the buffered_iomap mount option, as this mode
> does not support online defragmentation, inline data, fsverify,
> fscrypt, non-extent inodes, and data=journal mode.  If buffered_iomap
> is enabled, ext4 will fall back to the original I/O code path
> automatically if necessary.  Large writes show significant performance
> improvements when buffered iomap is enabled.
> 
> There are also miscellaneous bug fixes and improvements, including for
> fast commit and avoiding deadlocks and out-of-bound reads when
> handling corner cases involving corrupted file systems.
> 
> ----------------------------------------------------------------
> Daejun Park (2):
>       jbd2: don't advance j_fc_off before the buffer is recorded
>       ext4: don't report delalloc data as a hole on indirect-mapped inodes
> 
> Hemanth Selam (1):
>       ext4: skip extra isize expansion while unmounting
> 
> Hsiu-Hsien Lee (1):
>       ext4: fix fast commit replay failing on a read-only mount
> 
> Jinjie Ruan (2):
>       ext4: fix out-of-bounds read in ext4_get_group_info()
>       ext4: convert group-count barrier protocol to acquire/release
> 
> JonasZhou-oc (1):
>       jbd2: avoid false sharing with j_state_lock
> 
> Sergey Senozhatsky (1):
>       ext4: fix ABBA deadlock in ext4_rmdir()
> 
> Zhang Yi (31):
>       ext4: simplify size updating in ext4_setattr()
>       ext4: factor out ext4_truncate_[up|down]()
>       ext4: set EXT4_MAP_NEW flag for delayed allocated blocks
>       ext4: recheck extent status tree before block allocation
>       ext4: fix orig_mlen initialization in ext4_map_blocks()
>       ext4: allow ext4_map_blocks() to start its own transaction handle
>       ext4: avoid unnecessary transaction in ext4_map_blocks() for unwritten extents
>       ext4: skip block allocation for holes in the data submission path
>       ext4: add iomap address space operations for buffered I/O
>       ext4: implement buffered read path using iomap
>       ext4: pass out extent seq counter when mapping da blocks
>       ext4: do not use data=ordered mode for inodes using buffered iomap path
>       ext4: implement buffered write path using iomap
>       ext4: rework handle credit accounting for unwritten extent conversion
>       ext4: implement writeback path using iomap
>       ext4: implement mmap path using iomap
>       ext4: implement partial block zero range path using iomap
>       ext4: drain writeback before removing extents on the iomap path
>       ext4: add block mapping tracepoints for iomap buffered I/O path
>       ext4: disable online defrag when inode using iomap buffered I/O path
>       ext4: add EXT4_STATE_DISKSIZE_GROW_PENDING state bit and helpers
>       ext4: submit and wait for pending disksize-grow I/O on writeback
>       ext4: advance i_disksize to i_size upon disksize-grow I/O completion
>       ext4: defer i_disksize update while DISKSIZE_GROW_PENDING is set
>       ext4: submit and wait for disksize-grow I/O in fallocate paths
>       ext4: clear DISKSIZE_GROW_PENDING on truncate or error
>       ext4: set DISKSIZE_GROW_PENDING after zeroing unaligned EOF block
>       ext4: add tracepoints for DISKSIZE_GROW_PENDING set, clear, and wait
>       ext4: add tracepoints for EOF block zeroing and disksize-grow I/O
>       ext4: partially enable iomap for the buffered I/O path of regular files
>       ext4: introduce a mount option for iomap buffered I/O path
> 
> guzebing (2):
>       ext4: only update tune mount options when requested
>       ext4: reject delalloc to nodelalloc before applying remount options
> 
>  fs/ext4/balloc.c            |    2 +-
>  fs/ext4/ext4.h              |   96 ++-
>  fs/ext4/ext4_jbd2.c         |    8 +-
>  fs/ext4/ext4_jbd2.h         |    7 +-
>  fs/ext4/extents.c           |  131 ++--
>  fs/ext4/file.c              |   20 +-
>  fs/ext4/ialloc.c            |    1 +
>  fs/ext4/indirect.c          |   17 +
>  fs/ext4/inode.c             | 1448 +++++++++++++++++++++++++++++++++++++--------
>  fs/ext4/ioctl.c             |    3 +-
>  fs/ext4/mballoc.c           |    6 +-
>  fs/ext4/migrate.c           |    2 +
>  fs/ext4/move_extent.c       |   11 +
>  fs/ext4/namei.c             |   11 +-
>  fs/ext4/page-io.c           |  201 +++++++
>  fs/ext4/resize.c            |   19 +-
>  fs/ext4/super.c             |   67 ++-
>  fs/jbd2/journal.c           |    2 +-
>  include/linux/jbd2.h        |    2 +-
>  include/trace/events/ext4.h |  209 +++++++
>  20 files changed, 1927 insertions(+), 336 deletions(-)
