From: Jan Kara <jack@suse.cz>
Subject: Re: what exactly is CONFIG_EXT4_USE_FOR_EXT23 for?
Date: Thu, 11 Mar 2010 18:27:48 +0100
Message-ID: <20100311172748.GC19923@atrey.karlin.mff.cuni.cz>
References: <4B991C81.5040506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:43203 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751357Ab0CKR1u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Mar 2010 12:27:50 -0500
Content-Disposition: inline
In-Reply-To: <4B991C81.5040506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> commit 24b584240a0006ea7436cd35f5e8983eb76f1e6f
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Mon Dec 7 14:08:51 2009 -0500
> 
>     ext4: Use ext4 file system driver for ext2/ext3 file system mounts
>     
>     Add a new config option, CONFIG_EXT4_USE_FOR_EXT23 which if enabled,
>     will cause ext4 to be used for either ext2 or ext3 file system mounts
>     when ext2 or ext3 is not enabled in the configuration.
>     
>     This allows minimalist kernel fanatics to drop to file system drivers
>     from their compiled kernel with out losing functionality.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> 
> So now we have this thing, and people are using it, and running into trouble:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=15420
> Bug 15420 -  EXT4_USE_FOR_EXT23 causes wrong free space calculation on ext2 and ext3
> 
> and now we propose turning off delalloc if we mount ext3 as ext4; however,
> migrated ext3->ext4 filesystems, which initially may have no difference other
> than a superblock feature flag, will not get this behavior, I guess.
> 
> Jan suggests that we not surprise users by having delalloc enabled when ext3
> is mounted with the ext4 driver.  However there are other behavior differences
> as well, mballoc behavior comes to mind at least.  What about the 32000 subdir
> limit?  If we go back to ext3 is it ok with the subsecond timestamps and
> creation time etc?  Maybe so... have we tested any of this?
  Yeah, this is a good point... Honestly, I don't quite understand what's
the problem with "minimalist kernel fanatics" going and mounting all the
devices as ext4 (when they decided to compile kernel without ext2/3) - no
need for special kernel option. It will probably need some tweaks in
automounters but still...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
