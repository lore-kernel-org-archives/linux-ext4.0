From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 66/73] ext2: Split ext2_add_entry() from
 ext2_add_link() [ver #2]
Date: Sun, 26 Feb 2012 19:04:28 -0500
Message-ID: <20120227000428.GA8044@thunk.org>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
 <20120221180546.25235.50961.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
	valerie.aurora@gmail.com, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, linux-ext4@kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120221180546.25235.50961.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 21, 2012 at 06:05:46PM +0000, David Howells wrote:
> From: Valerie Aurora <vaurora@redhat.com>
> 
> Allow future code to use the guts of ext2_add_link().
> 
> Original-author: Valerie Aurora <vaurora@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-ext4@kernel.org

I'd suggest folding this in with the following patch (67/73).  It's
not clear from this patch why renaming ext2_add_link to
ext2_add_entry() makes sense and then adding a new ext2_add_link()
which calls ext_add_entry().   It doesn't seem to clarify much....

I won't insist on it, but this seems to be unnecessary complication.

      	    		       	  	       - Ted
