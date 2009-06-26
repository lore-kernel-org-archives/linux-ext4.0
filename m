From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext3: massive latencies for some write operations
Date: Fri, 26 Jun 2009 06:54:03 +0200
Message-ID: <20090626045403.GS3385@webber.adilger.int>
References: <97c719fa0906251918i5b047943yde752774c686f301@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, calvin.walton@gmail.com
To: Nick Bowler <nbowler@draconx.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:52590 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZFZEyI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Jun 2009 00:54:08 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n5Q4s7MI000583
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2009 21:54:07 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KLT00L00XALMB00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Thu,
 25 Jun 2009 21:54:07 -0700 (PDT)
In-reply-to: <97c719fa0906251918i5b047943yde752774c686f301@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 25, 2009  22:18 -0400, Nick Bowler wrote:
> I wasn't entirely sure which list to post this on, this one seemed to
> fit best.  Apologies if there was a better place.
> 
> Please CC any replies to me me as I am not subscribed to the list.

This is a relatively well-known problem with ext3.

> Recently, I've been experiencing enormous (more than a minute)
> latencies during some write operations to my /home filesystem.  During
> such a time, many programs tend to completely stop responding,
> although programs doing continuous reads (e.g. music or video players)
> appear to be unaffected.
> 
> The filesystem is a 3TB ext3 filesystem on a software raid-5 array (4x
> 1TB drives).  Dmesg is completely silent.
> 
> I'm on an amd64 running 2.6.30.  However, I had these issues on 2.6.26
> and 2.6.29 as well.  Latencytop output follows.
> 
>    LatencyTOP version 0.4       (C) 2008 Intel Corporation
> 
> Process amuled (19428)                     Total: 69182.1 msec
> start_this_handle journal_start ext3_journal_start68746.9 msec       99.4 %
> sync_page __lock_page find_lock_page filemap_fault 84.5 msec          0.3 %
> sync_page sync_page_killable __lock_page_killable  20.9 msec          0.0 %

You have some application that is doing a lot of "fsync" operations,
but because there is likely also a lot of other IO going on the
fsync operations are taking a long time to sync the journal.

If you use ext4 this problem should go away.  I would recommend the
FC11 2.6.29 kernel, since it has all of the latest ext4 fixes in it.

If you wanted to throw some hardware at the problem, adding an SSD device
for the journal should also solve the problem for ext3.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

