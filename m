From: Mingming <cmm@us.ibm.com>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Date: Thu, 29 Oct 2009 13:10:38 -0700
Message-ID: <1256847038.4341.0.camel@mingming-laptop>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
	 <20091016091558.GA10184@mit.edu>
	 <20091027101534.GA27584@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Parag Warudkar <parag.lkml@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51990 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbZJ2ULF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Oct 2009 16:11:05 -0400
In-Reply-To: <20091027101534.GA27584@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-10-27 at 15:45 +0530, Aneesh Kumar K.V wrote:
> Can you try this patch ?
> 
> commit a8836b1d6f92273e001012c7705ae8f4c3d5fb65
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Tue Oct 27 15:36:38 2009 +0530
> 
>     ext4: discard preallocation during truncate
>     
>     We need to make sure when we drop and reacquire the inode's
>     i_data_sem we discard the inode preallocation. Otherwise we
>     could have blocks marked as free in bitmap but still belonging
>     to prealloc space.
>     
>     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 

Make sense, reviewed-by: Mingming Cao <cmm@us.ibm.com>

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5c5bc5d..a1ef1c3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -209,6 +209,12 @@ static int try_to_extend_transaction(handle_t *handle, struct inode *inode)
>  	up_write(&EXT4_I(inode)->i_data_sem);
>  	ret = ext4_journal_restart(handle, blocks_for_truncate(inode));
>  	down_write(&EXT4_I(inode)->i_data_sem);
> +	/*
> +	 * We have dropped i_data_sem. So somebody else could have done
> +	 * block allocation. So discard the prealloc space created as a
> +	 * part of block allocation
> +	 */
> +	ext4_discard_preallocations(inode);
> 
>  	return ret;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


