From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 8 Nov 2009 14:12:27 -0500
Message-ID: <20091108191227.GB1647@mit.edu>
References: <bug-14354-13602@http.bugzilla.kernel.org/> <200911062207.nA6M7FgC014166@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48089 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbZKHTM1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Nov 2009 14:12:27 -0500
Content-Disposition: inline
In-Reply-To: <200911062207.nA6M7FgC014166@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 06, 2009 at 10:07:15PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> For ext4, one thing I would suggest is to simply always put the NUL at the 
> end of the name, even if the filesystem might not need it. Then 
> nd_terminate_link() will still write the NUL, but it won't change any data 
> (and thus no CRC's).

It's pretty simple to do this; in fact it's a one-line change in
ext4_symlink() in fs/ext4/inode.c:

		/* clear the extent format for fast symlink */
		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
		inode->i_op = &ext4_fast_symlink_inode_operations;
-		memcpy((char *)&EXT4_I(inode)->i_data, symname, l);
+		strcpy((char *)&EXT4_I(inode)->i_data, symname);
		inode->i_size = l-1;

					- Ted
