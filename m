From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] tune2fs: remove dire warning about check intervals
Date: Wed, 19 Jul 2017 09:21:57 +0200
Message-ID: <20170719072157.7kjwyltmuvzk2oec@localhost.localdomain>
References: <ce6bff3e-49f4-2bed-67ce-a7be604ce1cf@redhat.com>
 <CD3439EC-F272-4172-8C7F-229C6DAE06EC@dilger.ca>
 <20170719011517.tfvnzb7mzfle25hi@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Eric Sandeen <sandeen@redhat.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752751AbdGSHWI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Jul 2017 03:22:08 -0400
Content-Disposition: inline
In-Reply-To: <20170719011517.tfvnzb7mzfle25hi@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 18, 2017 at 09:15:17PM -0400, Theodore Ts'o wrote:
> On Tue, Jul 18, 2017 at 04:28:16PM -0600, Andreas Dilger wrote:
> > 
> > Sigh, I still think this is going in the wrong direction.  I'm happily
> > running a weekly e2fsck on a snapshot of the filesystem, and then reset
> > the time and mount-count fields in the superblock with tune2fs.  That
> > way I never see any warnings, or have slow boots because of a scan, but
> > I'm also notified if there are ever problems on the filesystem (which
> > happens occasionally, since I'm sometimes running experimental code).
> > 
> > Since virtually everyone is using MD/LVM devices these days, I don't
> > think that is hard to do.  I offered up my "lvcheck" script a few times,
> > but nobody at RH or on the DM team seemed interested at the time...
> > I'd also be happy if there was some other similar mechanism included with
> > the distro to do periodic background checks of the filesystem, rather
> > than letting them find any problem at some random time.  This is pretty
> > standard for RAID systems, I think it makes sense for the filesystem too.
> 
> I've had e2croncheck in the contrib directory for a long time.  I
> suspect it wouldn't be that hard to make a version of it which scans
> /proc/mounts, and for those devices that are in an LVM, or dm-thin,
> and if there is room for a snapshot, it would create a snapshot, run
> fsck on the snapshot, and if there are any errors, sends an e-mail
> report to root by default.  (We would need to have some kind of
> configuration file in /etc to control where to send the reports, what
> the default snapshot size should be, etc., but if we have intelligent
> defaults than the config file could be optional.)
> 
> We could try to make it a bit nicer, and then move it to the misc
> directory and start installing it by default with "make install".
> That might make it easier for more users to set it up.  Maybe some
> distros will even decide to install a crontab entry by default.
> 
> 	     	  	    	      - Ted

I am actually worried that with this approach we are, simply by adding
complexity, making situation worse than just not running periodic
e2fsck.

What we should be aiming for I think is the online file system check and
scrub. This would of course not replace the need rof e2fsck, but we
would be able to catch errors early while fixing some of those that we
can. But that's long term. Short term I think we're better off without
this snapshotting/checking complexity. Those who are concerned can still
enable the time/mount based checks right ?

-Lukas
