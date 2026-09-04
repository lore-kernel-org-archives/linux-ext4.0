Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FB53A4F2C;
	Fri,  4 Sep 2026 10:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518144; cv=none; b=LkKqY8a32I6ihf6eaJeLolK9oMYiA1qU1n57okyXdT1Y3FXQXOxMEIMrJ0kO+A0aNBrgZ3ErYr5i4szqQMzATxrrXcgGSRMvm6GszebqRSbk6CrhSOF9FTPVbR66f/M5hEYvRPj2dBjsmWAwa0Y/9WBDOcYSfu2i/5lIocTZzy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518144; c=relaxed/simple;
	bh=yZHTDj0uSXPKj3B0POCGsgLLqHCSJ3b0mjrBJlk0Pk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=la3OoGUZtVEIeJOGgqJ3okKR3f2Bu0fHCLa75J2oivX2XMHAAmfFB4o0/5In3d0pv2bNEy8F2Oz+u0t6ItySizLCVn6kJOIN64Q/3pWsY5s3K+5TLCmDCeTJ3woMIKcY7ZwOyvX1jmzrDhLgPxFUsbNTpdHO5TQR4X2vS8mNafQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=duQPQ4yI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="duQPQ4yI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED0E1F00A3F;
	Fri,  4 Sep 2026 10:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518142;
	bh=M2MOSiNqGFQGUMjl9nVSkxsKKmbDc4D6RS87KMDFULA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=duQPQ4yI2RMHIebtZRfMkbcoXv01nefB5DSNMeFK/nBqdD6QPQg+8HweNXhcFsPaX
	 /B2ujnsKV8z1BgYv/SUWogQJl9n56hifPSO7SKDS0sM+AJTkjv1KtyF8oHDDvi6BeO
	 xFqdyqw4+M9GUKu+0hE7xdObu1icce2oPQgAAsoRqn69peO8tjvyOotnWjshSgCdXv
	 bHOLzghsWnGEDs6Uq4PHxyyxO84jlckTWCsRtC7kXWnY2LpKAQjIyIR16mNXsZeW75
	 QmVdSuxh11gii/+Qj5xUs5FQRsxOduE554IpX7gXdiypWFHPiaWKAf9zNxXdSv+H/w
	 N3oTX5QrYhLgA==
Date: Fri, 4 Sep 2026 12:35:37 +0200
From: Christian Brauner <brauner@kernel.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Srikanth Aithal <Srikanth.Aithal@amd.com>, 
	Luca Weiss <luca.weiss@fairphone.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
Message-ID: <20260904-unkraut-preis-pendel-a57f694a54c5@brauner>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
 <apiMiLlwujmqyYLP@user>
 <c3be2678-72e6-4122-94de-ae95e980578b@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c3be2678-72e6-4122-94de-ae95e980578b@linux.alibaba.com>

On Thu, Sep 03, 2026 at 09:42:27AM +0800, Joseph Qi wrote:
> 
> 
> On 9/3/26 4:52 AM, Yalagada Pavan Kumar wrote:
> > On Wed, Sep 02, 2026 at 09:33:57AM +0800, Joseph Qi wrote:
> >> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> >> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> >> __bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
> >> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> >> directly") made them point b_data at the kmalloced frozen data rather
> >> than a folio.  Submitting such a buffer during journal commit oopses:
> >>
> >>   BUG: kernel NULL pointer dereference, address: 0000000000000000
> >>   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
> >>   Call Trace:
> >>    jbd2_journal_commit_transaction+0x932/0x1b10
> >>    kjournald2+0xb2/0x250
> >>
> >> Hit by the ocfs2-testsuite fill_verify_holes test running with
> >> data=writeback.
> >>
> >> Dropbehind only applies to buffers backed by a folio, so skip the check
> >> when b_folio is NULL.
> >>
> > Hi,
> > 
> > I was working on a fix for this syzbot report [1] and didn't realize that you were
> > already working on it. I noticed your patch on the mailing list, so i won't
> > send a duplicate patch.
> >  
> >> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")
> > 
> > Could you please add the Reported-by: and Closes: tags from the syzbot report
> > to your patch? This will help syzbot associate the patch with the reported
> > issue and track the fix.
> > 
> > [1]: https://syzkaller.appspot.com/bug?extid=41453ea05ab61c075f1f
> > 
> Hi Christian,
> Could you please address the above when apply the patch? Or should I
> resend the patch with them?

I'll do it. Thanks!
