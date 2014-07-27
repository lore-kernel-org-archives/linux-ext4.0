From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
Date: Sat, 26 Jul 2014 21:01:44 -0400
Message-ID: <20140727010144.GA13438@thunk.org>
References: <53CDF437.4090306@lge.com>
 <20140722073005.GT3935@laptop>
 <20140722081440.GA5137@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Peter Zijlstra <peterz@infradead.org>, Gioh Kim <gioh.kim@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58937 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbaG0BCA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 21:02:00 -0400
Content-Disposition: inline
In-Reply-To: <20140722081440.GA5137@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Gioh,

As follow up, if you want some further discussions about why these
patches should be accepted, it would be good to get some hard data
about why the keeping the ext4 superblock pinned is causing such a
problem for page migation.  Can you give us more details about what
the impact is of not having these patches?  And how it compres to
other data structures which are currently allocated in the moveable
area and tend to be pinned effectively indefinitely?

Thanks,

						- Ted
