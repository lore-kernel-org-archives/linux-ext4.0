From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Too large value in inode.i_blocks[1]
Date: Mon, 1 Jul 2013 13:02:15 -0400
Message-ID: <20130701170215.GC23896@thunk.org>
References: <loom.20130612T065900-326@post.gmane.org>
 <20130612125954.GB26388@thunk.org>
 <loom.20130612T152507-9@post.gmane.org>
 <20130612135204.GA27403@thunk.org>
 <CACyNnZNF6E6rY7oiBX084cuoT+aUMnyhQA_uJFr4=wnPwGAVwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34328 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab3GARCT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Jul 2013 13:02:19 -0400
Content-Disposition: inline
In-Reply-To: <CACyNnZNF6E6rY7oiBX084cuoT+aUMnyhQA_uJFr4=wnPwGAVwA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 01, 2013 at 05:15:21PM +0200, Felipe Monteiro de Carvalho wrote:
> On Wed, Jun 12, 2013 at 3:52 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > The ext4_extent_tail is not used in i_blocks[].  There will be up to 4
> > ext4_extent structures, or ext4_extent_idx structures, depending on
> > the depth of the tree.  The ext4_extent_idx structures are used for
> > the interior inodes of the tree.  The ext4_extent structures are used
> > for the leaf nodes of the tree.  The ext4_extent_tail is used in
> > extent tree blocks so we can checksum the metadata if the
> > metadata_csum feature is enabled.  The entire inode is checksummed, so
> > we don't need the ext4_extent_tail in i_blocks[].
> 
> Hello,
> 
> thanks, this part I understood fairly well, but what if eh_entries is
> 8, for example .... where are the other 4 structures?

For the root node which is located in the inode, that would be
illegal.  There is only room for four entries in the root node.  If an
inode needs more extents than that, then we have to have an extent
leaf tree block in an external 4k block and the root inode will point
to up to four extent tree leaf blocks.  If there are more than four
leaf blocks, then the tree would have to grow in depth again, and the
root node would contain a pointer to up to four index blocks, and each
index node block can point to up to 340 leaf tree blocks.  (Assuming a 4k block size)

Basically, this is a standard tree data structure.

       	   	       	   	      	  	 - Ted
