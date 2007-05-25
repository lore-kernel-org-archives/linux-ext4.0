From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Fri, 25 May 2007 10:39:57 -0400
Message-ID: <20070525143957.GA12669@thunk.org>
References: <1179777153.3910.13.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40941 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbXEYOkF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 May 2007 10:40:05 -0400
Content-Disposition: inline
In-Reply-To: <1179777153.3910.13.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Kalpak,

On Tue, May 22, 2007 at 01:22:32AM +0530, Kalpak Shah wrote:
> It will also protect against running e2fsck on a mounted filesystem
> by adding similar logic to ext2fs_open().

Your patch didn't add this logic to ext2fs_open(); it just reserved
the space in the superblock.

I don't mind reserving the space so we don't have to worry about
conflicting superblock uses, but I'm still on the fence about actually
adding this functionality (a) into e2fsprogs, and (b) into the ext4
kernel code.  I guess it depends on how complicated/icky the
implementation code is, I guess.  The question as before is whether
the complexity is worth it, given that someone who is actually going
to be subject to accidentally mounting an ext3/4 filesystem on
multiple systems needs to be using an HA system anyway.  So basically
this is just to protect against (a) a bug/failure in the HA subsystem,
and (b) the idiotic user that failed to realized he/she needed to set
up an HA subsystem in the first place.  Granted, the universe is going
to create idiots at a faster rate that we can deal with it, but that's
why I'm still not 100% convinced the complexity is worth it.

To be fair, if I was on a L3 support team having to deal with these
idiots, I'd probably feel differently.  :-)

							- Ted
