From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: question about patch queue and ext4-git
Date: Mon, 15 Oct 2007 05:10:05 -0500
Message-ID: <20071015051005.0865b2a7@gara>
References: <4712FC45.8080401@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: coyli@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:54988 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427AbXJOKJ5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2007 06:09:57 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9FA9uCn026475
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 06:09:56 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9FA9u9v429836
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 04:09:56 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9FA9uIR018647
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 04:09:56 -0600
In-Reply-To: <4712FC45.8080401@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 15 Oct 2007 13:36:05 +0800
Coly Li <coyli@suse.de> wrote:

> Now in my mind there are several words for ext4 patches, most frequently one are "patch queue".
> 
> I see the patches in patch queue from
> http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/ .
> Also I confirm some of the patches are in ext4 git tree now, but I am not sure for two questions:
> 1) Whether all the patches are in ext4 git tree ?

Yes, all these patches should be in ext4 git tree.

> 2) This patch queue is only used to push ext4 patch into upstream ?

The patch queue series is divided into stable and unstable patches.
The stable patches are the one usually the ones used to push back
upstream, while the unstable section has the patches for development
purposes only and are not ready for pushing upstream (and some may
never make it in).

> Also there is a patch-queue git at http://repo.or.cz/w/ext4-patch-queue.git , is it same to the
> patches in http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/ ?

Same thing bug in git format.  I believe Ted updates his patch queue
from the patches in the git tree repo, so  if you want latest/greatest
the git tree is what you want.

> Thanks for clarifying :-)
> 
> 

-JRS
