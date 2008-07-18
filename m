From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix data corruption when writing to prealloc area
Date: Fri, 18 Jul 2008 22:17:42 +0530
Message-ID: <20080718164742.GB25771@skywalker>
References: <1216387021-26384-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4880B2EE.8030903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:47911 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbYGRQr5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2008 12:47:57 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6IGkxBg029728
	for <linux-ext4@vger.kernel.org>; Sat, 19 Jul 2008 02:46:59 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6IGlt6K307488
	for <linux-ext4@vger.kernel.org>; Sat, 19 Jul 2008 02:47:55 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6IGlt8a006777
	for <linux-ext4@vger.kernel.org>; Sat, 19 Jul 2008 02:47:55 +1000
Content-Disposition: inline
In-Reply-To: <4880B2EE.8030903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2008 at 10:12:46AM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > We need to recalucate the path information on extent insert
> > even if depth doesn't change.
> 
> Aneesh, do you have a compact test case for this?
> 


git://github.com/shehjart/tools.git

writefallocate/test.sh

-aneesh
