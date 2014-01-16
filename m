From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: ext4: indirect block allocations not sequential in 3.4.67 and 3.11.7
Date: Thu, 16 Jan 2014 14:30:23 -0500
Message-ID: <20140116193023.GH12751@kvack.org>
References: <20140115192802.GK21295@kvack.org> <20140115202214.GH9229@birch.djwong.org> <20140115203205.GA12751@kvack.org> <20140115215613.GD12751@kvack.org> <20140116035459.GB14736@thunk.org> <20140116184826.GG12751@kvack.org> <20140116191227.GC32098@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:59302 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbaAPTaY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jan 2014 14:30:24 -0500
Content-Disposition: inline
In-Reply-To: <20140116191227.GC32098@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 16, 2014 at 02:12:27PM -0500, Theodore Ts'o wrote:
> An 8MB file will require two indirect blocks.  If you are using
> extents, almost certainly it will fit inside the inode, which means we
> don't need any external metadata blocks.  That massively speeds up
> fsck time, and unlink time, and it also speeds up the random read case
> since the best way to optimize a seek is to eliminate it.  :-)

> I understand that for your use case, it would be hard to move to using
> extents right away.  But I think you'd see so many improvements from
> going to ext4 and extents that it might be more efficient to optimize
> an indirect blocok scheme.

Unfortunately, the improvements from extents for our use-case are not 
enough to outweigh the other costs of deployment.  I think I've figured 
out a hack that results in the system doing most of what I want it to do: 
I've removed EXT4_MB_HINT_DATA in ext4_alloc_blocks().  With that change, 
the allocator is giving me mostly sequential allocations.  Hopefully that 
doesn't have any other negative side effects.

		-ben

> 						- Ted

-- 
"Thought is the essence of where you are now."
