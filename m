From: Theodore Tso <tytso@mit.edu>
Subject: Re: Enabling h-trees too early?
Date: Fri, 21 Sep 2007 07:45:04 -0400
Message-ID: <20070921114504.GM30221@thunk.org>
References: <20070919150715.GH9232@duck.suse.cz> <20070919182450.GF25497@thunk.org> <p738x709yrh.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34670 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbXIULpK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Sep 2007 07:45:10 -0400
Content-Disposition: inline
In-Reply-To: <p738x709yrh.fsf@bingen.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 21, 2007 at 11:02:58AM +0200, Andi Kleen wrote:
> I assume you mean sort by inode, because sort by htree key would
> be as bad as htrees.
> 
> But wouldn't that break parallel readdir for a directory that just grows
> from <32/64K to over it?  e.g. if the sort moves already read 
> entries to after the  cursor readdir would return some entries twice.

No, it wouldn't break it because after snapshotting the tree, we would
only use the snapshot and not refer to the on-disk format until the
directory file handle is closed or there is an explicit lseek to 0.
To quote from the spec:

  If a file is removed from or added to the directory after the most recent
  call to the opendir() or rewinddir() function, whether a subsequent call to
  the readdir() function returns an entry for that file is unspecified.

So, if some program does the stupid thing and opens a directory,
doesn't use it for five hours, and in the meantime 2,000 files are
created, it's OK if we only return the set of files that were in
existence when the opendir() was originally called.  This makes us OK
in terms of spec conformance, and given that real life programs don't
do stuff this stupid, we should be fine.

					- Ted
