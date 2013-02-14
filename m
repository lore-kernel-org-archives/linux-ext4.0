From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: REGRESSION: [PATCH 04/12] ext4: Disable merging of uninitialized
 extents
Date: Thu, 14 Feb 2013 14:05:55 -0500
Message-ID: <20130214190555.GA6641@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-5-git-send-email-jack@suse.cz>
 <20130209171015.GC8091@thunk.org>
 <20130214161116.GB31269@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48305 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758544Ab3BNTGZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2013 14:06:25 -0500
Content-Disposition: inline
In-Reply-To: <20130214161116.GB31269@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 14, 2013 at 05:11:16PM +0100, Jan Kara wrote:
>   OK, so I've debugged this. It wasn't actually that hard. The problem is
> that mpage_da_map_and_submit() prepares extent with e.g. 256 blocks but
> later we submit a shorter bio e.g. because it cannot carry that many pages.
> So ->end_io is called only for first 128 blocks or so. I spotted this
> problem already before, just it didn't come up when Ted sent me this bug
> report.

So can we get a corruption without these patches, but it was a lot
harder to hit that case before?

						- Ted
