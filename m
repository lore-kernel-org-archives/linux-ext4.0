From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: use correct depth value
Date: Sun, 27 Jul 2014 22:31:09 -0400
Message-ID: <20140728023109.GJ6725@thunk.org>
References: <1405955089-12777-1-git-send-email-dmonakhov@openvz.org>
 <1405955089-12777-2-git-send-email-dmonakhov@openvz.org>
 <20140721194837.GB19942@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59749 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaG1CbM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2014 22:31:12 -0400
Content-Disposition: inline
In-Reply-To: <20140721194837.GB19942@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 21, 2014 at 09:48:37PM +0200, Jan Kara wrote:
> On Mon 21-07-14 19:04:48, Dmitry Monakhov wrote:
> > Inode's depth can be changed from here:
> > ext4_ext_try_to_merge() ->ext4_ext_try_to_merge_up()
> > We must use correct value.
>   Looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
