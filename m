From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Is there any reason for us to use EXT4_MAXQUOTAS_INIT_BLOCKS?
Date: Wed, 15 Apr 2015 19:27:40 -0400
Message-ID: <20150415232740.GB25331@thunk.org>
References: <20150415155537.GA32494@thunk.org>
 <20150415204754.GA13039@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41549 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbbDOX1q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2015 19:27:46 -0400
Content-Disposition: inline
In-Reply-To: <20150415204754.GA13039@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 15, 2015 at 10:47:54PM +0200, Jan Kara wrote:
>   Yeah, the credit estimate in ext4_symlink():
> credits = 4 + EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb) + EXT4_XATTR_TRANS_BLOCKS;
>   is just too pessimistic. Actually what we need for long symlinks is only
> credits for inode creation + addition to orphan list (so 4 +
> EXT4_MAXQUOTAS_TRANS_BLOCKS -- sb, gdt, bitmap, inode).

Thanks, I just wanted to check with you before I fixed this, since we
didn't have anything explicitly documenting what
EXT4_MAXQUOAS_INIT_BLOCKS did (which I'll fix as well while I'm at
it), and I didn't want to make anything assumptions that might come
back and bite us later.  Of course, the fact that ext4_symlinks was
using way more credits than ext4_mknod made it clear something was
buggy, and I couldn't imagine any circumstances why creating a long
symlink (or more correctly, only the first part of creatinga long
symlink) would require modifying 156 metadata blocks!   :-)

	       	      	       	    	       - Ted
