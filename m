From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] Fix buffer dirtying in data=journal mode
Date: Mon, 12 Jul 2010 19:38:09 +0200
Message-ID: <20100712173809.GA12804@atrey.karlin.mff.cuni.cz>
References: <1277116973-4183-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45488 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753025Ab0GLRiL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jul 2010 13:38:11 -0400
Content-Disposition: inline
In-Reply-To: <1277116973-4183-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

>   two patches below fix warnings and possible BUGs in ext3/ext4 when running
> in data=journal mode (see https://bugzilla.kernel.org/show_bug.cgi?id=14156).
> Admittedly, the workaround I've chosen is kind of ugly but reimplementing
> block_prepare_write() just for the data=journal mode seems even uglier to me.
> If anybody has better solution, I'd gladly hear it.
  Ted, could you have a look at the ext4 patch and merge it if you're fine
with it? Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
