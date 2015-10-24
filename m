From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Question about ext4 journal
Date: Sat, 24 Oct 2015 07:23:33 -0400
Message-ID: <20151024112333.GA27558@thunk.org>
References: <CALLJCT3fAapW4aCSNPekeB8wx6XOU4O_PKfvQ7VhY-t8hrPBnA@mail.gmail.com>
 <CAOQ4uxhFw5HCyVuYsKROKvMHJWBCEqZfBM8gtcV1bPQGFXT-hQ@mail.gmail.com>
 <CAOQ4uxh79509HYo=4N27FamLanh0sV9PqeQWWTk3HK526iTdHA@mail.gmail.com>
 <CALLJCT2T9t9Qsn+6CPCJqd9HLTHn1ZHdOOM74+8X-LHvPuhqaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>,
	Ext4 <linux-ext4@vger.kernel.org>
To: Masanari Iida <standby24x7@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41895 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbbJXLXj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Oct 2015 07:23:39 -0400
Content-Disposition: inline
In-Reply-To: <CALLJCT2T9t9Qsn+6CPCJqd9HLTHn1ZHdOOM74+8X-LHvPuhqaw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 24, 2015 at 12:10:48PM +0900, Masanari Iida wrote:
> 
> My wild guess is
> file was created in inode #100 (for example),
> it was deleted and inode #100 moved to orphan list.
> The inode #100 was re-used in step 3.

The inode is removed from the orphan list as soon as the inode is
released.  The only time an inode remains on the orphan list is if
some other process had an open file descriptor on the file before it
was unlinked.  But in that case, when you recreate the file with the
same name, you will get a new inode, because the old inode has not yet
been released.  Once it has been released, it is removed from the orphan list.

> snapshot taken.

If the storage device is not synchronized with the file system then
there is no guarantee that the snapshot will be consistent.  But given
that you said you waited for hours before taking the snapshot, and it
seems likely that isn't the problem.

> Did we have such trouble during 2.6.32 time?

I don't recall anything like that.  But if you are still using 2.6.32,
then presumably you are on some enterprise distro.  I suggest you open
a support call with your enterprise distro provider, and/or with your
storage device (since I assume you're using some kind of storage array
that has a proprietary device driver).

Cheers,

					- Ted
