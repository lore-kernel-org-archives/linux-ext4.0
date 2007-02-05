From: Nathan Scott <nscott@aconex.com>
Subject: Re: [RFC][PATCH 2/3] Move the file data to the new blocks
Date: Tue, 06 Feb 2007 09:06:30 +1100
Message-ID: <1170713190.18017.457.camel@edge>
References: <20070116210520sho@rifu.tnes.nec.co.jp>
	 <20070205131204.GA15596@atrey.karlin.mff.cuni.cz>
Reply-To: nscott@aconex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sho@tnes.nec.co.jp, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070205131204.GA15596@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jan,

On Mon, 2007-02-05 at 14:12 +0100, Jan Kara wrote:
>   Hi,
> 
>   I'm replying rather late but I've been busy with my PhD thesis lately.
> So sorry for that.
> 
> > Move the blocks on the temporary inode to the original inode
> > by a page.
> > 1. Read the file data from the old blocks to the page
> > 2. Move the block on the temporary inode to the original inode
> > 3. Write the file data on the page into the new blocks
>   I have one thing - it's probably not good to use page cache for
> defragmentation. As you will read/write tons of data and that will push
> out all other data from the cache. I think it may be better to allocate
> some separate pages and use them as buffers.

The XFS defrag tool uses direct IO to avoid this issue.  You may
do an even better job with splice(2) in this situation, since its
simply read-then-write-straight-back-out without looking at the
file data.

cheers.

-- 
Nathan

