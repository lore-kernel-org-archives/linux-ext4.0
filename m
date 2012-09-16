From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4_orphan_del() sleeps in non-journal mode
Date: Sat, 15 Sep 2012 21:54:30 -0400
Message-ID: <20120916015430.GA11797@thunk.org>
References: <CAOMFOmWB4yxj65N2x5+KREmiQBdPoWsTiA7EBW6ONPBOyFo11w@mail.gmail.com>
 <87zk4rwqg2.fsf@openvz.org>
 <CAOMFOmWh3CVdREk5uyPCxwFQBTopiqainfGYxC6HijieM1rEWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50859 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab2IPBym (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Sep 2012 21:54:42 -0400
Content-Disposition: inline
In-Reply-To: <CAOMFOmWh3CVdREk5uyPCxwFQBTopiqainfGYxC6HijieM1rEWA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 15, 2012 at 03:28:19PM -0700, Anatol Pomozov wrote:
> 
> But the other more general issue "ext4_orphan_del sleeps in no-journal
> mode" still applies. As Dmitry mentioned in this commit 3d287de3b828
> such sleep might degrade performance. In no-journal mode we do not
> need to manipulate with i_orphan list and no reason to take the mutex....
> 
> In this example we take handle and important thing to note here is
> that IS_ERR(handle) can be true only in journal mode when starting
> journal failed. In non-journal mode ext4_journal_start() *always*
> returns a fake handle that is non-error (see ext4_get_nojournal). So
> the example above never sleeps in ext4_orphan_del().

Instead of trying to "fix" this at all of the call sites for
ext4_orphan_del(), the better way to fix this something like this:

-	/* ext4_handle_valid() assumes a valid handle_t pointer */
-	if (handle && !ext4_handle_valid(handle))
-	   return 0;
+	sbi = EXT4_SB(inode->i_sb);
+	if (!sbi->journal)
+		return 0;

I don't consider it a high priority fir for upstream, since all of the
places where ext4_orphan_del(NULL, ..) is called are in error paths,
where performance is not critical.  However, it should fix the problem
you're working on.

As far as the the local Google patch to 2.6.34, it might be worth
looking to see if it's still worth upstreaming it in the light of
commit 4bd809dbb: "ext4: don't take the i_mutex lock when doing DIO
overwrites".  It's been a while since I've looked that the DIO fast
path changes, but if it's worth geting upstream, we should do that ---
but we _will_ need to make it workable for file systems with journals.
(Which is someting I'd really like to fix for Google kernels, since
leaving things broken for file systems with journal is a bad ju-ju ---
at the very least we should disable the fast path codepath if one of
our customers try to mount file system with a journal.)

Cheers,

						- Ted
