From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/3] ext4: add EXT4_IOC_GETCRTIME ioctl
Date: Mon, 18 Aug 2008 02:01:58 -0700
Message-ID: <20080818090158.GJ3040@webber.adilger.int>
References: <48996A33.3010507@cn.fujitsu.com> <20080810022643.GC14756@mit.edu>
 <48A8D98B.9020701@cn.fujitsu.com> <20080818023656.GA20338@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38950 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYHRJCD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2008 05:02:03 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7I920sP019324
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 02:02:01 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K5S00E01GYXJ700@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 18 Aug 2008 02:02:00 -0700 (PDT)
In-reply-to: <20080818023656.GA20338@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 17, 2008  22:36 -0400, Theodore Ts'o wrote:
> That's the quick and dirty fast answer, yes.  The long-term (but one
> which involves much more work) is to define a new struct
> kernel<->glibc stat interface (we already have 5 or so :-) to extend
> it include st_crtime, and then try to get glibc to use the magic of
> ELF symbol versioning so there is a new struct stat as defined in
> /usr/include, and a new stat(2) call defined in glibc, which returns
> the new struct stat which include st_crtime.  This also means we have
> to define proper semantics for what happens if a filesystem doesn't
> support st_crtime.

In the meantime, I'd think it preferable to use a virtual-xattr to get
this information from the kernel instead of an ioctl.  That way a shell
script can extract it with getfattr, and it is no harder to do from a
C program using getxattr().

I'd propose something like "system.creation_time" for the xattr name,
but I'll leave it up to people who care to propose better names.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

