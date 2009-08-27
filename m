From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Buffer state bits
Date: Thu, 27 Aug 2009 18:03:18 +0530
Message-ID: <20090827123318.GA19422@skywalker.linux.vnet.ibm.com>
References: <20090826200021.GA5716@duck.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:34373 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbZH0MdX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Aug 2009 08:33:23 -0400
Content-Disposition: inline
In-Reply-To: <20090826200021.GA5716@duck.novell.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> BH_Mapped
> - Buffer has a physical block backing it stored in b_bdev + b_blocknr. This bit
>   is set by filesystem's get_block() function (or by VFS itself for block device
>   mappings).
> 
>   XXX: Some filesystems set BH_Mapped even for buffers that do no really
>   have the backing block (like buffers for delayed allocation). I think
>   we should get rid of it...
> 

Also we don't want get_block to be called multiple times for the same file offset.
__block_prepare_write does get_block looking at the BH_Mapped flag. ie one of reason
delay and unwritten buffer_heads are also marked mapped.


-aneesh
