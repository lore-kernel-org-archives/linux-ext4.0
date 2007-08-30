From: "Jeffrey W. Baker" <jwbaker@acm.org>
Subject: Re: ZFS, XFS, and EXT4 compared
Date: Thu, 30 Aug 2007 12:09:01 -0700
Message-ID: <1188500941.8980.20.camel@toonses.gghcwest.com>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
	<1188457666.24970.94.camel@edge.yarra.acx>
	<20070830132002.GA4086@infradead.org>  <46D71318.2050604@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: zfs-discuss@opensolaris.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <zfs-discuss-bounces@opensolaris.org>
In-Reply-To: <46D71318.2050604@sandeen.net>
List-Unsubscribe: <http://mail.opensolaris.org/mailman/listinfo/zfs-discuss>,
	<mailto:zfs-discuss-request@opensolaris.org?subject=unsubscribe>
List-Archive: <http://mail.opensolaris.org/pipermail/zfs-discuss>
List-Post: <mailto:zfs-discuss@opensolaris.org>
List-Help: <mailto:zfs-discuss-request@opensolaris.org?subject=help>
List-Subscribe: <http://mail.opensolaris.org/mailman/listinfo/zfs-discuss>,
	<mailto:zfs-discuss-request@opensolaris.org?subject=subscribe>
Sender: zfs-discuss-bounces@opensolaris.org
Errors-To: zfs-discuss-bounces@opensolaris.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-08-30 at 13:57 -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Thu, Aug 30, 2007 at 05:07:46PM +1000, Nathan Scott wrote:
> >> To improve metadata performance, you have many options with XFS (which
> >> ones are useful depends on the type of metadata workload) - you can try
> >> a v2 format log, and mount with "-o logbsize=256k", try increasing the
> >> directory block size (e.g. mkfs.xfs -nsize=16k, etc), and also the log
> >> size (mkfs.xfs -lsize=XXXXXXb).
> > 
> > Okay, these suggestions are one too often now.  v2 log and large logs/log
> > buffers are the almost universal suggestions, and we really need to make
> > these defaults.  XFS is already the laughing stock of the Linux community
> > due to it's absurdely bad default settings.
> 
> Agreed on reevaluating the defaults, Christoph!
> 
> barrier seems to hurt badly on xfs, too.  Note: barrier is off by
> default on ext[34], so if you want apples to apples there, you need to
> change one or the other filesystem's mount options.  If your write cache
> is safe (battery backed?) you may as well turn barriers off.  I'm not
> sure offhand who will react more poorly to an evaporating write cache
> (with no barriers), ext4 or xfs...

I didn't compare the safety of the three filesystems, but I did have
disk caches disabled and only battery-backed caches enabled.  Do you
need barriers without volatile caches?

Most people benchmark ext3 with data=writeback which is unsafe.  I used
ordered (the default).

I think if you look at all the features, zfs is theoretically the most
safe filesystem.  But in practice, who knows?

-jwb
