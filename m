From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: An idea for supporting large directories and readdir+stat
 workloads
Date: Mon, 13 Aug 2012 10:36:07 -0400
Message-ID: <20120813143607.GB32484@thunk.org>
References: <20120811212532.GB906@thunk.org>
 <B12EEBD6-6DA4-4D2C-A31F-B2F7FAFCD372@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44410 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab2HMOgL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2012 10:36:11 -0400
Content-Disposition: inline
In-Reply-To: <B12EEBD6-6DA4-4D2C-A31F-B2F7FAFCD372@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 12, 2012 at 11:11:32PM -0600, Andreas Dilger wrote:
> Essentially, this is storing the inode in the directory.

Well, except we don't need to store *all* of the inode in the
directory.  My proposal was to include just the bits which are
necessary for stat(2) to function, which is about 64 bytes including
the SELinux SID.

If we store the "compact inode" in the directory, for an average file
name length of, say, 12 bytes, we can still store some 50-52 directory
entries in each 4k block.  If the htree code directs us to the correct
leaf block, we can still do lookups and stats very quickly.

> What might be possible is to have the directory leaf block point be
> the same thing as the inode table block, and then use an xattr in
> the inode to hold the parent directory number and filename as the
> "dirent".

There are a couple of problems I see with this approach; one i show do
we handle hash collisions in this new scheme?  You could put multiple
entries in the index block, one for each inode table block, I suppose.

Another issue is that it will slow down a pure readdir() only workload
significantly, since it will require a large number of random reads
into the inode table.  Even a readdir+stat workload will require many
more random reads than the "compact inode" in the directory entry
which I propose.

> I think that by the time we store all of the "stat" attributes into the
> directory it would essentially duplicate the inode, and increase overhead
> instead of reducing it.  Every inode update would likely require also
> updating the directory (mtime, ctime, etc).

What I was proposing was in the case where the inode had only a single
hard link (the common case), the information in the "compat inode"
(i.e., in the directory entry) would take precedence over what was
stored in the inode table.  This means that we would only need to
update the directory block -- and these are the fields that we would
need to store:

Field		Size

ino		 4
dev		 4
mode		 4
uid		 4
gid		 4
size		 8
atime		 8
mtime		 8
ctime		 8
blocks		10
selinux sid	 4
               ====
TOTAL		62

So basically, instead of updating the inode table, we would have to
update the directory block instead.  So there wouldn't be any extra
I/O overhead.  In terms of increasing the size of the directory, it
would certainly do that; but I think the speed improvements could very
well be worth it.

Regards,

						- Ted
