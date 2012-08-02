From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] implement uid and gid mount options for ext2
Date: Thu, 2 Aug 2012 13:06:42 +0100
Message-ID: <20120802130642.46b12c59@pyramind.ukuu.org.uk>
References: <1343908443-17369-1-git-send-email-ludwig.nussel@suse.de>
	<1343908443-17369-2-git-send-email-ludwig.nussel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz> (maintainer:EXT2 FILE SYSTEM),
	Rob Landley <rob@landley.net> (maintainer:DOCUMENTATION),
	Andrew Morton <akpm@linux-foundation.org> (maintainer:EXT3 FILE
	SYSTEM),
	Andreas Dilger <adilger.kernel@dilger.ca> (maintainer:EXT3 FILE
	SYSTEM),
	"Theodore Ts'o" <tytso@mit.edu> (maintainer:EXT4 FILE SYSTEM),
	linux-ext4@vger.kernel.org (open list:EXT2 FILE SYSTEM),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION)
To: Ludwig Nussel <ludwig.nussel@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57634 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2HBMC1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Aug 2012 08:02:27 -0400
In-Reply-To: <1343908443-17369-2-git-send-email-ludwig.nussel@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> +uid=n[:m]			Make all files appear to belong to uid n.
> +				Useful for e.g. removable media with fstab
> +				options 'user,uid=useruid'. The optional second
> +				uid m is actually written to the file system.

So what happens if I insert a USB key containing a device node to the
hard disk ? Why is this functionality useful in the current form ?

(ie I think you need an actual rational security model first)


Also why is this at the per fs level duplicating stuff each time rather
than at the vfs level - this seems to be vfs level functionality.

> +
> +gid=n[:m]			Make all files appear to belong to gid n.
> +				The optional second gid m is actually written to
> +				the file system.

Your documentation seems only half completed ?

Alan
