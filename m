From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext2: Fix the max file size for ext2 file system.
Date: Fri, 12 Oct 2007 09:46:47 +0530
Message-ID: <470EF52F.6060004@linux.vnet.ibm.com>
References: <1192114207-8168-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20071011195449.GT8122@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:60714 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbXJLERT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Oct 2007 00:17:19 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9C4HFV0019704
	for <linux-ext4@vger.kernel.org>; Fri, 12 Oct 2007 14:17:15 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9C4HFMw4677800
	for <linux-ext4@vger.kernel.org>; Fri, 12 Oct 2007 14:17:15 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9C4EMJL031372
	for <linux-ext4@vger.kernel.org>; Fri, 12 Oct 2007 14:14:22 +1000
In-Reply-To: <20071011195449.GT8122@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Oct 11, 2007  20:20 +0530, Aneesh Kumar K.V wrote:
>> +	/* indirect blocks */
>> +	meta_blocks = 1;
>> +	/* double indirect blocks */
>> +	meta_blocks += 1 + (1LL << (bits-2));
>> +	/* tripple indirect blocks */
>> +	meta_blocks += 1 + (1LL << (bits-2)) + (1LL << (2*(bits-2)));
> 
> It may be worthwhile calculating how many indirect blocks there actually
> are in a file that size.  

The math become more confusing for that right ?. I am not sure we need to be that specific.


>Also note that your comments are backward -
> there is at most a single triple indirect block per file.

What i meant by those comment was, the count of meta data blocks taken for
different type of indirect blocks.

-aneesh
