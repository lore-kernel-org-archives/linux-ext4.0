From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Offsets of EAs in inode need not be sorted
Date: Fri, 20 Apr 2007 10:10:52 -0400
Message-ID: <20070420141052.GA28227@thunk.org>
References: <1176984336.3812.10.camel@garfield> <20070420123832.GB18529@thunk.org> <1177074341.7371.19.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53620 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993248AbXDTOK4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Apr 2007 10:10:56 -0400
Content-Disposition: inline
In-Reply-To: <1177074341.7371.19.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 20, 2007 at 06:35:41PM +0530, Kalpak Shah wrote:
> 
> I saw this problem when I was running a script which created a random
> number of EAs for a file of random sizes. If you mount the image I have
> given, all the EAs are displayed and they can be used/modified/deleted
> without any problems so its not a bug in ext3 code.

Not a bug in the ext3 code, but if a RHEL5 or SLES 10 or Debian etch
user uses EA-in-Inode, with SELinux enabled, and then uses the e2fsck
shipped with their distro, some of the unsorted EA's would get
deleted.... right?  

If that's correct, then that's a pretty nasty data corruption problem
(that with SELinux enabled could cause the system to become completely
non-functional, further contributing to SELinux's bad reputation...)
and we'll need to push your patch to the various distro's as a
relatively high priority bug fix.

						- Ted
