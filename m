From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] jbd2: jbd2_log_wait_for_space improve error detetcion
Date: Tue, 16 Sep 2014 14:51:30 -0400
Message-ID: <20140916185130.GL6205@thunk.org>
References: <1410698337-27454-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60351 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbaIPSve (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Sep 2014 14:51:34 -0400
Content-Disposition: inline
In-Reply-To: <1410698337-27454-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 14, 2014 at 04:38:56PM +0400, Dmitry Monakhov wrote:
> If EIO happen after we have drop j_state_lock so it is reasonable to move this check under
> i_sate_lock critical section. This patch helps to  prevent false positive complain after EIO

Thanks, applied.  I adjusted the commit description slightly:

    If EIO happens after we have dropped j_state_lock, we won't notice
    that the journal has been aborted.  So it is reasonable to move this
    check after we have grabbed the j_checkpoint_mutex and re-grabbed the
    j_state_lock.  This patch helps to prevent false positive complain
    after EIO.

Cheers,

					- Ted

P.S.  Welcome back!  Glad to see you are safe.
