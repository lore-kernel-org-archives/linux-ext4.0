From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: Ext4 Patch Queue using stgit.
Date: Fri, 18 May 2007 08:23:00 -0500
Message-ID: <1179494580.15044.8.camel@kleikamp.austin.ibm.com>
References: <464D9F2F.3030904@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:35826 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbXERNXL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 May 2007 09:23:11 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4IDNBe9026963
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 09:23:11 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4IDN88P269446
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 07:23:10 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4IDN8GM021131
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 07:23:08 -0600
In-Reply-To: <464D9F2F.3030904@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-05-18 at 18:12 +0530, Aneesh Kumar K.V wrote:
> Hi All,
> 
> I was looking at ext4 patch queue and was wondering why we are  putting 
> .patch under git. If we are looking for a quilt like functionality, one 
> can achieve the same using stgit. I was using stgit to maintain a set of
> patches before. So if you look at
> 
> http://git.openssi.org/~kvaneesh/gitweb.cgi?p=ci-to-linus.git;a=summary
> 
> you will see the patches i was working on with linus tree as from-linus. 
> Now to find out what changes were made to these patches during the 
> development one can look at the tracking branch. In the above case the 
> latest tracking branch was 2.6.20-rc1-ci-to-linus
> 
> http://git.openssi.org/~kvaneesh/gitweb.cgi?h=2.6.20-rc1-ci-to-linus;p=ci-to-linus.git;a=shortlog
> 
> Other tracking branches at different development stages can be found at
> http://git.openssi.org/~kvaneesh/gitweb.cgi?p=ci-to-linus.git;a=heads
> 
> 
> This make looking at the diff much easier. diff of .patch does seems to 
> be useful.

Does _not_ seem to be useful?

I agree that I find the current setup a little awkward.  The git tree
isn't something we can point Andrew or Linus to.  It has to be extracted
to another place for that.  We really should have some of these patches
in mainline by now, and that's not getting done.

I haven't looked at stgit, so I don't have an opinion on using it as an
alternative, but I'm open to the idea.

> Only problem i can think of is how multiple people will push to the same 
> repo.

If we continue to host on repo.or.cz, Ted can allow anyone he wants to
push to the tree.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
