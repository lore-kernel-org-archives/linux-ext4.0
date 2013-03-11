From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: Reserve metadata if writing into uninitialized
Date: Sun, 10 Mar 2013 22:49:03 -0400
Message-ID: <20130311024903.GI10090@thunk.org>
References: <1362731059-3508-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52373 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab3CKCtG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Mar 2013 22:49:06 -0400
Content-Disposition: inline
In-Reply-To: <1362731059-3508-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 08, 2013 at 09:24:17AM +0100, Lukas Czerner wrote:
> Currently in delalloc write we do not reserve any space if we're
> writing into the uninitialized extent. This is ok for data, because
> the space has already been allocated so we do not have to do data
> reservation, however we have to reserve metadata for uninitialized
> extent conversion on writeback.
> 
> Add new ext4_da_reserve_metadata() function to only reserve metadata
> blocks for delayed allocation an use it if we're writing delayed blocks
> into unwritten extent to reserve metadata for extent conversion.
> 
> The problem can be reproduced with xfstest 083 on bigalloc file system.
> With this patch I can not reproduce the problem anymore.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
