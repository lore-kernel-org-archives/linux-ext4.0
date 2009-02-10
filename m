From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH: e2fsprogs: resize2fs failed when "mkfs.ext4 -O
	flex_bg"]
Date: Mon, 9 Feb 2009 20:09:17 -0500
Message-ID: <20090210010917.GA30689@mini-me.lan>
References: <4990CB6A.1020403@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Gui Xiaohua <guixh@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51677 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZBJBQR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Feb 2009 20:16:17 -0500
Content-Disposition: inline
In-Reply-To: <4990CB6A.1020403@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 10, 2009 at 08:33:46AM +0800, Gui Xiaohua wrote:
> When mkfs.ext4 with flex_bg option, resize2fs with -M option will fail.
> 
> Steps to reproduce:
> 
> # mkfs.ext4 -O flex_bg /dev/sda6
> # resize2fs /dev/sda6 -M
> 
> resize2fs: No space left on device while trying to resize /dev/sda6

These problems were fixed in e2fsprogs 1.41.4.  See especially commit
id's 793a04a0 and 9227c5bb.  (There were a number of other resize2fs
bugs fixed in 1.41.4, but these two relate to the problems you were
trying to solve.)

I'm not convinced your attempt at trying to guesstimate how the number
of extra blocks needed by counting fragments works for anything other
than an empty filesystem.  If the filesystem is filled with contents,
and then it is shrunk, the resulting number of new extent blocks which
are needed is very much dependent on how the blocks end up getting
moved, and trying to determine the exact number up front is extremely
difficult.

Regards,

					- Ted
