From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Delayed allocation and page_lock vs transaction start ordering
Date: Tue, 15 Apr 2008 11:08:52 -0700
Message-ID: <1208282932.3636.9.camel@localhost.localdomain>
References: <20080415161430.GC28699@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57966 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYDOSI5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2008 14:08:57 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3FI8uMD029177
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 14:08:56 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3FI8ur0314930
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 14:08:56 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3FI8uLT001212
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 14:08:56 -0400
In-Reply-To: <20080415161430.GC28699@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-04-15 at 18:14 +0200, Jan Kara wrote:
>   Hi,
> 
>   I've ported my patch inversing locking ordering of page_lock and
> transaction start to ext4 (on top of ext4 patch queue). Everything except
> delayed allocation is converted (the patch is below for interested
> readers). The question is how to proceed with delayed allocation. Its
> current implementation in VFS is designed to work well with the old
> ordering (page lock first, then start a transaction). We could bend it to
> work with the new locking ordering but I really see no point since ext4 is
> the only user. 

I think the plan is port the changes to ext2/3/JFS and support delayed
allocation on those filesystems. 

> Also XFS has AFAIK ordering first start transaction, then
> lock pages so if we should ever merge delayed alloc implementations the new
> ordering would make it easier.
>   So what do people think here? Do you agree with reimplementing current
> mpage_da_... functions?

It worth a try, but I could not see how to bend delayed allocation to
work the new ordering:( With delayed allocation Ext4 gets into
writepage() directly with page locked, but we need to start transaction
to do block allocation...:(

I guess this reserve locking ordering allows support writepages() for
ext3/4? What other the benefits?

Regards,
Mingming

