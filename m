Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52592329C66
	for <linux-ext4@vger.kernel.org>; Tue,  5 May 2026 22:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778021796; cv=none; b=JPc+//nX8ZpIGRR0AZPRabRjXzsIeB48NDH9uiEMeLuX/JNrO+0N6Gbi0CofiUJRk5FAvf+IcSiOheDCSMqRKTC6BQYyiuF75xWq0j8p7KbuxBGR24jGtqxOt8aD/RZ04BcuJWV+mWdz6aRv5lDOMz6xWMSa619u6b3RH8GTpXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778021796; c=relaxed/simple;
	bh=JdAmRExcsgNqFdkEKktD2PmMk3fRxhQ8sXWg3BbmcIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JPiPqmRVIcckuadUFXLXrXhC4ppVKJMIGJIMJcAyuelb+VJo9pGvUKrqd1aeIt/vWJISsL7hK4CHtg7irobkC3YLQPDqtdEb1Se7+vnUxWiE+0XErQ6lZtgQl0Tp3NSqDoox7D33M5QmYqH1zQBwr81UhrWjQC5tzHnqTIc9n4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGLpjU6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGLpjU6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7185C2BCB4;
	Tue,  5 May 2026 22:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778021796;
	bh=JdAmRExcsgNqFdkEKktD2PmMk3fRxhQ8sXWg3BbmcIo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KGLpjU6BWojSnlPkXbfNFoN6nk2LDUdukc1aClMmzaLe0YTks2IZyLN0cNlyfrToL
	 bjuap+7pvWy5Wi3vsx35HuakntArGyHEu4aRK1atN1GAnwCp566lJYM2IV0kl2Cf8i
	 OfeuAbjxyPrM3vnfXVOoKmMU5iUI9aqBuc2myqhXESAUQ/XLvROWtzkNp3dnbOGXPh
	 9lyPbIU0qkitYgxAbEiCipT7WTDcywWJEU/QqegMbcLfq8bkwt75L3gjhSWKseqowj
	 MeLme6gUk9QdkqNGuq6fk6T/qKyF8AH+C5ZHLYBzHZjOQ9dufWkLZevU+T4AQi9MjG
	 gBGo2k9KkMgng==
Date: Tue, 5 May 2026 15:56:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 0/7] fix up issues from djwong/fuse4fs-fork
Message-ID: <20260505225635.GT7765@frogsfrogsfrogs>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260505000831.GA1101423@frogsfrogsfrogs>
 <20260505072144.GC16497@macsyma-wired.lan>
 <20260505155821.GI1101423@frogsfrogsfrogs>
 <20260505220441.GB49070@macsyma.local>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505220441.GB49070@macsyma.local>

On Wed, May 06, 2026 at 12:04:41AM +0200, Theodore Tso wrote:
> On Tue, May 05, 2026 at 08:58:21AM -0700, Darrick J. Wong wrote:
> > Hrm.  A bisect would be the best (but least conference-friendly) option
> > to narrow things down.
> 
> Well, a bisect was a bit painful because I had to cherry-pick patches
> so I could get a successfull build.  But I did finally come up with
> the guilty commit, and it's.... surprising at least to me:
> 
> commit b0bd58062bbf645942ab4f0aced3bb229f462dde
> Author: Darrick J. Wong <djwong@kernel.org>
> Date:   Thu Aug 28 10:30:40 2025 -0700
> 
>     fuse2fs: cache symlink targets in the kernel
> 
>     Speed up symlinks by allowing the kernel to cache them.
> 
>     Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> I don't know why it made a difference, but this attached patch appears
> fix the MacOS regression.  Could this be a bug in MacFuse[1]?  FWIW, I'm
> running MacFuse 5.2.0_1 from MacPorts.
> 
> [1] https://macfuse.github.io
> 
> I could condition the patch so that we only avoid setting
> FUSE_CAP_CACHE_SYMLINKS on MacOS?  WDYT?

I vomit a little in my mouth, because...

$ cd macfuse/Library-3
$ git grep FUSE_CAP_CACHE_SYMLINKS
<snip>
include/fuse_common.h:472:#define FUSE_CAP_CACHE_SYMLINKS (1UL << 23)

Ok, so fuse2fs passes want-flag 1<<23 into the kernel to turn on what it
*thinks* are cached symlinks.

[Editor's note: this email previously contained the following text]

    Unfortunately, we both now hit a brick wall, because the macfuse
    page says:

    "This repository contains the source code of libfuse.dylib and
    macFUSE.framework. The other components, e.g. the macFUSE kernel
    extension, are closed-source."

    Hence we have no way to find out what the kext thinks 1<<23 means.
    There's talk of some sort of "fskit" replacement for the signed
    kext, but I don't know where that is.

Actually, it's *MUCH* worse than that.  Look at what
Library-3/include/fuse_kernel.h contains:

#ifdef __APPLE__
/*
 * TODO(bf)
 *
 * Resolve conflict with vanilla API. As long as we don't support anything
 * beyond 7.19 on the kernel-side this should not be an issue. We need to clean
 * this up when moving to 7.20 or later.
 */
#define FUSE_DARWIN_ACCESS_EXT        (1 << 23)
#define FUSE_DARWIN_THREAD_SAFE        (1 << 24)
#define FUSE_DARWIN_RENAME_EXT        ((1 << 25) | (1 << 26))
#define FUSE_DARWIN_FALLOCATE        (1 << 27)
#define FUSE_DARWIN_CASE_INSENSITIVE    (1 << 29)
#define FUSE_DARWIN_SETVOLNAME        (1 << 30)
#endif

Then look up about 30 lines:

#define FUSE_CACHE_SYMLINKS	(1 << 23)
#define FUSE_NO_OPENDIR_SUPPORT (1 << 24)
#define FUSE_EXPLICIT_INVAL_DATA (1 << 25)
#define FUSE_MAP_ALIGNMENT	(1 << 26)
#define FUSE_SUBMOUNTS		(1 << 27)
#define FUSE_HANDLE_KILLPRIV_V2	(1 << 28)
#define FUSE_SETXATTR_EXT	(1 << 29)
#define FUSE_INIT_EXT		(1 << 30)

FUSE kABI 7.20 added FUSE_AUTO_INVAL_DATA, which is bit 12.  It looks to
me as though they decided to add their own MacOS-specific feature flags
at the end of the u32 want field.  Then Linux FUSE added 11 more feature
flags, at which point they unthinkingly ported over FUSE_CACHE_SYMLINKS,
which collides with FUSE_DARWIN_ACCESS_EXT.  Apparently nobody on the
macfuse end noticed, so on your machine you're getting whatever
"ACCESS_EXT" does.

$searchengine has zero hits for FUSE_DARWIN_ACCESS_EXT so who knows what
that actually does.  But this sure is a messed up situation.

Does this work?

/* MacFUSE overlays feature bits with LinuxFUSE, this is fcked up */
#if defined(FUSE_CAP_CACHE_SYMLINKS) && !defined(FUSE_CACHE_SYMLINKS)
	fuse_set_feature_flag(conn, FUSE_CAP_CACHE_SYMLINKS);
#endif

--D

> 						- Ted

> From fb3d2fc975d17d97ed76b2ed76022462a3b329f1 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Tue, 5 May 2026 23:34:53 +0200
> Subject: [PATCH] Revert "fuse2fs: cache symlink targets in the kernel"
> 
> This reverts commit b0bd58062bbf645942ab4f0aced3bb229f462dde.
> 
> This commit is apparently causing fuse2fs on MacOS to fail without "-o
> default_permissions".  It's not clear why, but it was determined using
> a git bisect, and reverting the commit addresses the regression.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  misc/fuse2fs.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
> index c46cfc23..0f9cefa6 100644
> --- a/misc/fuse2fs.c
> +++ b/misc/fuse2fs.c
> @@ -1593,9 +1593,6 @@ static void *op_init(struct fuse_conn_info *conn,
>  	if (ff->acl)
>  		fuse_set_feature_flag(conn, FUSE_CAP_POSIX_ACL);
>  #endif
> -#ifdef FUSE_CAP_CACHE_SYMLINKS
> -	fuse_set_feature_flag(conn, FUSE_CAP_CACHE_SYMLINKS);
> -#endif
>  #ifdef FUSE_CAP_NO_EXPORT_SUPPORT
>  	fuse_set_feature_flag(conn, FUSE_CAP_NO_EXPORT_SUPPORT);
>  #endif
> -- 
> 2.50.1 (Apple Git-155)
> 

