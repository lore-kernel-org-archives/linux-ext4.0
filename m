From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/3] Move the file data to the new blocks
Date: Tue, 6 Feb 2007 17:35:20 -0800
Message-ID: <20070206173520.7719a7de.akpm@linux-foundation.org>
References: <20070116210520sho@rifu.tnes.nec.co.jp>
	<20070205131204.GA15596@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sho@tnes.nec.co.jp, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070205131204.GA15596@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 5 Feb 2007 14:12:04 +0100
Jan Kara <jack@suse.cz> wrote:

> > Move the blocks on the temporary inode to the original inode
> > by a page.
> > 1. Read the file data from the old blocks to the page
> > 2. Move the block on the temporary inode to the original inode
> > 3. Write the file data on the page into the new blocks
>   I have one thing - it's probably not good to use page cache for
> defragmentation.

Then it is no longer online defragmentation.  The issues with maintaining
correctness and coherency with ongoing VFS activity would be truly ghastly.

If we're worried about pagecache pollution then it would be better to control
that from userspace via fadvise().
