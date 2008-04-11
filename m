From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 0/3] fiemap patches (RFC/testing)
Date: Fri, 11 Apr 2008 17:29:13 -0600
Message-ID: <20080411232913.GT5693@webber.adilger.int>
References: <47EA6DA9.4010103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Kalpak Shah <Kalpak.Shah@sun.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44409 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbYDKX3R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Apr 2008 19:29:17 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3BNTGbo006501
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2008 16:29:16 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZ600M01P6UIP00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 11 Apr 2008 16:29:16 -0700 (PDT)
In-reply-to: <47EA6DA9.4010103@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 26, 2008  10:37 -0500, Eric Sandeen wrote:
> Since Akira would like to use the fiemap ioctl for defrag, I thought I should
> put what I have so far out on the list, at least.  This could go in the unstable
> part of the tree if you like, though I need to do more testing etc before it's 
> really ready to go.
> 
> Also, below is a quick test application I was using with the ioctl.

Note that we have a patch for the e2fsprogs filefrag tool to use FIEMAP
ioctl first, and fall back to FIBMAP if that returns -EOPNOTSUPP or -ENOTTY.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

