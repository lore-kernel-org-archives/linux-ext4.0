From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Add extent conversion support to chattr
Date: Fri, 12 Sep 2008 09:26:44 -0600
Message-ID: <20080912152644.GB3086@webber.adilger.int>
References: <1221210249-26484-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20080912091713.GY3086@webber.adilger.int> <20080912092749.GC8405@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63003 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYILP0v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2008 11:26:51 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8CFQoiQ020379
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 08:26:50 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7300K019FQ8O00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 12 Sep 2008 08:26:50 -0700 (PDT)
In-reply-to: <20080912092749.GC8405@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 12, 2008  14:57 +0530, Aneesh Kumar wrote:
> On Fri, Sep 12, 2008 at 03:17:13AM -0600, Andreas Dilger wrote:
> > Why not just try to set this flag and let the kernel decide what is
> > possible?
> 
> The motivation is to give a clear message that we still don't support
> clearing extent flags. If we pass it to the kernel we will get
> operation not supported error which would confuse the user who does
> chattr -de f1

The problem is that if the kernel ever does allow converting extents->
block-mapped (or some other mapping that isn't extents), the chattr
tool will cause this to fail even when it shouldn't.  Better to leave
the check in a single place (the kernel, which knows best).

I don't think the user would be too confused.  You could still check
after the call to the kernel to see if the "e" option is being removed
and print an error if the call failed.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

