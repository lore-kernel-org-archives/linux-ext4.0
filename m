From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] jbd2: fold __wait_cp_io into jbd2_log_do_checkpoint()
Date: Tue, 2 Sep 2014 13:00:01 -0400
Message-ID: <20140902170001.GI6232@thunk.org>
References: <1409624051-6902-1-git-send-email-tytso@mit.edu>
 <1409624051-6902-2-git-send-email-tytso@mit.edu>
 <20140902163033.GC19412@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33018 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaIBRAF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Sep 2014 13:00:05 -0400
Content-Disposition: inline
In-Reply-To: <20140902163033.GC19412@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 02, 2014 at 06:30:33PM +0200, Jan Kara wrote:
>   Hum, is this really such a win? Unlike __process_buffer(), this function
> is well separated so IMHO the code is better readable before the folding.

I agree it's a closer call.  I'm not wedded to folding in
__wait_cp_io.  I was reacting more to the fact that the comment right
before the call to __wait_cp_io was horribly misleading, and when I
looked to confirm what I thought __wait_cp_io() was doing, it looked
like another static function used in exactly one place that could be
folded in.

If other folks think that it's more readable w/o this patch, I'm happy
to drop it.  Anyone else have an opinion?

Cheers,

					- Ted
