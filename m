From: Johannes Stezenbach <js@sig21.net>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Wed, 17 Aug 2016 22:02:32 +0200
Message-ID: <20160817200232.cd5ehiwbwbnggddo@sig21.net>
References: <20160718141723.GA8809@sig21.net>
 <7849bcd2-142d-0a12-0a04-7d0c3b6d788f@etorok.net>
 <20160805103544.kbt7znbzypvi5ofx@sig21.net>
 <20160805170228.GA19960@birch.djwong.org>
 <20160805181136.mcjnnvuo5m6kpxzb@sig21.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@etorok.net>,
	linux-kernel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160805181136.mcjnnvuo5m6kpxzb@sig21.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 05, 2016 at 08:11:36PM +0200, Johannes Stezenbach wrote:
> On Fri, Aug 05, 2016 at 10:02:28AM -0700, Darrick J. Wong wrote:
> > 
> > When you're back on 4.7, can you apply this patch[1] to see if it fixes
> > the problem?  I speculate that the new parallel dir lookup code enables
> > multiple threads to be verifying the same directory block buffer at the
> > same time.
> > 
> > [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/ext4/inode.c?id=b47820edd1634dc1208f9212b7ecfb4230610a23
> 
> I added the patch, rebuilt and rebooted.  It will take some time
> before I'll report back since the issue is so hard to reproduce.

FWIW, so far the issue didn't appear again after I applied
the patch to 4.7.0, and I stressed it a bit with repo syncs,
AOSP builds, rsync backups etc.

Johannes
