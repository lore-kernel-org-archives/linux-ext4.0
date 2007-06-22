From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] uninitialized groups ported - kernel
Date: Fri, 22 Jun 2007 10:04:54 -0600
Message-ID: <20070622160454.GM5181@schatzie.adilger.int>
References: <1181065733.5219.8.camel@mathur-dsktp> <4665AFEF.3060602@redhat.com> <20070605212005.GM5181@schatzie.adilger.int> <467755D3.8030802@linux.vnet.ibm.com> <20070619075034.GQ5181@schatzie.adilger.int> <1182340580.3819.3.camel@dhcp7.linsyssoft.com> <20070621173757.GA1075@schatzie.adilger.int> <467B0FA6.1090509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Girish Shilamkar <girish@clusterfs.com>, linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:34313 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbXFVQE4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jun 2007 12:04:56 -0400
Content-Disposition: inline
In-Reply-To: <467B0FA6.1090509@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 21, 2007  16:54 -0700, Avantika Mathur wrote:
> Kernel build was failing with the uninitialized patches when 
> CONFIG_CRC16=m. The patch below resolves this issue.

No patch?

> Also, when testing the patches, filesystem mount fails:
> 
> EXT4-fs error (device sdc1): ext4_check_descriptors: Checksum for group 1 
> failed (0!=1)
> 
> EXT4-fs: group descriptors corrupted!
> 
> EXT4-fs error (device sdc1): ext4_check_descriptors: Checksum for group 7 
> failed (0!=1)
> 
> Even though the uninitgrps feature is not enabled, the gdp->bg_checksum 
> on disk is nonzero.

Can you figure out why the on-disk checksum is non-zero?  That should not
happen.  Is it possible that the kernel patch and e2fsprogs somehow have
the wrong struct alignment?  Is mke2fs not zeroing out the on-disk data -
the error is reporting that bg_checksum on disk is 1 when it should be 0?

I suppose it is possible for the patch to just ignore the on-disk data if
checksums are not enabled, but we didn't have any such problems in the past...


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
