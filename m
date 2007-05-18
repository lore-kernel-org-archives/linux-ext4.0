From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Ext4 Patch Queue using stgit.
Date: Fri, 18 May 2007 22:39:49 +0530
Message-ID: <464DDDDD.7080308@linux.vnet.ibm.com>
References: <464D9F2F.3030904@linux.vnet.ibm.com> <20070518160626.GA19911@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:54086 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398AbXERRJ7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 May 2007 13:09:59 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l4IHBbXB6119606
	for <linux-ext4@vger.kernel.org>; Sat, 19 May 2007 03:11:37 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4IHDOUp139120
	for <linux-ext4@vger.kernel.org>; Sat, 19 May 2007 03:13:24 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4IH9qAV009114
	for <linux-ext4@vger.kernel.org>; Sat, 19 May 2007 03:09:52 +1000
In-Reply-To: <20070518160626.GA19911@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Theodore Tso wrote:
> On Fri, May 18, 2007 at 06:12:23PM +0530, Aneesh Kumar K.V wrote:
>> Hi All,
>>
>> I was looking at ext4 patch queue and was wondering why we are  putting 
>> .patch under git. If we are looking for a quilt like functionality, one 
>> can achieve the same using stgit. I was using stgit to maintain a set of
>> patches before. 
> 
> The problem with stgit is that you lose the history of the patches.
> This is why the stable kernel queue is also kept as a git repository
> of patches.
> 
> 

What i used to do with

http://git.openssi.org/~kvaneesh/gitweb.cgi?p=ci-to-linus.git;a=summary

is after doing stg refresh, push all the patches and then commit the 
diff between the head of the master (which is managed by stgit ) and one 
of the tracking branches to the tracking branch. That way the history of 
the patches can be tracked in the tracking branches. In my previous mail 
i have marked the below urls as eg:

http://git.openssi.org/~kvaneesh/gitweb.cgi?h=2.6.20-rc1-ci-to-linus;p=ci-to-linus.git;a=shortlog

http://git.openssi.org/~kvaneesh/gitweb.cgi?h=2.6.19-rc1-ci-to-linus;p=ci-to-linus.git;a=shortlog

-aneesh
