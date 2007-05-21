From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: files mapped funny? (related to online defragmentation)
Date: Mon, 21 May 2007 11:00:59 -0700
Message-ID: <1179770459.23003.7.camel@localhost.localdomain>
References: <1179755398.389.24.camel@eric-laptop>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:37086 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215AbXEUSBG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 May 2007 14:01:06 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4LI13lN022073
	for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 14:01:03 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4LI105c260308
	for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 12:01:03 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4LI10mN010114
	for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 12:01:00 -0600
In-Reply-To: <1179755398.389.24.camel@eric-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-05-21 at 06:49 -0700, Eric wrote:
> Hi,
> 
> I'm getting strange results when I map out the blocks used in files
> larger than a several thousand KB. I never seem to get any more than
> 1024 contiguous data blocks in a row. 
> 
> Here's a portion of the output of my script when I run it on a 176MB
> file in my home directory:
> ...
> Contiguous chunk 67: 2385568 - 2385591  (24 blocks)
> Contiguous chunk 68: 2385608 - 2386448  (841 blocks)
> Contiguous chunk 69: 2386450 - 2387473  (1024 blocks)
> Contiguous chunk 70: 2387475 - 2388498  (1024 blocks)
> Contiguous chunk 71: 2388500 - 2389523  (1024 blocks)
> ...
>
> Maybe this is a bug in my script? Can anyone explain why this would
> happen?
> 
filefrag command comes with e2fsprogs will print the file fragmentation
info. I guess you can try filefrag -v command and see if that matches
what your scripts reported.

Mingming

> I'm attaching my script in case other ext2/3/4 newbies can get any use
> out of it, and in case anyone needs to see it in order to answer my
> question. It's pretty self-explanatory, though.
> 
> Cheers,
> 
> Eric
> 
