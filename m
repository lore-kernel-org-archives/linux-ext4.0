From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] directory quota survey on xfs
Date: Thu, 16 Jan 2014 08:32:07 +1100
Message-ID: <20140115213207.GJ3431@dastard>
References: <20131222095929.GA11444@gmail.com> <20131223014222.GC3220@dastard>
	<20140115081201.GA3820@gmail.com>
	<5966C533-EF18-4804-8C83-DFBD607D9BE6@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <gnehzuil.liu@gmail.com>,
	xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>, Li Xi <pkuelelixi@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <5966C533-EF18-4804-8C83-DFBD607D9BE6@dilger.ca>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 15, 2014 at 11:03:22AM -0700, Andreas Dilger wrote:
> On Jan 15, 2014, at 1:12 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > On Mon, Dec 23, 2013 at 12:42:22PM +1100, Dave Chinner wrote:
> >> I'd also strongly suggest that you use the XFS userspace quota API
> >> for managing project quotas, so that we can use the same management
> >> tools and tests to verify that they behave the same. Please don't
> >> invent a new version of the quota API to implement this - everything
> >> you need ifor managing project/directory quotas is already there in
> >> xfs_quota.....
> > 
> > Frankly, I don't like this, really.  Now we have quota-tool to manage
> > the quota in ext4.  So IMHO we'd better go on using this tool because it
> > is natural for ext4 users.

Zheng - you're confusing the userspace tool that users run with
the quotactl API the tool uses to communicate with the kernel.

> > I still couldn't accept this fact that I
> > need to install xfsprogs for using a feature of ext4.  Further, it could
> > make users puzzled because they use quota to control user/group quota in
> > ext4, but it uses xfs_quota to control project quota.  It could bring
> > some troubles for the ext4 users who have written some scripts to manage
> > their machines.
> 
> Please see Li Xi's recent email "Directory/Project quota supports" on
> the linux-ext4 list.  He has already added some prototype support for
> project quotas to quota-tools.

So, while it is a prototype, lets do it the right way. i.e. let's
not reinvent the wheel.

> I think it might make sense to keep the same API as XFS for the ext4
> quotas (to keep compatibility for existing XFS deployments), but add
> support into quota-tools so that it is usable by all filesystems.

Well, yes. If you are writing a generic quota tool, then it needs to
support all filesystems. We already have a fully featured quota API
that can provide this support - it's the API that XFS has been using
since it was ported to Linux.  We have the opportunity to unify the
quota APIs that ext4 and XFS, so we should take the opportunity
while it is here.  Don't create a new API for ext4 simply because of
NIH syndrome.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
