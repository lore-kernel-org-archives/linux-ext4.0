From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/12] mke2fs: allow metadata blocks to be at the
 beginning of the file system
Date: Mon, 20 Jan 2014 11:30:30 -0500
Message-ID: <20140120163030.GB14689@thunk.org>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
 <1390197254-14583-13-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50132 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbaATQab (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jan 2014 11:30:31 -0500
Content-Disposition: inline
In-Reply-To: <1390197254-14583-13-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 20, 2014 at 12:54:14AM -0500, Theodore Ts'o wrote:
> Add the extended options packed_meta_blocks and journal_location_front
> which causes mke2fs to place the metadata blocks at the beginning of
> the file system.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>  #define EXT2_MKJOURNAL_LAZYINIT	0x0000002 /* don't zero journal inode before use*/
>  #define EXT2_MKJOURNAL_NO_MNT_CHECK 0x0000004 /* don't check mount status */
> +#define EXT2_MKJOURNAL_LOCATION_FRONT 0x0000004 /* journal at the beginning */

s/0x0000004/0x0000008/

					- Ted
