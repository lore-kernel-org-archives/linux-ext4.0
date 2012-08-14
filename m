From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH V5 00/23] ext4: Add inline data support.
Date: Mon, 13 Aug 2012 20:43:49 -0600
Message-ID: <67344EBF-9B68-46AD-8936-4C383D0A2072@whamcloud.com>
References: <1341070917-4889-1-git-send-email-tm@tao.ma> <20120813150445.GC13072@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Tao Ma <tm@tao.ma>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33289 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab2HNCnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2012 22:43:46 -0400
Received: by ggdk6 with SMTP id k6so4035151ggd.19
        for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2012 19:43:46 -0700 (PDT)
In-Reply-To: <20120813150445.GC13072@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-08-13, at 9:04, Theodore Ts'o <tytso@mit.edu> wrote:
> I had an idea which I think would make inline directories more
> efficient, although it wouldn't be a backwards compatible change with
> the existing patch sets to date.
> 
> We don't actually need to store the entry for '.', since we know what
> that should be, and we could just store the parent directory in a
> 4-byte entry.

> By not storing the full directory entries for "." and
> "..", we would save 20 bytes, which for a 256 byte inode where only
> 120 bytes or so are available for the inline directory, is pretty
> significant.  (We can just synthesize them for the benefit of readdir
> and lookup --- and I'm pretty sure the VFS is doing its own synthesis
> for "." and possibly ".." already as far as lookup is concerned.)

One concern is that we have expanded the dentries for "." and ".." to store the Lustre FID in the expanded dirent. The "." dirent isn't needed for in-inode directories, and I suppose we could get the Lustre ".." FID from the "link" xattr (parent inode+name) already stored in the inode as well...  Both are useful for robustness with external directory files, but  they aren't useful inside the inode. 

Other than that, it seems reasonable to economize on space inside the inode. It makes the handling a bit more complex.

Cheers, Andreas