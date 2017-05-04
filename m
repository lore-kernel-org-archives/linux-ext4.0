From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext4: no need to cond_resched() in
 ext4_trim_all_free()
Date: Thu, 4 May 2017 13:19:16 +0200
Message-ID: <20170504111916.2y4ali7kk6twij5n@localhost.localdomain>
References: <1493282200-32257-1-git-send-email-lczerner@redhat.com>
 <20170430042605.v3myihn2x4lolmso@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752496AbdEDLTU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 4 May 2017 07:19:20 -0400
Content-Disposition: inline
In-Reply-To: <20170430042605.v3myihn2x4lolmso@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 30, 2017 at 12:26:05AM -0400, Theodore Ts'o wrote:
> On Thu, Apr 27, 2017 at 10:36:40AM +0200, Lukas Czerner wrote:
> > There is no need to call cond_resched() in ext4_trim_all_free() since
> > blkdev_issue_discard() already takes care of that. So just remove it.
> 
> Actually, it could be needed.  If minblocks is a small value, say 2,
> and every other block in file system is allocated, then we could be in
> the while loop for a long time.  That's a pretty unusual case, but
> it's good to have the need_resched() check there.
> 
> 						- Ted

Fair enough, it's unusuall case, but still possible. Let's keep it this
way.

Thanks!
-Lukas
