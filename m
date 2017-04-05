From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Wed, 5 Apr 2017 14:03:58 -0700
Message-ID: <20170405210358.GA31725@bombadil.infradead.org>
References: <1491241657.2673.10.camel@redhat.com>
 <20170403191602.GF30811@bombadil.infradead.org>
 <1491250577.2673.20.camel@redhat.com>
 <87h924kh6t.fsf@notabene.neil.brown.name>
 <20170404115358.GH30811@bombadil.infradead.org>
 <1491308268.20445.4.camel@redhat.com>
 <20170404161247.GJ30811@bombadil.infradead.org>
 <1491323146.309.1.camel@redhat.com>
 <20170404170909.GK30811@bombadil.infradead.org>
 <1491421792.18658.20.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NeilBrown <neilb@suse.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491421792.18658.20.camel@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 05, 2017 at 03:49:52PM -0400, Jeff Layton wrote:
> > That only gives us 20 bits of counter, but I think that's enough.
> 
> 2^20 is 1048576, which seems a little small to me.
> 
> We may end up bumping the counter on every failed I/O. How fast can we
> generate 1M failed I/Os? :)

So there's a one-in-a-million chance of missing a failed I/O ... if
we're generating lots of errors, the next time the app calls fsync(),
it'll notice the other million times we've hit the problem :-)

> Actually...we could put this field in the inode instead of the mapping.
> I know we've traditionally tracked this in the mapping, but is that
> required here?
> 
> If we put this field in the inode then perhaps we can union it with
> something and mitigate the cost of a larger counter...maybe in the
> i_pipe union? I don't think S_ISREG inodes use anything in there, do
> they?

But writeback isn't just done on ISREG inodes, but also on S_ISBLK inodes,
which use i_bdev (right?)

Another possibility is to move this out of the address_space and into
either the super_block or the backing_device_info.  Errors don't tend
to be constrained to a single file but affect the entire filesystem,
or even multiple filesystems if you have a partitioned block device ...
