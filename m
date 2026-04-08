Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E463C38AC95
	for <linux-ext4@vger.kernel.org>; Wed,  8 Apr 2026 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775655295; cv=none; b=Syyb511B5srZqrw6GyXF+CEGPyFx3LK85qqKlsiejTrX2O8pTwzflo0HC3C7eVhvdCb8HYjBENfJi52zj0K44oGmtFCf0aBqphb7S42iIrjRryE7AWflS+che/tG0SrM5r3/Zvq0NbhjyHMmme5Yf+h9fJ9VhU5bJru5RYunBdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775655295; c=relaxed/simple;
	bh=9FqZTEv6cRlunSY6LUjBbULCRnJZTygZkqDpHHAEoTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZ8NSsvlZpL8WuckyHaoqXexDp8m8iuZKR6w2eyrVcltJlTTIHG6240C3+1JIILGdZ+PM6h0KrZji5WzYJMg6tmTlMaBzjtHf5JdT+cvxp3D6ENTpV68EvAOz+ApkB4FXxOm9hdWfjY7smUz6HhiZ2h5BKCRUVH0jezWXH7IEbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=oTJMFx5s; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="oTJMFx5s"
Received: from macsyma.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 638DYO0v000915
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 8 Apr 2026 09:34:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775655267; bh=kAKSOT8KUNZdHSOe3MjpGwiByod+BmerxcJbt5nx18w=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=oTJMFx5s1b0Rp3E0AQZej8+CIGNnfPMY12FD1SdnZZbKSADmF28tVYt6ZXnqGCVyP
	 qLyqNwIfuZvw5MyoFMGfIbBDL4jXVo9uU5nk4/+gMlpI5ZSVbwlp1qwmAoujiiWbW7
	 9KqtkuZhkdB0pifoV/tLOO/dkGMYPSBlP5bJHU45zzYxP6BSogyaZwYTBbxd716JBd
	 rYzNkkRcFhQfDHaEGyymE8c5bbz/EX5RQHZu1vG31yLB/9AAH0I37I6iohknrZAg60
	 Vzv/mkDecM58Es0nBTfG64rNRBD9xLYwrRWwEzzY8s0OzqQbU4ubBCOj1L1HXjGjIS
	 2gDXelc9JoWIA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 4D38262428C4; Wed,  8 Apr 2026 09:33:24 -0400 (EDT)
Date: Wed, 8 Apr 2026 09:33:24 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Sean Smith <defendthedisabled@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, dsterba@suse.com, david@fromorbit.com,
        brauner@kernel.org, osandov@osandov.com, almaz@kernel.org,
        hirofumi@mail.parknet.co.jp, linkinjeon@kernel.org
Subject: Re: [RFC PATCH v1 0/6] provenance_time (ptime): a new settable
 timestamp for cross-filesystem provenance
Message-ID: <20260408133324.GA18443@macsyma-wired.lan>
References: <20260405225442.GA1763@macsyma-wired.lan>
 <20260407000558.417-1-DefendTheDisabled@gmail.com>
 <20260407233618.GB12536@macsyma-wired.lan>
 <92e61267-eb24-4f94-b9a1-e009b5e00d65@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92e61267-eb24-4f94-b9a1-e009b5e00d65@gmail.com>

On Tue, Apr 07, 2026 at 09:54:17PM -0500, Sean Smith wrote:
> Finding an alternative to using rename() to transfer ptime between
> inodes during atomic saves seems beyond the scope of what I can address
> as someone who relies upon AI agents to review and modify code....
>
> It also doesn't solve the immediate needs of increasing number of users
> who are trying to ditch Windows for Linux. Windows 11 has pushed one too
> many people too far, and they, like me, have had enough.

I understand that you have one goal which seems more important than
anything else (to you).  But consider what might happen if you ask an
AI, "How can we solve the paper clip shortage problem?", or "How do we
carry out regime change in Iran?"  AI models which don't consider
secord order effects (or used by people who have different priorities
than others) can result in... suboptimal results.

And this is why it's important why it's important to have humans in
the loop instead of blindly trusting AI models.

I'd also suggest that you consider the value of patience.  Linux is 35
years old as of this writing.  One of the reasons why Linux has stuck
around this long is because we take the long view.  Sure, it might
take longer to shift the ecosystem to use some new interface or new
feature; but everyone will have to live with muddled interface
semantics *forever*.

> The need for ptime is very real....

It's important for *you*.  But the vast majority of Linux users are
not Windows refugees.  (Ask your AI models to explain the significance
of the phrase, "This is the year of the Linux Desktop".)  Even for
Windows users, it is not all clear that Windows-style File Creation
time is that important for those users.  MacOS doesn't have this
Windows-style timestamp support, and it hasn't stopped many users from
switching from Windows to MacOS.

> ... and the code in my patch gets the job done...

But it doesn't.  Bastardizing the semantics of the rename interface
doesn't completely solve the problem you've articulated.  In
particular, all of the userspace programs which need to create new
files --- tar file extraction, unzip, file copying, etc., still need
to be changed.

This will require changing userspace applications.  So why not use
that approach to address your problem statement?

> I can patch every application I use which is open-source, or I can patch
> the kernel. Rational analysis requires that I patch the kernel.

That's certainly your perogative, and that's the beauty of Open
Source.  You're free to patch the software that you use on your
system.

Cheers,

						- Ted

