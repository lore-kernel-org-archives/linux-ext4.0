From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH REGRESSION FIX] ext4: fix mtime update in nodelalloc mode
Date: Sun, 30 Sep 2012 15:50:09 -0400
Message-ID: <20120930195009.GA4780@thunk.org>
References: <1349034499-4731-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>,
	stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1349034499-4731-1-git-send-email-tytso-3s7WtUTddSA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Note: this fixes a failure in xfstests #215 for ext3 file systems
mounted using ext4 and ext4 file systems mounted with -o nodelalloc.

	      	       	    	 	 - Ted

On Sun, Sep 30, 2012 at 03:48:19PM -0400, Theodore Ts'o wrote:
> Commits 41c4d25f78c0 and 41c4d25f78c0 introduced a regression into
> 3.6-rc1 for ext4 in nodealloc mode, such that mtime updates would not
> take place for files modified via mmap if the page was already in the
> page cache.
> 
> The problem was that ext4_page_mkwrite() had a shortcut which would
> avoid calling __block_page_mkwrite() under some circumstances, and the
> above two commit transferred the responsibility of calling
> file_update_time() to __block_page_mkwrite --- which woudln't get
> called in some circumstances.
> 
> Since __block_page_mkwrite() only has three years,
> block_page_mkwrite(), ext4_page_mkwrite, and nilfs_page_mkwrite(), the
> best way to solve this is to move the responsibility for calling
> file_update_time() to its caller.
> 
> Signed-off-by: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
