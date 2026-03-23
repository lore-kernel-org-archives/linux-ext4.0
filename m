Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88EB390217;
	Mon, 23 Mar 2026 10:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774262779; cv=none; b=cZrWU1k4/26wufI+X3ffJznsX2I4Wq8ZPNFoveS6ttVN8BzsYyjA+LyGz33ipAu/WMvbtlJz5jLIDSCKEsiUyCaY1fFyQlGHVS3epQYX2NE7thRxAwuLLLWub7kGxc3vgkRtFPpm7HsJ48itERyeNF+2WAJ9sVd85hHUWnRBSQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774262779; c=relaxed/simple;
	bh=XtjcoKtxUKZ+Ju2UBvtKQvmMn/QTSZDI+fqZetzComg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iTONtjdJpkD8kRyJPjwKpZ7uwJlrzmRH/KWg9dKucP2y33ChFS3pcn1dGFrrjqGiX8lbY759VKU7fV0loxEH2Bz/yAwJzKIBZV5OHW+4gET829fzZ7AO3NJwqh0xqVN/+mHL9RnVKVmyrBhkOGnHrVa05+pKuRGv3k56DCpZL9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Tv6B3eRk; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Tv6B3eRk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774262775; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iQ6mAQdlt6rOthd/wT56xFxrcrGf+UGd+c4429Y/xYM=;
	b=Tv6B3eRkCpXLOJCtaN79deX5c91AnqJ4uF/YIu2hwwcyAF3SFEmOjdoUF3bm1JwJBgRVkp6EBeqixfO/vJXEBkJt3JvEVWkCMOGZI4Ze5CBjQVgsvGvRWkGiKSeqJvk2GwRQO+pVsmJGAIAV81ZucuUImVQX9T2E0L9diap8ajg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.WQK-Y_1774262772;
Received: from 30.221.129.170(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X.WQK-Y_1774262772 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Mar 2026 18:46:13 +0800
Message-ID: <abaf00ff-3374-44de-81b9-6f806c370227@linux.alibaba.com>
Date: Mon, 23 Mar 2026 18:46:12 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/41] ocfs2: Drop pointless sync_mapping_buffers() calls
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 Al Viro <viro@ZenIV.linux.org.uk>, linux-ext4@vger.kernel.org,
 Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 David Sterba <dsterba@suse.com>, OGAWA Hirofumi
 <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org, linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-45-jack@suse.cz>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260320134100.20731-45-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/20/26 9:40 PM, Jan Kara wrote:
> ocfs2 never calls mark_buffer_dirty_inode() and thus its metadata
> buffers list is always empty. Drop the pointless sync_mapping_buffers()
> calls.
> 
> CC: Joel Becker <jlbec@evilplan.org>
> CC: Joseph Qi <joseph.qi@linux.alibaba.com>
> CC: ocfs2-devel@lists.linux.dev
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlmglue.c | 1 -
>  fs/ocfs2/namei.c   | 3 ---
>  2 files changed, 4 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index bd2ddb7d841d..7283bb2c5a31 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3971,7 +3971,6 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
>  		mlog(ML_ERROR, "Could not sync inode %llu for downconvert!",
>  		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
>  	}
> -	sync_mapping_buffers(mapping);
>  	if (blocking == DLM_LOCK_EX) {
>  		truncate_inode_pages(mapping, 0);
>  	} else {
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 268b79339a51..1277666c77cd 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -1683,9 +1683,6 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
>  	if (rename_lock)
>  		ocfs2_rename_unlock(osb);
>  
> -	if (new_inode)
> -		sync_mapping_buffers(old_inode->i_mapping);
> -
>  	iput(new_inode);
>  
>  	ocfs2_free_dir_lookup_result(&target_lookup_res);

