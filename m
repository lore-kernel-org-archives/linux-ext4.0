From: Neil Brown <neilb@suse.de>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Wed, 11 Jul 2007 13:21:55 +1000
Message-ID: <18068.19667.942363.686858@notabene.brown>
References: <1183275424.4010.126.camel@localhost.localdomain>
	<20070710163038.ceb2ae94.akpm@linux-foundation.org>
	<1184105380.3759.65.camel@localhost.localdomain>
	<20070710182237.e2f88bf3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Tuesday July 10
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday July 10, akpm@linux-foundation.org wrote:
> 
> Yes, thanks.  It doesn't actually tell us why we want to implement
> this attribute and it doesn't tell us what the implications of failing
> to do so are, but I guess we can take that on trust from the NFS guys.

You would like to think so, but remember NFSv4 was designed by a
committee :-)

The 'change' number is used for cache consistency, and as the spec
makes very strong statements about the 'change' number, it is very
hard (or impossible) to implement a server correctly without storing a
change number in stable storage (just one of my grips about V4).

> 
> But I suspect the ext4 implementation doesn't actually do this.  afaict we
> won't update i_version for file overwrites (especially if s_time_gran can
> indeed be 1,000,000,000) and of course for MAP_SHARED modifications.  What
> would be the implications of this?

The first part sounds like a bug - i_version should really be updated
by every call to ->commit_write (if that is still what it is called).

The MAP_SHARED thing is less obvious.  I guess every time we notice
that the page might have been changed, we need to increment i_version.

> 
> And how does the NFS server know that the filesystem implements i_version? 
> Will a zero-value of i_version have special significance, telling the
> server to not send this attribute, perhaps?

That is a very important question.  Zero probably makes sense, but
what ever it is needs to be agreed and documented.
And just by-the-way, the server doesn't really have the option of not
sending the attribute.  If i_version isn't defined, it has to fake
something using mtime, and hope that is good enough.

Alternately we could mandate that i_version is always kept up-to-date
and if a filesystem doesn't have anything to load from storage, it
just sets it to the current time in nanoseconds.

That would mean that a client would need to flush it's cache whenever
the inode fell out of cache on the server, but I don't think we can
reliably do better than that.

I think I like that approach.

So my vote is to increment i_version in common code every time any
change is made to the file, and alloc_inode should initialise it to
current time, which might be changed by the filesystem before it calls
unlock_new_inode. 
... but doesn't lustre want to control its i_version... so maybe not :-(

NeilBrown
