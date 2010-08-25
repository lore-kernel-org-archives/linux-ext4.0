From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Wed, 25 Aug 2010 17:39:11 -0600
Message-ID: <8B4A0D91-D3E1-4328-890C-BD66189598B5@dilger.ca>
References: <20100823095056.ACBA.61FB500B@jp.fujitsu.com> <20100824131735.GD3713@quack.suse.cz> <20100825090551.DEB3.61FB500B@jp.fujitsu.com> <20100825230442.GH2738@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:36283 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0HYXjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 19:39:12 -0400
In-Reply-To: <20100825230442.GH2738@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-25, at 17:04, Jan Kara wrote:
>> What size is the inode ? This problem happens if the size is larger than 128 byte. (I tested at 256 byte inode.)
> 
> Ah, that was the reason. Thanks. But looking at the implications, I'm a bit
> reluctant to do the change you propose. If someone has a filesystem created
> by old mkfs, he could suddently see corrupted xattrs in his lost+found
> directory with the new kernel. Not that there would be a big chance this
> happens but people run various strange environments...

The fix to e2fsck for this issue has been around for a long time, AFAIK.  It was only needed in the kernel while the broken mke2fs was in wide use, and before a fixed e2fsck was available.


Cheers, Andreas





