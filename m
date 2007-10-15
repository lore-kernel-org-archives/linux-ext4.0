From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: question about patch queue and ext4-git
Date: Mon, 15 Oct 2007 08:21:13 -0500
Message-ID: <20071015082113.79c8f503@gara>
References: <4712FC45.8080401@suse.de>
	<20071015051005.0865b2a7@gara>
	<47136128.5050301@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: coyli@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49186 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759839AbXJONVw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Oct 2007 09:21:52 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9FDNEna002601
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 09:23:14 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9FDLdOv525078
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 09:21:43 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9FDLTrc012929
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 09:21:29 -0400
In-Reply-To: <47136128.5050301@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 15 Oct 2007 20:46:32 +0800
Coly Li <coyli@suse.de> wrote:

> Thanks for the replying :-)
> 
> Jose R. Santos wrote:
> > On Mon, 15 Oct 2007 13:36:05 +0800
> > Coly Li <coyli@suse.de> wrote:
> > 
> >> Now in my mind there are several words for ext4 patches, most frequently one are "patch queue".
> >>
> >> I see the patches in patch queue from
> >> http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/ .
> >> Also I confirm some of the patches are in ext4 git tree now, but I am not sure for two questions:
> >> 1) Whether all the patches are in ext4 git tree ?
> > 
> > Yes, all these patches should be in ext4 git tree.
> > 
> >> 2) This patch queue is only used to push ext4 patch into upstream ?
> > 
> > The patch queue series is divided into stable and unstable patches.
> > The stable patches are the one usually the ones used to push back
> > upstream, while the unstable section has the patches for development
> > purposes only and are not ready for pushing upstream (and some may
> > never make it in).
> 
> How to recognize which patch is stable patch and which one is unstable patch ?

Look in the series file.  The mark where the stable patches end is
documented there.
  
> > 
> >> Also there is a patch-queue git at http://repo.or.cz/w/ext4-patch-queue.git , is it same to the
> >> patches in http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/ ?
> > 
> > Same thing bug in git format.  I believe Ted updates his patch queue
> > from the patches in the git tree repo, so  if you want latest/greatest
> > the git tree is what you want.
> > 
> >> Thanks for clarifying :-)
> >>
> >>
> > 
> > -JRS
> 

-JRS
