Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F696F507
	for <linux-ext4@vger.kernel.org>; Tue,  5 May 2026 00:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777939712; cv=none; b=Qs/RQd8DihPYGiOtgO188uMwROJfmji2HpYo33up4u4gN0vB6yyDiDZEXaHz3nuKOHhj0hzOrpw39yXUd8FtFV/6yk7UOnZo7zl9ufC7/xvo8DnsbTY9dm8lacCq8vpy6uzCJAPG9AY+44GvDLyRNIRyBipA87ZFMyzkOaN18kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777939712; c=relaxed/simple;
	bh=OfAZeba+WCnbk01jo491rI/w06ENJthBFcGj6Oleavc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QS6y7SllWEthEHtzJqSoa9J1ebP8U6Nm5i8/TiuMcwio6yvkskWdpn+gHW++IWQT+sK3MDrZJNP08OKtnxiTRFuZoeWzEZ0WbZvElPtINTI28hE18jh/qaZWq0tKuvC0+KqWw1w7ZOzSXJLh01lxiGbyFazq63ynVhdLJO3+7gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sY57pNb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sY57pNb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34666C2BCB8;
	Tue,  5 May 2026 00:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777939712;
	bh=OfAZeba+WCnbk01jo491rI/w06ENJthBFcGj6Oleavc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sY57pNb9T4ukWbQlylpIDimCet2N+Xb5EskHYOc5bp/f1SMnTcu4MWlM4GdngbU5N
	 50AJtlrmcLv5pjSGKnWDF5/o1795d9tgnWABJCg/DfzYbhA6dQHGzehDDu2EWZhfhO
	 ITqF+UOg2K/mvEOx2Y8o2H+U70xacWCxComR394oUY1PHFAQAc8mfqChq1/EYqbjeI
	 Ya54GDa6Agl1F9/cOE5F6gIYrOl5AKfreoEB/79zm7HaFFiTgvmOjLehkUaqbuzIdj
	 hlwEKZJFSN5B/S50K68OkLQHh1VPh9ZRXiMDSaacgg7uHqMV0uSMVdbrR256s2heMq
	 7ORUBDFelBfWQ==
Date: Mon, 4 May 2026 17:08:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 0/7] fix up issues from djwong/fuse4fs-fork
Message-ID: <20260505000831.GA1101423@frogsfrogsfrogs>
References: <20260504233301.2345652-1-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504233301.2345652-1-tytso@mit.edu>

On Mon, May 04, 2026 at 07:32:54PM -0400, Theodore Ts'o wrote:
> These are the patches that I've applied to the next branch to clean up
> found when trying to compile e2fsprogs on MacOS and via the github's
> continuous integration testing.
> 
> Note: See .github/workflows/ci.yaml; it's a good reason to get a
> github account if you are doing a lot of e2fsprogs development.
> If you fork my e2fsprogs repository and push your changes to your github
> repo, you can get reports like the ones found here:
>       https://github.com/tytso/e2fsprogs/actions
> 
> 
> Anyway, with these patches, e2fsprogs builds on MacOS (both using the
> github CI and on locally on my Macbook).  Unfortunately fuse2fs has
> regressed in that non-root accesses are getting denied with a permission
> denied on MacOS, and this worked with e2fsprogs v1.47.4.  Here's a
> lightly edited transcript from my Macbook Air:

Hm, curious.  It's regrettable that I no longer have a Mac, and
therefore can't really do much investigating.  If you give
-o default_permissions,allow_other , does that fix the problem?
If that fixes it, then fuse2fs has a bug somewhere in its own
permissions checking.

> % uname -a
> Darwin macsyma.local 25.4.0 Darwin Kernel Version 25.4.0: Thu Mar 19 19:33:09 PDT 2026; root:xnu-12377.101.15~1/RELEASE_ARM64_T8112 arm64 arm Darwin
> % ./mke2fs -Fq -t ext4 -d . /tmp/foo.img  1G
> % ./fuse2fs -o allow_other /tmp/foo.img /Users/tytso/mnt
> FUSE2FS (foo.img): Warning: fuse2fs does not support using the journal.
> There may be file system corruption or data loss if
> the file system is not gracefully unmounted.
> % stat /Users/tytso/mnt/revoke.o
> stat: cannot stat '/Users/tytso/mnt/revoke.o': Permission denied
> % sudo stat /Users/tytso/mnt/revoke.o
>   File: /Users/tytso/mnt/revoke.o
>   Size: 29728     	Blocks: 64         IO Block: 16384  regular file
> Device: 55,270	Inode: 91          Links: 1
> Access: (0644/-rw-r--r--)  Uid: (15806/   tytso)   Gid: (   20/   staff)
> Access: 2026-05-05 00:21:50.000000000 +0200
> Modify: 2026-05-05 00:21:50.000000000 +0200
> Change: 2026-05-05 00:21:50.000000000 +0200
>  Birth: -
> % stat revoke.o
>   File: revoke.o
>   Size: 29728     	Blocks: 64         IO Block: 4096   regular file
> Device: 1,18	Inode: 851374      Links: 1
> Access: (0644/-rw-r--r--)  Uid: (15806/   tytso)   Gid: (   20/   staff)
> Access: 2026-05-05 00:21:50.903084819 +0200
> Modify: 2026-05-05 00:21:50.346338295 +0200
> Change: 2026-05-05 00:21:50.346580544 +0200
>  Birth: 2026-05-05 00:21:50.293229053 +0200
> % sum revoke.o
> 45116    30 revoke.o
> % sum /Users/tytso/mnt/revoke.o
> sum: /Users/tytso/mnt/revoke.o: Permission denied

That's really strange.  Does MacOS do any strange idmapping stuff?

I'm also curious if there's a particular commit that makes it all work
again?  There are a few defaults that changed between fuse2 and fuse3,
and since MacFuse claims to have vendored both, it could very well be
the megacommit dropping the fuse2 api support.

--D

> So fuse2fs is broken on MacOS, but it's not *totally* broken, since you
> can still use it as root.  I'll want to fix this before updating the
> master branch, but this is good enough for the next branch.
> 
> 
> 
> Theodore Ts'o (7):
>   libsupport: drop xbitops.h and define fls() if necessary
>   configure.ac: fix disable fuse2fs/fuse4fs by default path
>   libsupport: don't use bzero in cache.c
>   fuse[24]fs: suppress clang warnings which were breaking the github CI
>   libsupport: remove the LIST_HEAD macro from list.h
>   libsupport: fix gcc -Wall warnings
>   fuse2fs: fix uninitialized variable warnings
> 
>  configure               |   8 +++
>  configure.ac            |   3 +
>  fuse4fs/Makefile.in     |  18 +++---
>  fuse4fs/fuse4fs.c       |  29 +++++++--
>  lib/config.h.in         |   3 +
>  lib/support/Makefile.in |   2 +-
>  lib/support/cache.c     |  49 ++++++++++++---
>  lib/support/cache.h     |   2 +-
>  lib/support/list.h      |  17 ++++--
>  lib/support/xbitops.h   | 128 ----------------------------------------
>  misc/fuse2fs.c          |  21 +++++++
>  11 files changed, 125 insertions(+), 155 deletions(-)
>  delete mode 100644 lib/support/xbitops.h
> 
> -- 
> 2.53.0
> 
> 
