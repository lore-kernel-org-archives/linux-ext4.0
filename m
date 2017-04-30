From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: no need to cond_resched() in
 ext4_trim_all_free()
Date: Sun, 30 Apr 2017 00:26:05 -0400
Message-ID: <20170430042605.v3myihn2x4lolmso@thunk.org>
References: <1493282200-32257-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33602 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755188AbdD3E0H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Apr 2017 00:26:07 -0400
Content-Disposition: inline
In-Reply-To: <1493282200-32257-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 27, 2017 at 10:36:40AM +0200, Lukas Czerner wrote:
> There is no need to call cond_resched() in ext4_trim_all_free() since
> blkdev_issue_discard() already takes care of that. So just remove it.

Actually, it could be needed.  If minblocks is a small value, say 2,
and every other block in file system is allocated, then we could be in
the while loop for a long time.  That's a pretty unusual case, but
it's good to have the need_resched() check there.

						- Ted
