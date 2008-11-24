From: Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap and
 mark_diskspace_used
Date: Mon, 24 Nov 2008 19:36:49 +0300
Message-ID: <492AD821.9030506@sun.com>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20081123140038.GC26473@mit.edu> <492A5453.9030801@sun.com>
 <20081124113323.GC8462@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@MIT.EDU>, cmm@us.ibm.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:65021 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbYKXQg7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 11:36:59 -0500
Received: from fe-emea-10.sun.com (gmp-eb-lb-1-fe3.eu.sun.com [192.18.6.10])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAOGav92027345
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 16:36:57 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAU00H01J2GNT00@fe-emea-10.sun.com>
 (original mail from Alex.Zhuravlev@Sun.COM) for linux-ext4@vger.kernel.org;
 Mon, 24 Nov 2008 16:36:57 +0000 (GMT)
In-reply-to: <20081124113323.GC8462@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Ok the changes was not done for this purpose. I need to make sure we
> update bitmap and clear group_desc uninit flag after taking sb_bgl_lock
> That means when we claim blocks we can't use mb_set_bits with
> sb_bgl_lock because we would already be holding it. How about the below
> change

may I have a look at the original patch?

thanks, Alex

