Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AFC3290D8
	for <linux-ext4@vger.kernel.org>; Sun, 22 Mar 2026 20:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774211541; cv=none; b=a/GdZGg2WWzehT0Ljc/h7HJxnwQ1p+LUdnAwLSQEiL23Zc/DoOqNWeNfcxD3pKq/efGUCdHB5ub48XTK1VBnxfke7Wbt68FyYM3j/g1GYSH5yxMqBJvoix0zJNUg5AiMJxo1HD2LwVjliBk9MF85y8wznLpBoOsR+0SidZGigvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774211541; c=relaxed/simple;
	bh=tM+/UY328FJDNiZwa35a9co2Q3qPVhE18Ea4eeQLv6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n3ZK2shZjmDMXL0mHIeKYN2Yu9rMGXU/+5cCOiUcUVQNQ5sLFZe+noxifJRISuvO+fiyJr4VKrgmX+KLtQdbozsvLnm2v9ud7+rjQSk1hvH+/3ngM2q4nI/eLRGSqL9znsaCBggNdoGiHtQ2NjBH86rtzuvgdQQkOfuCtHQWJIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=dNbRzOag; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="dNbRzOag"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62MKVqWO017077
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Mar 2026 16:31:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774211514; bh=iEccsDOzEp4fu19KyZY9/xIJr6KjvuxTLq/e+HCMxE0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=dNbRzOagN6ZIOGtlHfaiHxuohKPBc/VNrAq4z6Uhd6jsV0UYRe8vypeoBL94lYcOn
	 F7Nycjl28BFgQYoEJ1jGS2GF3TU0qREcVKlJvdC76UPd3DjYkHoiuD4K7keFFP+t1t
	 /hTwKkKTi4JrTCi9ACoIx6N6jZPjGTqe332HRULizwR/Q8IToauxZ63tLz32ejLCWY
	 H7FDoeLrj6XFBiCLySZIMH+0geh7ikAZ9sBKO0yr5P2BXPjS39BE5ZBiuMku3yYbw5
	 I7YjOQ/sa9t3jxVzH55EKuAn1GznCygf3qbudLWA3HBsZlMINZH4AbeILu7ex+jVoG
	 qkJ+8fdPnJsUw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 0817D5EC2E65; Sun, 22 Mar 2026 15:31:52 -0500 (CDT)
Date: Sun, 22 Mar 2026 15:31:51 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Anand Jain <asj@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/3] fix s_uuid and f_fsid consistency for cloned
 filesystems
Message-ID: <20260322203151.GA98947@mac.lan>
References: <cover.1772095546.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1772095546.git.asj@kernel.org>

On Thu, Feb 26, 2026 at 10:23:32PM +0800, Anand Jain wrote:
> 
>               | s_uuid  f_fsid
> --------------|---------------------------
> EXT4          | same    same
> Btrfs         | random  random
> XFS           | same    f(devt)
> EXT4-patched  | same    f(devt)
> Btrfs-patched | same    f(s_uuid,rootid,devt)

I don't *object* to changing ext4 reports since having something that
is unique is probably better.  However, my bigger concern is using
f_fsid in the first place.  It's only 64 bits, and that's really not
enough to gaurantee uniqueness.  And even as you've proposed to change
things, it's not consistent across file systems.  In particular, your
proposed solution mixes s_uuid into btrfs-patched, but not
ext4-patched.  Why?

> Problem
> -------
> Btrfs currently never duplicates s_uuid or f_fsid for cloned filesystems.
> When an fsid collision is detected at mount time, btrfs generates a new
> in-memory fsid (temp_fsid), but this is ephemeral — it changes on every
> mount. This has two consequences:
> 
> 1. IMA (Integrity Measurement Architecture) cannot reliably track the
>    filesystem across mount-cycle, since the f_fsid it sees keeps changing.
>    This does not scale. Whereas on the otherhand if you have same s_uuid
>    on multiple filesystems, monitoring per distint filesystem is lost.

The problem with using f(dev_t) for IMA is that if you have a
removable device (e.g., an SD card), reporting f_fsid as purely being
a function of dev_t means that the if an SD card ejected, and replaced
with another, the fsid_t will manifestly *not* be unique.  So in that
sense, replace f(dev_t) with f(s_uuid) would be worse if you think
"file system unique id" should be unique in the case of removable
storage devices.

If the audit log includes mounts and unmounts, then this might not be
fatal.  But if less-than intelligent system administrator or LLM tries
to analyize an audit log using tools like "grep", it would be pretty
easy for someone to get misled.

I know you were primarily interested in cloned file systems, but I
think we also need to take into account other cases, including ones
where there might be more the file system associated with a block
device over time.

> 2. If we instead allow cloned filesystems to share the same f_fsid (as
>    ext4 currently does), fanotify loses the ability to distinguish
>    between distinct filesystem instances. FAN_EVENT_INFO_TYPE_FID events
>    will fail to resolve to the correct mountpoint when f_fsid values
>    are identical across clones.

My personal opinion is that f_fsuid is just a terrible interface, the
fact that IMA and fanotify used this is regrettable.  I understand why
it happened, because there wasn't anything better, and for many use
cases, it's good enough.   But not all.

So I hope we can just actively discourage anyone else using it.  Given
that exactly it has not been standardized, across different operating
systems, and different file systems for Linux --- hopefully most
people will have already made that choice.

						- Ted
