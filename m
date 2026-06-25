Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF9525771
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416128; cv=none; b=i9e4795nBbq9lJ4kQfGQ3NUZVZthSJ1QStUgUT2GlGYGhGXuVTqeUJ7jpi/BwoGPsQH1ZDrTFaxASZp3VunkElTQ6EMdUzaSG+CYTbTw/kkv/MNkRMdMY36x9W31GkySWKT4Lov6KRZAyxVWhwtPiNnhc3tzQAjT405ails2OeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416128; c=relaxed/simple;
	bh=AypP85wiSPf8s8hYfACnqWOrdjZhnp1K4dy5oBSniCY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zd2Gs8UX1igyZn7h4fLDbMkWKei3L7OPjJOFJSpkMjTbEoj8LJXWGO1vHgraEvsw11zai4vBIaGYAy97yIL15XRJDMUtj+1X2/cXA1+ouUkkKXkI1WcV3CszlDKGtWYa/MhmPxnSlMGDylK1v1c4kgkQ3XMrEFmQ+aJhEmJ2ux0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIzu6J6o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIzu6J6o"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 789BF1F000E9;
	Thu, 25 Jun 2026 19:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416127;
	bh=pGggdfu6pIVulrebLMutTstcY7EjcM0mJVc9fLhnaG8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=lIzu6J6on0BXjcSDJ0rb9itkyCqwIS5E0TrGj5jImqftEXs5/epdaKftxdq1HmhL1
	 2l/tKR4hvjyJDUFdGI8idOPDBFB7RQOU/x26UPZMUgRkrLuh53EZMpBikOEoXCL+VB
	 nl/djIPwTeD4MnOQEBMlBfaYK12CfDuvoQZarV5FcCjw0mGdKCAvmmECn9dDUjMahv
	 AYNeaQ0QLvFt9Sx8pz/aRtIhKOL5VWs72RWdzR7otV71i7MFn/ZIUzscdytzpnIubD
	 tAJF2rw39d8fSCkpm6HXd4NTrkUDLP1bBuwmziq7DVz7ZzIAFXFHfEjUOw5i9tn3xt
	 0ByPgj8aHwmUA==
Date: Thu, 25 Jun 2026 12:35:27 -0700
Subject: [PATCHSET v6 2/4] fuse4fs: run servers as a contained service
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, linux-ext4@vger.kernel.org
Message-ID: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
In-Reply-To: <20260625193302.GC6054@frogsfrogsfrogs>
References: <20260625193302.GC6054@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series packages the newly created fuse4fs server into a systemd
socket service.  This service can be used by the "mount.service" helper
in libfuse to implement untrusted unprivileged mounts.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

e2fsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse4fs-service-container
---
Commits in this patchset:
 * libext2fs: make it possible to extract the fd from an IO manager
 * libext2fs: fix checking for valid fds in mmp.c
 * unix_io: allow passing /dev/fd/XXX paths to the unixfd IO manager
 * libext2fs: fix MMP code to work with unixfd IO manager
 * libext2fs: bump libfuse API version to 3.19
 * fuse4fs: hoist some code out of fuse4fs_main
 * fuse4fs: enable safe service mode
 * fuse4fs: set proc title when in fuse service mode
 * fuse4fs: make MMP work correctly in safe service mode
 * debian: update packaging for fuse4fs service
---
 lib/ext2fs/ext2_io.h         |    4 
 lib/ext2fs/ext2fs.h          |    1 
 lib/ext2fs/ext2fsP.h         |    4 
 MCONFIG.in                   |    2 
 configure                    |  303 ++++++++++++++++++++++++++-
 configure.ac                 |  131 +++++++++++
 debian/e2fsprogs.install     |    7 +
 debian/fuse4fs.install       |    3 
 debian/libext2fs2t64.symbols |    1 
 debian/rules                 |    3 
 fuse4fs/Makefile.in          |   42 +++-
 fuse4fs/fuse4fs.c            |  479 ++++++++++++++++++++++++++++++++++++------
 fuse4fs/fuse4fs.socket.in    |   17 +
 fuse4fs/fuse4fs@.service.in  |  102 +++++++++
 lib/config.h.in              |   12 +
 lib/ext2fs/io_manager.c      |    8 +
 lib/ext2fs/mmp.c             |  101 +++++++++
 lib/ext2fs/openfs.c          |    1 
 lib/ext2fs/unix_io.c         |   50 ++++
 util/subst.conf.in           |    3 
 20 files changed, 1177 insertions(+), 97 deletions(-)
 mode change 100644 => 100755 debian/fuse4fs.install
 create mode 100644 fuse4fs/fuse4fs.socket.in
 create mode 100644 fuse4fs/fuse4fs@.service.in

