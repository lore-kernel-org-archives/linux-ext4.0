From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: f.s. corruption ext3, kernel 4.4.8
Date: Sun, 24 Apr 2016 22:14:13 -0400
Message-ID: <20160425021413.GM20980@thunk.org>
References: <CABWT5yh98_f5=Y0k7_ELHM=fn35s0Eb5D5kmDCSsFMikgmscnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Barry Kauler <bkauler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34484 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbcDYCOP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Apr 2016 22:14:15 -0400
Content-Disposition: inline
In-Reply-To: <CABWT5yh98_f5=Y0k7_ELHM=fn35s0Eb5D5kmDCSsFMikgmscnQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 25, 2016 at 09:46:19AM +0800, Barry Kauler wrote:
> I sent this direct to Greg KH yesterday morning. 24 hours later got an
> automated reply to send my email to one of the lists.
> 
> I'm a user, not a kernel developer, gotta post this somewhere.
> 
> I reckon this is urgent.
> I have rolled back from 4.4.8 to 4.4.7, have used heavily for 24 hours
> since then,
> no problem. So, it's the kernel, not my laptop.

No one else has reported any problems to date, and there are only two
changes in ext4 code between v4.4.7 and v4.4.8, neither of which seem
at all likely to cause file system corruption.

ee8516a ext4: ignore quota mount options if the quota feature is enabled
321299a ext4: add lockdep annotations for i_data_sem

If you can send us the "EXT4-fs error" message that would have been
logged before the file system went read-only, or the output from
e2fsck, that might be helpful in matching up your report from any
others, or to have some insight into what might have happened.

Unfortunately, without any more information there's not much we can do
with your report other than to keep an ear out in case anyone else
complains.

Thanks,

					- Ted
