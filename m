From: Andreas Dilger <adilger@sun.com>
Subject: Re: Tool to view extent metadata
Date: Thu, 09 Jul 2009 16:55:07 -0600
Message-ID: <20090709225507.GH5073@webber.adilger.int>
References: <23904f640907091517w10608fa4y9b3b8b3a631217c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Manuel Benitez <rickyb@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45784 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZGIWzX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jul 2009 18:55:23 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n69MtM4B005917
	for <linux-ext4@vger.kernel.org>; Thu, 9 Jul 2009 15:55:22 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KMJ00E00DS11N00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Thu,
 09 Jul 2009 15:55:22 -0700 (PDT)
In-reply-to: <23904f640907091517w10608fa4y9b3b8b3a631217c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 09, 2009  15:17 -0700, Manuel Benitez wrote:
> I'm currently evaluating the ext4 allocator and one thing I've come
> across is the lack of a tool that displays the exact structure of the
> extents making up a file. I've found plenty of tools that will tell me
> how many contiguous segments a file contains, but nothing so far to
> let me see the actual makeup of the extents that map the inode to the
> blocks that comprise the file. Have I just missed something obvious,
> or would this be something worth me spending some time doing?
> 
> If so, one option would be to either modify the stat command or add a
> similar command in debugfs to show the extents from the roots through
> the root down to the leafs. Anyone have preferences or opinions?

The "filefrag" tool in recent e2fsprogs should provide such information,
using the FIEMAP ioctl to extract extent information from the kernel.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

