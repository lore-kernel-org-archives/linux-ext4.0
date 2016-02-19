From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: revert i_data_sum locking cleanups for
 dioread_nolock
Date: Fri, 19 Feb 2016 00:30:47 -0500
Message-ID: <20160219053047.GD12743@thunk.org>
References: <20160212182506.GB1592@localhost.localdomain>
 <20160216050840.GA3426@thunk.org>
 <20160218220956.GA24219@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54842 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629AbcBSFat (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Feb 2016 00:30:49 -0500
Content-Disposition: inline
In-Reply-To: <20160218220956.GA24219@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 18, 2016 at 11:09:56PM +0100, Jan Kara wrote:
> OK, I had a look into this. So I'm not 100% what has happened but the
> following looks likely: Current io_end handling can overwrite io_end
> pointer in the inode in dioread_nolock mode (nothing prevents unlocked DIO
> to overwrite pointer of locked DIO and then clear it out). I suspect that
> the change in i_data_sem locking made this race more visible. Attached
> patch should fix the issue (I don't see failures of generic/300 with it in
> dioread_nolock mode). Can you consider this instead of a revert Eric sent?

Thanks!  That does appear to be it. I dropped the revert, confirmed
that I could still trivially reproduce the failure, applied patch,
and ran the test 10 times ("kvm-xfstests -C 10 -c dioread_nolock
generic/300") and it passed with flying colors.

> I have also a more complete rewrite of io_end handling which makes the code
> more comprehensible and avoids storing io_end pointer in the inode (thus
> avoids similar pitfalls in future) but that is a 4.6 matter. I'll submit
> the rewrite once xfstests runs complete.

Great, thanks!

					- Ted
