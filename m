From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/29] jbd2: Reduce journal_head size
Date: Fri, 12 Apr 2013 00:04:39 -0400
Message-ID: <20130412040439.GE4865@thunk.org>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33718 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3DLEEn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Apr 2013 00:04:43 -0400
Content-Disposition: inline
In-Reply-To: <1365456754-29373-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:09PM +0200, Jan Kara wrote:
> Remove unused t_cow_tid field (ext4 copy-on-write support doesn't seem
> to be happening) and change b_modified and b_jlist to bitfields thus
> saving 8 bytes in the structure.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied for testing in the ext4 dev branch.

						- Ted
