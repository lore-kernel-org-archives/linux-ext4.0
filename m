From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH,STABLE 2.6.29 06/18] ext4: Automatically allocate delay
	allocated blocks on close
Date: Wed, 03 Jun 2009 12:14:19 -0600
Message-ID: <20090603181419.GN9002@webber.adilger.int>
References: <1243944479-20574-1-git-send-email-tytso@mit.edu>
 <1243944479-20574-2-git-send-email-tytso@mit.edu>
 <1243944479-20574-3-git-send-email-tytso@mit.edu>
 <1243944479-20574-4-git-send-email-tytso@mit.edu>
 <1243944479-20574-5-git-send-email-tytso@mit.edu>
 <1243944479-20574-6-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, stable@kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38732 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZFCSOi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jun 2009 14:14:38 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n53IEXPi019909
	for <linux-ext4@vger.kernel.org>; Wed, 3 Jun 2009 11:14:35 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KKO00H00BTYNZ00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 03 Jun 2009 11:14:33 -0700 (PDT)
In-reply-to: <1243944479-20574-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 02, 2009  08:07 -0400, Theodore Ts'o wrote:
> When closing a file that had been previously truncated, force any
> delay allocated blocks that to be allocated so that if the filesystem
> is mounted with data=ordered, the data blocks will be pushed out to
> disk along with the journal commit.  Many application programs expect
> this, so we do this to avoid zero length files if the system crashes
> unexpectedly.
> 
> @@ -3880,6 +3880,9 @@ void ext4_truncate(struct inode *inode)
>  	if (!ext4_can_truncate(inode))
>  		return;
>  
> +	if (inode->i_size == 0)
> +		ei->i_state |= EXT4_STATE_DA_ALLOC_CLOSE;

Since some applications open files with open(..., O_WRONLY|O_CREAT|O_TRUNC)
to avoid re-using existing files (and avoiding the need to check if the
file already exists to modify the flags), it would make sense to set
EXT4_STATE_DA_ALLOC_CLOSE only if the file previously had some data in it.

By the time we get to ext4_truncate() i_size is overwritten already, but
it might make sense to also check i_disksize != 0 before setting this flag.
Otherwise delayed allocation may be inadvertently disabled for these apps
when it should not be.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

