From: Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>
Subject: Re: [PATCH, RFC] ext4: Remove i_ext_generation from	ext4_inode_info
 structure
Date: Sat, 08 Nov 2008 13:07:44 +0300
Message-ID: <491564F0.4030502@sun.com>
References: <E1KxVcr-0005hL-Qy@closure.thunk.org>
 <20081108085928.GK3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:43086 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYKHKVJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Nov 2008 05:21:09 -0500
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe2.eu.sun.com [192.18.6.11])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mA8A8n5b015502
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 10:09:00 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KA000401EKJSX00@fe-emea-09.sun.com>
 (original mail from Alex.Zhuravlev@Sun.COM) for linux-ext4@vger.kernel.org;
 Sat, 08 Nov 2008 10:08:49 +0000 (GMT)
In-reply-to: <20081108085928.GK3184@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Nov 04, 2008  18:47 -0500, Theodore Ts'o wrote:
>> ext4_inode_info.i_ext_generation isn't used by anything.  Was there an
>> intent to use it for something in the future?
> 
> Alex was going to use this at one point in the future, but it never
> happened.

actually it was used by delayed allocation patch as walk_space() takes
truncate_sem, then, if block isn't allocated yet, start transaction which
we can't do holding truncate_sem. so the idea is to release truncate_sem,
start transaction, then acquire truncate_sem. but in this window the tree
can change making path structure obsolete. either we check tree hasn't
changed or use generation to avoid unneeded path revalidation?

thanks, Alex



