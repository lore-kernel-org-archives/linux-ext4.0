From: Theodore Tso <tytso@mit.edu>
Subject: Re: on disk format: value of bg_inode_table_hi?
Date: Thu, 29 Jan 2009 00:12:22 -0500
Message-ID: <20090129051221.GH8990@mit.edu>
References: <20090128180137.GD3652@webber.adilger.int> <653674.25270.qm@web23601.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46724 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZA2FM2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jan 2009 00:12:28 -0500
Content-Disposition: inline
In-Reply-To: <653674.25270.qm@web23601.mail.ird.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 28, 2009 at 08:47:09PM +0000, Etienne Lorrain wrote:
> > De: Andreas Dilger <adilger@sun.com>
> > Date: Mercredi 28 Janvier 2009, 18h01
> > On Jan 28, 2009  00:20 +0000, Etienne Lorrain wrote:
> > > I have created an ext4 fs on a 64 Mb USB disk by
> > > "mkfs.ext4 /dev/sdb" on debian lenny (no partition).
> > > When I analyse the filesystem using my own tools, I
> > > seem to read at least some bg_inode_table_hi values which
> > > are not null, on such a very small filesystem.

bg_inode_table_hi doesn't exist on a small filesystem.  You need to
take a look at if INCOMPAT_64BIT is not set, or if INCOMPAT_64BIT is
set and s_desc_size is 32, then only the first 32 bytes of struct
ext4_group_desc are in use --- which look exactly the same as
ext2_group_desc.

So there is no problem here.  Just a misunderstanding of the
filesystem format.

						- Ted
