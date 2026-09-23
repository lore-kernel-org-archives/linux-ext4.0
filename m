Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699A82C21DF
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 18:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790186482; cv=none; b=qEC+E0WtWaGxEe8igxrJV7eqSehxoF03brzX+DeKryy3Gi2GiQHaXpfaKeJZPflhY/keIAjnCHOKC+n8ETvtfYGgQRRiG3ZSTn66lXUQIgcN2ED5QYu8cRspkLvTagH4sj5iudhdwDrC3qMry2DXde/WF8nsC9/V942joRtVfqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790186482; c=relaxed/simple;
	bh=Tm7sl7NGWloS+2ZBH58j+BgHDNvX0yCchKJYZNRWBUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tSamHyZ+IFX7Hu2Xlbhq68XIbPE9PpVUkDG2fcEkWmcNDTNP+R4u1BLL4bKjAMbcUd/jZ3LhLT537i7AQEzlLIH/ZWIPh0gkSXnXNmTVfmsH7t/zd9w28Ibid0rh7C8mp3hZaKcfYNphY6Fo5gISbLSpaQG0gkDfoJ/wSzWAlZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e4k/s9Z6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e4k/s9Z6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43B01F00898;
	Wed, 23 Sep 2026 18:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790186481;
	bh=Nq4sDOnQYuAMueeF6eNLwsN00DoistE8A7BtPya20Fw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e4k/s9Z6/nJ1T5LNL6xQuspTUv4P+mHFKRitQ2Jj61v5MTOSgu4J5uhAc1HxDgHXW
	 t/Dwvm+JoU9LykYFJaMIFO5on/HQtd05dnhiRIH7TTsql8C9uJTD5y8Y3ULnYKhHgt
	 TfGrj3skfBjZsXJLtQpUTd79PIBTSt8LKEWVuwB+8PGJXcV8FeuinQfykOdfEOlSIL
	 cmOVLFsVHYjIxWA9rNAzd7OUsLZAmRjilh4R8c7u7iRr/jKITLfhFLLZMhqIOuJsJk
	 kZI9Sgts54OKOkhP1gIRIBDRkHSBAT/UJ8VZHALylJoVRfr+HCyvfwcKSmxYcqo6MC
	 KsnsKWECgfD2g==
Date: Wed, 23 Sep 2026 18:01:19 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: Alberto Garcia <berto@igalia.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
Message-ID: <20260923180119.GA1506901@google.com>
References: <arO0KE9_Jf8rNRwN@igalia.com>
 <38d9a34b-0547-45f0-b8b3-64da1f913058@linux.alibaba.com>
 <arPIrtWTXUTwqxFC@igalia.com>
 <cbbfa461-c770-457d-bfc6-317d744f1dcd@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbbfa461-c770-457d-bfc6-317d744f1dcd@linux.alibaba.com>

On Wed, Sep 23, 2026 at 09:28:54PM +0800, Baokun Li wrote:
> On 2026/9/23 20:40, Alberto Garcia wrote:
> > On Wed, Sep 23, 2026 at 08:12:03PM +0800, Baokun Li wrote:
> >>> 1) Enable encryption on an ext4 filesystem with tune2fs -O encrypt
> >> Is it valid to enable encrypt at mount time?
> > Good question, I always understood that it was allowed and tune2fs
> > certainly doesn't forbid it (compare with casefold):
> >
> > https://github.com/tytso/e2fsprogs/blob/v1.47.4/misc/tune2fs.c#L1599
> >
> > Berto
> 
> 
> If enabling encryption on a mounted ext4 fs is allowed,
> I think the current change is fine.
> 
> Ted, Eric - would either of you know the details here?

Yes, it is allowed.

The proposed patch looks good, even though the problem seems to be gone
on mainline already due to the removal of the code path that used the
non-large-folio-compatible function fscrypt_encrypt_pagecache_blocks().

There can be another patch that removes both that check and the
mount-time check, if they're truly no longer needed (I don't know of any
reason why they would be, but it needs to be properly tested).

- Eric
