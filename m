From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH 2/5] ext4: fix removing status extents in
 ext4_collapse_range()
Date: Thu, 17 Apr 2014 14:54:18 +0900
Message-ID: <005e01cf5a01$78bc0990$6a341cb0$@samsung.com>
References: <004401cf59ff$ff136f30$fd3a4d90$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: 'Lukas Czerner' <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:55315 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaDQFyT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2014 01:54:19 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N45005IUV2IN3B0@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 17 Apr 2014 14:54:18 +0900 (KST)
In-reply-to: <004401cf59ff$ff136f30$fd3a4d90$@samsung.com>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Currently in ext4_collapse_range() when calling ext4_es_remove_extent() to
> remove status extents we're passing (EXT_MAX_BLOCKS - punch_start - 1)
> in order to remove all extents from start of the collapse range to the
> end of the file. However this is wrong because we might miss the
> possible extent covering the last block of the file.
> 
> Fix it by removing the -1.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Looks good to me! 

Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks Lukas.

