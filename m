From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [PATCH] e2fsprogs: Offsets of EAs in inode need not be sorted
Date: Sat, 21 Apr 2007 00:47:51 +0530
Message-ID: <1177096671.3171.4.camel@garfield>
References: <1176984336.3812.10.camel@garfield>
	 <20070420123832.GB18529@thunk.org> <1177074341.7371.19.camel@garfield>
	 <20070420141052.GA28227@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:43308 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbXDTTPb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Apr 2007 15:15:31 -0400
In-Reply-To: <20070420141052.GA28227@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-04-20 at 10:10 -0400, Theodore Tso wrote:
> On Fri, Apr 20, 2007 at 06:35:41PM +0530, Kalpak Shah wrote:
> > 
> > I saw this problem when I was running a script which created a random
> > number of EAs for a file of random sizes. If you mount the image I have
> > given, all the EAs are displayed and they can be used/modified/deleted
> > without any problems so its not a bug in ext3 code.
> 
> Not a bug in the ext3 code, but if a RHEL5 or SLES 10 or Debian etch
> user uses EA-in-Inode, with SELinux enabled, and then uses the e2fsck
> shipped with their distro, some of the unsorted EA's would get
> deleted.... right?  

Yes thats what I meant, it is certainly not a bug in ext3. And actually
the effects are worse, _all_ the EAs in the inode get deleted. I think
not many people have been using > 128 byte inodes and hence this problem
might not have cropped up until now.

Thanks,
Kalpak Shah.
<kalpak@clusterfs.com>

> 
> If that's correct, then that's a pretty nasty data corruption problem
> (that with SELinux enabled could cause the system to become completely
> non-functional, further contributing to SELinux's bad reputation...)
> and we'll need to push your patch to the various distro's as a
> relatively high priority bug fix.
> 
> 						- Ted
