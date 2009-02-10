From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix to read empty directory blocks correctly in
	64k blocksize filesystems
Date: Tue, 10 Feb 2009 10:20:49 -0500
Message-ID: <20090210152049.GF30689@mini-me.lan>
References: <4990FAE4.1080009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Wei Yongjun <yjwei@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60539 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbZBJSVc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2009 13:21:32 -0500
Content-Disposition: inline
In-Reply-To: <4990FAE4.1080009@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a good patch, but the patch description doesn't tell the
complete tale.  I've replaced it with the following.

	 	     	      	      	  - Ted

ext4: Fix to read empty directory blocks correctly in 64k

From: Wei Yongjun <yjwei@cn.fujitsu.com>

The rec_len field in the directory entry is 16 bits, so there was a
problem representing rec_len for filesystems with a 64k block size in
the case where the directory entry takes the entire 64k block.
Unfortunately, there were two schemes that were proposed; one where
all zeros meant 65536 and one where all ones (65535) meant 65536.
E2fsprogs used 0, whereas the kernel used 65535.  Oops.  Fortunately
this case happens extremely rarely, with the most common case being
the lost+found directory, created by mke2fs.

So we will be liberal in what we accept, and accept both encodings,
but we will continue to encode 65536 as 65535.  This will require a
change in e2fsprogs, but with fortunately ext4 filesystems normally
have the dir_index feature enabled, which precludes having a
completely empty directory block.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

