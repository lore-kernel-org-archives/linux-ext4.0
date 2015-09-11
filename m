From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsck discrepancy with debugfs stat ?
Date: Fri, 11 Sep 2015 13:55:51 -0400
Message-ID: <20150911175551.GD31723@thunk.org>
References: <55F2449D.9090000@yale.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Chris Hunter <chris.hunter@yale.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46529 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbbIKRzw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Sep 2015 13:55:52 -0400
Content-Disposition: inline
In-Reply-To: <55F2449D.9090000@yale.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2015 at 11:03:57PM -0400, Chris Hunter wrote:
> Are there scenarios where e2fsck will report a deleted/unused inode but
> debugfs is able to read the inode structure ?

When e2fsck reports that an inode is deleted/unused, it means that the
i_links_count field in the inode is zero.  If that happens, it's
possible that the blocks previously associated with inode have been
reassigned, and so may contain someone else's love letters, medical
records, etc., and so the ext4 file system will report a corruption,
and allow you to read the inode, and e2fsck assumes that the
appropriate resolution to the problem is to clear the directory entry.

(After all, you wouldn't want to accidentally commit a HIPPA
violation, when fines for violations range $100 to $50,000 per record,
would you?  Not to mention potentially getting lots of terrible Yelp
reviews.  :-)

> However when I run command debugfs -c -R "stat /O/0/d19/131249395" <DEV>, I
> can retrieve inode contents. Further debugfs "dump" will successfully pull
> the contents (980 bytes) of the file entry.

You can do anything with with debugfs.  Debugfs doesn't care if the
i_links_count field is zero, so it will happily return whatever might
be pointed to by that inode.

In terms of what might cause this, unless someone has been
manipulating file system structures using debugfs (for example,
"set_inode_field /O/0/d19/131249395 i_links_count 0"), it shouldn't
happen modulo hardware or software malfunctions / bugs.  For example,
if you are using a SSD which isn't power failure protected (most
consumer-grade SSD's aren't) after a power failure, even if the file
system is properly using cache flush commands, if the SSD isn't set up
to make sure the SSD's metadata is properly saved to stable storage
after a power failure, the underlying file system can get corrupted.

      	      	       	   	      	   	  - Ted

