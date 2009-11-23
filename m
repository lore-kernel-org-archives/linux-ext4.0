From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: i_version, NFSv4 change attribute
Date: Mon, 23 Nov 2009 13:11:19 -0500
Message-ID: <1258999879.8700.17.camel@localhost>
References: <20091122222047.GB21944@fieldses.org>
	 <20091123114831.GA2532@thunk.org>  <20091123164445.GB3292@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-out2.uio.no ([129.240.10.58]:49526 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbZKWSLT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 13:11:19 -0500
In-Reply-To: <20091123164445.GB3292@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-11-23 at 11:44 -0500, J. Bruce Fields wrote: 
> If the side we want to optimize is the modifications, I wonder if we
> could do all the i_version increments on *read* of i_version?:
> 
> 	- writes (and other inode modifications) set an "i_version_dirty"
> 	  flag.
> 	- reads of i_version clear the i_version_dirty flag, increment
> 	  i_version, and return the result.
> 
> As long as the reader sees i_version_flag set only after it sees the
> write that caused it, I think it all works?

That probably won't make much of a difference to performance. Most NFSv4
clients will have every WRITE followed by a GETATTR operation in the
same compound, so your i_version_dirty flag will always immediately get
cleared.

The question is, though, why does the jbd2 machinery need to be engaged
on _every_ write? The NFS clients don't care if we lose an i_version
count due to a sudden server reboot, since that will trigger a rewrite
of the dirty data anyway once the server comes back up again.
As long as the i_version is guaranteed to be written to stable storage
on a successful call to fsync(), then the NFS data integrity
requirements are fully satisfied.

Trond

