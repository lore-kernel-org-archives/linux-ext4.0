Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865207;
	b=R8/u0lKmPlnovDE70hG3ow4fNWyzcRWU/417RvZWJyJH1Z62pfkT3dIyKYt3nOAON2TH
	 h/N4Eeh62NLqzsX9W9vSdeEv9dnRuqCkj/I2Pj6GkIYEBMw85LrcumsRh+UZ9E+FVrhKc
	 73dYmxlhLOcWxqelKKKFaMJii6DmXl7i1JYEpkhyojt+Lq5QBPGeaf1MBCFN7WnbXJkz8
	 X07gCMtjLNmgulrmiZnDhgijF0J8PFawKjgOeKYMhCe0BpgbuJzTqF4wC+r6oATGNU0E+
	 KPCb9UDp9kB5viDBirtoTC4Qiwg5UOmfwShebqn42F1lBBb0HuZdkEDw85g3+1NYfSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865207;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=blfgXIbOe9CLDWymWGfeRse6331aW3AgoqdoPjSZ3Ys=;
	b=p+F18kwdMS77Ila27gGvsF7+5K9zjWfdosDaGzZ99y82vHMfWrqbUaP1Vjl5vLYHfOEu
	 y+iasTF+erEhpu30RcwCsdViZQjyOfRCF7a7baA/m3B5Z3yopIiiKDV1ao7U7DvEYM3j5
	 2HCVYv6jaXve+aKv0XBfRe8zSZOjqnCWlV8CaTtOx+ukqkC2LjGjpl9HY4zsOTP7OUpFl
	 YeJSufL/enHYhM8lx+ou2QGk0Akna0ZQSeNwFHvnSUnY9kTuFoyY6j0W/NpBybG3h1snU
	 3x5v2ynYcWuyWWc85eIx5FKTH8zvgsPq/7TxJLj3A6+E2pNJHX/VK0BCo1B1QIPRHMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=MlIBBcXs;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F29606A322
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 21:40:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1F29606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=MlIBBcXs
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AGLdslR013263
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 16:39:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794865196; bh=blfgXIbOe9CLDWymWGfeRse6331aW3AgoqdoPjSZ3Ys=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=MlIBBcXs++B0CmfEY5tzsrnmG0YK9tVG3u5qFebBSppFPavbYLiuOjm12F9NaUfBv
	 IcTSs+huF++/GwhAW4YQtlT2cSpEXhb/ZKSlFTpebKAPTbulSdplbkniIw2hxGeY6C
	 f80hX2YBoOlyQq40PMh6hfyk6Ig0X2ETRxWz5nO+7yq89kW1a8LtoAoCa62mS791pZ
	 2U3gVKq23bQvoBBB1erXpvRsWRXVUe/36tc94DWuGdL8mQ9JhcUmYwLtpASvAxswgz
	 WbsX+ZxuCM/WgFNxYXzbWlZ2TSokY/ElrDxK9+C6gR5CFnf/6UyL07sShvC1M9Z+sk
	 bXkfud17OL7uA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id B879727ACFA1; Mon, 16 Nov 2026 16:39:53 -0500 (EST)
Date: Mon, 16 Nov 2026 16:39:53 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Ahmed Khan <ahmadpsn95@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ext4: NULL pointer dereference in
 jbd2_journal_file_inode() during inline data conversion
Message-ID: <avt1ObnHmA4AmSmc@mit.edu>
References: <CAOaS1==g3mdoqmS2AjOC0_-woXJbA_X0LJQt7+M7d1=+gfyQqw@mail.gmail.com>
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
In-Reply-To: <CAOaS1==g3mdoqmS2AjOC0_-woXJbA_X0LJQt7+M7d1=+gfyQqw@mail.gmail.com>

On Sat, Nov 14, 2026 at 07:43:08PM -0500, Ahmed Khan wrote:
> 
> My name is Ahmed Khan, I am a security researcher from Canada. I
> believe I found a bug within the Linux Kernel, specifically, version
> 7.3.4 affecting all major distros. I will be candid and state that I
> used AI heavily in fuzzing the kernel using "syzkaller"....

When you say "syzkaller", are you referring to your own instance of
syzkaller, which you may have modified to use AI-directed fuzzing?

> This corresponds to syzbot crash ID:
> 3eb9083d961b1b97587d103692546ba06797de4e

This crash ID doesn't appear to be one which is recognized by
https://syzkaller.appspot.com --- which would make sense if it's your
own Syzkaller instance.

> Please let me know if you would like the standalone C reproducer or
> the minimal ext4 disk image attached inline. I have this in a private
> repo and would be happy to add you as a project contributor.

Yes, please send the standalone C reproducer and minimal crafted ext4 image.
That would be most helpful.

Note that we don't really consider crashes which require a crafted
file system image to trigger to be a security vulnerability, unless
the file system corruption is not caught by e2fsck (or triggers a
memory pointer bug or other issue in e2fsck).  Not running fsck on an
untrusted file system before introducing it to the Trusted Computing
Base of the linux kernel is roughly equivalent to running "dd
if=/dev/zero of=/dev/mem".  Sure, it might crash the system, but
that's really a PEBCAK system administrator issue.  :-)

Regards,

					- Ted
