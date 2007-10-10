From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: max file size for ext3
Date: Wed, 10 Oct 2007 11:49:38 +0530
Message-ID: <470C6EFA.9050006@linux.vnet.ibm.com>
References: <470C64BF.509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:41993 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbXJJGUV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2007 02:20:21 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9A6K5A1005666
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 16:20:05 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9A6K59a3137746
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 16:20:05 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9A6HDJI015339
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 16:17:13 +1000
In-Reply-To: <470C64BF.509@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is what i have now . But still i am not able to map the magic number

#include <stdio.h>
main()
{
	unsigned long long upper_limit;
	int meta_blocks;
	int bits = 12;

	/* total blocks in 512 bytes */
	upper_limit = (1LL << 32) -1;
	/* total blocks in file system block size */
	upper_limit >>= (bits - 9);


	/* indirect blocks */
	meta_blocks = 1;
	/* double indirect blocks */
	meta_blocks += 1 + (1LL << (bits-2));
	/* tripple indirect blocks */
	meta_blocks += 1 + (1LL << (bits-2)) + (1LL << (2*(bits-2)));

	upper_limit -= meta_blocks;
	upper_limit <<= bits;

	printf("expected %llx %llx\n",0x1ff7fffd000LL, upper_limit);
}

expected 1ff7fffd000 1feff7fc000
