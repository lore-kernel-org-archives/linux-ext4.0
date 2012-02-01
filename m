From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 2/2] ext3: Don't update ctime in ext3_splice_branch()
Date: Wed, 01 Feb 2012 16:56:17 +0900
Message-ID: <4F28F021.8030904@sx.jp.nec.com>
References: <4F2657BD.8030208@sx.jp.nec.com> <20120130175217.GA7827@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51926 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2BAH7d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Feb 2012 02:59:33 -0500
In-Reply-To: <20120130175217.GA7827@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/01/31 2:52, Jan Kara wrote:
>   Thanks for the patches.  This is true for ordinary writes but not true
> when you write via mmap. We call file_update_time() during page fault so
> ctime won't be completely wrong but still we should update it after block
> is allocated during writeback to reflect that new block is allocated to
> the inode.

Should we update ctime whenever a block is allocated?
If so, ordinary write in ext4 with indirect block mapping has the same problem
due to the following patch, right?
http://marc.info/?l=linux-ext4&m=124505184027078&w=4

Regards,
Kazuya Mio
