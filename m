From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: which tree should I generate the ext4 patch ?
Date: Thu, 24 May 2007 14:35:58 +0530
Message-ID: <46555576.5010004@linux.vnet.ibm.com>
References: <1179910843.4119.33.camel@coly-t43.site> <20070523121723.GC5608@thunk.org> <1179997371.4353.1.camel@coly-t43.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:38278 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbXEXJGP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 May 2007 05:06:15 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l4O97qpq5152934
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2007 19:07:52 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.250.242])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4O99bt9129110
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2007 19:09:42 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4O960r8009476
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2007 19:06:01 +1000
Received: from [9.124.35.22] (SKYWALKER-009124035022.in.ibm.com [9.124.35.22])
	by d23av01.au.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l4O960i1009410
	for <linux-ext4@vger.kernel.org>; Thu, 24 May 2007 19:06:00 +1000
In-Reply-To: <1179997371.4353.1.camel@coly-t43.site>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



coly wrote:
> Theodore,
> 
> I can see all the files, but how can I download the files by cvs ? I
> tried pserver, but it seems does not work ..
> 
> could you give me some hints ?
> 
> 



hg clone http://thunk.org/hg/e2fsprogs/


hg come in mercurial package.

-aneesh
