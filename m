From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 2nd Attempt - FSCK Errors
Date: Fri, 3 May 2013 17:31:32 -0400
Message-ID: <20130503213132.GA6032@thunk.org>
References: <007b01ce45ab$0ffc24f0$2ff46ed0$@ntlworld.com>
 <CAFB1F4E-F086-4712-B70D-74F85F3BFDAE@dilger.ca>
 <000f01ce47ec$ca7767c0$5f663740$@ntlworld.com>
 <20130503131421.GC32297@thunk.org>
 <002701ce4802$8c4e4fc0$a4eaef40$@ntlworld.com>
 <20130503152914.GE32297@thunk.org>
 <001601ce482e$07282510$15786f30$@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Andreas Dilger' <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Stephen Elliott <techweb@ntlworld.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46180 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763741Ab3ECVbh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 May 2013 17:31:37 -0400
Content-Disposition: inline
In-Reply-To: <001601ce482e$07282510$15786f30$@ntlworld.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 03, 2013 at 07:42:55PM +0100, Stephen Elliott wrote:
> One thing maybe you could explain (and Andreas gave me his take too) is how
> you can multiply assigned blocks shared with "0" files. Andreas offered the
> suggestion that they may be in the same file. If this were really the case,
> I would suspect there to be some file corruption issues etc...

It could be that the blocks appear multiple times in the file; or it
could be the storage system is returning different data on subsequent
reads from the device.

What we need is a debugfs dump of the inode on the file system that is
having trouble.  A debugfs dump of the inode from a completely
underlated file system is not useful....

						- Ted
