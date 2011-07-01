From: Dave Chinner <david@fromorbit.com>
Subject: Re: fsync serialization on ext4 with blkio throttling (Was: Re:
 [PATCH 0/8][V2] blk-throttle: Throttle buffered WRITEs in
 balance_dirty_pages())
Date: Fri, 1 Jul 2011 10:16:25 +1000
Message-ID: <20110701001625.GL561@dastard>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
 <20110629004219.GP32466@dastard>
 <20110629015336.GA19082@redhat.com>
 <20110630200459.GI27889@redhat.com>
 <20110630204432.GL27889@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
	linux-fsdevel@vger.kernel.org, andrea@betterlinux.com,
	linux-ext4@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110630204432.GL27889@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 30, 2011 at 04:44:32PM -0400, Vivek Goyal wrote:
> On Thu, Jun 30, 2011 at 04:04:59PM -0400, Vivek Goyal wrote:
> 
> [..]
> > Dave,
> > 
> > Just another example where serialization is taking place with ext4.
> > 
> > I created a group with 1MB/s write limit and ran tedso's fsync tester
> > program with little modification. I used write() system call instead
> > of pwrite() so that file size grows. This program basically writes
> > 1MB of data and then fsync's it and then measures the fsync time.
> > 
> > I ran two instances of prgram in two groups on two separate files. One
> > instances is throttled to 1MB/s and other is in root group unthrottled.
> > 
> > Unthrottled program gets serialized behind throttled one. Following
> > are fsync times.
> > 
> > Throttled instance	Unthrottled Instance
> > ------------------ 	--------------------
> > fsync time: 1.0051	fsync time: 1.0067
> > fsync time: 1.0049	fsync time: 1.0075
> > fsync time: 1.0048	fsync time: 1.0063
> > fsync time: 1.0073	fsync time: 1.0062
> > fsync time: 1.0070	fsync time: 1.0078
> > fsync time: 1.0032	fsync time: 1.0049
> > fsync time: 0.0154	fsync time: 1.0068
> > fsync time: 0.0137	fsync time: 1.0048
> > 
> > Without any throttling both the instances do fine
> > -------------------------------------------------
> > Throttled instance	Unthrottled Instance
> > ------------------ 	--------------------
> > fsync time: 0.0139	fsync time: 0.0162
> > fsync time: 0.0132	fsync time: 0.0156
> > fsync time: 0.0149	fsync time: 0.0169
> > fsync time: 0.0165	fsync time: 0.0152
> > fsync time: 0.0188	fsync time: 0.0135
> > fsync time: 0.0137	fsync time: 0.0142
> > fsync time: 0.0148	fsync time: 0.0149
> > fsync time: 0.0168	fsync time: 0.0163
> > fsync time: 0.0153	fsync time: 0.0143
> > 
> > So when we are inreasing the size of file and fsyncing it, other
> > unthrottled instances of similar activities will get throttled
> > behind it.
> > 
> > IMHO, this is a problem and should be fixed. If filesystem can fix it great.
> > But if not, then we should consider the option of throttling buffered writes 
> > in balance_dirty_pages().
> 
> XFS seems to be doing well for this particular test. Unthrottled
> fsyncer does not get serialized behind throttled one.
> 
> Throttled instance	Unthrottled Instance
> ------------------ 	--------------------
> fsync time: 1.0511	fsync time: 0.0204
> fsync time: 1.0486	fsync time: 0.0260
> fsync time: 1.0445	fsync time: 0.0260
> fsync time: 1.0485	fsync time: 0.0260
> fsync time: 1.0446	fsync time: 0.0260
> fsync time: 1.2157	fsync time: 0.0260
> fsync time: 1.0446	fsync time: 0.0300
> fsync time: 1.0484	fsync time: 0.0340
> fsync time: 1.0446	fsync time: 0.0221
> fsync time: 1.0486	fsync time: 0.0340
> fsync time: 1.0406	fsync time: 0.0340

And you've just illustrated my point better than I did - that
different filesytsems will suffer from different problems, but some
filesytsems will work better than others out of the box. :)

Of course, there's no guarantee XFS will remain this way - if you
want us to care about regressions of this sort at all, you need to
encapsulate all this behaviour in a set of automated tests.
Preferrably within the xfstests infrastructure because that now has
fairly wide usage within the fs dev community....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
