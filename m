From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Ext4 benchmarks
Date: Tue, 20 Mar 2007 22:08:45 -0500
Message-ID: <4600A1BD.80700@us.ibm.com>
References: <45FFFBAA.6080404@bull.net>
Reply-To: jrs@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34626 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933283AbXCUDKL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Mar 2007 23:10:11 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2L3A98r007936
	for <linux-ext4@vger.kernel.org>; Tue, 20 Mar 2007 23:10:09 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2L38mIc307542
	for <linux-ext4@vger.kernel.org>; Tue, 20 Mar 2007 23:08:48 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2L38mQR017382
	for <linux-ext4@vger.kernel.org>; Tue, 20 Mar 2007 23:08:48 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l2L38mYL017377
	for <linux-ext4@vger.kernel.org>; Tue, 20 Mar 2007 23:08:48 -0400
In-Reply-To: <45FFFBAA.6080404@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jean-Pierre Dion wrote:
> Hi all,
>
> we already discussed during the conf calls what
> benchmarks should be ran on ext4.
>
> As we have OLS paper on the table we were thinking
> here at Bull what bench t run and on which kernel.
>
> If we want trying to compare ext3 and ext4, I guess we
> should at least show that :
> - ext4 has equivalent perfs than ext3,
>   

Define equivalent performance.

Are the workloads only going to be focused on single repetitive 
operations or simulation of actual desktop/server environments?  How 
about performance on an aged filesystem?
> - improvements done for ext3 are still in ext4 (mb alloc, del alloc...).
>
> So  we were wondering what's best to do :
> - run on 2.6.19 (includes del alloc and mb alloc if I am not wrong),
> - run on 2.6.20 (lacks mb alloc),
>   

What about system configurations?  While a desktop configuration would 
be easy to come by, a server configuration needs a bit more thought.  
Will ext4 perform better than ext3 in a wide range of storage 
configuration that scale from a couple thousands IOPS to several hundred 
thousand IOPS?

Having baseline data on other filesystems like XFS or JFS would be 
interesting as well to see how well ext4 stacks up to the competition. :)
> - select relevant benchs (iozone...).
>   

I haven checked IOzone in quite a bit but last time I checked FFSB had a 
couple of capabilities that are not available in IOzone like multi 
threading on a shared data set and a very customizable IO operations to 
attempt to simulate real IO patterns seen on workloads.  Might be worth 
a look if your interested in compiling a very comprehensive set of results
> What do you think ?
>
> Thanks.
>
>
> jean-pierre
>   

-JRS
