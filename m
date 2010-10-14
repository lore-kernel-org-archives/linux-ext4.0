From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: Fix debug message in do_get_write_access()
Date: Thu, 14 Oct 2010 12:23:26 +0200
Message-ID: <20101014102326.GC3482@quack.suse.cz>
References: <1286979247-7721-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Jiri Kosina <trivial@kernel.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44454 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab0JNKYZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Oct 2010 06:24:25 -0400
Content-Disposition: inline
In-Reply-To: <1286979247-7721-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 13-10-10 23:14:07, Namhyung Kim wrote:
> 'buffer_head' should be 'journal_head'.
  Thanks. Merged.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
