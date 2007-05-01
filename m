From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext2/3 block remapping tool
Date: Tue, 1 May 2007 11:28:06 -0400
Message-ID: <20070501152806.GC26093@thunk.org>
References: <20070426192953.GC2841@duck.suse.cz> <20070427180942.GB5967@schatzie.adilger.int> <20070430120930.GA10604@thunk.org> <20070501060142.GZ5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53518 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXEAP2N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 May 2007 11:28:13 -0400
Content-Disposition: inline
In-Reply-To: <20070501060142.GZ5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 01, 2007 at 12:01:42AM -0600, Andreas Dilger wrote:
> Except one other issue with online shrinking is that we need to move
> inodes on occasion and this poses a bunch of other problems over just
> remapping the data blocks.

Well, I did say "necessary", and not "sufficient".  But yes, moving
inodes, especially if the inode is currently open gets interesting.  I
don't think there are that many user space applications that would
notice or care if the st_ino of an open file changed out from under
them, but there are obviously userspace applications, such as tar,
that would most definitely care.

					- Ted
