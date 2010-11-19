From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 12:16:16 +0000
Message-ID: <1290168976.2570.45.camel@dolmen>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
	 <20101118130630.GJ6178@parisc-linux.org>
	 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
	 <20101118141957.GK6178@parisc-linux.org>
	 <20101118142918.GA18510@infradead.org>
	 <1290100750.3041.72.camel@mulgrave.site>
	 <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On Thu, 2010-11-18 at 18:35 +0100, Lukas Czerner wrote:
> On Thu, 18 Nov 2010, James Bottomley wrote:
> 
> > On Thu, 2010-11-18 at 09:29 -0500, Christoph Hellwig wrote:
> > > On Thu, Nov 18, 2010 at 07:19:58AM -0700, Matthew Wilcox wrote:
> > > > I guess I was assuming that, on receiving a FALLOC_FL_PUNCH_HOLE, a
> > > > filesystem that was TRIM-aware would pass that information down to the
> > > > block device that it's mounted on.  I strongly feel that we shouldn't
> > > > have two interfaces to do essentially the same thing.
> > > > 
> > > > I guess I'm saying that you're going to have to learn about TRIM :-)
> > > 
> > > Did you actually look Lukas FITRIM code (not the slight reordering here,
> > > but the original one).  It's the ext4 version of the batched discard
> > > model, that is a userspace ioctl to discard free space in the
> > > filesystem.
> > > 
> > > hole punching will free the blocks into the free space pool.  If you do
> > > online discard it will also get discarded, but a filesystem that has
> > > online discard enabled doesn't need FITRIM.
> > 
> > Not stepping into the debate: I'm happy to see punch go to the mapping
> > data and FITRIM pick it up later.
> > 
> > However, I think it's time to question whether we actually still want to
> > allow online discard at all.  Most of the benchmarks show it to be a net
> > lose to almost everything (either SSD or Thinly Provisioned arrays), so
> > it's become an "enable this to degrade performance" option with no
> > upside.
> > 
> > James
> > 
> 
> This time began a long time ago :) that is why am I originally created
> batched discard for ext4 (ext3) accessible through FITRIM ioctl. Ext4
> performance with -o discard mount option goes down on the most of the
> SSD's and every Thinly-provisioned storage I have a chance to benchmark.
> 
> But, for example SSD's are getting better and as time goes by we might
> see devices that does not suffer terrible performance loss with discard
> enabled (discard on unlink in ext4 etc...), so this "online" discard
> probably still does make sense.
> 
> -Lukas

I agree that it is early days for trim/discard hardware implementations.
I hope that if it can be shown that it is useful (and if the hardware
vendors are following this thread!) then maybe it will spur them on to
providing faster implementations in the future. There doesn't seem to be
any technical reason why faster implementations are not possible.

Equally, FITRIM is useful since the overhead can be reduced to certain
points in time when a system is less busy. With GFS2 (this may well also
apply to OCFS2) doing a userspace trim is not very easy since there is
no simple way to access the locking for the fs from userspace, so it
would imply that an admin unmounted the filesystem on all nodes and then
runs a utility on just one node. Using FITRIM though, it would be
possible to perform the trim during normal fs operation (initiating
FITRIM from multiple nodes at once would also work correctly, even if it
is not desirable from a performance point of view)

GFS2 already has code for online discard, and the changes required to
support FITRIM are relatively small. Both online discard and FITRIM
simply require iterating through the resource group bitmaps and
generating discard requests depending on the bitmap states encountered.
I'm intending to put a patch together fairly shortly to implement FITRIM
for GFS2.

So I think there is a place for both approaches,

Steve.
