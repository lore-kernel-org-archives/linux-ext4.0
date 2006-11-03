From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: Re: [RFC] Defragmentation interface
Date: Fri, 03 Nov 2006 08:50:44 -0600
Message-ID: <1162565444.8604.7.camel@kleikamp.austin.ibm.com>
References: <20061102143929.GA8607@atrey.karlin.mff.cuni.cz>
	 <20061102225953.GF8394166@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43968 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1753263AbWKCO5k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Nov 2006 09:57:40 -0500
To: David Chinner <dgc@sgi.com>
In-Reply-To: <20061102225953.GF8394166@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2006-11-03 at 09:59 +1100, David Chinner wrote:

> Let me get this straight - the interface you propose for
> moving data about is:
> 
> 	read and process extents into an internal structure
> 	find range where you want to relocate
> 	find free space you want to relocate into
> 	write desired block to alloc_goal
> 	seek to allocation offset in data/alloc
> 	write length into data/alloc
> 	allocate new inode
> 	write new inode number into data/reloc to relocate blocks
> 
> What I proposed:
> 
> 	fcntl(src, FIBMAP);
> 	/* find range to relocate */
> 	open(tmp, O_CREATE);
> 	funlink(tmp);
> 	fs_get_free_list(src, policy, list);
> 	/* select free extent to use */
> 	fs_allocate_space(tmp, list[X], off, len);
> 	fs_move_data(src, tmp, off, len);
> 	close(tmp);
> 	close(src);
> 
> So the process is pretty close to the same except the interface I
> proposed does not change the location of the inode holding the data.
> The major difference is that one implementation requires 3 new
> generically useful syscalls, and the other requires every filesystem
> to implement a metadata filesystem and require root priviledges
> to use.

I agree with Dave here.  The metadata filesystem will require a lot of
overhead (and a lot of code) both in the kernel and in user-space.  The
only benefit I see, is that it can be easily extended.  This may be
useful for debugging and prototyping, but I don't like it as a solution
for adding a permanent interface.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
