From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: add i_data_sem sanity check
Date: Sun, 27 Jul 2014 22:29:20 -0400
Message-ID: <20140728022920.GI6725@thunk.org>
References: <1405955089-12777-1-git-send-email-dmonakhov@openvz.org>
 <20140721193510.GA19942@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59742 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaG1C30 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2014 22:29:26 -0400
Content-Disposition: inline
In-Reply-To: <20140721193510.GA19942@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 21, 2014 at 09:35:10PM +0200, Jan Kara wrote:
> On Mon 21-07-14 19:04:47, Dmitry Monakhov wrote:
> > Each caller of ext4_ext_dirty must hold i_data_sem,
> > The only exception is migration code, let's make it convenient.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>   Looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
