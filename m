From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3][RFC](Repost) ext4: add a message in remount/umount
	for ext4
Date: Wed, 30 Sep 2009 13:22:20 -0400
Message-ID: <20090930172220.GL24383@mit.edu>
References: <20090930154931.ef2a4760.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, adilger@sun.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43103 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbZI3RW7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Sep 2009 13:22:59 -0400
Content-Disposition: inline
In-Reply-To: <20090930154931.ef2a4760.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 30, 2009 at 03:49:31PM +0900, Toshiyuki Okajima wrote:
> From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> 
> ext4 doesn't log a record of having unmounted the filesystem. And ext4 doesn't 
> log a record when the filesystem is remounted also with read-only. Therefore 
> in the system log, we cannot judge whether or not at the certain time this
> filesystem user touches it.
> For enterprise users, they often want to know when a certain filesystem is 
> mounted/remounted/unmounted.
> 
> So, we output the message to the system log when the filesystem is 
> remounted/unmounted.
> 
> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

The question of whether this should be at the VFS layer is still an
open one, I think.  It is true that ext3 and ext4 does print some
filesystem specific information, but that could be handled via a new
method function in struct super_ops:

       mount_msg(struct super *sb, char *buf, int buflen)

Note by the way that I've made some changes to clean up ext4's
mount/umount messages, trying to get rid of excess messages.  In fact
ext4 already prints a "filesystem mounted" message in
ext4_fill_super().  You removed the one in ext4_setup_super(), but
I've already removed it in a recent commit pushed to Linus to remove
superflous mount-time printk's.  I left the one at the very end of
ext4_fill_super() in; and your patch adds one about 2/3'rd of the way
into ext4_fill_super() --- so two "filesystem mounted" messages would
end up getting printed as a result.  

Did you actually test the patch and see what sort of messages would be
printed as a result?

						- Ted
