From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: new mballoc patches.
Date: Thu, 27 Sep 2007 12:03:22 +0530
Message-ID: <46FB4EB2.3090802@linux.vnet.ibm.com>
References: <46E651E6.3070107@linux.vnet.ibm.com> <20070926225821.8cc6a2e0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:34115 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbXI0Gd6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2007 02:33:58 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8R6XmmS030398
	for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2007 16:33:48 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8R6bNew241212
	for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2007 16:37:23 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8R6WJVl008597
	for <linux-ext4@vger.kernel.org>; Thu, 27 Sep 2007 16:32:19 +1000
In-Reply-To: <20070926225821.8cc6a2e0.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andrew Morton wrote:
> On Tue, 11 Sep 2007 13:59:26 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
>> I have updated the mballoc patches.
> 
> Has anyone reviewed this stuff?  I don't see much evidence of it here?
> 
> Just a quick scan shows up heavy over-inlining, many
> macros-which-should-be-functions and numerous needlessly global symbols. 
> Whether there are more substantial problems in there I have not the time to
> tell.


I idea of getting it added to the patch queue was to get more testing and also review.
I am right now looking at the code trying to add more documentation. Things which are not
clear at the moment is marked with FIXME!!. 

-aneesh
