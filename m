From: Ted Ts'o <tytso@mit.edu>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Thu, 9 Dec 2010 21:38:52 -0500
Message-ID: <20101210023852.GB3059@thunk.org>
References: <20101207182243.GB21112@redhat.com>
 <20101207193514.GA2921@thunk.org>
 <AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com>
 <20101209180111.GF2921@thunk.org>
 <AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8@mail.gmail.com>
 <20101209201359.GG2921@thunk.org>
 <AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0@mail.gmail.com>
 <20101209231616.GA12515@basil.fritz.box>
 <1291945065-sup-1838@think>
 <AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Jon Nelson <jnelson@jamponi.net>,
	Mike Snitzer <snitzer@redhat.com>,
	Milan Broz <mbroz@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Matt <jackdachef@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39476 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab0LJCjF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Dec 2010 21:39:05 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 10, 2010 at 02:53:30AM +0100, Matt wrote:
> 
> Try a kernel before 5a87b7a5da250c9be6d757758425dfeaf8ed3179
> 
> from the tests I've done that one showed the least or no corruption if
> you count the empty /etc/env.d/03opengl as an artefact

Yes, that's a good test.  Also try commit bd2d0210cf.  The patch
series that is most likely to be at fault if there is a regression in
between 5a87b7a5d and bd2d0210cf inclusive.

I did a lot of testing before submitting it, but that wa a tricky
rewrite.  If you can reproduce the problem reliably, it might be good
to try commit 16828088f9 (the commit before 5a87b7a5d) and commit
bd2d0210cf.  If it reliably reproduces on bd2d0210cf, but is clean on
16828088f9, then it's my ext4 block i/o submission patches, and we'll
need to either figure out what's going on or back out that set of
changes.

If that's the case, a bisect of those changes (it's only 6 commits, so
it shouldn't take long) would be most appreciated.

Regards,

						- Ted
