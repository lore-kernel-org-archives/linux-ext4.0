From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4 patched linux-2.6.26-rc6 kernel crashes
Date: Mon, 16 Jun 2008 23:14:39 +0530
Message-ID: <20080616174439.GE14214@skywalker>
References: <3.0.6.32.20080616102947.02418998@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:58882 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYFPRpC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 13:45:02 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5GHi5XY016896
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 03:44:05 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5GHixXA254064
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 03:44:59 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5GHix8X031649
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 03:44:59 +1000
Content-Disposition: inline
In-Reply-To: <3.0.6.32.20080616102947.02418998@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 16, 2008 at 10:29:47AM +0000, Gary Hawco wrote:
> Good morning,
> 
> I can't seem to get my linux kernel 2.6.26-rc6 patched with the latest
> ext4-patch-queue to boot.
> 
> The patches apply fine and the kernel compiles fine. I used my .config from
> -rc5 kernel which will boot fine.
> 
> This "oops" occurs in both Gentoo and Slackware 12.1. It seems to happen at
> about the point when the operating systems are autoloading modules.
> 
> I am unable to take a screen shot to assist, so I was wondering if someone
> could try the new kernel with the latest patches?  The source is the latest
> linux-2.6.26-rc6.tar.bz2 so I am sure it's fine.
> 

The below patch should fix one of the crash reported. 

http://article.gmane.org/gmane.comp.file-systems.ext4/7321


-aneesh
