From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Thu, 26 Jul 2007 17:17:27 +0530
Message-ID: <46A889CF.3030101@linux.vnet.ibm.com>
References: <46A8628D.6070103@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:46424 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbXGZLr4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Jul 2007 07:47:56 -0400
In-Reply-To: <46A8628D.6070103@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Alex Tomas wrote:
> Good day,
> 
> please review ...
> 
> thanks, Alex
> 
> 
> basic delayed allocation in VFS:
> 
>  * block_prepare_write() can be passed special ->get_block() which
>    doesn't allocate blocks, but reserve them and mark bh delayed
>  * a filesystem can use mpage_da_writepages() with other ->get_block()
>    which doesn't defer allocation. mpage_da_writepages() finds all
>    non-allocated blocks and try to allocate them with minimal calls
>    to ->get_block(), then submit IO using __mpage_writepage()
> 

I missed this patch when looking at the ext4 patches. Can we mark related
patch as [ PATCH 1/2 ] so that we know that another patch is going to follow.

-aneesh
