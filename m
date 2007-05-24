From: Karel Zak <kzak@redhat.com>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Fri, 25 May 2007 01:25:21 +0200
Message-ID: <20070524232521.GD26432@petra.dvoda.cz>
References: <1179777153.3910.13.camel@garfield> <4652987D.70209@clusterfs.com> <1179819282.4797.9.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Manoj Joseph <manoj@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbXEXXZY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 May 2007 19:25:24 -0400
Content-Disposition: inline
In-Reply-To: <1179819282.4797.9.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 22, 2007 at 01:04:42PM +0530, Kalpak Shah wrote:
> On Tue, 2007-05-22 at 12:45 +0530, Manoj Joseph wrote:
> > Kalpak Shah wrote:
> > > Hi,
> > > 
> > > There have been reported instances of a filesystem having been
> > > mounted at 2 places at the same time causing a lot of damage to the
> > > filesystem. This patch reserves superblock fields and an INCOMPAT
> > > flag for adding multiple mount protection(MMP) support within the
> > > ext4 filesystem itself. The superblock will have a block number
> > > (s_mmp_block) which will hold a MMP structure which has a sequence
> > > number which will be periodically updated every 5 seconds by a
> > > mounted filesystem. Whenever a filesystem will be mounted it will
> > > wait for s_mmp_interval seconds to make sure that the MMP sequence
> > > does not change. To further make sure, we write a random sequence
> > > number into the MMP block and wait for another s_mmp_interval secs.
> > > If the sequence no. doesn't change then the mount will succeed. In
> > > case of failure, the nodename, bdevname and the time at which the MMP
> > > block was last updated will be displayed. tune2fs can be used to set
> > > s_mmp_interval as desired.

 Frankly, I don't understand why we need this feature. The filesystem
 limitations (=not ready for clusters) should be described in docs.
 That's enough from my POV...

> >
> > What would the default value of s_mmp_interval be? 5 seconds? more?
> 
> I have set the default value to 6 seconds. Depending on specific
> conditions (hardware, etc.) it can be increased using tunefs.
> > 
> > If I am not reading this wrong a mount will take more than 
> > 's_mmp_interval' seconds to complete. Wouldn't this be too much of a 
> > penalty during boot up if the system has many 'mount at boot' filesystems?
> 
> Yes it may take a maximum of s_mmp_interval*2 seconds to mount a
> filesystem which has INCOMPAT_MMP feature set. Its up to the user to use
> this feature, if he finds the penalty is too large, he can do away with
> this feature. This feature will mostly be used for filesystems used in
> failover scenarios.

 I hope the feature will be disabled by default. It sounds strange
 that I have to way 6 secs to mount a FS if I (and 99% of Linux users)
 needn't to share same FS between two mountpoint. 
 
 I have 5 filesystems on my workstation = 30 secs penality during boot?!

> > Also, I am curious about this. Is there a test case for mounting the 
> > same filesystem multiple times? Does this use different paths to reach 
> > the device? Or is there a race? Or does it happen on a device shared by 
> > multiple hosts?
> 
> If you are using some HA software, there is the possibility of a race.
> Yes it can happen on a device shared by multiple hosts.

 That's reason why people use OCFS or GFS.

> A simple test case for this will be:
> $ dd if=/dev/zero of=img0 bs=1M count=256
> $ mke2fs -F -j img0
> $ ln img0 img1
> $ losetup /dev/loop0 img0
> $ losetup /dev/loop1 img1
> $ mount /dev/loop0 /mnt/loop0
> $ mount /dev/loop1 /mnt/loop1
> 
> This succeeds currently causing a multiple mount.

 And what? That's wrong FS usage.
 
    Karel

-- 
 Karel Zak  <kzak@redhat.com>
