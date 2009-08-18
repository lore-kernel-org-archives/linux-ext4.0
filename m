From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: Fix possible deadlock between
	ext4_truncate() and ext4_get_blocks()
Date: Mon, 17 Aug 2009 22:17:00 -0400
Message-ID: <20090818021700.GF498@mit.edu>
References: <1250252772-13302-1-git-send-email-jack@suse.cz> <1250252772-13302-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43593 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbZHRCRC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Aug 2009 22:17:02 -0400
Content-Disposition: inline
In-Reply-To: <1250252772-13302-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Added to the ext4 patch queue, thanks!!

I did fix the comments a little:

> Thig bug has been found and analyzed by Ted Tytso <tytso@mit.edu>.

The last name is "Ts'o".  :-)

					- Ted
