From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V6 RESEND 03/15] ext4: add a function which sets up a
 new group desc
Date: Tue, 3 Jan 2012 21:24:27 -0500
Message-ID: <20120104022427.GF30502@thunk.org>
References: <1325242812-27005-1-git-send-email-xiaoqiangnk@gmail.com>
 <1325242812-27005-4-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36858 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab2ADDth (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jan 2012 22:49:37 -0500
Content-Disposition: inline
In-Reply-To: <1325242812-27005-4-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 30, 2011 at 07:00:00PM +0800, Yongqiang Yang wrote:
> +
> +	memset(gdp, 0, EXT4_DESC_SIZE(sb));
> +	 /* LV FIXME */
> +	memset(gdp, 0, EXT4_DESC_SIZE(sb));
> +	ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV FIXME */
> +	ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV FIXME */
> +	ext4_inode_table_set(sb, gdp, input->inode_table); /* LV FIXME */

There is a duplicated (and unneeded) call to memset above.  Also, the
LV FIXME was a comment introduced by Laurent Vivier in commit bd81d8ee
because at the time input->block_bitmap was a 32-bit value.  In the
new ext4_new_group_data structure, input->block_bitmap is now a 64-bit
field, so the need for "LV FIXME" is gone, and should be removed.

I'll remove the duplicate memset() calls and the "LV FIXME".

For future reference, this is why it's better to use something
descriptive about the FIXME "64-bit FIXME", as opposed to your
initials.  And it's best if there's an explicit comment explaining why
the fixme is there (and what the consequences of leaving partially
broken code in the kernel :-), so that future code maintainers won't
have to do code archeology to figure out what the FIXME is all about.

     	   		      	     	 - Ted
