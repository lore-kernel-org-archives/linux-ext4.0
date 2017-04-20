From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: xattr-in-inode support
Date: Thu, 20 Apr 2017 17:24:40 -0400
Message-ID: <20170420212440.w4oek4rbzxeu2qqk@thunk.org>
References: <86611BEE-5695-4047-9404-D2D3E232318A@dilger.ca>
 <20170414132720.je5ca2c5fibjn6qq@thunk.org>
 <20170420075823.GA18523@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        James Simmons <jsimmons@infradead.org>, tahsin@google.com,
        nauman@google.com, tytso@google.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59674 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S947822AbdDTVYx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Apr 2017 17:24:53 -0400
Content-Disposition: inline
In-Reply-To: <20170420075823.GA18523@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 20, 2017 at 09:58:23AM +0200, Jan Kara wrote:
> So the proposal seems to have implicit in it that we will be
> "deduplicating" xattr values. Currently we deduplicate only full external
> xattr blocks (which possibly contain more xattrs). Any idea how big win
> that is going to be over deduplicating only full sets of xattrs?

So in Windows, the security ID can be larger than what can fit in the
inode (if file creator belongs to foreign domains; I'm told that the
SID in some cases can be 12k or more).  And of course the Windows/Rich
acl can also be substantially bigger than what can fit in the inode.

So if you a directory hierarcy which all have the same ACL's, and a
large number of users that writing into that directory (so there is a
large number of different sids), the resulting cross product can be
large.

Windows also has a large number of other use cases for extended
attributes that will be unique.  In some cases, such as the Unix
timestamps, file owner, permissions bits, for files written by the
Windows Subsystem for Linux will fit in the inode table.  The
information that a particular flie was downloaded from 
"http://russia.phish.org/rootme.exe" so the user could be asked if
they really wanted to open it is also stored in an xattr.

It's definitely true that adding some hueristics to sort certain
xattrs into in-inode xattr will definitely help.  (For example, this
will definitely help the Android SE Linux label / ext4 encryption
context overflow case.)  But there will be definitely some cases,
probably mostly with Windows CIFS serving, where Microsoft is using
enough xattrs where this will probably be useful.

> One idea I had in mind was that one way of supporting larger xattrs would
> be to support something like xattr fork - i.e., in the xattr space of the
> inode we would have root of an extent tree describing xattr space of the
> inode. Then inside the space described by the extent tree would be stored
> xattrs - possibly in the same format as they are currently stored in a
> block (we would just redefine that e_value_block+e_value_offs describe the
> offset of xattr value inside the xattr space). From the perspective of
> "disk reads required to get the xattrs" this proposal should be similar as
> above (xattr space description will mostly fully fit in the xattr space of
> the inode) so we will just go and read the xattr headers and then value.
> It has an advantage that it basically does not limit xattr size or number
> of xattrs. It has the disadvantage that deduplication possibilities are
> lower.

The concern of disk reads required to get the xattrs is especially of
concern for those things are needed every time the file is accessed
--- e.g., for Rich ACL's.  It's the sharing which is what fixes the
disk seeks, and so the lower deduplications possibilities are a major
weakness of the scheme you've proposed above.

I'm personally not that interested in suppporting a large number of
large xattr's.  If we allow xattr values in inodes, that will allow
for a small number large xattr's, which ought to be sufficient, no?

      	    	   	 	  	- Ted
