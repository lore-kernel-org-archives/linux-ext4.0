Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DE13624AA;
	Tue,  7 Apr 2026 15:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775575036; cv=none; b=SsHL33ImaNkCjN5eABKjuhpw4Iow69Z4FxfONY6143ETsK6bCOV9G6ZWqYZXHKEhQdS3tLBo4OzZBv1WV/11SCrzXia1HoFST9U6MSJ3xI+HziVg6kS5/WxK4v4/bFPXevCxGuYDiYYLK3/jMZwZ62ptOyBDJDU9B4Ba6xgaArc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775575036; c=relaxed/simple;
	bh=fs4VZ2EY//mQx/p8Z2S5c9nBZLOU+YLylsBN7JyjZZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WvhZPyH2SoZxxegbBZ8ScI0R2hTzKB0l7OyMompajUzrj2Jnyt0WEHn7Utez1J2lj/mswq62U8VXKPQP/kVC6d7doThQPrxl3d9WzlH3kwGbBAdkoagg1tZU4TqiEbt8368UYWJJe8WDZyrv3jOXqDg2aMIX5WvrufwbLjSj1kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgsmt5li; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgsmt5li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10202C116C6;
	Tue,  7 Apr 2026 15:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775575034;
	bh=fs4VZ2EY//mQx/p8Z2S5c9nBZLOU+YLylsBN7JyjZZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jgsmt5lia/FU62K2mMQ0ojqx6T5Laf7BhTYb4Cv4uUiZCqVmiFOPA8L7gpb+40UbD
	 IT9ajiG2LTblQJanFF8nUX0w6NF4eSvcu6Buh1F+W00toL9IIz4u2pVU3H2b2URQ49
	 g4RTPhBRnPTL9+qXti0OhRCTblV9X/YHE7126S5PzQ3sQJCsmPHpTTU0X6qkoN+cPS
	 QNDCoVqHzs24knRuGZ+f0k7fAS9o1GvnEA2xHmwqcUjdXfAkdN99ekYGB4U1gkzKKi
	 mqS1E7nlPrCHGPvbDs6tJC8y4a9pzD5Gk+XmmvbygmhciQ0oRJbl9OgHNCQyr68Fsg
	 Cmm+0pOywIZqQ==
Date: Tue, 7 Apr 2026 08:17:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sean Smith <defendthedisabled@gmail.com>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	dsterba@suse.com, david@fromorbit.com, brauner@kernel.org,
	osandov@osandov.com, hirofumi@mail.parknet.co.jp,
	linkinjeon@kernel.org
Subject: Re: [RFC PATCH v1 0/6] provenance_time (ptime): a new settable
 timestamp for cross-filesystem provenance
Message-ID: <20260407151713.GM6202@frogsfrogsfrogs>
References: <20260405225442.GA1763@macsyma-wired.lan>
 <20260407000558.417-1-DefendTheDisabled@gmail.com>
 <20260407014129.GC6192@frogsfrogsfrogs>
 <e5be4e66-5fb0-41d3-807f-d26f78949c3d@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e5be4e66-5fb0-41d3-807f-d26f78949c3d@gmail.com>

On Tue, Apr 07, 2026 at 01:06:09AM -0500, Sean Smith wrote:
> 
> [written with AI assistance]
> 
> On 4/6/2026 20:42, Darrick J. Wong wrote:
> 
> > "Standard"... I was about to write a sardonic reply here, but then I
> > remembred that Linux finally *does* have a standard means to transfer
> > some of those newer file attributes: file_getattr/file_setattr.
> >
> > (Go Andrey!)
> >
> > So, I guess all you really need to do is extend struct file_attr and now
> > userspace has a fairly convenient means to propagate the provenance
> > time. 🙂
> 
> Thank you for pointing to file_getattr/file_setattr — this
> is a significantly better API path than our utimensat
> extension. The size-versioned struct file_attr eliminates
> the glibc times[2] limitation entirely, which was one of
> the main upstream concerns with the current approach.
> 
> We will investigate extending struct file_attr with ptime
> fields for v2. The on-disk storage across all 5 filesystems
> and the rename-over preservation are API-independent and
> would remain unchanged. The change is re-plumbing the
> userspace write path from utimensat to file_setattr.
> 
> Two design questions:
> 
> Would you recommend fa_ptime_sec (__u64) + fa_ptime_nsec
> (__u32) matching the statx timespec pattern, or a different
> representation?

That uses less space in the struct, so yes.

> Pali Rohar has announced plans for mask fields in file_attr.
> Should we coordinate with his mask work so ptime can be
> selectively set without read-modify-write?

fa_xflags already provides that coverage for the other fields in struct
file_attr, e.g. a getattr caller can ignore fa_extsize if
FS_XFLAG_EXTSIZE isn't set; and setattr will (iirc) reject nonzero
fa_extsize if FS_XFLAG_EXTSIZE isn't set.

Pali Rohar's work would make it possible to discover which fa_xflags
fields are settable or clearable for a given file.

> > So does the provenance time cover just the file's contents, or the other
> > attributes and xattrs?
> 
> Content only. ptime records when the file's data first came
> into existence. Metadata changes (permissions, owner,
> xattrs) update ctime but leave ptime unchanged. This
> matches the semantics of Windows Date Created and macOS
> creation time.
> 
> > The reason I ask is, does the ptime get copied over for an FICLONE,
> > which maps all of one file's data blocks into another?
> 
> It should, conceptually — the content's provenance doesn't
> change when you clone it. Currently FICLONE shares data
> extents but does not copy inode metadata (timestamps,
> permissions), so ptime would not be automatically
> preserved. The calling tool (e.g., cp --reflink) handles
> timestamp copying separately via the write path.
> 
> The question is whether FICLONE should be enhanced to copy
> ptime from source to destination at the kernel level —
> similar to how rename-over preserves ptime. There is an
> argument for it: if the kernel handles provenance during
> clone, tools don't need to know. But FICLONE doesn't
> currently copy mtime either, so adding ptime alone would
> be inconsistent. Worth discussing.

FICLONE is currently treated like a write, which means that mtime is
updated on the destination file.  For filesystems supporting ptime you'd
probably want the kernel to copy the ptime from src to dest after the
remapping completes.

(Same for exchange-range)

> Btrfs subvolume snapshots are a different case — they do
> preserve ptime because the inodes are COW copies of the
> originals.
> 
> > And by extension, would it also need to be exchanged if you told
> > XFS_IOC_EXCHANGE_RANGE to exchange all contents between two files?
> 
> Yes — if the content moves, the provenance should move
> with it. If files A and B exchange data extents, their
> ptimes should swap. ptime follows the content, not the
> inode identity.
> 
> > (I know, I know, you said XFS was TBDHBD ;))
> 
> Worth considering for a future XFS implementation — and
> the file_attr route you suggested would give XFS a clean
> integration path for ptime alongside FICLONE and
> EXCHANGE_RANGE.
> 
> > Last question: Is the provenance time only useful if the file is
> > immutable?  Either directly via chattr +i, or by enabling fsverity?
> 
> No — ptime is useful regardless of mutability. It records
> when the document was born, the same way Windows Date
> Created works. Editing a document updates mtime but not
> the creation date. Both are independently valuable:
> 
>   ptime: "This file was first created March 15, 2019"
>   mtime: "It was last modified today"
>   btime: "This inode was created when I copied it here"
> 
> Immutable files (chattr +i, fsverity) are a special case
> where ptime has extra forensic strength — the content
> provably hasn't changed since the provenance date. But for
> the primary use case — preserving creation dates across
> cross-platform migrations — mutability doesn't diminish
> ptime's value. A document's creation date remains meaningful
> regardless of subsequent edits.

Got it.

--D

> Sean
> 
> 
> 
