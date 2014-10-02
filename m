From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] vfs: Fix data corruption when blocksize < pagesize
 for mmaped data
Date: Wed, 1 Oct 2014 22:06:19 -0400
Message-ID: <20141002020619.GA16766@thunk.org>
References: <1411648916-16773-1-git-send-email-jack@suse.cz>
 <1411648916-16773-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411648916-16773-2-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 25, 2014 at 02:41:55PM +0200, Jan Kara wrote:
> ->page_mkwrite() is used by filesystems to allocate blocks under a page
> which is becoming writeably mmapped in some process' address space. This
> allows a filesystem to return a page fault if there is not enough space
> available, user exceeds quota or similar problem happens, rather than
> silently discarding data later when writepage is called.
> 
> However VFS fails to call ->page_mkwrite() in all the cases where
> filesystems need it when blocksize < pagesize. For example when
> blocksize = 1024, pagesize = 4096 the following is problematic:
>   ftruncate(fd, 0);
>   pwrite(fd, buf, 1024, 0);
>   map = mmap(NULL, 1024, PROT_WRITE, MAP_SHARED, fd, 0);
>   map[0] = 'a';       ----> page_mkwrite() for index 0 is called
>   ftruncate(fd, 10000); /* or even pwrite(fd, buf, 1, 10000) */
>   mremap(map, 1024, 10000, 0);
>   map[4095] = 'a';    ----> no page_mkwrite() called
> 
> At the moment ->page_mkwrite() is called, filesystem can allocate only
> one block for the page because i_size == 1024. Otherwise it would create
> blocks beyond i_size which is generally undesirable. But later at
> ->writepage() time, we also need to store data at offset 4095 but we
> don't have block allocated for it.
> 
> This patch introduces a helper function filesystems can use to have
> ->page_mkwrite() called at all the necessary moments.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied to the ext4 tree, thanks.

					- Ted
