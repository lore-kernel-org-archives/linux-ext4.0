From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/6] lsattr: treat inode generation as an unsigned int
Date: Sun, 6 Mar 2016 18:13:49 -0500
Message-ID: <20160306231349.GD30238@thunk.org>
References: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
 <1457224716-72388-4-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38304 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbcCFXNu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 18:13:50 -0500
Content-Disposition: inline
In-Reply-To: <1457224716-72388-4-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 05, 2016 at 05:38:34PM -0700, Andreas Dilger wrote:
> The EXT2_GETVERSION ioctl is defined to take a "long" parameter, but
> fgetversion() calls ioctl() with an "int" parameter instead.  This is
> handled in the kernel correctly, but the generation is sign-extended
> in fgetversion() before return on 64-bit systems and lsattr prints
> it as a huge positive number for inode generation above 0x80000000:
> 
>         1635574212 -------------e-- /mnt/ost0/O/0/d0/12928
>         18446744073045131735 -------------e-- /mnt/ost0/O/0/d0/166240
>         782808861 -------------e-- /mnt/ost0/O/0/d0/31744
>         18446744072181134840 -------------e-- /mnt/ost0/O/0/d0/135008
> 
> Correctly assign the returned generation number as an unsigned value,
> and print it with a 10-character field width.  The version is printed
> left-aligned for consistency with the old code and to ensure it is
> always printed in the first column for use with tools like "cut":
> 
>         1635574212 -------------e-- /mnt/ost0/O/0/d0/12928
>         3630547415 -------------e-- /mnt/ost0/O/0/d0/166240
>         782808861  -------------e-- /mnt/ost0/O/0/d0/31744
>         2766550520 -------------e-- /mnt/ost0/O/0/d0/135008
> 
> Do not return a random value from the stack as the version on error.
> Clean up some style issues and consolidate some duplicate code.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
