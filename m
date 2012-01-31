From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 0/2] ext3: Reduce calling ext3_mark_inode_dirty() for
 speedup
Date: Tue, 31 Jan 2012 14:03:55 +0900
Message-ID: <4F27763B.6090703@sx.jp.nec.com>
References: <4F2657AD.9060901@sx.jp.nec.com> <97F0BDAD-B6D8-4246-B790-E269025F4A7D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58246 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2AaFHF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jan 2012 00:07:05 -0500
In-Reply-To: <97F0BDAD-B6D8-4246-B790-E269025F4A7D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/01/31 5:36, Andreas Dilger wrote:
> Can you please run this same measurement on ext4 formatted and running
> with the default options?  I'd like to know if this is still a problem
> in ext4 or not.

Sure. I will send the result as soon as possible.

Regards,
Kazuya Mio
