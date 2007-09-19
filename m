From: Theodore Tso <tytso@mit.edu>
Subject: Re: Enabling h-trees too early?
Date: Wed, 19 Sep 2007 14:24:50 -0400
Message-ID: <20070919182450.GF25497@thunk.org>
References: <20070919150715.GH9232@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41856 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbXISSY4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2007 14:24:56 -0400
Content-Disposition: inline
In-Reply-To: <20070919150715.GH9232@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 19, 2007 at 05:07:15PM +0200, Jan Kara wrote:
> 
>   I was just wondering: Currently we start to build h-tree in a directory
> already when the size of directory exceeds one block. But honestly, it does
> not seem to make much sence to use this feature until the directory is much
> larger (I'd say at least 16 or 32 KB). It actually slows down some
> operations like deleting the whole directory, etc. So what is the reason
> for starting building the tree so early? Just the simplicity of building it
> when the directory is just one block large?

How much is it slowing down operations such as rm -rf?  For a small
directory (< 32k), I would assume that the difference would be
relatively small.  What sort of differences have you measured, and is
this a common case problem?

Certainly one of the things that we could consider is for small
directories to do an in-memory sort of all of the directory entries at
opendir() time, and keeping that list until it is closed.  We can't do
this for really big directories, but we could easily do it for
directories under 32k or 64k.

	   	    	      	 	     	      - Ted
