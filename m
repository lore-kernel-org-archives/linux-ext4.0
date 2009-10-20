From: Andreas Dilger <adilger@sun.com>
Subject: Re: changing stride and stripe_width post-fs-creation?
Date: Tue, 20 Oct 2009 15:08:51 -0600
Message-ID: <EA1A7036-FD43-4996-9665-E04FD32A449F@sun.com>
References: <7284e2210910201032h74cf437bm6043d97748ece4c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Doug Hunley <doug@hunley.homeip.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42738 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZJTVIv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Oct 2009 17:08:51 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n9KL8ubM006861
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 14:08:56 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KRT00K00ZUOR900@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 20 Oct 2009 14:08:56 -0700 (PDT)
In-reply-to: <7284e2210910201032h74cf437bm6043d97748ece4c9@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 20-Oct-09, at 11:32, Doug Hunley wrote:
> Is it safe to use tune2fs to alter stride and stripe_width on an ext4
> fs once it has been created? Any caveats I should know about? Thanks


The stride is mostly used at fs creation time, but there is no problem
with changing it.  The stripe_width is used by the allocator to align
file allocations with the RAID layout.

One question for Eric is whether the new libdisk patches he made will  
set
the stripe_width to something ridiculous like 512 or 4096 bytes, or if  
it
just leaves that field unset in that case.  I suspect it would be bad  
for
mballoc to see the stripe_width be such a small value.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

