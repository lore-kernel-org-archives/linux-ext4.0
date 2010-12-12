From: Ted Ts'o <tytso@mit.edu>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Sat, 11 Dec 2010 20:40:13 -0500
Message-ID: <20101212014013.GF3059@thunk.org>
References: <20101209201359.GG2921@thunk.org>
 <AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0@mail.gmail.com>
 <20101209231616.GA12515@basil.fritz.box>
 <1291945065-sup-1838@think>
 <AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com>
 <20101210023852.GB3059@thunk.org>
 <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
 <AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
 <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
 <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 10, 2010 at 08:14:56PM -0600, Jon Nelson wrote:
> > Barring false negatives, bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc
> > appears to be the culprit (according to git bisect).
> > I will test bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc again, confirm
> > the behavior, and work backwards to try to reduce the possibility of
> > false negatives.
> 
> A few additional notes, in no particular order:
> 
> - For me, triggering the problem is fairly easy when encryption is involved.
> - I'm now 81 iterations into testing
> bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc *without* encryption.  Out of
> 81 iterations, I have 4 failures: #16, 40, 62, and 64.
> 
> I will now try 1de3e3df917459422cb2aecac440febc8879d410 much more extensively.
> 
> Is this useful information?

Yes, indeed.  Is this in the virtualized environment or on real
hardware at this point?  And how many CPU's do you have configured in
your virtualized environment, and how memory memory?  Is having a
certain number of CPU's critical for reproducing the problem?  Is
constricting the amount of memory important?

It'll be a lot easier if I can reproduce it locally, which is why I'm
asking all of these questions.

Thanks,

					- Ted
