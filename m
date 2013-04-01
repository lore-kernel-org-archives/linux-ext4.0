From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] fs: take i_mutex in __page_symlink()
Date: Mon, 1 Apr 2013 17:35:38 +0100
Message-ID: <20130401163538.GC21522@ZenIV.linux.org.uk>
References: <20130328140635.GA32635@thunk.org>
 <1364829822-18989-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1364829822-18989-1-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 01, 2013 at 11:23:42AM -0400, Theodore Ts'o wrote:
> In Documentation/filesystems/Locking, it's documented that
> write_begin() is guaranteed to be called with i_mutex locked.  The
> function __page_symlink() was not taking i_mutex before calling
> pagecache_write_begin(), which will eventually result in the file
> system's write_begin()'s function getting called.
> 
> Other callers of pagecache_write_begin such as in fs/splice.c, call
> pagecache_write_begin() with i_mutex locked, so fix __page_symlink()
> to be consistent.
> 
> This was discovered by the addition of a new ext4 debugging assertion
> which checked to make sure i_mutex was locked before calling
> ext4_truncate().

	I doubt that it's worth doing (inode has just been created and
nobody else should have references to it - it's not fully set up, after
all)...
