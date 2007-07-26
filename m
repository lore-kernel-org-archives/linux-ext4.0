From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] basic delayed allocation in ext4
Date: Thu, 26 Jul 2007 15:50:46 +0400
Message-ID: <46A88A96.7@clusterfs.com>
References: <46A86294.6050608@clusterfs.com> <46A88700.2090807@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.245.247]:60834 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760747AbXGZMQ1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jul 2007 08:16:27 -0400
In-Reply-To: <46A88700.2090807@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar K.V wrote:
>> +    /* first, we need to know whether the block is allocated already
>> +     * XXX: when the filesystem has a lot of free blocks, we could
>> +     * reserve even allocated blocks to save this lookup */
>> +    ret = ext4_get_blocks_wrap(NULL, inode, iblock, 1,  bh_result, 0, 
>> 0);
>> +    if (ret >= 0) {
> 
> 
> I guess this should be (ret > 0)

well, no. it has to catch allocated and non-allocated blocks
(though can be written more clear, probably)

> I was not able to find mpage_da_writepages()..

sorry, it's part of vfs delayed allocation patch, should be on the list now.

thanks, Alex
