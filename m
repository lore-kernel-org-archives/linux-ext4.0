From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: journal superblock modifications in
	ext4_statfs()
Date: Mon, 9 Nov 2009 07:53:36 -0500
Message-ID: <20091109125336.GF7592@mit.edu>
References: <4AF4A429.7090507@redhat.com> <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com> <20091108214804.GC7592@mit.edu> <4AF741A4.9060907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54383 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733AbZKIMxm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Nov 2009 07:53:42 -0500
Content-Disposition: inline
In-Reply-To: <4AF741A4.9060907@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 08, 2009 at 04:09:40PM -0600, Eric Sandeen wrote:
>
> But don't we journal the superblock sometimes, not others ... for  
> example write_super -> ext4_write_super -> ext4_commit_super does no  
> journaling of superblock modifications. ext4_orphan_add, however, does.  
> This would likely lead to trouble w/ the debugging patch ... though I  
> didn't see it ... ?

Ah, I had forgotten about ext4_orphan_add(); that is indeed the one
place where we would be updating the super block under normal
operations, besides online-resize.

I've been looking at the write_super() paths, and from what I can tell
it's only used in two places.  The generic fsync() handler,
file_fsync(), which we do't use, and sync_supers(), which will indeed
call write_super() -> ext4_write_super() if sb->s_dirt is set.  That
led me to examine the places where we set s_dirt, and it's in a lot of
places where we're no longer modifying the superblock any more, but
we're still setting sb->s_dirt.  I don't know why you didn't see
problems with the debugging patch; the only thing I can think of is
that since the actual superblock update is deferred to a
timer-triggered callback, you were getting consistently lucky ---
which is hard for me to believe, but I don't have a better suggestion.

What I think we do need to do is eliminate all of the places where we
set sb->s_dirt, and if we need to update the superblock, we do it
ourselves, under journaling control.

That leaves places which call ext4_commit_super() directly, which is
at mount and unmount time (which should be OK, as long as it's before
or after journalling is active) and when we freeze the filesystem,
which might be OK, but we need to take a careful look at it.

            	       	       	       	  - Ted
