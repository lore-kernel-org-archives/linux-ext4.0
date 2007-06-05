From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] uninitialized groups ported - kernel
Date: Tue, 05 Jun 2007 13:48:15 -0500
Message-ID: <4665AFEF.3060602@redhat.com>
References: <1181065733.5219.8.camel@mathur-dsktp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbXFESua (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jun 2007 14:50:30 -0400
In-Reply-To: <1181065733.5219.8.camel@mathur-dsktp>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Avantika Mathur wrote:
> Hi Andreas,
> 
> I have ported your uninitialized block group kernel patch to mainline
> 2.6.22-rc3, included below.
> I will also be posting the ported e2fsprogs patches. I had trouble
> testing the patches because of inconsistency in the block_group
> structure in e2fsprogs - which is only using ext2_block_group, and not
> ext4_block_group.
> 
> Thanks
> Avantika 
> 
> ---

...

> +#if !defined(CONFIG_CRC16) && !defined(CONFIG_CRC16_MODULE)
> +/** CRC table for the CRC-16. The poly is 0x8005 (x16 + x15 + x2 + 1) */
> +__u16 const crc16_table[256] = {
> +	0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
> +	0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,


Apologies if this has already been discussed & I missed it, but why 
replicate all this?  why not just require CONFIG_CRC16?

-Eric
