From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3 v2] ext4: Inode flags handling
Date: Wed, 23 Nov 2016 10:36:57 +0100
Message-ID: <20161123093657.GA4177@quack2.suse.cz>
References: <1475751874-32114-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933152AbcKWJzi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Nov 2016 04:55:38 -0500
Content-Disposition: inline
In-Reply-To: <1475751874-32114-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 06-10-16 13:04:31, Jan Kara wrote:
> Hello,
> 
> so these three patches implement what I had in mind when discussing ext4
> inode flags handling. What do you guys think? I've verified chattr(1)
> keeps working as expected, xfstests run has passed.
> 
> Changes since v1:
> * fixed handling of EXTENTS and JOURNAL_DATA flags

Ping? Any opinion on these patches?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
