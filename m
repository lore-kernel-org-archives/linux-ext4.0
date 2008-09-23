From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: jbd2-abort-instead-of-waiting-for-nonexistent-transactions.patch
Date: Tue, 23 Sep 2008 17:56:27 +0100
Message-ID: <e9e943910809230956n3f36e544hc46a80c00ff9804a@mail.gmail.com>
References: <20080922140851.bc3f9319.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"Stephen C. Tweedie" <sct@redhat.com>, linux-ext4@vger.kernel.org
To: "Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.185]:9751 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbYIWQ4a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Sep 2008 12:56:30 -0400
Received: by gv-out-0910.google.com with SMTP id e6so162746gvc.37
        for <linux-ext4@vger.kernel.org>; Tue, 23 Sep 2008 09:56:28 -0700 (PDT)
In-Reply-To: <20080922140851.bc3f9319.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/9/22 Andrew Morton <akpm@linux-foundation.org>:
> Guys, I have a note here that this might be needed in 2.6.27.
>
> I also have a note that Stephen had issues with it, but I
> don't recall what they were.

Stephen suggested that it would be better to sanity check the journal
start/end pointers on mount, rather than catching the error later like
this. I never quite convinced myself I'd worked out the right way to
do that, sorry. Perhaps someone would like to confirm (or otherwise)
whether or not the following is correct:

In journal_reset (?) check that:

journal->j_first == 1 (this seems to be the only valid value)

and

journal->j_last >= JFS_MIN_JOURNAL_BLOCKS

Additionally, it should be possible to check the journal->j_last more
precisely. For internal journals it seems straight-forward, we can
just check that journal->j_last == inode->i_size >>
inode->i_sb->s_blocksize_bits. For external journals we'd need to load
the device's superblock and check journal->j_last == s_blocks_count.

> Can we get this sorted out please?

If the above is confirmed I'll send a patch to that effect for jdb,
jdb2 and for e2fsprogs (fsck doesn't check j_first/j_last either).

Regardless, I think the original patch may be a good idea. It improves
robustness and matches the other locations where we call
jbd2_log_do_checkpoint. They are all in loops that test that
journal->j_checkpoint_transactions != NULL.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
