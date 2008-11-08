From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] ext4: Remove i_ext_generation from	ext4_inode_info
 structure
Date: Sat, 08 Nov 2008 01:59:28 -0700
Message-ID: <20081108085928.GK3184@webber.adilger.int>
References: <E1KxVcr-0005hL-Qy@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Alex Zhuravlev <Alex.Zhuravlev@sun.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63752 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbYKHI7b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Nov 2008 03:59:31 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mA88xVvc016418
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 00:59:31 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KA000A01BJ3V800@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 08 Nov 2008 00:59:30 -0800 (PST)
In-reply-to: <E1KxVcr-0005hL-Qy@closure.thunk.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 04, 2008  18:47 -0500, Theodore Ts'o wrote:
> ext4_inode_info.i_ext_generation isn't used by anything.  Was there an
> intent to use it for something in the future?

Alex was going to use this at one point in the future, but it never
happened.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

