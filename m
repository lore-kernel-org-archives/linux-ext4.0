From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: ext4 writepages is making tiny bios?
Date: Fri, 4 Sep 2009 09:20:13 +0200
Message-ID: <20090904072013.GR18599@kernel.dk>
References: <20090901184450.GB7885@think> <20090901205744.GE6996@mit.edu> <20090901212740.GA9930@infradead.org> <20090903055201.GA7146@discord.disaster> <20090903164209.GA28384@infradead.org> <20090904001545.GA30759@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090904001545.GA30759@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 03 2009, Theodore Tso wrote:
> On Thu, Sep 03, 2009 at 12:42:09PM -0400, Christoph Hellwig wrote:
> > > Careful:
> > > 
> > > -	tloff = min(tlast, startpage->index + 64);
> > > +	tloff = min(tlast, startpage->index + 8192);
> > > 
> > > That will cause 64k page machines to try to write back 512MB at a
> > > time. This will re-introduce similar to the behaviour in sles9 where
> > > writeback would only terminate at the end of an extent (because the
> > > mapping end wasn't capped like above).
> > 
> > Pretty good point, any applies to all the different things we discussed
> > recently.  Ted, should be maybe introduce a max_writeback_mb instead of
> > the max_writeback_pages in the VM, too?
> 
> Good point.
> 
> Jens, maybe we should replace my patch with this one, which makes the
> tunable in terms of megabytes instead of pages?

That is probably a better metric than 'pages', lets update it.

-- 
Jens Axboe

