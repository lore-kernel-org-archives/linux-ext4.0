From: Theodore Tso <tytso@mit.edu>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Wed, 17 Jun 2009 19:46:04 -0400
Message-ID: <20090617234604.GF7867@mit.edu>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38355 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbZFQXqE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 19:46:04 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Curt,

Thanks for your analysis of the bug.  The reason for the strange logic
in ext4_set_aops() is because at the moment the code doesn't support
the combination of data=journalled && delalloc.  That's why it was
explicitly checking for ext4_should_order_data() and
ext4_should_writeback_data().

We have a check for this in ext4_fill_super(), so your patch should be
safe, since the combination of ext4_should_journal_data &&
test_opt(inode->i_sb, DELALLOC) should never happen.

As to your question of whether the nodelalloc and nojournal case
should really be ext4_journalled_aops, I suspect ext4_writeback_aops
makes more sense.  I haven't audited all of the code paths to make
sure they DTRT in the non-journalled case yet, though.

							- Ted
