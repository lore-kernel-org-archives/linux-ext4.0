From: Dave Chinner <david@fromorbit.com>
Subject: Re: Filesystem writes on RAID5 too slow
Date: Wed, 11 Dec 2013 11:27:53 +1100
Message-ID: <20131211002753.GD10988@dastard>
References: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
 <528A5C45.4080906@redhat.com>
 <20131119005740.GY6188@dastard>
 <CACtJ3Ha3C7JNi5VZRnNMn+-okNheygmbj=j9AnUMvfzfZjNwug@mail.gmail.com>
 <20131121092606.GU11434@dastard>
 <CACtJ3HZAsOtmLArMWraygfQxpGymtZjr+a_reXv8o6LJzoMbvw@mail.gmail.com>
 <CACtJ3Ha5P2Heu4qiEEk6c4g+tKyR=RrD-4E-Cqj+bP8YDjKQ6w@mail.gmail.com>
 <20131121234116.GD6502@dastard>
 <20131210191803.GA31162@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Boutin <martboutin@gmail.com>,
	"Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"Kernel.org-Linux-EXT4" <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131210191803.GA31162@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 10, 2013 at 11:18:03AM -0800, Christoph Hellwig wrote:
> > xfs: align initial file allocations correctly.
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The function xfs_bmap_isaeof() is used to indicate that an
> > allocation is occurring at or past the end of file, and as such
> > should be aligned to the underlying storage geometry if possible.
> > 
> > Commit 27a3f8f ("xfs: introduce xfs_bmap_last_extent") changed the
> > behaviour of this function for empty files - it turned off
> > allocation alignment for this case accidentally. Hence large initial
> > allocations from direct IO are not getting correctly aligned to the
> > underlying geometry, and that is cause write performance to drop in
> > alignment sensitive configurations.
> > 
> > Fix it by considering allocation into empty files as requiring
> > aligned allocation again.
> 
> Seems like this one didn't get picked up yet?

I'm about to resend all my outstanding patches...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
