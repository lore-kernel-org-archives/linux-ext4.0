From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Wed, 21 May 2008 15:40:35 -0400
Message-ID: <200805211540.36276.chris.mason@oracle.com>
References: <482DDA56.6000301@redhat.com> <20080521182949.GL8581@mit.edu> <20080521193633.GA26780@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080521193633.GA26780@shareable.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wednesday 21 May 2008, Jamie Lokier wrote:
> Theodore Tso wrote:
> > On Wed, May 21, 2008 at 11:03:24AM -0700, Andrew Morton wrote:
> > > afaik there is no need to enable this feature if the machine (actually
> > > the disks) are on a UPS, yes?
> >
> > Yes, as long as you're confident that there won't be a kernel
> > bug/regression causing a lockup while the server is under severe
> > memory pressure while doing lots of fsync's, file creations, renames,
> > etc.  And as long as your 100% confident that UPS's will never fail,
> > janitors will never accidentally hit the Emergency Power Office
>
> Can a kernel lockup cause this kind of corruption?

No

>
> Will a system reboot wipe the disk's write cache?
>

Only if you reboot with the power switch (some test rigs do)

> I had imagined only power loss would prevent the disk from
> writing it's cache eventually; is that wrong?
>

-chris
