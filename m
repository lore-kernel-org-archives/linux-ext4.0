From: Andreas Dilger <adilger@sun.com>
Subject: Re: Ordered data mode vs. writeback mode
Date: Tue, 17 Jun 2008 08:34:07 -0600
Message-ID: <20080617143407.GC3726@webber.adilger.int>
References: <3.0.6.32.20080616225930.01b86a60@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57222 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714AbYFQOeL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 10:34:11 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5HEY8uJ028570
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 07:34:10 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2M00C0131OQ200@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 17 Jun 2008 07:34:08 -0700 (PDT)
In-reply-to: <3.0.6.32.20080616225930.01b86a60@pop.west.cox.net>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 16, 2008  22:59 +0000, Gary Hawco wrote:
> What is the preferred mode for a home desktop system with ext4? Is
> writeback still the fastest, but ordered data has more data integrity?  And
> does delalloc only work when writeback is enabled? And does the commit=XX
> seconds still only work with writeback mode, ala ext3, or is it a valid
> option with ordered data mode?

Using ordered mode is the default and preferred mode.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

