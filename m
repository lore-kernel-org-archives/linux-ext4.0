From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 29 Oct 2009 20:11:08 GMT
Message-ID: <200910292011.n9TKB8B0017201@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41574 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbZJ2ULE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 16:11:04 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9TKB8U1017203
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2009 20:11:08 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #143 from Mingming Cao <cmm@us.ibm.com>  2009-10-29 20:11:04 ---
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

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.