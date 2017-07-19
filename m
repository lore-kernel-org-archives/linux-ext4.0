From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] tune2fs: remove dire warning about check intervals
Date: Wed, 19 Jul 2017 10:57:05 -0700
Message-ID: <20170719175705.GB4211@magnolia>
References: <ce6bff3e-49f4-2bed-67ce-a7be604ce1cf@redhat.com>
 <CD3439EC-F272-4172-8C7F-229C6DAE06EC@dilger.ca>
 <20170719011517.tfvnzb7mzfle25hi@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Eric Sandeen <sandeen@redhat.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33483 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753322AbdGSR5T (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Jul 2017 13:57:19 -0400
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

So... I've had a private debian package for years that does most of
this.  There are two scripts -- one that uses lvs and blkid to identify
potential ext4 LVS and calls the second script, which sets up the
snapshot, runs e2fsck on that, and (optionally) calls fstrim on the
original fs if the snapshot fscks cleanly.  There's also a udev rules
script to discourage udev from "managing" /dev/disk/ symlinks to the
fsck snapshot.  Newer versions of the package integrate systemd support
to (clumsily) isolate the e2fsck process, send email if things fail, and
run automatically a la cron.

There are some missing pieces, however -- I didn't modify d-i to reserve
free space in the VG; there needs to be a monitoring daemon to kill fsck
and the snapshot if the snapshot exhausts all of its space; a boot time
script to kill the fsck snapshots if the system happened to go down
while fsck was in progress.  It also assumes that the fs is idle enough
that 256M for the snapshot will be sufficient.

I've never bothered to submit any of it because I haven't had the time
to implement any of those missing bits.

--D

> 
> 	     	  	    	      - Ted
