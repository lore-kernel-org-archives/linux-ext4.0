From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [Bug 421482] Firefox 3 uses fsync excessively
Date: Mon, 26 May 2008 06:07:51 -0400
Message-ID: <20080526100751.GB24507@mit.edu>
References: <bug-421482-310856@https.bugzilla.mozilla.org/> <200805260513.m4Q5DAU8018498@mrapp54.mozilla.org> <20080526000506.1d0fb047.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080526000506.1d0fb047.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 26, 2008 at 12:05:06AM -0700, Andrew Morton wrote:
> It's purportedly showing that fdatasync() on ext3 is syncing the whole
> world in fsync()-fashion even with an application which does not grow
> the file size.
> 
> But fdatasync() shouldn't do that.  Even if the inode is dirty from
> atime or mtime updates, that shouldn't cause fdatasync() to run an
> ext3 commit?

Well, ideally it shouldn't, although POSIX allows fdatasync() to be
implemented in terms of fsync().  It is at the moment.  :-/

The problem is we don't currently have a way of distinguishing between
a "smudged" inode (only the mtime/atime has changed) and a "dirty"
inode (even if the number of blocks hasn't changed, if i_size has
changed, or i_mode, or anything else, including extended attributes
inline in the inode).  We're not tracking that difference.  If we only
allow mtime/atime changes through setattr (see Cristoph's patches),
and don't set the VFS dirty bit, but our own "smudged" bit, we could
do it --- but at the moment, we're not.

							- Ted
