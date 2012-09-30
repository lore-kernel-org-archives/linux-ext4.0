From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH REGRESSION FIX] ext4: fix mtime update in nodelalloc mode
Date: Sun, 30 Sep 2012 16:30:26 -0400
Message-ID: <20120930203026.GD4780@thunk.org>
References: <20120930195124.GF18169@1wt.eu>
 <20120930195002.GA30441@elie.Belkin>
 <20120930195341.GC4780@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>,
	stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Willy Tarreau <w@1wt.eu>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120930195341.GC4780-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

The rewritten commit description:

ext4: fix mtime update in nodelalloc mode

Commits 5e8830dc85d0 and 41c4d25f78c0 introduced a regression into
3.6-rc1 for ext4 in nodealloc mode, such that mtime updates would not
take place for files modified via mmap if the page was already in the
page cache.  This would also affect ext3 file systems mounted using
the ext4 file system driver.

The problem was that ext4_page_mkwrite() had a shortcut which would
avoid calling __block_page_mkwrite() under some circumstances, and the
above two commit transferred the responsibility of calling
file_update_time() to __block_page_mkwrite --- which woudln't get
called in some circumstances.

Since __block_page_mkwrite() only has three callers,
block_page_mkwrite(), ext4_page_mkwrite, and nilfs_page_mkwrite(), the
best way to solve this is to move the responsibility for calling
file_update_time() to its caller.

This problem was found via xfstests #215 with a file system mounted
with -o nodelalloc.

Signed-off-by: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Note: If this gets pushed to Linus before the merge window opens, I'll
drop the cc of stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, since the regression was
introduced in 3.6-rc1.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
