From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: Oops while going into hibernate
Date: Wed, 12 Jan 2011 18:37:23 +0100 (CET)
Message-ID: <alpine.LFD.2.02.1101121836320.2011@localhost6.localdomain6>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6> <20110112162655.GA13496@thunk.org> <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6> <20110112172646.GB13496@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:54487 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab1ALRh2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Jan 2011 12:37:28 -0500
In-Reply-To: <20110112172646.GB13496@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, 12 Jan 2011, Ted Ts'o wrote:
> Since I don't have a machine set up to test hibernation easily at
> hand, I'd really appreciate it if you could try this patch to
> determine which inode had the NULL jinode --- and then once you get
> the device and inode number, to use debugfs's "ncheck" command to map
> the inode number to a pathname.
> 
> If you could do that, it would be a huge help.
ok, will do

> 
> Thanks, regards,
> 
> 						- Ted
> 
> P.S.  Also, if you could try suspending once or twice, with different
> programs running, to see if the inode number and pathname are constant
> or vary, that would also be helpful.
> 
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index d8b992e..7d6d7d7 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -252,8 +252,15 @@ static inline int ext4_journal_force_commit(journal_t *journal)
> 
>  static inline int ext4_jbd2_file_inode(handle_t *handle, struct inode *inode)
>  {
> -	if (ext4_handle_valid(handle))
> +	if (ext4_handle_valid(handle)) {
> +		if (unlikely(EXT4_I(inode)->jinode == NULL)) {
> +			/* Should never happen */
> +			ext4_msg(inode->i_sb, KERN_CRIT, 
> +				 "inode #%lu has NULL jinode", inode->i_ino);
> +			BUG();
> +		}
>  		return jbd2_journal_file_inode(handle, EXT4_I(inode)->jinode);
> +	}
>  	return 0;
>  }
> 
> 
