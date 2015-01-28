From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/54] e2fsck: on read error, don't rewrite blocks past
 the end of the fs
Date: Wed, 28 Jan 2015 15:35:36 -0800
Message-ID: <20150128233536.GF9976@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073657.13308.5523.stgit@birch.djwong.org>
 <20150127173507.GM2453@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:46846 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891AbbA2BmI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Jan 2015 20:42:08 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
	by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t0SNZfEa002944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 28 Jan 2015 23:35:42 GMT
Content-Disposition: inline
In-Reply-To: <20150127173507.GM2453@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 27, 2015 at 12:35:07PM -0500, Theodore Ts'o wrote:
> On Mon, Jan 26, 2015 at 11:36:57PM -0800, Darrick J. Wong wrote:
> > If e2fsck encounters a read error on a block past the end of the
> > filesystem, don't bother trying to "rewrite" the block.  We might
> > still want to re-try the read to capture FS data marooned past the end
> > of the filesystem, but in that case e2fsck ought to move the block
> > back inside the filesystem.
> > 
> > This enables e2fuzz to detect writes past the end of the FS due to
> > software bugs.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Applied, but if we have a block which is past the end of the file
> system, why did we try to read it in the first place?
> 
> Was it because e2fsck was told to ignore a file system inconsistency?
> Or because e2fsck didn't notice before trying to read a block?  If so,
> we should look to see if there is some way we could have caught this
> error in the first place.  So it might be useful to run e2fuzz and
> call abort() if we try to read past the end of the file system, so we
> can get a stack dump and understand what happened....

Ok, so I went a little ways down the path to see what I could see:

print_pathname() will run right into it if we try to display the path
name and one of the directories on that path happens to have a bad
directory block pointer, and we haven't yet gotten to fixing the bad
directory block.  Read errors simply make it print "???", so there's
no need to abort().

The journal code will try to replay the journal without checking block
boundaries; returning an error (or a zeroed block with no journal
magic) aborts journal replay like you'd expect.  No need to abort()
the whole program here either.

check_is_really_dir() tries to read a (potentially badly corrupt) file
to guess if it's a directory before we scan the extent tree for
invalid blocks.  Hitting a read error here isn't the end of the world
either.

pass1[b-d] is where things really get tricky -- if pass1 detects that
an extent block collides with critical metadata, it'll put the ETB on
the list of blocks to clone, refuse to touch any of the data
inside that ETB, and restart fsck from the beginning once all the
critical colliding blocks have been reassigned.  This is to avoid
corrupting bitmap/inode/group data.  However, in iterating the
unchecked ETB during that first run through pass 1b, it's possible for
the block iteration call to try to read garbage contents.

There's possibly more, but so far I've not encountered any scenarios
where fsck actually does the wrong thing as a result of reading past
the end of the FS.  It seems that e2fsck will fix pointers to data
blocks outside the filesystem.  Granted, it "fixes" things by erasing
them... but so far, I haven't found anything needing a code fix.

--D

> 
>     	  	     	 	    	 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
