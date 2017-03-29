From: Jan Kara <jack@suse.cz>
Subject: Re: Question about dirty data for unlinked files
Date: Wed, 29 Mar 2017 13:23:46 +0200
Message-ID: <20170329112346.GB18467@quack2.suse.cz>
References: <CAGDaZ_qFMGuNMGzvOyStmtC9ZcCH3knHrhaOiP8HvmaphcWvVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Raymond Jennings <shentino@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37079 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755996AbdC2LXt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 29 Mar 2017 07:23:49 -0400
Content-Disposition: inline
In-Reply-To: <CAGDaZ_qFMGuNMGzvOyStmtC9ZcCH3knHrhaOiP8HvmaphcWvVw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 23-03-17 13:07:23, Raymond Jennings wrote:
> If you delete a file (and don't have it open), and there's a bunch of
> dirty data for that file still in page cache, does all that dirty data
> disappear or does it still get written back?

The dirty data just gets discarded when the inode is deleted. In fact if
the file fits in memory (and in dirty_limit), none of the data need to make
it to disk.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
