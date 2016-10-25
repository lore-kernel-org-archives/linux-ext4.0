From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: allow inode expansion for nojournal file systems
Date: Tue, 25 Oct 2016 19:05:21 -0400
Message-ID: <20161025230521.dut6yubmg3gpf4d5@thunk.org>
References: <20161025211405.GA15502@localhost.localdomain>
 <AAF1FFC4-7D4B-4E62-89D2-8C7978D16C35@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43066 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932449AbcJYXFZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Oct 2016 19:05:25 -0400
Content-Disposition: inline
In-Reply-To: <AAF1FFC4-7D4B-4E62-89D2-8C7978D16C35@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 25, 2016 at 03:54:16PM -0600, Andreas Dilger wrote:
> I think the reason we required that the filesystem be journaled to expand
> the inode reserved space is to ensure that the update was an all-or-nothing
> approach.  If there are in-inode xattrs that need to be moved to an external
> xattr block, and that block needs allocation and such, it is possible that
> a nojournal filesystem could result in the xattrs being moved and the inode
> is written (w/o the xattrs), but the xattr block is not written to disk
> before a crash.

In nojournal mode, any number of failures can cause data loss.  For
example, we could be splitting a node in an extent tree, or in a htree
directory block, and we can end up losing data if we crash at an
inconvenient time.  The chances of losing half of an interior node of
an extent tree block after a crash is going to be the same, and the
data loss form such same is going to be far worse than the loss if we
are unluck expanding an inode and moving xattrs to an external block....

    	   	     	      	  - Ted
