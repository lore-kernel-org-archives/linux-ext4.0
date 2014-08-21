From: Theodore Ts'o <tytso@mit.edu>
Subject: Potential bug in fs/ext4/inline.c?
Date: Thu, 21 Aug 2014 18:01:26 -0400
Message-ID: <20140821220126.GA3597@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: gnehzuil.liu@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43607 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbaHUWB1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Aug 2014 18:01:27 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_find_inline_entry(), there is the following:

	if (ext4_get_inline_size(dir) == EXT4_MIN_INLINE_DATA_SIZE)
		goto out;

Am I missing something, or shouldn't this be:

	if (ext4_get_inline_size(dir) <= EXT4_MIN_INLINE_DATA_SIZE)
		goto out;

?

Thanks,

						- Ted




