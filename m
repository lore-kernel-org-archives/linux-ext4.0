From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix oops in jbd2_journal_put_journal_head()
Date: Mon, 13 May 2013 09:49:28 -0400
Message-ID: <20130513134928.GD4845@thunk.org>
References: <1368451916-16785-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, eunb.song@samsung.com,
	linux-ext4@vger.kernel.org, Tony Luck <tony.luck@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48025 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab3EMNtf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 09:49:35 -0400
Content-Disposition: inline
In-Reply-To: <1368451916-16785-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, applied.  BTW, I've changed the subject line to be "jbd,jbd2",
since the change was to a common journal-head.h file, and although
this problem was identified with ext4, it would apply to ext3 users as
well.

I also added Tony Luck to the reported by line since he also helped to
identify and bisect the problem.  Thanks to Tony and Eunbong for
reporting and then identifying the suspect commit!

						- Ted
