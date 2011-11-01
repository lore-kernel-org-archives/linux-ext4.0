From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] jbd/jbd2: validate sb->s_first in
 journal_get_superblock()
Date: Tue, 1 Nov 2011 19:06:42 -0400
Message-ID: <20111101230642.GK32161@thunk.org>
References: <1320113103-27406-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44576 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab1KAXGn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 19:06:43 -0400
Content-Disposition: inline
In-Reply-To: <1320113103-27406-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 01, 2011 at 10:05:03AM +0800, Eryu Guan wrote:
> I hit a J_ASSERT(blocknr != 0) failure in cleanup_journal_tail() when
> mounting a fsfuzzed ext3 image. It turns out that the corrupted ext3
> image has s_first = 0 in journal superblock, and the 0 is passed to
> journal->j_head in journal_reset(), then to blocknr in
> cleanup_journal_tail(), in the end the J_ASSERT failed.
> 
> So validate s_first after reading journal superblock from disk in
> journal_get_superblock() to ensure s_first is valid.
>
> ...
> 
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Thanks, applied.  (I took the jbd fixup as well, since it's obvious)

					- Ted
