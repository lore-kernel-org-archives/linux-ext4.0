From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: Avoid crashes / infinite loops for absurdly
 large devices
Date: Tue, 25 Oct 2016 14:09:47 -0400
Message-ID: <20161025180947.7oqbnhonzzpm5qob@thunk.org>
References: <1477397504-5663-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42132 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755059AbcJYSJv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Oct 2016 14:09:51 -0400
Content-Disposition: inline
In-Reply-To: <1477397504-5663-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 25, 2016 at 02:11:44PM +0200, Jan Kara wrote:
> When a device reports absurdly high size, some arithmetics in mke2fs can
> overflow (e.g. number of block descriptors) and we end in an infinite
> loop. Fix that by checking and refusing insanely large devices.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
