From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: WARNING: at fs/ext4/inode.c:230 ext4_evict_inode+0x41b/0x510
Date: Mon, 8 Jul 2013 23:35:10 -0400
Message-ID: <20130709033510.GE6000@thunk.org>
References: <20130708183829.GA3205@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
To: Guenter Roeck <linux@roeck-us.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36074 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab3GIDfQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jul 2013 23:35:16 -0400
Content-Disposition: inline
In-Reply-To: <20130708183829.GA3205@roeck-us.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 08, 2013 at 11:38:29AM -0700, Guenter Roeck wrote:
> Hi,
> 
> seen this morning with a brand new top-of-tree kernel (as of last night) plus a
> couple of patches I am working on.
> 
> Due to my changes, there is a slight chance that the problem is not due to an
> upstream bug, but I think that is quite unlikely (my changes are unrelated
> to file system code).
> 
> If there is anything I can help to track this down, please let me know.
> 
> [13071.291013] ------------[ cut here ]------------
> [13071.291021] WARNING: at fs/ext4/inode.c:230 ext4_evict_inode+0x41b/0x510()

Hmm, this warning was added by commit 5dc23bdd5: ext4: remove
ext4_ioend_wait().

What sort of work load are you running on this machine?  Do you know
what might have triggered it?

Thanks,

					- Ted
