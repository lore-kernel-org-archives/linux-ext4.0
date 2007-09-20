From: Jan Kara <jack@suse.cz>
Subject: Re: Enabling h-trees too early?
Date: Thu, 20 Sep 2007 15:33:50 +0200
Message-ID: <20070920133350.GH2689@duck.suse.cz>
References: <20070919150715.GH9232@duck.suse.cz> <20070919182450.GF25497@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44478 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753404AbXITNM7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 09:12:59 -0400
Content-Disposition: inline
In-Reply-To: <20070919182450.GF25497@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 19-09-07 14:24:50, Theodore Tso wrote:
> On Wed, Sep 19, 2007 at 05:07:15PM +0200, Jan Kara wrote:
> > 
> >   I was just wondering: Currently we start to build h-tree in a directory
> > already when the size of directory exceeds one block. But honestly, it does
> > not seem to make much sence to use this feature until the directory is much
> > larger (I'd say at least 16 or 32 KB). It actually slows down some
> > operations like deleting the whole directory, etc. So what is the reason
> > for starting building the tree so early? Just the simplicity of building it
> > when the directory is just one block large?
> 
> How much is it slowing down operations such as rm -rf?  For a small
> directory (< 32k), I would assume that the difference would be
> relatively small.  What sort of differences have you measured, and is
> this a common case problem?
  So for example deleting kernel tree on my computer takes ~14 seconds with
h-trees and less than 9 without them. Also doing 'cp -lr' of the kernel
tree takes 8 seconds with h-trees and 6.3s without them... So I think the
performance difference is quite measurable.

> Certainly one of the things that we could consider is for small
> directories to do an in-memory sort of all of the directory entries at
> opendir() time, and keeping that list until it is closed.  We can't do
> this for really big directories, but we could easily do it for
> directories under 32k or 64k.
  Umm, yes. That would be probably feasible. But converting to htrees only
when directories grow larger would avoid the problem also. It also does not
seem *that* hard but maybe I miss some nasty details...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
