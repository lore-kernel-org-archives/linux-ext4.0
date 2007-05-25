From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Fri, 25 May 2007 12:14:23 +0530
Message-ID: <1180075463.4658.12.camel@garfield>
References: <1179777153.3910.13.camel@garfield>
	 <4652987D.70209@clusterfs.com> <1179819282.4797.9.camel@garfield>
	 <20070524232521.GD26432@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Manoj Joseph <manoj@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:33432 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbXEYGkj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 May 2007 02:40:39 -0400
In-Reply-To: <20070524232521.GD26432@petra.dvoda.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-05-25 at 01:25 +0200, Karel Zak wrote:
>  Frankly, I don't understand why we need this feature. The filesystem
>  limitations (=not ready for clusters) should be described in docs.
>  That's enough from my POV...

It is highly advocated that ext3/4 filesystem should not be multiply
mounted. This just makes doubly sure of this only if the user desires.

> > >
> > > What would the default value of s_mmp_interval be? 5 seconds? more?
> > 
> > I have set the default value to 6 seconds. Depending on specific
> > conditions (hardware, etc.) it can be increased using tunefs.
> > > 
> > > If I am not reading this wrong a mount will take more than 
> > > 's_mmp_interval' seconds to complete. Wouldn't this be too much of a 
> > > penalty during boot up if the system has many 'mount at boot' filesystems?
> > 
> > Yes it may take a maximum of s_mmp_interval*2 seconds to mount a
> > filesystem which has INCOMPAT_MMP feature set. Its up to the user to use
> > this feature, if he finds the penalty is too large, he can do away with
> > this feature. This feature will mostly be used for filesystems used in
> > failover scenarios.
> 
>  I hope the feature will be disabled by default. It sounds strange
>  that I have to way 6 secs to mount a FS if I (and 99% of Linux users)
>  needn't to share same FS between two mountpoint. 
>  
>  I have 5 filesystems on my workstation = 30 secs penality during boot?!

This feature won't be enabled by default. Its absolutely the users
discretion if he wants to enable this feature. It can be set by tune2fs
and can be disabled without unmounting the filesystem. So you won't have
to waste time during mounting unless you choose to.

> 
> > > Also, I am curious about this. Is there a test case for mounting the 
> > > same filesystem multiple times? Does this use different paths to reach 
> > > the device? Or is there a race? Or does it happen on a device shared by 
> > > multiple hosts?
> > 
> > If you are using some HA software, there is the possibility of a race.
> > Yes it can happen on a device shared by multiple hosts.
> 
>  That's reason why people use OCFS or GFS.

OCFS and GFS are clustered file systems and hence provide read-write
support at multiple mount points.

Note that the MMP feature will make that you can't run e2fsck on a
mounted filesystem. So in short the filesystem cannot be opened in
read-write mode by more than 1 entity.

> 
> > A simple test case for this will be:
> > $ dd if=/dev/zero of=img0 bs=1M count=256
> > $ mke2fs -F -j img0
> > $ ln img0 img1
> > $ losetup /dev/loop0 img0
> > $ losetup /dev/loop1 img1
> > $ mount /dev/loop0 /mnt/loop0
> > $ mount /dev/loop1 /mnt/loop1
> > 
> > This succeeds currently causing a multiple mount.
> 
>  And what? That's wrong FS usage.

Here I had just described a test case for reproducing multiple mounts.

Thanks,
Kalpak.

>  
>     Karel
> 
