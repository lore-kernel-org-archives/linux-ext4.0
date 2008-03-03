From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4-mm-delalloc-ext4.patch
Date: Mon, 03 Mar 2008 15:12:44 -0800
Message-ID: <1204585964.3636.20.camel@localhost.localdomain>
References: <20080229010555.21ab9c77.akpm@linux-foundation.org>
	 <1204305996.3629.5.camel@localhost.localdomain>
	 <20080303130823.ed6991a8.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37405 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbYCCXNN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Mar 2008 18:13:13 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m23NFC0s019177
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 18:15:12 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m23NDDTD240406
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 18:13:13 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m23NDCHt028737
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 18:13:13 -0500
In-Reply-To: <20080303130823.ed6991a8.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-03-03 at 13:08 -0800, Andrew Morton wrote:
> On Fri, 29 Feb 2008 09:26:36 -0800
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > On Fri, 2008-02-29 at 01:05 -0800, Andrew Morton wrote:
> > > generic_commit_write() is scheduled for removal in 2.6.26 and is
> > > removed already from -mm.
> > > 
> > > Please switch to the new write_begin/write_end interface.
> > 
> > I have a patch for that, sent to linux-ext4 last week. I will merge it
> > to the parent patch and update in ext4 patch queue.
> > 
> > ext4: use write_begin/write_end in delalloc instead of prepare_write()
> > From: Mingming Cao <cmm@us.ibm.com>
> 
> Thanks.  But this change still isn't at
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/,
> so ext4 is still a no-build for me.
> 

Oh, sorry about the confusion.  What I mean by "ext4 patch queue" is a
cutting edge ext4 development tree, which is not intend for mm or
upstream inclusion.

I have asked Ted this morning to update the "official" ext4 patch queue
at kernel.org, which is visiable to you and the world. I can't update it
myself. 

Best regards,
Mingming


