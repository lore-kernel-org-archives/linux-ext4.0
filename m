Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32914 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbeLCFSL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 3 Dec 2018 00:18:11 -0500
Date: Mon, 3 Dec 2018 00:18:06 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs v4 0/9] Support encoding awareness and casefold
Message-ID: <20181203051806.GA6639@thunk.org>
References: <20181201003910.18982-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181201003910.18982-1-krisman@collabora.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Gabriel,

Thanks for all of your work on it so far.  There's still some work
that we need to do, but I think this is good enough for merge what we
have, so I've pulled this into the e2fsprogs master and next branches.
There were a few commit description adjustments, and in one place I
replaced a call to calloc() with a fixed-size buffer to just using a
on-stack buffer.

The main thing I noticed is that nothing is initializing fs->encoding.
We need to do that in ext2fs_open() and ext2fs_initialize().  We also
need to add some test cases --- if we did, we would have noticed the
missing initialization of fs->encoding.

I do want to include of the script which generates utf8data.h in
e2fsprogs sources; we'll need to it in sync with the kernel sources,
and so long as it stays in sync, we can always double check that
version of utf8data.h in e2fsprogs matches the version the one in the
kernel.  But for reasons of GPL compliance, we should keep a copy of
the script which creates the generated .h file.

Again, thanks for the work so far!

					- Ted
