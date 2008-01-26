From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Sat, 26 Jan 2008 16:39:28 +1100
Message-ID: <20080126053928.GO155407@sgi.com>
References: <20080125195938t-sato@mail.jp.nec.com> <20080126053526.GN155407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080126053526.GN155407@sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jan 26, 2008 at 04:35:26PM +1100, David Chinner wrote:
> On Fri, Jan 25, 2008 at 07:59:38PM +0900, Takashi Sato wrote:
> > The points of the implementation are followings.
> > - Add calls of the freeze function (freeze_bdev) and
> >   the unfreeze function (thaw_bdev) in ext3_ioctl().
> > 
> > - ext3_freeze_timeout() which calls the unfreeze function (thaw_bdev)
> >   is registered to the delayed work queue to unfreeze the filesystem
> >   automatically after the lapse of the specified time.
> 
> Seems like pointless complexity to me - what happens if a
> timeout occurs while the filsystem is still freezing?
> 
> It's not uncommon for a freeze to take minutes if memory
> is full of dirty data that needs to be flushed out, esp. if
> dm-snap is doing COWs for every write issued....

Sorry, ignore this bit - I just realised the timer is set
up after the freeze has occurred....

Still, that makes it potentially dangerous to whatever is being
done while the filesystem is frozen....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
