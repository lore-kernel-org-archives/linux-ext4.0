From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 07/12] rfc: 2fsprogs update
Date: Tue, 26 Sep 2006 13:37:00 -0400
Message-ID: <20060926173700.GD4219@thunk.org>
References: <20060926143343.GA20020@openx1.frec.bull.fr> <20060926144832.GG25755@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:701 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S932172AbWIZRhN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 13:37:13 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060926144832.GG25755@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 26, 2006 at 04:48:32PM +0200, Alexandre Ratchov wrote:
> convert all 32bit on-disk block number definitions (currently __u32,
> blk_t, unsigned long, unsigned int...) to pblk_t that is defined as
> __u32. In this way we are sure that blk_t is used only in memory.
> Later, this would allow to make blk_t 64bit without disturbing any
> programs (this would just eat more momory and use 64bit arithmetic).

I *really* dislike this approach, because it makes it very hard to
prove that we got all of the conversions right --- any mistakes about
which instances of blk_t need to become pblk_t, and which are supposed
to stay blk_t, and we end up breaking our ABI compatibility.  And
let's just say I have higher standards than Greg KH has shown with
udev.  :-)    

I also don't like pblk_t, because it's not at all obvious what it
means.  And what if we want to support 64-bit logicial blocks someday?
Then it's another painful exercise to figure out which blk_t get
separated to lblk_t, etc.   


So my plan is to introduce a new type, blk64_t, and create new
interfaces, such as ext2fs_extent_iterate(), which will use the new
type --- and which will work with old-style indirect block inodes as
well (it will translate indirect blocks into extents).  

					- Ted
