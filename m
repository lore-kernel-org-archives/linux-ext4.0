From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 0/2] ext3: Reduce calling ext3_mark_inode_dirty() for
 speedup
Date: Wed, 01 Feb 2012 17:35:46 +0900
Message-ID: <4F28F962.2040209@sx.jp.nec.com>
References: <4F2657AD.9060901@sx.jp.nec.com> <97F0BDAD-B6D8-4246-B790-E269025F4A7D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33603 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab2BAIjB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Feb 2012 03:39:01 -0500
In-Reply-To: <97F0BDAD-B6D8-4246-B790-E269025F4A7D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/01/31 5:36, Andreas Dilger wrote:
> Can you please run this same measurement on ext4 formatted and running
> with the default options?  I'd like to know if this is still a problem
> in ext4 or not.

I performed the same measurement on ext4 with the default options.
Here is its result:

    filesystem        time(sec)  call extX_mark_inode_dirty(times)
    ---
    ext3              220.5      50,338,104
    ext3 (patched)    196.3      25,169,658
    ext4 (*1)         190.3      28,465,799
    ext4 (*2)         201.5      27,963,473
    ext4 (default)    223.3      14,026,118

    *1 disable ext4-specific options (delalloc, extent, and so on)
    *2 disable only delalloc option

Regards,
Kazuya Mio
