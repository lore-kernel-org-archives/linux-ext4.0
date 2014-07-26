From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: fix 32bit overflow during minimal size
 calculation for 64bit fs.
Date: Sat, 26 Jul 2014 17:53:41 -0400
Message-ID: <20140726215341.GU6725@thunk.org>
References: <1406359167-13610-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lists2009@fnarfbargle.com
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58815 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbaGZVxt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 17:53:49 -0400
Content-Disposition: inline
In-Reply-To: <1406359167-13610-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 11:19:27AM +0400, Azat Khuzhin wrote:
> calculate_minimum_resize_size() multiplying two 32bit numbers, however the
> result must be 64bit, but it will be truncated to 32bit, and because of this
> data_blocks will be zero, and it will never leave loop...

There is a much more general patch which solves a number of other
instances where this bug exists which I've already committed into my
tree:

https://git.kernel.org/cgit/fs/ext2/e2fsprogs.git/commit/?h=maint&id=1e33a8b408123a4e02a6b9135807f6fd61f3e235

Cheers,

					- Ted
