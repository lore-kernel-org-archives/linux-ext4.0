From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Date: Wed, 31 Jul 2013 18:01:54 -0400
Message-ID: <20130731220154.GA11378@thunk.org>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org,
	hch@infradead.org, david@fromorbit.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37593 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab3GaWC5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Jul 2013 18:02:57 -0400
Content-Disposition: inline
In-Reply-To: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Have you considered what happens if you have a 10 megabyte file, of
which the first 5 megs are mmap'ed into a userspace process.

Now suppose you call COLLAPASE_RANGE on a one megabyte range starting
at offset 1024k from the beginning of the file.

Does the right thing happen to the mmap'ed region in memory?

Cheers,

					- Ted
