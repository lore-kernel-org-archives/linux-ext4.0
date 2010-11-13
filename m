From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Strange bug
Date: Sat, 13 Nov 2010 17:42:36 -0500
Message-ID: <20101113224236.GA18658@thunk.org>
References: <loom.20101113T101254-909@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mariusz Bialonczyk <manio@skyboo.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37016 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab0KMWmo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Nov 2010 17:42:44 -0500
Content-Disposition: inline
In-Reply-To: <loom.20101113T101254-909@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 13, 2010 at 09:18:39AM +0000, Mariusz Bialonczyk wrote:
> Hello
> I'd like to share the bug report which i had on yesterday's git kernel.

I'm pretty sure it's not "yesterday's" git kernel.  At least, not as
far as Linus's git tree is concerned.  The "57" in your version number
in your dmesg:

	2.6.37-rc1-00057-gc3e1500-dirty

... is too small for Linus's git tree as of Friday, November 12th.

I wasn't able to track down the git commit ID: c3e1500 so I'm guessing
there are some commits from some other git tree involved.

However, looking at the BUG_ON which you reported:

> Nov 12 23:19:34 draco kernel: [  997.220452] kernel BUG at fs/ext4/page-io.c:146!

I'm pretty sure it's a bug which is fixed as of v2.6.37-rc1-git6,
specifically by commit id: f7ad6d2e9 (ext4: handle writeback of inodes
which are being freed).

Best regards,

					- Ted
