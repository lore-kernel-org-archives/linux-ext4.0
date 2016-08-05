From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Fri, 5 Aug 2016 12:15:48 -0700
Message-ID: <20160805191548.GD19960@birch.djwong.org>
References: <20160718141723.GA8809@sig21.net>
 <7849bcd2-142d-0a12-0a04-7d0c3b6d788f@etorok.net>
 <20160805103544.kbt7znbzypvi5ofx@sig21.net>
 <20160805170228.GA19960@birch.djwong.org>
 <20160805181136.mcjnnvuo5m6kpxzb@sig21.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@etorok.net>,
	linux-kernel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Johannes Stezenbach <js@sig21.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160805181136.mcjnnvuo5m6kpxzb@sig21.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 05, 2016 at 08:11:36PM +0200, Johannes Stezenbach wrote:
> On Fri, Aug 05, 2016 at 10:02:28AM -0700, Darrick J. Wong wrote:
> > On Fri, Aug 05, 2016 at 12:35:44PM +0200, Johannes Stezenbach wrote:
> > > On Wed, Aug 03, 2016 at 05:50:26PM +0300, Török Edwin wrote:
> > > > I have just encountered a similar problem after I've recently upgraded to 4.7.0:
> > > > [Wed Aug  3 11:08:57 2016] EXT4-fs error (device dm-1): dx_probe:740: inode #13295: comm python: Directory index failed checksum
> > > > [Wed Aug  3 11:08:57 2016] Aborting journal on device dm-1-8.
> > > > [Wed Aug  3 11:08:57 2016] EXT4-fs (dm-1): Remounting filesystem read-only
> > > > [Wed Aug  3 11:08:57 2016] EXT4-fs error (device dm-1): ext4_journal_check_start:56: Detected aborted journal
> > > 
> > > It just happened again to me, this time hitting /usr/sbin/
> > > on root fs.  Meanwhile I ran memtest86 7.0 for two nights,
> > > it didn't find anything.  I'm using hibernate regularly
> > > and I think so this only happened after a few hibernate/resume
> > > cycles, but no idea if that means anything.
> > > Now I'm back at 4.4.16 to see if it reproduces.
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

FWIW I could trigger it reliably by running a bunch of directory traversal
programs simultaneously on the same directory.  I have a script that fires
up multiple mutts pointing to the Maildirs for the high traffic Linux lists.

--D

> 
> Thanks,
> Johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
