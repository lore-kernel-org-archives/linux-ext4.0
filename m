From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext2 hang on (intentionally) corrupted filesystem
Date: Mon, 28 May 2012 13:31:33 -0400
Message-ID: <20120528173133.GA31109@thunk.org>
References: <20120505013841.GD13332@sli.dy.fi>
 <20120509211236.GI5092@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sami Liedes <sami.liedes@iki.fi>, linux-ext4@vger.kernel.org,
	linux-fsdev@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46007 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab2E1Rbt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 13:31:49 -0400
Content-Disposition: inline
In-Reply-To: <20120509211236.GI5092@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 09, 2012 at 11:12:36PM +0200, Jan Kara wrote:
> > 1. wget http://sli.dy.fi/~sliedes/berserker/testcases/ext2.110.min.bz2
> > 2. mount ... /mnt -t ext2 -o errors=continue
> > 3. Do some operations; what I do (it's the rm that crashes):
> >   timeout 30 rm -rf /mnt/* >&/dev/null
> > 4. The rm task hangs
> > 
>   OK, you've changed '.' directory entry to a normal directory entry with a
> name 0x6e. I guess that has some potential in confusing something. Actually
> rm -rf does not reproduce the problem for me (it just complains about
> cyclic directory hierarchy) but trying to rmdir bad entry hangs the system
> - we try to grab i_mutex for the directory twice because the directory is
> it's own parent... That would be kind of hard to fix in VFS since once our
> directory structure contains a cycle, our locking protocol is no longer
> deadlock free. I'll see what we could do...

Just wanted to chime in that this crashes when the file system is
mounted using ext4; not surprising, since it's clearly a VFS issue.

The following proof-of-concept patch (see reply chained to this mail
message) fixes the problem for your test file system.  Al, what do you
think?  Is it worth it to define a new mechanism where we can pass
VFS-detected corruption down to the low-level file system?

						- Ted
