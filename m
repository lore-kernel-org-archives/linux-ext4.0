From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext3: kernel BUG at fs/jbd/journal.c:412!
Date: Thu, 6 Nov 2008 22:13:26 +0530
Message-ID: <20081106164326.GG25194@skywalker>
References: <20081106155025.GE25194@skywalker> <20081106161227.GA9254@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Arthur Jones <ajones@riverbed.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:60741 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbYKFQvQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 11:51:16 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id mA6GovGj3874934
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 03:50:57 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA6GhfgE3068006
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 03:43:41 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA6Ghbq7013582
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 03:43:37 +1100
Content-Disposition: inline
In-Reply-To: <20081106161227.GA9254@ajones-laptop.nbttech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 06, 2008 at 08:12:27AM -0800, Arthur Jones wrote:
> Hi Aneesh, ...
> 
> On Thu, Nov 06, 2008 at 07:50:25AM -0800, Aneesh Kumar K.V wrote:
> > I get this with ext4-patchqueue. I guess we have some ext3 patches queued there.
> 
> This could be related to a patch I just posted.
> 
> I'd like to try to reproduce this.  What is the
> ext4-patchqueue?  What were you running that caused
> this to pop up?

I got it while running fsstress with mem=128MB kernel option.
I can also reproduce it while running http://lkml.org/lkml/2006/12/27/180

> 
> See the thread on linux-ext4 called "ext3: slow symlink corruption
> on umount" for details on how this patch came about...
> 
> Thanks...
> 

-aneesh
