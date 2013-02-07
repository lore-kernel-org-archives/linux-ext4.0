From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: GRUB and the risk of block list corruption in extX
Date: Thu, 7 Feb 2013 15:53:35 -0500
Message-ID: <20130207205335.GA28084@thunk.org>
References: <51137F76.8070705@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Martin Wilck <martin.wilck@ts.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47306 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab3BGUxj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2013 15:53:39 -0500
Content-Disposition: inline
In-Reply-To: <51137F76.8070705@ts.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 07, 2013 at 11:18:30AM +0100, Martin Wilck wrote:
> Hello,
> 
> you may have seen the following warning that is displayed when
> someone tries to install GRUB2 on in a extX partition:
> 
>   "/sbin/grub-setup: warn: Embedding is not possible. GRUB can only be
>   installed in this setup by using blocklists. However, blocklists are
>   UNRELIABLE and their use is discouraged."

This only happens if grub2 can't install itself in the space between
the MBR and the beginning of the first partition.  So in practice,
most people won't see this unless they install the root partition on
the whole disk, or perhaps for disks with GUUID partition tables.

I think the grub2 developers are being far too paranoid.  In practice,
ext4 doesn't move blocks around.  If you create a file and then mark
the it as immutable, it should be pretty much safe.  Yes, if you do an
off-line shrink (or in some vary rare cases, an off-line resize2fs
expand operation) it's possible that the file blocks might get moved,
but that's a pretty rare case.

There are some folks who are proposing that we use a bootloader inode:

#define EXT2_BOOT_LOADER_INO  5	       /* Boot loader inode */

for grub's benefit.  It doesn't really make things any safer from a
block relocation perspective, but maybe since it's "official", maybe
it would make the grub2 developers feel better.  But it's not
something that has been terribly high priority, since it's basically
more of a security blanket for the grub2 developers more than anything
else....

						- Ted
