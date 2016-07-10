From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [4.7-rc4] WARNING: CPU: 10 PID: 3359 at fs/inode.c:280
 drop_nlink+0x3e/0x50
Date: Sun, 10 Jul 2016 11:25:15 -0400
Message-ID: <20160710152515.GH26097@thunk.org>
References: <20160704234633.GE27480@dastard>
 <20160705044524.GE15193@thunk.org>
 <20160710001416.GA1922@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54054 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170AbcGJPZY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jul 2016 11:25:24 -0400
Content-Disposition: inline
In-Reply-To: <20160710001416.GA1922@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry if I offended your sense of non-newbieness :-), but I didn't
know how your root file system and qemu was configured, and I did find
a potential place where a corrupted file system could lead to exact
symptoms that you reported.  Hence the reason that I made the
assumption that I did.

Cheers,

					- Ted
