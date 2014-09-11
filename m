From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 00/25] e2fsprogs Summer 2014 patchbomb, part 5.2
Date: Thu, 11 Sep 2014 18:33:47 -0400
Message-ID: <20140911223347.GH17990@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52246 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaIKWdw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 18:33:52 -0400
Content-Disposition: inline
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

... and I've pushed out the next branch with all but 23-26 applied.

Darrick, can you take a look and see if everything landed as you
expect?

23-25 is a new feature (pending comments on 23, and I remember wanting
to take a much closer look at 24 and 25 from a month or two ago), and
26 is pending some comments I had vis-a-vis ext2fs_new_block() vs
ext2fs_get_block(), so if you want to send out patchbomb part 6 with
what's left of part 5, that might be appropriate.

Thanks for all of your work on e2fsprogs!

						- Ted
