From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Enable quotas before orphan cleanup
Date: Sat, 2 Mar 2013 18:04:18 -0500
Message-ID: <20130302230418.GG22941@thunk.org>
References: <1361835369-19850-1-git-send-email-jack@suse.cz>
 <1361835369-19850-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50969 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab3CBXEU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Mar 2013 18:04:20 -0500
Content-Disposition: inline
In-Reply-To: <1361835369-19850-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 26, 2013 at 12:36:09AM +0100, Jan Kara wrote:
> When using quota feature we need to enable quotas before orphan cleanup
> so that changes happening during it are properly reflected in quota
> accounting.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
