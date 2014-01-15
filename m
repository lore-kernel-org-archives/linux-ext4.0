From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: ext4: indirect block allocations not sequential in 3.4.67 and 3.11.7
Date: Wed, 15 Jan 2014 15:32:05 -0500
Message-ID: <20140115203205.GA12751@kvack.org>
References: <20140115192802.GK21295@kvack.org> <20140115202214.GH9229@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:45190 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaAOUcG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jan 2014 15:32:06 -0500
Content-Disposition: inline
In-Reply-To: <20140115202214.GH9229@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 15, 2014 at 12:22:14PM -0800, Darrick J. Wong wrote:
> A dumpe2fs would be nice, but I think I have enough here to speculate:

It's trivial to reproduce.  Just create a 1GB file, run mkfs.ext3, then 
mount with ext4 and dd a 10MB file onto the filesystem.

> The data blocks are all sequential, which looks like what one would expect from
> mballoc.  Is your complaint is that the *IND blocks are not inline with the
> data blocks, like what ext3 did?

The problem is that the indirect blocks are nowhere near where the file's 
data is.  It'd be perfectly okay if they were at the beginning of the range 
of blocks used for the file's data.

> FWIW, ext3 did something like this:
> (0-11):6144-6155, (IND):6156, (12-1035):6157-7180, (DIND):7181, (IND):7182,
> (1036-2059):7183-8206, (IND):8207, (2060-2559):8208-8707
> 
> I think the behavior that you're seeing is ext4 trying to keep the mapping
> blocks close to the inode table to avoid fragmenting the file -- see
> ext4_find_near() in indirect.c.  There's an XXX comment in ext4_find_goal()
> that implies that someone might have wanted to tie in with mballoc, which I
> suppose you could use to restore the ext3 behavior... but there's no way to do
> that.
...

I tried a few tests setting goal to different things, but evidently I'm 
not managing to convince mballoc to put the file's data close to my goal 
block, something in that mess of complicated logic is making it ignore 
the goal value I'm passing in.

		-ben
-- 
"Thought is the essence of where you are now."
