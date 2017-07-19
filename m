From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: remove dire warning about check intervals
Date: Tue, 18 Jul 2017 21:15:17 -0400
Message-ID: <20170719011517.tfvnzb7mzfle25hi@thunk.org>
References: <ce6bff3e-49f4-2bed-67ce-a7be604ce1cf@redhat.com>
 <CD3439EC-F272-4172-8C7F-229C6DAE06EC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37418 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751560AbdGSBPV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Jul 2017 21:15:21 -0400
Content-Disposition: inline
In-Reply-To: <CD3439EC-F272-4172-8C7F-229C6DAE06EC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 18, 2017 at 04:28:16PM -0600, Andreas Dilger wrote:
> 
> Sigh, I still think this is going in the wrong direction.  I'm happily
> running a weekly e2fsck on a snapshot of the filesystem, and then reset
> the time and mount-count fields in the superblock with tune2fs.  That
> way I never see any warnings, or have slow boots because of a scan, but
> I'm also notified if there are ever problems on the filesystem (which
> happens occasionally, since I'm sometimes running experimental code).
> 
> Since virtually everyone is using MD/LVM devices these days, I don't
> think that is hard to do.  I offered up my "lvcheck" script a few times,
> but nobody at RH or on the DM team seemed interested at the time...
> I'd also be happy if there was some other similar mechanism included with
> the distro to do periodic background checks of the filesystem, rather
> than letting them find any problem at some random time.  This is pretty
> standard for RAID systems, I think it makes sense for the filesystem too.

I've had e2croncheck in the contrib directory for a long time.  I
suspect it wouldn't be that hard to make a version of it which scans
/proc/mounts, and for those devices that are in an LVM, or dm-thin,
and if there is room for a snapshot, it would create a snapshot, run
fsck on the snapshot, and if there are any errors, sends an e-mail
report to root by default.  (We would need to have some kind of
configuration file in /etc to control where to send the reports, what
the default snapshot size should be, etc., but if we have intelligent
defaults than the config file could be optional.)

We could try to make it a bit nicer, and then move it to the misc
directory and start installing it by default with "make install".
That might make it easier for more users to set it up.  Maybe some
distros will even decide to install a crontab entry by default.

	     	  	    	      - Ted
