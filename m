From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 10/17] signed int -> blk64_t to fix bugs at 2^31 -	2^32
 blocks
Date: Fri, 14 Nov 2008 13:35:08 -0700
Message-ID: <20081114203508.GX16005@webber.adilger.int>
References: <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
 <1226461390-5502-10-git-send-email-vaurora@redhat.com>
 <1226461390-5502-11-git-send-email-vaurora@redhat.com>
 <20081113195742.GV16005@webber.adilger.int> <20081114023812.GD20637@shell>
 <20081114142433.GD25117@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:59719 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYKNUfL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2008 15:35:11 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAEKZB8I005791
	for <linux-ext4@vger.kernel.org>; Fri, 14 Nov 2008 12:35:11 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAC00101BS0SN00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 14 Nov 2008 12:35:11 -0800 (PST)
In-reply-to: <20081114142433.GD25117@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 14, 2008  09:24 -0500, Theodore Ts'o wrote:
> I'll probably miss next week's conference call as well since I'll be in
> Tokyo, BTW.

Speaking of which, I'll also miss next week's call due to travelling.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

