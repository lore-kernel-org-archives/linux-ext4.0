From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2fsck: Fix bug which can cause e2fsck -fD to corrupt
 non-indexed directories
Date: Wed, 24 Feb 2010 01:25:16 -0700
Message-ID: <56B4B314-CBF3-495B-96BD-FCD524D539DA@sun.com>
References: <1266903821-20800-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38535 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab0BXIZT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Feb 2010 03:25:19 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o1O8PIhU001700
	for <linux-ext4@vger.kernel.org>; Wed, 24 Feb 2010 00:25:18 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KYC0010078ZZX00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 24 Feb 2010 00:25:18 -0800 (PST)
In-reply-to: <1266903821-20800-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-22, at 22:43, Theodore Ts'o wrote:
> E2fsprogs 1.41.10 introduced a regression (in commit b71e018) where
> e2fsck -fD can corrupt non-indexed directories when are exists one or
> more file names which alphabetically sort before ".".  This can happen
> with ext2 filesystems or for small directories (take less than a
> block) which contain filenames that begin with a space or some other
> punctuation mark.
>
> Fix this by making sure we never reorder the '.' or '..' entry in the
> directory, since they must be first.

Ted, thanks for getting this out so fast.  We were just building our  
release based on 1.41.10 and are able to add this in.

Do you have a regression test for this case?  e2fsck itself will  
detect the corruption ("." and ".." not at the start of the directory)  
after the fact, but I guess it means that there are no existing tests  
where there is a directory entry that sorts before "." or it would  
have been noticed earlier.

Looking at the ASCII characters before "." it seems that CVS "old  
version" files with a leading ".#", "(", and "%gconf.xml" would  
probably be the most likely cause of problems.

In any case, I can reproduce this easily on my filesystem with my mp3  
collection (on a backup, fortunately).  Unfortunately, it seems that  
re-running e2fsck after such a corruption causes all (thousands) of  
the entries that were sorted to the beginning of the directory to be  
deleted, and moved into /lost+found.

Have you pulled this release from Sourceforge and any downstream  
releases already (Debian, FC, etc)?  It seems like a pretty serious  
problem, even though "-fD" is likely not run very often.

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> e2fsck/rehash.c |    7 ++++++-
> 1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
> index 780742e..ceb8543 100644
> --- a/e2fsck/rehash.c
> +++ b/e2fsck/rehash.c
> @@ -763,7 +763,12 @@ retry_nohash:
>
> 	/* Sort the list */
> resort:
> -	qsort(fd.harray, fd.num_array, sizeof(struct hash_entry), hash_cmp);
> +	if (fd.compress)
> +		qsort(fd.harray+2, fd.num_array-2, sizeof(struct hash_entry),
> +		      hash_cmp);
> +	else
> +		qsort(fd.harray, fd.num_array, sizeof(struct hash_entry),
> +		      hash_cmp);
>
> 	/*
> 	 * Look for duplicates
> -- 
> 1.6.6.1.1.g974db.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

