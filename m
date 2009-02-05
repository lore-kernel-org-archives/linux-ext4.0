From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 0/3] Fix possible NULL pointer dereference in JBD2
Date: Thu, 5 Feb 2009 11:32:17 -0800
Message-ID: <20090205193217.GZ17410@wotan.suse.de>
References: <1233845582-954-1-git-send-email-jack@suse.cz>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923AbZBETcT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:19 -0500
Content-Disposition: inline
In-Reply-To: <1233845582-954-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 05, 2009 at 03:52:59PM +0100, Jan Kara wrote:
> 
>   Hi,
> 
>   the three patches below fix a bug in jbd2_journal_begin_ordered_truncate() that
> could possibly lead to NULL pointer dereference. The question is how to merge
> the fix as it changes the prototype of the function and both ext4 and ocfs2 use it.
> Mark, Mingming, any suggestions?

This seems like it'd be easiest for Andrew to carry. The Ocfs2 patch is
unlikely to conflict with anything in my tree.

Btw, you can add:

Acked-by: Mark Fasheh <mfasheh@suse.com>

to the Ocfs2 patch.
	--Mark

--
Mark Fasheh
