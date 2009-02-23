From: Andreas Dilger <adilger@sun.com>
Subject: Re: rawhide's init/nash segfaults in libblkid
Date: Mon, 23 Feb 2009 15:42:19 -0700
Message-ID: <20090223224219.GB3199@webber.adilger.int>
References: <87ab8dds1z.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64890 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbZBWWnF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Feb 2009 17:43:05 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n1NMgqEw017722
	for <linux-ext4@vger.kernel.org>; Mon, 23 Feb 2009 14:42:56 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KFJ00700ICIMA00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 23 Feb 2009 14:42:52 -0800 (PST)
In-reply-to: <87ab8dds1z.fsf@meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 23, 2009  17:41 +0100, Jim Meyering wrote:
> FYI, I've just filed this against the kernel:
> 
>   http://bugzilla.redhat.com/486997
> 
> Perhaps it should be reassigned to e2fsprogs...
> ---------
> 
> Normally I track rawhide pretty closely, but for the last few weeks
> new kernels haven't booted on the system I use for that, so I stuck
> with the most recent one that worked,

Is rawhide using util-linux-ng that included the libblkid code?  It
seems we probably need to add a configure check to e2fsprogs not to
build libblkid if util-linux-ng has it.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

