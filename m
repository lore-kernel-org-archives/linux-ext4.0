From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs tutorial or examples
Date: Tue, 29 Jan 2013 16:29:51 -0500
Message-ID: <20130129212951.GA17244@thunk.org>
References: <1359484603.41909.YahooMailNeo@web164603.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Anders Lind <anderslindgaard@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46094 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab3A2V3y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2013 16:29:54 -0500
Content-Disposition: inline
In-Reply-To: <1359484603.41909.YahooMailNeo@web164603.mail.gq1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 29, 2013 at 10:36:43AM -0800, Anders Lind wrote:
> Sorry to bother you genius and hard working developers.
> Is there any good examples or detailed tutorial about e2fsprogs? I know "man" is always the best friend. But I would like to see more real examples. Since I realized these set of utilities are so powerful that I cannot use it well by just browsing the manual.

There are two levels of using e2fsprogs.  The first is the basic
system administrator's use of mke2fs to format a new file system,
lsattr and chattr to manipulate file attributes.  For those, the man
pages should be plenty, and there are a lot of books and tutorials
about basic Linux/Unix system administration.

If you are trying to do very low-level detailed manipulation of the
file system using debugfs, or you are trying to repair a very badly
corrupted file system, it requires some very detailed understanding of
the file system.  For that, there are technical papers which describe
the details of the ext[234] file system family.  See:

https://ext4.wiki.kernel.org/index.php/Publications

There is also some books which describe low level file systems
details.  One example is File System Forensics Analysis, which doesn't
cover ext4 (since it's too old) and has a very specific bias in terms
of how to apply this technical knowledge:

http://books.google.com/books?isbn=0321268172

I give a tutorial with Lisa entitled called "How To Recover from Hard
Drive Disasters" which talks about basic file system technologies (as
well as partitions, etc.) from a very different approach.  So a lot
depends on what you are trying to do.

I hope this helps,

				- Ted
