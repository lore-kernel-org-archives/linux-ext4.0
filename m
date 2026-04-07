Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF341EA7CE;
	Tue,  7 Apr 2026 01:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775526121; cv=none; b=Y1lSklrYEdsEae5pM1jzWbd8R1Wa3Adr2OQBStLw2TIvJ5/tJKfiyOC9NymgzSItUuG6Ca/OH/5f54OOvTiMjV0LADt1FU9HqXhTFXrVOF+a34jI2L3Na/9BiEGqrntyIlJVMgVm9fXmPd/j/rH9S0S5n11q1d0LYh8t2LTN2wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775526121; c=relaxed/simple;
	bh=6GqMEeFeK67U6dewY+vo1+MD3lh4/5dQ5kZL2lfHA6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdJOL4TePVWoVomK5F06+nzgQY4Eiu0G0/j78yuxe/p3AYXmIOWIy2IQu+5PQJ1aZq1fa+pUD2gI1O5CHD4SsQCvXawyBSv/UA84ofKllxZtVrfsGu6lR2hY4QQI3Q1IYQGPjzzeMFU88AkLMN/fpl/uPiwuaMuKoysZ1UQrGT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f8ar6ELX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8ar6ELX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC046C4CEF7;
	Tue,  7 Apr 2026 01:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775526120;
	bh=6GqMEeFeK67U6dewY+vo1+MD3lh4/5dQ5kZL2lfHA6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f8ar6ELXDkzkawu3Lum83bNvV1I86HR8RhDzF3PAP6HG0ON3oAMif3scbBBrbGqNh
	 aEghzSz7OswC5Ts7zuK7PFIs1IBzYui0s0Qp7Wi51X1s1cUqJb/ubKECZhcHI8zrg+
	 LWh8E0nPEE4gHQ2pBnA8BR/AUZaVVFnfIRSw1CldXln8O8mAydIWRPcM1DzEeV4V+a
	 3F/i/eCJsjmHpBTHIvguLFHlmM5NhLSO7eR/C/uM4hztjUDZ69+/rNX0ZgDRi7ot1D
	 sT9TD+/5CbBuu0b5tQbMgipt2hrCXz3B7hUGqT4+oOsBuRqU2JpTqWPv91YJHu/j/N
	 KuDSQOhMzru9g==
Date: Mon, 6 Apr 2026 18:42:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sean Smith <defendthedisabled@gmail.com>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	dsterba@suse.com, david@fromorbit.com, brauner@kernel.org,
	osandov@osandov.com, hirofumi@mail.parknet.co.jp,
	linkinjeon@kernel.org
Subject: Re: [RFC PATCH v1 0/6] provenance_time (ptime): a new settable
 timestamp for cross-filesystem provenance
Message-ID: <20260407014129.GC6192@frogsfrogsfrogs>
References: <20260405225442.GA1763@macsyma-wired.lan>
 <20260407000558.417-1-DefendTheDisabled@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260407000558.417-1-DefendTheDisabled@gmail.com>

[drop almaz because the kernel.org mailer immediately refused]

On Mon, Apr 06, 2026 at 07:05:55PM -0500, Sean Smith wrote:
> [written with AI assistance]
> 
> On Sun, Apr 05, 2026 at 06:54:42PM -0400, Theodore Tso wrote:
> 
> Thanks for the substantive engagement — it helps clarify where
> the proposal needs to justify itself.
> 
> > On Sun, Apr 05, 2026 at 02:49:56PM -0500, Sean Smith wrote:
> > > 
> > >   1. Application atomic saves destroy xattrs. Programs that save
> > >      via write-to-temp + rename() replace the inode, permanently
> > >      destroying all extended attributes. Only the VFS sees both
> > >      inodes during rename -- no userspace mechanism can intercept
> > >      this and copy metadata across.
> > 
> > The VFS could potentially copy the xattr on a rename, no?
> 
> It could, but even scoping to user.* means adding conditional
> xattr-copy logic into every filesystem's rename handler — with
> dynamic allocation and xattr tree lookups on a hot path. ptime
> avoids this: one inline inode field, clear semantics, same VFS
> patterns as atime/mtime/btime.
> 
> > >   2. Every tool in the copy chain must explicitly opt in to xattr
> > >      preservation. cp requires --preserve=xattr, rsync requires -X,
> > >      tar requires --xattrs. Each missing flag causes silent data
> > >      loss. Transparent preservation through arbitrary tool flows
> > >      is not achievable in userspace.
> > 
> > But this is true for your proposed ptime as well.  You have to change
> > every single tool to copy over the ptime.  Worse, you have to change
> > the format of tar in a non-standard on-disk format change to support
> > this new ptime timestamp.  And rsync will require a non-standard
> > protocol change to support the new timestamp.
> 
> You are right that copy tools require patches. If ptime only
> improved the copy-tool situation, I would agree it does not
> justify new kernel surface over xattrs.
> 
> The structural difference is in the default adoption path.
> xattr preservation is permanently per-invocation opt-in: each
> tool call needs the correct flag, and the default is to drop
> them. A kernel timestamp exposed through statx/utimensat
> follows the same API pattern as mtime — standard libraries
> and tools naturally evolve to preserve all standard timestamps
> by default. ptime has a path to default-preservation that
> xattrs structurally cannot reach.

"Standard"... I was about to write a sardonic reply here, but then I
remembred that Linux finally *does* have a standard means to transfer
some of those newer file attributes: file_getattr/file_setattr.

(Go Andrey!)

So, I guess all you really need to do is extend struct file_attr and now
userspace has a fairly convenient means to propagate the provenance
time. :)

> On the formats: the tar patch uses a vendor-prefixed PAX
> header (SCHILY.ptime), backward-compatible — old readers
> ignore it cleanly. The rsync patch plugs into the existing
> --crtimes machinery that already supports macOS and Cygwin.
> 
> > > Atomic saves are the default behavior of mainstream applications
> > > (LibreOffice, Vim, Kate, etc.).
> > 
> > You will also have to change mainstream applications to copy ptime
> > from the original file to the file.new before the atomic rename.
> > Using ptime doesn't change this.  So you will need to make this
> > non-standard, Linux-specific change to all of these mainstream
> > applications.
> 
> This is where the cover letter was not clear enough, and it
> is the core reason ptime must be a kernel timestamp.
> 
> The patches implement rename-over preservation in all 5
> filesystem rename handlers. When rename(source, target)
> replaces an existing file, and the source has ptime=0 (the
> default for any newly-created temp file) while the target
> has ptime != 0, the filesystem copies the target's ptime to
> the source before destroying the target's inode. This runs
> inside the rename transaction, atomic with the rename itself.
> 
> Most GUI applications — LibreOffice, Kate, Qt and GNOME
> apps — save via write-to-temp + rename-over-original. For
> these, ptime survives automatically with no application
> changes:
> 
>   1. App writes to temp file              (ptime = 0)
>   2. rename(temp, document.odt)
>   3. Kernel: source ptime=0, target!=0 -> copies ptime
>   4. ptime preserved. No app change.
> 
> This is not universal: editors that use rename-away +
> create-new (Vim with default backupcopy=no, Emacs) do not
> trigger rename-over, and the spec documents this as a known
> limitation. But the write-to-temp + rename-over pattern is
> the dominant GUI save path, and the kernel handles it
> transparently — something no xattr mechanism can provide
> without application cooperation.

So does the provenance time cover just the file's contents, or the other
attributes and xattrs?

The reason I ask is, does the ptime get copied over for an FICLONE,
which maps all of one file's data blocks into another?

And by extension, would it also need to be exchanged if you told
XFS_IOC_EXCHANGE_RANGE to exchange all contents between two files?

(I know, I know, you said XFS was TBDHBD ;))

Last question: Is the provenance time only useful if the file is
immutable?  Either directly via chattr +i, or by enabling fsverity?

--D

> > Is it worth it?  It's a huge amount of cost being spread across a very
> > large part of the open source ecosystem just this fairly narrow use
> > case.  Personally, I'm not convinced it's worth the effort.
> 
> I think the use case is broader than I conveyed. Any workflow
> that copies files from NTFS, APFS, or HFS+ onto native Linux
> filesystems loses user-visible creation time unless carried
> out-of-band. This affects personal migrations, enterprise
> backups, dual-boot users, and professional workflows in
> photography, legal, scientific data, and media production.
> Windows, macOS, and SMB have supported a settable creation
> timestamp for decades — Linux is the outlier.
> 
> Users already expend significant resources working around
> this gap — metadata manifests, scripts to stamp creation
> dates into filenames or xattrs, side-channel databases —
> or simply accept the data loss. The cost is already being
> paid, continuously and redundantly across the ecosystem.
> One upstream investment in ptime converts that distributed
> ongoing cost into a bounded effort.
> 
> ptime is separate from btime by design: it preserves btime's
> value as immutable forensic metadata while providing a
> settable timestamp that travels with file content across
> filesystem boundaries.
> 
> On ecosystem cost: the kernel surface is ~240 lines across
> 28 files. For context, I am a disabled Medicaid recipient
> who came to this from a disability rights litigation
> workflow — I need file provenance preserved across an
> NTFS-to-Btrfs migration for legal work. The complete
> implementation — kernel patches across 5 filesystems,
> tool patches, and xfstests — was produced in a few days using 
> agentic development tools, which suggests the adoption cost may 
> be meaningfully lower than traditional estimates as these 
> tools become available across the ecosystem.
> 
> I understand a new timestamp is permanent API surface and
> the bar should be high. My claim is that rename-over
> preservation — automatic ptime survival through application
> saves, without application changes — makes this materially
> different from an xattr workaround, and justifies that cost.
> 
> Sean
> 
