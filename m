From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] ext3: dump dentry in ext3_dx_add_entry
Date: Tue, 03 Feb 2015 11:39:36 +0100
Message-ID: <54D0A568.4050905@fastmail.fm>
References: <1422955349-19631-1-git-send-email-olaf@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Olaf Hering <olaf@aepfle.de>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57905 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754958AbbBCKjj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2015 05:39:39 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 9FD6E2053B
	for <linux-ext4@vger.kernel.org>; Tue,  3 Feb 2015 05:39:38 -0500 (EST)
In-Reply-To: <1422955349-19631-1-git-send-email-olaf@aepfle.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 02/03/2015 10:22 AM, Olaf Hering wrote:
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> ---
>  fs/ext3/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index f197736..0692058 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -1529,7 +1529,7 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
>  		if (levels && (dx_get_count(frames->entries) ==
>  			       dx_get_limit(frames->entries))) {
>  			ext3_warning(sb, __func__,
> -				     "Directory index full!");
> +				     "Directory index full! %pd4 %pd", dentry->d_parent, dentry);
>  			err = -ENOSPC;
>  			goto cleanup;
>  		}

Would you mind to also add the inode number? That way one could use
debugfs to figure out the complete path.
And it should be done for ext4 as well.



Cheers,
Bernd
