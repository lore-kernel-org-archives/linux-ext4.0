Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.89.141.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794938363;
	b=mH6jvG2OI6u1mKKURunN8AWBiB5Hda7CvsOgzEOzcnjYC7rgOiO8h33g8UILDQLFiZ+8
	 aG7TBO+tl3FBQio42gKLWVNvuGJldUpTlOa9TL0eqoezCXX8PpAwOsR1DC5HdyTXLfl6P
	 ersGv1mIcNR20O4+/cl4YCcWx1kA0GTLBgFN4u7zKgT2kCzbO+KizNf0lKGm2/2kxj2Cs
	 VgRcPERUQ+9DAgTfcK0kbhSth8j0uoIQXor20mDMfnESgFGOqAfdzK2WDJR0JIF0yngfh
	 Z9zCx9TecRsMwHBR51zsNzbs3rc0oFxkk5VHeR/eMc4XM8HnX8rijj/Aij3uMrlsMyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794938363;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:Sender;
	bh=k/LpWY5KUfJWDsk5FQz9MJ7AFM3pBZFBjow0OZbAt5g=;
	b=dY4rBlQKPlvCFZhBkziq8dPcF9ONQRTQKWzWF5VFFoFZk45QNviVsbpINsQsorDNAcZ8
	 uL/YO9ajfhknZaeZtQ9QszoqOl/o875hwPJc0Q/BrkLVFrwu/O3qXrUMjbYk/A7JnLplx
	 mBBHf7L6Sb1v+UBuKhKYE4svlAMj+BOT3igKshliWaFMdamWvNOWNYyU9znkphfkRg7CR
	 qAXljVcsyEXHWo4rRKWjLH9mmqpvpMeLq3KE1I0KgrPwpRxwr7O1MFZod5VsK4aReQyUp
	 3gV7WD4u24p27Hk9Yj2/+jFfU5OhpSRvnLt/Owmai5H0qDtIZtWAm2oOikxyQH5ae1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=zeniv.linux.org.uk;
	spf=none smtp.mailfrom=ftp.linux.org.uk;
	arc=none smtp.remote-ip=62.89.141.173
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E676E606A31C;
	Tue, 17 Nov 2026 17:59:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E676E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=k/LpWY5KUfJWDsk5FQz9MJ7AFM3pBZFBjow0OZbAt5g=; b=uPUfOMorYVWSloBmur3+jTWfN0
	/cucEqJPX9ROXNS2Nts4ejxMitj7HKce5BP223k/EVYDvr6meZVWcSR2bDaawotGyswtu3/9RgBdQ
	AM+ACyr1j9xK/5VZyXDH8KM7kA/6anBcqZxRuPjG8zfAFPMgFMBD9KrOE+CaSf37vOfUO0TLsaRTd
	im/RcrikIEZHnc6zmCFGfzF1R7mCFc/8qx6j80lHa9otWtWhRUbjLGB6XfPsB8Z6/f0PdlSnLHkBP
	TuKeIF9ztx35seJ03QlLJqpfLfZMGX4HSJFLM/njHPzgrPvXQcY3cyUbMGy5W0eQGY4CX+x1AZ+LT
	8AuxY6ww==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTNSf-00000001zpb-0Jnf;
	Tue, 17 Nov 2026 17:59:17 +0000
Date: Tue, 17 Nov 2026 17:59:17 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: David Laight <david.laight.linux@gmail.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Sarthak Kukreti <sarthakkukreti@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
	Eric Biggers <ebiggers@google.com>,
	Dmitry Torokhov <dtor@google.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] libfs: reject casefolded names that fold to ".",
 "..", or empty
Message-ID: <20261117175917.GO989762@ZenIV>
References: <20261113065332.929085-1-sarthakkukreti@google.com>
 <20261113065332.929085-2-sarthakkukreti@google.com>
 <878q2swoxp.fsf@cartola>
 <avu0X5E298dHRBHY@mit.edu>
 <20261117084727.0cfa196a@pumpkin>
 <avxe5v6r1C7ZG7E2@mit.edu>
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
In-Reply-To: <avxe5v6r1C7ZG7E2@mit.edu>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Nov 17, 2026 at 09:54:32AM -0500, Theodore Tso wrote:
> On Tue, Nov 17, 2026 at 08:47:27AM -0500, David Laight wrote:
> > > Sigh... I really think these characters are *evil*.  I wonder if we
> > > should simply drop those code points unconditionally when they are fed
> > > to the kernel --- not only folding to themselves, but *not* preserving
> > > them when a misguided application tries to create a file with one of
> > > these misbegotten Unicode charactesr.
> > 
> > Doesn't that assume that filenames are UTF8 rather than just sequences
> > of bytes with everything except '\0' and '/' being valid.
> > Casefolding is itself so evil/impossible it shouldn't have been allowed.
> 
> We would only do this if casefolding is enabled.

Which is to say, on any distro kernel.  Besides, it's not just a matter of
filtering that dreck out on getname() and friends (syscall boundary won't
do at all due to the things like binfmt_misc opening files, etc.) - you'd
need to scan what you get upon ->get_link() as well.

> For better or for
> worse, it's better than what it replaced which was this terrible
> wrapfs hack that was a trivial to trigger deadlocks using fsstress ---
> which was even more evil.
> 
> The other way we can deal with this is that if case folding is
> enabled, we change the VFS to call the case-folding for incoming
> filename *before* it does its special case checking for '.' and '..'
> if casefolding is enabled.

That would penalize every pathname resolution, whether that misfeature is
stepped into or not; hash_name() is fairly hot.

'.' and '..' should be recognized only as literal octet sequences 0x2e
and 0x2e 0x2e; if some misguided filesystem decides to treat something
else as equivalent to those, it bloody well ought to recognize and reject
that something else in its ->lookup() (or ->d_hash(), for that matter).
