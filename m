From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Thu, 26 Aug 2010 14:27:54 +0200
Message-ID: <20100826122754.GI3294@quack.suse.cz>
References: <20100823095056.ACBA.61FB500B@jp.fujitsu.com>
 <20100824131735.GD3713@quack.suse.cz>
 <20100825090551.DEB3.61FB500B@jp.fujitsu.com>
 <20100825230442.GH2738@quack.suse.cz>
 <8B4A0D91-D3E1-4328-890C-BD66189598B5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49899 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab0HZM2l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Aug 2010 08:28:41 -0400
Content-Disposition: inline
In-Reply-To: <8B4A0D91-D3E1-4328-890C-BD66189598B5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 25-08-10 17:39:11, Andreas Dilger wrote:
> On 2010-08-25, at 17:04, Jan Kara wrote:
> >> What size is the inode ? This problem happens if the size is larger than 128 byte. (I tested at 256 byte inode.)
> > 
> > Ah, that was the reason. Thanks. But looking at the implications, I'm a bit
> > reluctant to do the change you propose. If someone has a filesystem created
> > by old mkfs, he could suddently see corrupted xattrs in his lost+found
> > directory with the new kernel. Not that there would be a big chance this
> > happens but people run various strange environments...
> 
> The fix to e2fsck for this issue has been around for a long time, AFAIK.
> It was only needed in the kernel while the broken mke2fs was in wide use,
> and before a fixed e2fsck was available.
  I agree but rather old e2fsprogs are still in use and if a filesystem
created by these e2fsprogs would be (possibly on a different machine)
accessed by the new kernel it would see corrupted xattrs. I've looked at our
supported products (the oldest is currently SLES9 SP3) and it has e2fsprogs
1.38. This should be new enough. But RHEL3 which is also still supported
for another three years has e2fsprogs 1.32 so these are buggy. So I'd
rather be on the safe side and fix the bug by consistently refusing to
store extented attributes in inode for inodes <= EXT3_FIRST_INO + 1 as I
don't think that really costs us much...
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
