From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Updated ext4 patches for 2.6.18-rc6
Date: Fri, 8 Sep 2006 12:09:32 -0600
Message-ID: <20060908180931.GK6441@schatzie.adilger.int>
References: <20060908131144sho@rifu.tnes.nec.co.jp> <1157698868.8616.20.camel@localhost.localdomain> <20060908161324.GA19256@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, akpm@osdl.org, shaggy@us.ibm.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:55969 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1751109AbWIHSJg
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Sep 2006 14:09:36 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060908161324.GA19256@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 08, 2006  18:13 +0200, Alexandre Ratchov wrote:
> there are 2 more patches:
> 
> * ext4_remove_relative_block_numbers:
> 
>   use 48bit absolute block numbers instead of mixed relative/absolute block
>   numbers. This is simpler and seems to fix issues with large file systems.
>    
> * ext4_allow_larger_descriptor_size:
> 
>   allow larger block group descriptors: this patch will allow to add new
>   features that need more space in the block descriptor.

Hmm, I'm a bit confused.  If we are adding larger block group descriptors,
why wouldn't we put 32-bit "high" block numbers into the larger descriptor
space?  That could be part of the INCOMPAT_64BIT support.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

