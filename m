Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9991391
	for <linux-ext4@vger.kernel.org>; Tue,  7 Apr 2026 00:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775520378; cv=none; b=f4Ozb+obhV20rQxi5WM6lLVou1ZHUi+HWim5gcMQBHJPVF3gVpFMwL1ev/LEHbpH5dQeI8LDlKlsEyv6HeWR7J4YJhzjMNWGG92Yrg5G6UZXq7FUxu913/FIbTJ7dqMwXOAEkiAJmbiApwzsE750zQVs+sCqoClr2bo3jdFE2mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775520378; c=relaxed/simple;
	bh=pbj+2DNzQ488rZE5wsUUXkMbr4pEgJwxXa4D6G2pHgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sL9u+KK8Ds0q2H5N9DuRJ4bD44+NDNzeJl2wqXvouOehoQValsR7N4IlpMBj6eHTgVshRMWkMFlWM9Cf9QlosTVyfnWsxPRU7hWKGNzYJ8xfslz4Tj6v2Snw6SJyV0YaN8zvYKoV9ouc25NmLXT/bwh6USZYmjgxmgBBBMxGAi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KB/XCZPE; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KB/XCZPE"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-4648447e29bso1138422b6e.0
        for <linux-ext4@vger.kernel.org>; Mon, 06 Apr 2026 17:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775520376; x=1776125176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=55V4D/ehX3CNaBAUBfcX9JoEKWKh4l8j4IryuEySytc=;
        b=KB/XCZPE3MOdR6pmJxcdQlE+4YCBgTCdbsftnVu9zq2jMbL06HZoXO5d2zf/RadOud
         Wp2aTFTSxLLZr+yzxdBGWmT+F8en2aJLyKmGQO+mTvYpg635bGxvhfJjG65IMmAEQW3I
         OW55q6tRj39cyiEtdzxt8W/4DJVbJfEzj3dSQUbnuk0a2Mawx+NPdWNBO1s0Hyy9YPxK
         rrOQ6FAqfWVtkDWQdQUS/BMbvv04znBn0pZQdnE5MHq8+J4J7c0B4DTQeOmSeHxsyeZj
         uFc3MMMOac64nbLkcHhJc9FzYCempMiIqvD7R8PMGIpFVpsXPWLr7BEqZKG1QORjlRar
         vPIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775520376; x=1776125176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=55V4D/ehX3CNaBAUBfcX9JoEKWKh4l8j4IryuEySytc=;
        b=k9NzDYZJsMXCwNMizswUJyTfxLjEeoe3A4jzN7HbEth1jOOGPhiQ7XjY0auMRot3y1
         oG8YgOZnltbD77WzFJ4dxSsW+Vobs59nc0bv9zbqk2XyRhxXGFYQURjbyecKhAmH4Sa5
         9nKazYpsw5etwcJQ26nK9nh+1beau1TAHIJL/cIa7LZxPoUmVTSklmxSm2pjz1d2kX8B
         vqKl4zeuIoaSEBdnH2WJNmwGe6tOOH/s47QX7sBRbvqaacfEDHi/LVeoks1++uEKpUzC
         t4BaAxy4tlv8jQvzlkT69rFcB8XPGfDo1at1NHtYp1cw3R1AqYXLftnx79EJ0lrC2GyK
         HPig==
X-Forwarded-Encrypted: i=1; AJvYcCWXw0FKn0qT8mDH0/Ls5UM3XcPlPHXpf/akltNPcW28Loixyo6rafulZ+v7F1H0wE/VV2rc3pufgPtE@vger.kernel.org
X-Gm-Message-State: AOJu0YyrBz2kUo6uUhiU4clsd8jWh0qvaajcnrZ30E5Sso7OBuTHa+UA
	VkAQ0iHPncbUlD6Z41fHIxao6OgMf0c/DAoYEgfxzh8mVd6vOKXrPq5r
X-Gm-Gg: AeBDiesKKC3prMpm0i58tUhbsPWJ903sWwUH1P5VyZZs7arzbUsGhT6gl2rIirtmDcY
	1aPs+TK3iY7BrTNvJ5tEPBb09fFN9xgAveKvL5E8BvXrA3syyv03ve4g7CeH8VhF/+nd5IZCF3B
	o4qLA5n0DO89NmqhW96OnEeF8qql9WR2x1Wdqfn+SIV25kTS0Tkrmq0fEHVNupMelyzG0k9T4dK
	m6PiJCDxo61pH3UzuO9fWe/wicq0RQE4NO6HD2rSWMpTrskP7e5U7KUtwpIlPyv7IC57PkqATPJ
	F+akXhlIiT/YwbHnr12e2yupXQ4k9HudUxcyj7CxRNj5fcqRYL6bmaTh8ri9zEMmUEqDsl9FS3D
	4kktynBTVTa4rxc4zy68d7WuLSMSlzz/ER7+4olyaQWY3HLte6FK7gi9ACyKM3gh+ok69nz1FN5
	bs9XGR2AwPQHAVrbcBP0D2sOlREI6nk3Bs6nRRagoOdBWI+MTwon/6jUad9U5GO4U7W8Ur0j3o2
	ZnPilWH23Xm1fg=
X-Received: by 2002:a05:6808:4489:b0:467:cda:f15d with SMTP id 5614622812f47-46ef730616emr7590414b6e.26.1775520375967;
        Mon, 06 Apr 2026 17:06:15 -0700 (PDT)
Received: from localhost.localdomain (c-73-5-99-191.hsd1.la.comcast.net. [73.5.99.191])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46f46160155sm6450094b6e.17.2026.04.06.17.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 17:06:14 -0700 (PDT)
From: Sean Smith <defendthedisabled@gmail.com>
X-Google-Original-From: Sean Smith <DefendTheDisabled@gmail.com>
To: tytso@mit.edu
Cc: defendthedisabled@gmail.com,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	dsterba@suse.com,
	david@fromorbit.com,
	brauner@kernel.org,
	osandov@osandov.com,
	almaz@kernel.org,
	hirofumi@mail.parknet.co.jp,
	linkinjeon@kernel.org
Subject: Re: [RFC PATCH v1 0/6] provenance_time (ptime): a new settable timestamp for cross-filesystem provenance
Date: Mon,  6 Apr 2026 19:05:55 -0500
Message-ID: <20260407000558.417-1-DefendTheDisabled@gmail.com>
X-Mailer: git-send-email 2.51.0.windows.1
In-Reply-To: <20260405225442.GA1763@macsyma-wired.lan>
References: <20260405225442.GA1763@macsyma-wired.lan>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[written with AI assistance]

On Sun, Apr 05, 2026 at 06:54:42PM -0400, Theodore Tso wrote:

Thanks for the substantive engagement — it helps clarify where
the proposal needs to justify itself.

> On Sun, Apr 05, 2026 at 02:49:56PM -0500, Sean Smith wrote:
> > 
> >   1. Application atomic saves destroy xattrs. Programs that save
> >      via write-to-temp + rename() replace the inode, permanently
> >      destroying all extended attributes. Only the VFS sees both
> >      inodes during rename -- no userspace mechanism can intercept
> >      this and copy metadata across.
> 
> The VFS could potentially copy the xattr on a rename, no?

It could, but even scoping to user.* means adding conditional
xattr-copy logic into every filesystem's rename handler — with
dynamic allocation and xattr tree lookups on a hot path. ptime
avoids this: one inline inode field, clear semantics, same VFS
patterns as atime/mtime/btime.

> >   2. Every tool in the copy chain must explicitly opt in to xattr
> >      preservation. cp requires --preserve=xattr, rsync requires -X,
> >      tar requires --xattrs. Each missing flag causes silent data
> >      loss. Transparent preservation through arbitrary tool flows
> >      is not achievable in userspace.
> 
> But this is true for your proposed ptime as well.  You have to change
> every single tool to copy over the ptime.  Worse, you have to change
> the format of tar in a non-standard on-disk format change to support
> this new ptime timestamp.  And rsync will require a non-standard
> protocol change to support the new timestamp.

You are right that copy tools require patches. If ptime only
improved the copy-tool situation, I would agree it does not
justify new kernel surface over xattrs.

The structural difference is in the default adoption path.
xattr preservation is permanently per-invocation opt-in: each
tool call needs the correct flag, and the default is to drop
them. A kernel timestamp exposed through statx/utimensat
follows the same API pattern as mtime — standard libraries
and tools naturally evolve to preserve all standard timestamps
by default. ptime has a path to default-preservation that
xattrs structurally cannot reach.

On the formats: the tar patch uses a vendor-prefixed PAX
header (SCHILY.ptime), backward-compatible — old readers
ignore it cleanly. The rsync patch plugs into the existing
--crtimes machinery that already supports macOS and Cygwin.

> > Atomic saves are the default behavior of mainstream applications
> > (LibreOffice, Vim, Kate, etc.).
> 
> You will also have to change mainstream applications to copy ptime
> from the original file to the file.new before the atomic rename.
> Using ptime doesn't change this.  So you will need to make this
> non-standard, Linux-specific change to all of these mainstream
> applications.

This is where the cover letter was not clear enough, and it
is the core reason ptime must be a kernel timestamp.

The patches implement rename-over preservation in all 5
filesystem rename handlers. When rename(source, target)
replaces an existing file, and the source has ptime=0 (the
default for any newly-created temp file) while the target
has ptime != 0, the filesystem copies the target's ptime to
the source before destroying the target's inode. This runs
inside the rename transaction, atomic with the rename itself.

Most GUI applications — LibreOffice, Kate, Qt and GNOME
apps — save via write-to-temp + rename-over-original. For
these, ptime survives automatically with no application
changes:

  1. App writes to temp file              (ptime = 0)
  2. rename(temp, document.odt)
  3. Kernel: source ptime=0, target!=0 -> copies ptime
  4. ptime preserved. No app change.

This is not universal: editors that use rename-away +
create-new (Vim with default backupcopy=no, Emacs) do not
trigger rename-over, and the spec documents this as a known
limitation. But the write-to-temp + rename-over pattern is
the dominant GUI save path, and the kernel handles it
transparently — something no xattr mechanism can provide
without application cooperation.

> Is it worth it?  It's a huge amount of cost being spread across a very
> large part of the open source ecosystem just this fairly narrow use
> case.  Personally, I'm not convinced it's worth the effort.

I think the use case is broader than I conveyed. Any workflow
that copies files from NTFS, APFS, or HFS+ onto native Linux
filesystems loses user-visible creation time unless carried
out-of-band. This affects personal migrations, enterprise
backups, dual-boot users, and professional workflows in
photography, legal, scientific data, and media production.
Windows, macOS, and SMB have supported a settable creation
timestamp for decades — Linux is the outlier.

Users already expend significant resources working around
this gap — metadata manifests, scripts to stamp creation
dates into filenames or xattrs, side-channel databases —
or simply accept the data loss. The cost is already being
paid, continuously and redundantly across the ecosystem.
One upstream investment in ptime converts that distributed
ongoing cost into a bounded effort.

ptime is separate from btime by design: it preserves btime's
value as immutable forensic metadata while providing a
settable timestamp that travels with file content across
filesystem boundaries.

On ecosystem cost: the kernel surface is ~240 lines across
28 files. For context, I am a disabled Medicaid recipient
who came to this from a disability rights litigation
workflow — I need file provenance preserved across an
NTFS-to-Btrfs migration for legal work. The complete
implementation — kernel patches across 5 filesystems,
tool patches, and xfstests — was produced in a few days using 
agentic development tools, which suggests the adoption cost may 
be meaningfully lower than traditional estimates as these 
tools become available across the ecosystem.

I understand a new timestamp is permanent API surface and
the bar should be high. My claim is that rename-over
preservation — automatic ptime survival through application
saves, without application changes — makes this materially
different from an xattr workaround, and justifies that cost.

Sean
