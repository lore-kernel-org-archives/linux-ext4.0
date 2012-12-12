From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: A huge latency in ext4 and xfs because of stable page write
Date: Wed, 12 Dec 2012 13:13:32 +0800
Message-ID: <20121212051332.GA6718@gmail.com>
References: <20121211084520.GA13277@gmail.com> <20121211111707.GU15784@dastard>
	<20121212041803.GA29427@gmail.com> <20121212044948.GW16353@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, darrick.wong@oracle.com, xfs@oss.sgi.com, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20121212044948.GW16353@dastard>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 12, 2012 at 03:49:49PM +1100, Dave Chinner wrote:
[cut...]
> > > > Hence, I wonder whether or not we could revert stable page write temporarily.
> > > > After it is improved, we could add it back again.
> > > 
> > > The plan is to turn it off for filesystems/devices that don't
> > > require it. That list of devices will grow in future, so you
> > > probably should plan to handle latencies in the application
> > > properly...
> > 
> > I wonder whether we can provide a sysctl to turn on/off stable page
> > write.  At least we need to give sysadmin an opportunity to control it.
> 
> That's already been considered and discarded because turning off
> stable pages on devices that require it will cause validation or
> data corruption problems. The discussion was for these patches (and
> I think a followup series as well):
> 
> http://www.spinics.net/lists/linux-fsdevel/msg59421.html

Thanks for pointing out.  So now it seems that only I can do is to
present a proposal to revert stable page write temporarily because it
causes a huge latency for some applications.

Thanks,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
