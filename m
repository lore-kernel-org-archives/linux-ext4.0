From: Theodore Ts'o <tytso@mit.edu>
Subject: xfstests ext4/304 failing due to donor inode's i_size == 0
Date: Sun, 18 Oct 2015 22:57:27 -0400
Message-ID: <20151019025727.GA6676@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58140 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbbJSC5a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Oct 2015 22:57:30 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dmitry,

I was investigating why ext4/304 is failing, and it's due to
defrag-fuzzer returning an error:

defrag-fuzzer: (groupid=0, jobs=1): err=22 (file:ioengines.c:309, func=td_io_que
ue, error=Invalid argument): pid=3207: Sun Oct 18 19:43:57 2015

After instrumenting the kernel, it appears that this is due to donor
inode's i_size being set to 0.

Can you reproduce this faiure?  And if it's working for you, what
version of fio are you using?  I normally use fio 2.1.3, since newer
versions of fio have caused test regressions that appear to be caused
by fio bugs.  I tried fio 2.1.14, it was also failing.  I could try
using 2.2.x versions of fio, but as I recall, that set of versions was
were I started running into other test failures caused by fio bugs.
(When I asked Dave Chinner about this a while back, he tod me he was
using 2.1.3 because he had run into regressions caused by vio, and
I've been sticking with fio 2.1.3 for quite a while now.)

Thanks,

						- Ted

