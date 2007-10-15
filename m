From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: question about patch queue and ext4-git
Date: Mon, 15 Oct 2007 14:59:35 -0700
Message-ID: <1192485575.3791.10.camel@localhost.localdomain>
References: <4712FC45.8080401@suse.de>	<20071015051005.0865b2a7@gara>
	 <47136128.5050301@suse.de> <20071015082113.79c8f503@gara>
	 <47137943.2000206@suse.de>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: coyli@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45805 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762019AbXJOWAB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Oct 2007 18:00:01 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9FLxsJD013850
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 17:59:54 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9FLxt4b117558
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 17:59:55 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9FLxi6I002423
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 17:59:44 -0400
In-Reply-To: <47137943.2000206@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-10-15 at 22:29 +0800, Coly Li wrote:
> 
> Jose R. Santos wrote:
> > On Mon, 15 Oct 2007 20:46:32 +0800
> > Coly Li <coyli@suse.de> wrote:
> > 
> >> Thanks for the replying :-)
> >>
> >> Jose R. Santos wrote:
> >>> On Mon, 15 Oct 2007 13:36:05 +0800
> >>> Coly Li <coyli@suse.de> wrote:
> >>>
> >>>> Now in my mind there are several words for ext4 patches, most frequently one are "patch queue".
> >>>>
> >>>> I see the patches in patch queue from
> >>>> http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/ .
> >>>> Also I confirm some of the patches are in ext4 git tree now, but I am not sure for two questions:
> >>>> 1) Whether all the patches are in ext4 git tree ?
> >>> Yes, all these patches should be in ext4 git tree.
> >>>
> >>>> 2) This patch queue is only used to push ext4 patch into upstream ?
> >>> The patch queue series is divided into stable and unstable patches.
> >>> The stable patches are the one usually the ones used to push back
> >>> upstream, while the unstable section has the patches for development
> >>> purposes only and are not ready for pushing upstream (and some may
> >>> never make it in).
> >> How to recognize which patch is stable patch and which one is unstable patch ?
> > 
> > Look in the series file.  The mark where the stable patches end is
> > documented there.
> >   
> Find it now. Thanks for your explaining :-)


when a new ext4 patch is being submitted, it first added to the patch
queue on repo.or.cz, where the whole series (stable and unstable
patches) will be tested automatically. After the patches being stablized
a bit, Ted will pull ext4 patches from patch queue from repo.or.cz to
his git tree, and public the current patches in the git tree on
kernel.org.

Also there is a stable-boundary patch being added in repo.or.cz patch
queue to indicating where the unstable patches starts.

Mingming
> 
> >>>> Also there is a patch-queue git at http://repo.or.cz/w/ext4-patch-queue.git , is it same to the
> >>>> patches in http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/ ?
> >>> Same thing bug in git format.  I believe Ted updates his patch queue
> >>> from the patches in the git tree repo, so  if you want latest/greatest
> >>> the git tree is what you want.
> >>>
> >>>> Thanks for clarifying :-)
> >>>>
> >>>>
> >>> -JRS
> > 
> > -JRS
> 
