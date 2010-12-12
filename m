From: Ted Ts'o <tytso@mit.edu>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Sun, 12 Dec 2010 07:43:54 -0500
Message-ID: <20101212124354.GA4513@thunk.org>
References: <1291945065-sup-1838@think>
 <AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com>
 <20101210023852.GB3059@thunk.org>
 <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
 <AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
 <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
 <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
 <20101212023415.GG3059@thunk.org>
 <AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
 <AANLkTinhHTqqpP=pQ8Foyc9xeaZi65GHGHGY51OyZtvF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt <jackdachef@gmail.com>, Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Milan Broz <mbroz@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jon Nelson <jnelson@jamponi.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49508 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab0LLMoH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Dec 2010 07:44:07 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTinhHTqqpP=pQ8Foyc9xeaZi65GHGHGY51OyZtvF@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 12, 2010 at 04:18:29AM -0600, Jon Nelson wrote:
> > I have one CPU configured in the environment, 512MB of memory.
> > I have not done any memory-constriction tests whatsoever.

I've finally been able to reproduce it myself, on real hardware.  SMP
is not necessary to reproduce it, although having more than one CPU
doesn't hurt.  What I did need to do (on real hardware with 4 gigs of
memory) was to turn off swap and pin enough memory so that free memory
was around 200megs or so before the start of the test.  (This is the
natural amount of free memory that the system would try to reach,
since 200 megs is about 5% of 4 gigs.)

Then, during the test, free memory would drop to 50-70 megabytes,
forcing writeback to run, and then I could trigger it about 1-2 times
out of three.

I'm guessing that when you used 512mb of memory, that was in effect a
memory-constriction test, and if you were to push the memory down a
little further, it might reproduce even more quickly.  My next step is
to try to reproduce this in a VM, and then I can start probing to see
what might be going on.

						- Ted
