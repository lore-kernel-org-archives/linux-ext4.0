From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: panic on boot at ext4_mb_poll_new_transaction
Date: Thu, 16 Oct 2008 12:47:16 +0530
Message-ID: <20081016071716.GB19480@skywalker>
References: <20081016070735.GA28486@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Michael Spang <mspang@csclub.uwaterloo.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:32885 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYJPHYF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Oct 2008 03:24:05 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id m9G7URPu181138
	for <linux-ext4@vger.kernel.org>; Thu, 16 Oct 2008 18:30:28 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9G7HUnd3293196
	for <linux-ext4@vger.kernel.org>; Thu, 16 Oct 2008 18:17:30 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9G7HTZ6017819
	for <linux-ext4@vger.kernel.org>; Thu, 16 Oct 2008 18:17:30 +1100
Content-Disposition: inline
In-Reply-To: <20081016070735.GA28486@csclub.uwaterloo.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 16, 2008 at 03:07:35AM -0400, Michael Spang wrote:
> I switched my laptop over to ext4 yesterday. Then I used tune2fs to
> enable the features from mke2fs.conf's defaults for ext4 (some failed).
> 
> It worked fine initially but today I am getting a panic when the machine
> boots: http://csclub.uwaterloo.ca/~mspang/panic.jpg .
> 
> Let me know if there's anything I can do to rescue it. Otherwise I'll
> just reinstall.

Which version of the kernel ? Did you try ext4 patchqueu at
http://repo.or.cz/w/ext4-patch-queue.git . I have a patch queued
for fixing a crash I found. I am not sure whether it is same one
http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=do_mballoc_init_before_doing_filesystem_recovery;h=426bb0dab5fc5279e077a542cd4068d13f945dff;hb=HEAD

-aneesh
