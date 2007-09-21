From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Enabling h-trees too early?
Date: 21 Sep 2007 11:02:58 +0200
Message-ID: <p738x709yrh.fsf@bingen.suse.de>
References: <20070919150715.GH9232@duck.suse.cz>
	<20070919182450.GF25497@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52389 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbXIUJC7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Sep 2007 05:02:59 -0400
In-Reply-To: <20070919182450.GF25497@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:
> 
> Certainly one of the things that we could consider is for small
> directories to do an in-memory sort of all of the directory entries at
> opendir() time, and keeping that list until it is closed.  We can't do
> this for really big directories, but we could easily do it for
> directories under 32k or 64k.

I assume you mean sort by inode, because sort by htree key would
be as bad as htrees.

But wouldn't that break parallel readdir for a directory that just grows
from <32/64K to over it?  e.g. if the sort moves already read 
entries to after the  cursor readdir would return some entries twice.

I suspect you would need to keep it always sorted after that no matter
how big it gets. So the 32/64k boundary seems useless and you would
need a sorted potentially partial in memory rbtree anyways.

-Andi
