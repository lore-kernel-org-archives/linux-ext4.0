From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3][RFC](Repost) ext4: add a message in remount/umount
	for ext4
Date: Wed, 30 Sep 2009 23:55:44 -0400
Message-ID: <20091001035544.GT24383@mit.edu>
References: <20090930154931.ef2a4760.toshi.okajima@jp.fujitsu.com> <20090930172220.GL24383@mit.edu> <4AC41FF1.7060703@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, adilger@sun.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55238 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534AbZJADzy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Sep 2009 23:55:54 -0400
Content-Disposition: inline
In-Reply-To: <4AC41FF1.7060703@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 01, 2009 at 12:20:17PM +0900, Toshiyuki Okajima wrote:
> I am recognizing it. But I think I have already explained its answer as follows:
>  - A print mechanism has already been included at mount time.

It's true that some file systems already are printing a message at
mount time; but when we abstract up something to the VFS layer, that's
also an opportunity to remove some kernel printk's from some
filesystems, including ext2/3/4 at the same time this feature is
introduced.

> > filesystem specific information, but that could be handled via a new
> > method function in struct super_ops:
> >
> >        mount_msg(struct super *sb, char *buf, int buflen)
> >

Note that what I was assuming is that we would is something like this
in the VFS mount code:

     printk(KERN_INFO "Device %s mounted file system type %s read-%s%s\n",
            sb->s_sid, sb->s_type->name, 
	    sb->s_flags & MS_RDONLY ? "only" : "write",
	    sb->s_op->mount_msg ? sb->s_op->mount_msg(sb) : "");

The advantage of this is that we would now have a single consistent
kernel message for all file systems, with some room for file system
specific message.

						- Ted

