From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: A huge latency in ext4 and xfs because of stable page write
Date: Wed, 12 Dec 2012 11:47:10 -0800
Message-ID: <20121212194710.GA9453@blackbox.djwong.org>
References: <20121211084520.GA13277@gmail.com>
 <20121211111707.GU15784@dastard>
 <20121212041803.GA29427@gmail.com>
 <20121212044948.GW16353@dastard>
 <20121212051332.GA6718@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	hch@infradead.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121212051332.GA6718@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 12, 2012 at 01:13:32PM +0800, Zheng Liu wrote:
> On Wed, Dec 12, 2012 at 03:49:49PM +1100, Dave Chinner wrote:
> [cut...]
> > > > > Hence, I wonder whether or not we could revert stable page write temporarily.
> > > > > After it is improved, we could add it back again.
> > > > 
> > > > The plan is to turn it off for filesystems/devices that don't
> > > > require it. That list of devices will grow in future, so you
> > > > probably should plan to handle latencies in the application
> > > > properly...
> > > 
> > > I wonder whether we can provide a sysctl to turn on/off stable page
> > > write.  At least we need to give sysadmin an opportunity to control it.
> > 
> > That's already been considered and discarded because turning off
> > stable pages on devices that require it will cause validation or
> > data corruption problems. The discussion was for these patches (and
> > I think a followup series as well):
> > 
> > http://www.spinics.net/lists/linux-fsdevel/msg59421.html
> 
> Thanks for pointing out.  So now it seems that only I can do is to
> present a proposal to revert stable page write temporarily because it
> causes a huge latency for some applications.

Hrm... just to be clear, is your complaint that you have one of these
checksum-happy disks and overwrites are slow on it, or that you have a regular
SATA disk that doesn't require stable pages and you don't want to take the
speed hit?

If it's the second, then let's just push the bdi flag thing upstream.  Given
your comments a couple of days ago, I'm pretty sure it's the second, but I
figured I ought to clarify the record. :)

I haven't posted new patches because I've been busy writing a fix for ext3.
It seems to be working, so I'll clean it up and send out a new series.

--D
