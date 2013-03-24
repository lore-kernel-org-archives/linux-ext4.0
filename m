From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add WARN_ON to check the length of allocated blocks
Date: Sun, 24 Mar 2013 14:23:18 -0400
Message-ID: <20130324182318.GA26792@thunk.org>
References: <1364118173-12354-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55453 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab3CXSXY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Mar 2013 14:23:24 -0400
Content-Disposition: inline
In-Reply-To: <1364118173-12354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 24, 2013 at 05:42:53PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> In this commit (921f266b) a sanity check is added in map_blocks to make
> sure 'retval == map->m_len'.  But we need to define a macro to enable
> it.  This commit uses a WARN_ON to do the same thing.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

You and Dmitry were the ones who using originally these these checks
to fix the bugs here; if we think the code is clean enough that we
don't need the debugging information with the inode number, length,
etc., then sure, we could use the unconditionally defined WARN_ON().

If we wanted to be really paranoid and give ourselves the maximal
amount of debugging information, we could of course do something like
this:

		if (retval != map->m_len) {
			ext4_warning(inode->i_sb, "ES len assertation failed for inode: %lu retval %d != map->m_len %d\n", inode->i_ino, retval,
			       map->m_len);
			 WARN_ON(1);
		}

This way, we get the stack dump, the file system device, and all of
the debugging information.  The tradeoff is we're bloating the code
size a bit.

The question is really how confident are we that we've found all of
the potential bugs here.  If we think that there's a chance we might
trip this check in the future, sometimes it's good to print as much
information as possible, especially if it's hard to create a
reproduction on demand.

What do you think?

						- Ted
