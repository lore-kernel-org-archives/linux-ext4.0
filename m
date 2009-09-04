From: Andreas Dilger <adilger@sun.com>
Subject: Re: EXT4: kernel BUG at fs/ext4/mballoc.c:1721!
Date: Fri, 04 Sep 2009 06:52:33 -0600
Message-ID: <20090904125233.GE4197@webber.adilger.int>
References: <4A9F7B48.9010903@in.ibm.com>
 <20090903112003.GA13105@skywalker.linux.vnet.ibm.com>
 <4AA0CF83.8060405@in.ibm.com>
 <20090904084943.GB19757@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Sachin Sant <sachinp@in.ibm.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:40229 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538AbZIDMw1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Sep 2009 08:52:27 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n84CqD2w022676
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 05:52:28 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPG000006BLUK00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 04 Sep 2009 05:52:13 -0700 (PDT)
In-reply-to: <20090904084943.GB19757@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 04, 2009  14:19 +0530, Aneesh Kumar wrote:
> Ok i am running test with the below patch. It is more invasive in that it
> moves the need init flag check into load buddy. I guess we need to do that,
> otherwise we will be operating with stale buddy information when
> we have resize happening parallel. Also with the patch i posted before
> we still have issues as explained below
> 
> a) we check for init flag we find it doesn't need an cache init
> b) we resize and mark the group in need for init
> c) in load buddy we look at the pageuptodate flag and find it uptodate
>    and continue using the old buddy cache information.

Why not have the resize code do the update of the buddy bitmap also?
When we were just using the block bitmap for allocation the resize
code would clear the bits in the bitmap just like deleting a file,
so that it was totally coherent with any other bitmap user.  Having
the resize code do the same with the buddy (instead of only marking
it stale and leaving it for another process to refresh) should avoid
the race condition entirely.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

