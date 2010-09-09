From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Thu, 9 Sep 2010 13:23:38 -0600
Message-ID: <2D696E8B-9566-42AA-9120-E768A2423B86@dilger.ca>
References: <20100823095056.ACBA.61FB500B@jp.fujitsu.com> <20100824131735.GD3713@quack.suse.cz> <20100825090551.DEB3.61FB500B@jp.fujitsu.com> <20100825230442.GH2738@quack.suse.cz> <8B4A0D91-D3E1-4328-890C-BD66189598B5@dilger.ca> <20100826122754.GI3294@quack.suse.cz> <771B1868-889A-4DD1-A247-9E183395E627@dilger.ca> <20100827135838.GC3274@quack.suse.cz> <608119C2-BE41-4BC1-AAA3-A215C06720FE@dilger.ca> <20100909163807.GA3281@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:23830 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab0IITXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Sep 2010 15:23:39 -0400
In-Reply-To: <20100909163807.GA3281@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-09-09, at 10:38, Jan Kara wrote:
>  Sigh, sorry to bring this up again... I wanted to use the original patch
> with the workaround you suggested but realized there's still a hole. The
> new patched kernel will happily use extra inode space for xattrs for inode
> 11 but if you mount the filesystem with older kernel it will reset
> i_extra_size to zero and thus you'll lose the stored xattrs.
>  So to get out of this compatibility trap we'd have to accept xattrs in
> the extended inode space but never store it there and after a sufficiently
> long time, we could remove the workaround. But this seems not worth the
> effort to me given we speak about a single inode and rather trivial
> workaround in ext3_iget and ext3_new_inode.

The old saying goes "Be strict in what you send, but generous in what you receive", so I think it makes sense that we allow reading xattrs from inode #11 (and also the root inode #2 is affected), and as you suggest we should only store these xattrs in external blocks.

The unfortunate thing is that xatts on the root inode will probably be the most heavily used, but it will also most likely be in cache so it probably won't be a serious performance issue (it can't be any worse than it is today).

While I think it would be slightly less complex to deny in-inode xattrs entirely, that doesn't give us any path toward actually removing this problem.

Of course, I think in the next 6 months or so (once ext4 is the default on RHEL6, widely in use at Google, and available on SLES11 SP1) we should probably consider ext4 stable enough that we should consider removing ext3 entirely from the tree and just have the "ext3" filesystem type be handled by ext4 as well.

Cheers, Andreas.