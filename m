From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Tool to view extent metadata
Date: Fri, 10 Jul 2009 10:49:29 +0530
Message-ID: <20090710051929.GA17701@skywalker>
References: <23904f640907091517w10608fa4y9b3b8b3a631217c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manuel Benitez <rickyb@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55386 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZGJFTh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jul 2009 01:19:37 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp08.au.ibm.com (8.13.1/8.13.1) with ESMTP id n6AFCQGM019832
	for <linux-ext4@vger.kernel.org>; Sat, 11 Jul 2009 01:12:26 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6A5JZu91286342
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 15:19:35 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6A5JZ1o027174
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 15:19:35 +1000
Content-Disposition: inline
In-Reply-To: <23904f640907091517w10608fa4y9b3b8b3a631217c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 09, 2009 at 03:17:00PM -0700, Manuel Benitez wrote:
> I'm currently evaluating the ext4 allocator and one thing I've come
> across is the lack of a tool that displays the exact structure of the
> extents making up a file. I've found plenty of tools that will tell me
> how many contiguous segments a file contains, but nothing so far to
> let me see the actual makeup of the extents that map the inode to the
> blocks that comprise the file. Have I just missed something obvious,
> or would this be something worth me spending some time doing?
> 
> If so, one option would be to either modify the stat command or add a
> similar command in debugfs to show the extents from the roots through
> the root down to the leafs. Anyone have preferences or opinions?
> 


tst_exents in lib/ext2fs/ provide a debugfs similar interface. There are
commands for inode, root etc

-aneesh
