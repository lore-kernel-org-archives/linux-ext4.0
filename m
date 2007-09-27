From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Review of mballoc-core.patch
Date: Thu, 27 Sep 2007 21:34:14 +0530
Message-ID: <46FBD47E.2060205@linux.vnet.ibm.com>
References: <E1Iauxj-0001fp-F4@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:43266 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbXI0QEf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2007 12:04:35 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8RG4JLr013969
	for <linux-ext4@vger.kernel.org>; Fri, 28 Sep 2007 02:04:19 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8RG4HBL2965658
	for <linux-ext4@vger.kernel.org>; Fri, 28 Sep 2007 02:04:17 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8RG4GsJ010616
	for <linux-ext4@vger.kernel.org>; Fri, 28 Sep 2007 02:04:17 +1000
In-Reply-To: <E1Iauxj-0001fp-F4@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Theodore Ts'o wrote:
> Here's an initial code review of the mballoc-core.patch.  As far as I
> can tell, the patch sent by Aneesh doesn't address any of these.
> Aneesh, assuming that you'll be fixing these, could you please combine
> your last set of fixes with fixes to address these, and send out an
> updated mballoc-core.patch?   

Will do that

>Patches on top of patches are useful for
> seeing what has changed, but for the patch queue I'd like to get the
> patches folded into a single patch, since that's what we'd want to have
> placed into the git tree.
> 

That is what i did with my last update. The diff of the source was sent to
the mailing list and and updated mballoc-core.patch was put at www.radian.org
so that we can use the same to update the patch queue. The diff against mballoc.c
helps in reviewing the changes made.


> Thanks!!
> 
> 							- Ted
> 
[.. snip...]
> 
> 
> There are a bunch of FIXME's in this which I assume will get addressed
> before we consider this ready to push to mainline?
> 


I have updated the code with  your suggestion. I haven't resolved all the
questions. The rest are marked with FIXME in the source. The idea is this 
will help Alex to find easily the portion of the code that needs his immediate
attention.

-aneesh
