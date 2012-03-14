From: Phillip Susi <phillsusi@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 14 Mar 2012 10:28:20 -0400
Message-ID: <4F60AB04.1000706@gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com> <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com> <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com> <20120310044804.GB5652@thunk.org> <4F5F9A97.5060404@ubuntu.com> <20120313195339.GA24124@thunk.org> <4F5FAC9C.9070607@gmail.com> <20120313213304.GB11969@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@whamcloud.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120313213304.GB11969@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 3/13/2012 5:33 PM, Ted Ts'o wrote:
> Are you volunteering to spearhead the design and coding of such a
> thing?  Run-time sorting is backwards compatible, and a heck of a lot
> easier to code and test...

Do you really think it is that much easier?  Even if it is easier, it is 
still an ugly kludge.  It would be much better to fix the underlying 
problem rather than try to paper over it.

> The reality is we'd probably want to implement run-time sorting
> *anyway*, for the vast majority of people who don't want to convert to
> a new incompatible file system format.  (Even if you can do the
> conversion using e2fsck --- which is possible, but it would be even
> more code to write --- system administrators tend to be very
> conservative about such things, since they might need to boot an older
> kernel, or use a rescue CD that doesn't have an uptodate kernel or
> file system utilities, etc.)

The same argument could have been made against the current htree 
implementation when it was added.  I think it carries just as little 
weight now as it did then.  People who care about the added performance 
the new feature provides can use it, those who don't, won't.  Eventually 
it will become ubiquitous.

> We would still have to implement the case where hash collisions *do*
> exist, though, and make sure the right thing happens in that case.
> Even if the chance of that happening is 1 in 2**32, with enough
> deployed systems (i.e., every Android handset, etc.) it's going to
> happen in real life.

Sure it will happen, but if we read one extra block 1 in 4 billion 
times, nobody is going to notice.
