From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3/jbd: Avoid WARN() messages when failing to write to the superblock
Date: Sun, 21 Sep 2008 19:33:28 +0200
Message-ID: <20080921173328.GB23547@atrey.karlin.mff.cuni.cz>
References: <1221946547-9873-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51696 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYIURd3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Sep 2008 13:33:29 -0400
Content-Disposition: inline
In-Reply-To: <1221946547-9873-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> This fixes some very common warnings reported by kerneloops.org
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
  The patch looks nice but does it really fix the warnings? I see
at least ext3_put_super() calling mark_buffer_dirty() before calling
ext3_commit_super(). We should just remove that mark_buffer_dirty()
call.
  BTW: Do you plan doing a similar fix for ext2 and ext4?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
