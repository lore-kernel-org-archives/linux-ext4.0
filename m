Return-Path: <SRS0=G5ay=OI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43034 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbeK2PON (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Nov 2018 10:14:13 -0500
Date: Wed, 28 Nov 2018 23:10:14 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com
Subject: Re: [PATCH v2] ext2fs: don't read group descriptors during e2label
Message-ID: <20181129041014.GJ31885@thunk.org>
References: <20181128204840.4544-1-artem.blagodarenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128204840.4544-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 28, 2018 at 11:48:40PM +0300, Artem Blagodarenko wrote:
> tune2fs is used to make e2label duties.  ext2fs_open2() reads group
> descriptors which are not used during disk label obtaining, but
> takes a lot of time on large partitions.

Are you trying to speed up using e2label to *read* the label, or
e2label to *write* the label?  How often do you need to write the
label, and do you need to write the label with a dirty journal?

I really don't like this patch because it makes the
EXT2_FLAG_JOURNAL_ONLY flag an **extremely** hazardous flag to use.
If the application uses it wrong, it could lead to extremely serious,
disastrous data loss.

In fact, I'm going to guess that you only care about reading the
label, and you didn't even test using "tune2fs -L new_label
/dev/large_file_system_with_precious_data".  Because if you did, the
tune2fs -L would call ext2fs_mark_super_dirty(), and then
ext2fs_close() would call ext2fs_flushfs(), which would write out all
of the block groups, writing uninitialized trash into all of the block
group descriptor blocks beyond the first one, and your large
production file system would be very sad.

So, ah, NACK.  :-)

If what you care about is "print label" case, what I would suggest is
a new interface which simply reads the superblock into a struct
ext2_super_block and calls ext2fs_swap_super() on it.  This will speed
up the e2label read case.

If you want to speed up the e2label write case when the file system is
cleanly unmounted, we could have a new interface that writes out the
superblock, and tune2fs would use it if the file system does not need
to have a journal replay.  But if the journal does need to be
replayed, we would need to do a full ext2fs_open2() call.

When designing library interfaces, it's always important to imagine
how an well-meaning programmer calling them might misuse them.
Leaving land-mines for programmers to trip over --- especially when
you trip over them yourself in the same patch which introduces the
interfaces --- is just not a nice thing to do.  For your amusement,
I'll leave you with:

Rusty Rusell's writeup, "How Do I Make This Hard to Misuse":

   https://ozlabs.org/~rusty/index.cgi/tech/2008-03-30.html

And the flip side, his "What If I Don't Actually Like My Users?"

   https://ozlabs.org/~rusty/index.cgi/tech/2008-04-01.html

						- Ted
