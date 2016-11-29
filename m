From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: Add EXT4_JOURNAL_DATA_FL and EXT4_EXTENTS_FL
 to modifiable mask
Date: Tue, 29 Nov 2016 11:16:50 -0500
Message-ID: <20161129161650.3ytp3e7ouv6urjcs@thunk.org>
References: <1475751874-32114-1-git-send-email-jack@suse.cz>
 <1475751874-32114-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56400 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755355AbcK2QQ5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Nov 2016 11:16:57 -0500
Content-Disposition: inline
In-Reply-To: <1475751874-32114-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 06, 2016 at 01:04:32PM +0200, Jan Kara wrote:
> Add EXT4_JOURNAL_DATA_FL and EXT4_EXTENTS_FL to EXT4_FL_USER_MODIFIABLE
> to recognize that they are modifiable by userspace. So far we got away
> without having them there because ext4_ioctl_setflags() treats them in a
> special way. But it was really confusing like that.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
