From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Ext4 Patch Queue using stgit.
Date: Fri, 18 May 2007 19:55:00 +0530
Message-ID: <464DB73C.1080806@linux.vnet.ibm.com>
References: <464D9F2F.3030904@linux.vnet.ibm.com> <1179494580.15044.8.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:40607 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbXEROZJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 May 2007 10:25:09 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l4IEjDDl301578
	for <linux-ext4@vger.kernel.org>; Sat, 19 May 2007 00:45:13 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4IESa3d166830
	for <linux-ext4@vger.kernel.org>; Sat, 19 May 2007 00:28:36 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4IEP4A7017935
	for <linux-ext4@vger.kernel.org>; Sat, 19 May 2007 00:25:05 +1000
In-Reply-To: <1179494580.15044.8.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Dave Kleikamp wrote:
> On Fri, 2007-05-18 at 18:12 +0530, Aneesh Kumar K.V wrote:
>> Hi All,
>>
>> I was looking at ext4 patch queue and was wondering why we are  putting 
>> .patch under git. If we are looking for a quilt like functionality, one 
>> can achieve the same using stgit. I was using stgit to maintain a set of
>> patches before. So if you look at
>>
>> http://git.openssi.org/~kvaneesh/gitweb.cgi?p=ci-to-linus.git;a=summary
>>
>> you will see the patches i was working on with linus tree as from-linus. 
>> Now to find out what changes were made to these patches during the 
>> development one can look at the tracking branch. In the above case the 
>> latest tracking branch was 2.6.20-rc1-ci-to-linus
>>
>> http://git.openssi.org/~kvaneesh/gitweb.cgi?h=2.6.20-rc1-ci-to-linus;p=ci-to-linus.git;a=shortlog
>>
>> Other tracking branches at different development stages can be found at
>> http://git.openssi.org/~kvaneesh/gitweb.cgi?p=ci-to-linus.git;a=heads
>>
>>
>> This make looking at the diff much easier. diff of .patch does seems to 
>> be useful.
> 
> Does _not_ seem to be useful?
> 

yes. that was a typo

> I agree that I find the current setup a little awkward.  The git tree
> isn't something we can point Andrew or Linus to.  It has to be extracted
> to another place for that.  We really should have some of these patches
> in mainline by now, and that's not getting done.
> 
> I haven't looked at stgit, so I don't have an opinion on using it as an
> alternative, but I'm open to the idea.
> 
>> Only problem i can think of is how multiple people will push to the same 
>> repo.
> 
> If we continue to host on repo.or.cz, Ted can allow anyone he wants to
> push to the tree.
> 



The problem is stgit management of git repo is local to the user. That 
means the stgit commands like push, pop and refresh works on local repo. 
  I am not sure how easily this mode of operation can be replicated 
across different user. There will be a slight overhead on each developer 
side when somebody else does a git push and later the developer does a 
pull. He/she will have to update the patcheset that is being managed by 
stgit by hand.


-aneesh
