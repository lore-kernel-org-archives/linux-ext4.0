From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [1/1] handle e2image offset value better
Date: Sat, 11 Jan 2014 13:43:43 -0500
Message-ID: <20140111184343.GA20583@thunk.org>
References: <CAGW2f1ES7Gji4hXEeMzCSdH3VabXU7SeD-4cg4GL6K9ArugwHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47554 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbaAKSnw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jan 2014 13:43:52 -0500
Content-Disposition: inline
In-Reply-To: <CAGW2f1ES7Gji4hXEeMzCSdH3VabXU7SeD-4cg4GL6K9ArugwHw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 05, 2014 at 04:42:42AM +0000, jon ernst wrote:
> current e2image cannot handle offset value as 0.
> 
> For example,
> e2image -aro   0 /dev/sda7 ~/e2image7
> will return usage()
> but
> e2image -aro   1 /dev/sda7 ~/e2image7
> is fine.

I'm not seeing a problem;

    cp /dev/null /tmp/foo.img
    mke2fs -t ext4 -F /tmp/foo.img 100
    e2image -aro 0 /tmp/foo.img /tmp/bar.img

Is working just fine for me.

Looking at your patch, I don't think it's correct.  We only want to go
into "move mode" when the user has specified a single argument, and
either the source or destination is non-zero, and of course this
really only makes sense when we are in raw mode.

That's what the code is currently doing.  If I were going to make any
changes, I'd probably change the criteria so that we check to see if
the source and destination offset is identical (since then it's just a
no-op), and we should probably enforce the restriction that we only
allow move mode when the user has specified both the -a and the -r
option.  (Otherwise, they will destroy the data on their file system,
which is probably not the result they were looking for.)

Regards,

						- Ted
