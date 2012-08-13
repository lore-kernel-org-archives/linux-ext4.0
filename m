From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: An idea for supporting large directories and readdir+stat
 workloads
Date: Mon, 13 Aug 2012 10:39:41 -0400
Message-ID: <20120813143941.GC32484@thunk.org>
References: <20120811212532.GB906@thunk.org>
 <B12EEBD6-6DA4-4D2C-A31F-B2F7FAFCD372@dilger.ca>
 <20120813143607.GB32484@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44414 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab2HMOjn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2012 10:39:43 -0400
Content-Disposition: inline
In-Reply-To: <20120813143607.GB32484@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 13, 2012 at 10:36:07AM -0400, Theodore Ts'o wrote:
> Field		Size
> 
> ino		 4

Silly me, we don't need actually need to store the inode a second
time, since that's already in the struct ext4_dir_entry.

> dev		 4

... and we only need to store the device if this is a block or
character device, so we could actually use the i_size field below to
store the dev_t for devices inodes.

So this would shrink the size of the "compact inode" that would be
stored in the directory entry down from 62 bytes to 58 bytes.

						- Ted
