From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] ext2: Update also inode on disk when dir is IS_DIRSYNC
Date: Tue, 13 Jan 2009 14:08:07 +0100
Message-ID: <20090113130807.GC30352@atrey.karlin.mff.cuni.cz>
References: <1231850522-11074-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39472 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbZAMNII (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jan 2009 08:08:08 -0500
Content-Disposition: inline
In-Reply-To: <1231850522-11074-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> We used to just write changed page for IS_DIRSYNC inodes. But we also have to
> update directory inode itself just for the case that we've allocated a new
> block and changed i_size.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> CC: Pavel Machek <pavel@suse.cz>

Tested, and I can't break ext2 in simple tests now.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
