From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] uninitialized groups ported - kernel
Date: Thu, 21 Jun 2007 11:37:57 -0600
Message-ID: <20070621173757.GA1075@schatzie.adilger.int>
References: <1181065733.5219.8.camel@mathur-dsktp> <4665AFEF.3060602@redhat.com> <20070605212005.GM5181@schatzie.adilger.int> <467755D3.8030802@linux.vnet.ibm.com> <20070619075034.GQ5181@schatzie.adilger.int> <1182340580.3819.3.camel@dhcp7.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:33716 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbXFURiA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 13:38:00 -0400
Content-Disposition: inline
In-Reply-To: <1182340580.3819.3.camel@dhcp7.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 20, 2007  17:26 +0530, Girish Shilamkar wrote:
>  			crc = crc16(crc, (__u8 *)gdp + offset,
> -				    sbi->s_es->s_desc_size - offset);
> +				    le16_to_cpu(sbi->s_es->s_desc_size)
> +					- offset);

Minor nit - please put '-' at the end of the previous line, and align
"offset" with '(sbi-> ...'.

Also, we're missing the signoff:

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Girish Shilamkar <girish@clusterfs.com>


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
