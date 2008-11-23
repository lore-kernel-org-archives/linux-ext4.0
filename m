From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH -V2 4/5] ext4: Use both hi and lo bits of the group desc
	values.
Date: Sat, 22 Nov 2008 22:09:39 -0600
Message-ID: <20081123040939.GU3186@webber.adilger.int>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <4926F00D.6030403@redhat.com> <20081121174110.GH11212@skywalker>
 <4926F599.5040605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Coly Li <coyli@suse.de>, cmm@us.ibm.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62295 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbYKWEJr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Nov 2008 23:09:47 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAN49g1V003533
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 20:09:42 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAR00J01Q2RWL00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 22 Nov 2008 20:09:42 -0800 (PST)
In-reply-to: <4926F599.5040605@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 21, 2008  11:53 -0600, Eric Sandeen wrote:
> Ok, and for the rest?  (free_blocks, free_inodes) - I guess these are
> only needed for > 2^32 block filesystems?

Actually, since this is a per-group number, I'm not sure why this is
needed at all.  I don't object to keeping the helper functions though.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

