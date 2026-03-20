Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4E333EAED
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 12:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774010015; cv=none; b=GhE19tr45CJ9Pw4dfPc2VSSF1ly1GK1DuqqN8zf6nokTfTJsedmEBFCugszv4AUXnBbIHmb5pDUtN7sRAOOhujMeX1iUzkUKoykeo8SGUs7XjLY+S/4ce4jl/qkVRDHVAKPbWio1eACfKVohmGiA/ROeheRBsARpucZ4O5Efn5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774010015; c=relaxed/simple;
	bh=yeCICO2tMCoVr2w7g106Z2YCxGWedOQPQY6gDlOwXZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TB/0rRxpd8E+EfPaWTjGh2Yn7hYv1MGe+hHvxXkT1oOMYyzApLfl+nyULQiAu9ksZm9VmwCPtFCtH8JKm7GBr1/XYPn/W88mTJWpvsHv5ihdEXjDmxc3jKjfm0hV014inSz6tpMgq0L3atqihU8LWQMyB6OKQ0CIxS6fm1Ap/Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=HxhlHMyN; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="HxhlHMyN"
Received: from macsyma.thunk.org (pool-173-48-82-49.bstnma.fios.verizon.net [173.48.82.49])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62KCXNnP004857
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Mar 2026 08:33:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774010005; bh=FqdV8jVF6ciRgFNzbaoO3n2lL2YXzcLmpNd21f4CeYI=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=HxhlHMyNId2szpCYj4/9iN/y7bz7OA9meDqC8/uVDpig31it4a8bNbcgb9G6n5HOe
	 Hgtc0fVT+VmBmkQfbQY6imne/nvSQJo2NATdIVToOhaYgFLLoFsgxkiloMxArwjFWc
	 MQID7a4TJYfE40LRUW54NVFPLsa0EsJptAa/r1AIueDnm7o2JVACGJZKFZFwZ4PGIv
	 QfoaKPoMlGXmjyLAYJLW3tKeRZcRlrXaLq4ItDCIy709/Ojjm9ZllfPmk/LR6L6UeM
	 e/ASZT1D8Q5UYxfCJrnPxpXcdovfVSAkmgrew0V/8NzotOdxFcZbLyWCAdv+wXKfGV
	 wjf5bSHb/cNmA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id C97545E73C10; Fri, 20 Mar 2026 08:32:22 -0400 (EDT)
Date: Fri, 20 Mar 2026 08:32:22 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: adilger.kernel@dilger.ca, tahsin@google.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        r33s3n6@gmail.com, zzzccc427@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: xattr: fix out-of-bounds access in
 ext4_xattr_set_entry
Message-ID: <20260320123222.GC14752@macsyma-wired.lan>
References: <20260318075842.3341370-1-gality369@gmail.com>
 <20260318144509.GA82331@macsyma-wired.lan>
 <CAOmEq9Uq5xMvhT7cyoY2uhSBhwSEEJ1vYRY36N4sxZSPCO1S8w@mail.gmail.com>
 <20260319135826.GA91368@macsyma-wired.lan>
 <CAOmEq9VAW_a7RsSPquy0_eJOLP4aHOWvwTtzmeLUPXpy85xJvw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOmEq9VAW_a7RsSPquy0_eJOLP4aHOWvwTtzmeLUPXpy85xJvw@mail.gmail.com>

On Fri, Mar 20, 2026 at 03:43:21PM +0800, ZhengYuan Huang wrote:
> 
> There seem to be three layers of defense: fsck, mount-time checks, and
> runtime checks.

Within runtime checks, there are those checks that are done the first
time metadata is loaded from disk --- for example, see the checks in
__ext4_iget() and the functions it calls, such as check_igot_inode().

And then there are checks that are done in hotpaths, since at least in
theory, a stupid system administrator which makes a block device be
world-writeable and so a malicious or accidental actor could modify
the copy of the metadata in the buffer cache.  Those are the ones
sorts of runtime checks we sould try to avoid.

Mount-time checks tend to be those that validate superblock and block
group descriptor contents.  They can't validate all of the inodes
because that would take a lot longer.

> Would it be more accurate to understand the boundary
> this way: once the filesystem metadata has passed mount-time
> validation (even if it would not necessarily pass fsck), the
> filesystem is still expected to handle later errors gracefully rather
> than crash?

It is a nice to have that a file system, should handle errors
gracefully rather than crash.  However, if the inconsistency would
have been caught and corrected by fsck, I don't consider it a
CVE-worthy security bug, but rather a quality-of-implementation bug.

This is important, because there are risks associated with rolling out
a new kernel to hundreds of thousands of machines, or using live
patching to fix high severity security bugs.  If the issue could have
been caught by fsck, and a competently administered system *does* run
fsck at boot time (such as at $WORK), the cost benefit ratio of
treating such bugs as security bugs doesn't make sense.

> More specifically, for inconsistencies that arise at runtime, is the
> general expectation that they are outside the filesystem's
> responsibility and should instead be handled by other layers (for
> example, lower-level storage redundancy / RAID)? Or is there still
> room for defensive checks in the filesystem, as long as they are done
> outside hot paths?

This would be on a case by case basis.  If the check is *super* cheap,
and it's done outside of a hotpath --- say, when a file is first
opened.  And if doesn't cause long-term maintenance issues, it is
comething that could be considered.  But in terms of the priority of
dealing with such patches, it is not something that would be
considered high priority.  Perhaps just a step above spelling or
grammer fixes in comments.  :-)

Consider that for a enterprise hard drives, the bit error rate is 1 in
10**15.  And the chances that such as a bit error would be cause a
metadata inconsistency that would lead to a crash has to be factored
in.  If we had infinite resources, it might be something that would be
considered higher priority, but in the real world, when the
opportunity cost of having software engineers working on other
improvements, it's not necessarily going to be a compelling business
case when I go to my management asking for more headcount.  And if you
are an academic, perhaps the impact of such work might also be called
into question.

Cheers,

						- Ted
