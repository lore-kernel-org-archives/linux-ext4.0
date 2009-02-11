From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 3/3] ocfs2: Add journal parameter to jbd2_journal_begin_ordered_truncate()
Date: Wed, 11 Feb 2009 13:01:28 -0800
Message-ID: <20090211210128.GD17410@wotan.suse.de>
References: <1233845582-954-1-git-send-email-jack@suse.cz> <1233845582-954-2-git-send-email-jack@suse.cz> <1233845582-954-3-git-send-email-jack@suse.cz> <1233845582-954-4-git-send-email-jack@suse.cz> <20090210151255.GE30689@mini-me.lan>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@oss.oracle.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:54917 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbZBKVBa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 16:01:30 -0500
Content-Disposition: inline
In-Reply-To: <20090210151255.GE30689@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 10, 2009 at 10:12:55AM -0500, Theodore Tso wrote:
> The problem with separating out the patch into three separate commits
> is that it can potentially break a "git bisect".  To fix this, I
> believe the right thing to do is to combine the three patches into a
> single commit, and to push this via the ext4 tree; any objections?

That's fine with me. Btw, you forgot my:

Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
