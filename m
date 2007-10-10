From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: patch queue updated
Date: Wed, 10 Oct 2007 10:33:25 -0700
Message-ID: <1192037606.3880.19.camel@localhost.localdomain>
References: <470CBFFF.3080308@linux.vnet.ibm.com>
	 <1192032053.3880.11.camel@localhost.localdomain>
	 <470CFAB4.8080408@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:53352 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbXJJRdo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2007 13:33:44 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9AHXb5o024382
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 13:33:37 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9AHXRuX345030
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 11:33:32 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9AHXQOr025696
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 11:33:27 -0600
In-Reply-To: <470CFAB4.8080408@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-10-10 at 21:45 +0530, Aneesh Kumar K.V wrote:
> 
> Mingming Cao wrote:
> > On Wed, 2007-10-10 at 17:35 +0530, Aneesh Kumar K.V wrote:
> >> I have updated the patch queue at 
> >>
> >> http://www.radian.org/~kvaneesh/ext4/patch-series/
> >>
> >> http://www.radian.org/~kvaneesh/ext4/patch-series/ext4-patch-queue.tar
> >>
> >> Changes:
> >> a) Add large-file-blocktype.patch  large-file.patch patch.
> > 
> > Could you send them out separately? I noticed that your queue is not
> > based on the last ext4 patch queue. You modified mballoc-core.patch
> > directly with large file block type changes...but your updated
> > mballoc-core.patch doesn't have the latest proc fs fix from Ted. 
> > 
> 
> It has the changes. http://www.radian.org/~kvaneesh/ext4/patch-series/mballoc-core.patch
> I searched for PROC_FS . I did a git pull on patch queue before updating the patches.
> 
> 
> 
> 
> > I would appreciate if you separete the largeblocktype changes for
> > mballoc out of the core mballoc changes, as that patch is getting really
> > big already.
> > 
> >> b) Add the stable-boundary-patch with dummy change
> >> c) Add stable-boundary-undo.patch which undo the above dummy change.
> > 
> > The stable-boundary patch is being removed from ext4 patch queue,as some
> > tools expect a meaning code diff to apply any patch.
> > 
> 
> That is why i added a dummy change which is reverted by the later patch.
> 
I see your intention is to bring back the boundary patch which doesn't
upset the tools but also doesn't have any code impact to the tree.

Okay, updated ext4-patch-queue with your updates. 


> 
> -aneeshh-

> 
> -aneesh
