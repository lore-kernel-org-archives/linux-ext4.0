From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix deadlock with quota feature
Date: Tue, 9 Apr 2013 09:20:19 -0400
Message-ID: <20130409132019.GB12050@thunk.org>
References: <1365156382-16703-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60607 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760383Ab3DINUY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 09:20:24 -0400
Content-Disposition: inline
In-Reply-To: <1365156382-16703-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 05, 2013 at 12:06:22PM +0200, Jan Kara wrote:
> We didn't mark hidden quota files with S_NOQUOTA flag and thus quota was
> accounted even for quota files. Thus we could recurse back to quota code
> when adding new blocks to quota file which can easily deadlock. Mark
> hidden quota files properly.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
