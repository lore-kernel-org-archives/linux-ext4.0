From: Theodore Tso <tytso@mit.edu>
Subject: Re: kernel BUG at fs/ext/super.c:428
Date: Tue, 13 Jan 2009 20:44:34 -0500
Message-ID: <20090114014434.GE14730@mit.edu>
References: <20090110003645.GA16107@linux-os.sc.intel.com> <20090113164842.c6aa7095.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47071 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbZANBol (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Jan 2009 20:44:41 -0500
Content-Disposition: inline
In-Reply-To: <20090113164842.c6aa7095.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 13, 2009 at 04:48:42PM -0800, Andrew Morton wrote:
> Well that's not good.  I don't recall us making any changes which
> affect the orphan list handling.  Perhaps "filesystem freeze: add error
> handling of write_super_lockfs/unlockfs", but only indirectly.
> 
> Does Arjan's new async stuff play with filesystems at umount/shutdown
> time?  Don't think so.

Well, Arjan's commit, efaee192: "async: make the final inode deletion
an asynchronous event", does change how inodes get deleted, and this
looks like a race where an inode is getting deleted during the umount.

So I would try reverting commit efaee192 and see if it fixes things
before starting a full bisect...

							- Ted
