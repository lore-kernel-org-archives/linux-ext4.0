From: Jan Kara <jack@suse.cz>
Subject: Re: need help with getting into a corrupted sub directory
Date: Tue, 9 Feb 2010 16:51:07 +0100
Message-ID: <20100209155106.GD15318@atrey.karlin.mff.cuni.cz>
References: <004d01caa172$8d846c10$6401a8c0@kyle> <27FC5E2E-2F85-478A-95F2-1B9ED9D07690@sun.com> <00b601caa2f4$2564bf80$b902a8c0@kyle>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: kyle <kylewong@southa.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36007 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab0BIPvI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 10:51:08 -0500
Content-Disposition: inline
In-Reply-To: <00b601caa2f4$2564bf80$b902a8c0@kyle>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> >
> > To get most of the data off the dying drive, use rsync -v, and create
> > a list
> > of files to exclude, when you detect they cause the drive to die.
> 
> I need to get files from 'public/EL/', however, 'public' cause the drive die
> ........
> 
> >
> >
> > debugfs is your friend.  It can open and list a directory by inode
> > number, and dump the files to another filesystem.
> 
> Is it possible to get the inode number of 'public/EL' without hitting the
> 'public' which cause the drive die?
  Not easily. But as Ted pointed out, you might try to dd blocks from /dev/sde
upto the problematic block and then next time starting after the problematic block.
If this works out, you can then just run fsck at the resulting image and it should
recover the filesystem reasonably...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
