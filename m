From: Andreas Dilger <adilger@sun.com>
Subject: Re: Do we need dump for ext4?
Date: Thu, 28 Aug 2008 14:04:48 -0600
Message-ID: <20080828200448.GQ3392@webber.adilger.int>
References: <48B6BD02.3080307@redhat.com> <20080828184804.GN26987@mit.edu>
 <48B6F69C.3090700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38742 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990AbYH1UFB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 16:05:01 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7SK50aU003503
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 13:05:00 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6B00201U73SU00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 28 Aug 2008 13:05:00 -0700 (PDT)
In-reply-to: <48B6F69C.3090700@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 28, 2008  15:03 -0400, Ric Wheeler wrote:
>> Finally, I suspect most of the problem with using tar is the HTREE
>> dirent sorting problem.  If we modify tar to sort the directory
>> entries before emitting the files, and then use that tar across all
>> the filesystems, I suspect the results would be much more better for
>> ext3 and ext4.
>
> Like acp ;-)

I think there is little benefit to fixing each program to do sorting.
Either your LD_PRELOAD library should become more standard (e.g. put
into glibc), or we use something like e2scan or a modified find to
generate filenames in inode order.

NB: e2scan itself scans the inode table in order, but it makes no effort
    to generate filenames in that order, since Lustre doesn't care about
    that.  It likely gets it largely right by coincidence.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

