From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Fri, 9 Sep 2011 18:11:26 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.1109091809180.9183@trent.utfs.org>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org> <4E66478E.90102@redhat.com> <alpine.DEB.2.01.1109060923340.9183@trent.utfs.org> <4E664DFD.80308@redhat.com> <20110908185139.GA2393@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	mszeredi@suse.cz, Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([194.246.123.103]:49106 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab1IJBL3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Sep 2011 21:11:29 -0400
In-Reply-To: <20110908185139.GA2393@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 8 Sep 2011 at 20:51, Jan Kara wrote:
> There's race where VFS remount code can race with unlink and result will
> be unlinked file in orphan list on read-only filesystem. Christian seems to
> be hitting this race. Miklos Szeredi has patches
> (http://lkml.indiana.edu/hypermail/linux/kernel/1108.3/00169.html) to
> mostly close this hole but they're waiting for Al to find time to look at
> them / merge them AFAIK.

While these patches are still pending review, are they "dangerous" to 
apply? If not, I'd like to volunteer as a tester :-)

Christian.
-- 
BOFH excuse #180:

ether leak
