Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0831D4534B3
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 10:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785840795; cv=none; b=ueRmUfE9qRyzFKGX2hcpr+wcCNvKJEtm+aH8PT6LpsltRf6P8hNPT+H7Nr2w+sxHGc38oDFYRFe+5uWbuMw2X234lTML5Zs5/k7K548CUd5RNf8BwtDpjNKKAvyJt7IvyINdRqwH2bXML+GSXGLEjhs1REYRggJl1A9d38DBZhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785840795; c=relaxed/simple;
	bh=G4KxFRKdD4wss852PWp7glkHmFOhVXmkPUMRWcCViSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=beftMs7VM00bp6QkV2NZFz3WamrG3/fWRdrPWzjGaCiyYluPXDw8NMcml1E+IKn+8osrwMTd5w8+yGobg3ZbAcPtslRFOPWWejFIYJNf9+uudqlf2xdoHwmGNFH+qOX0iYPHEQu0AZ9j2MrKNDQm9+lWGS8X95EqsLqZWUz6FIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=W8Gc8OcE; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="W8Gc8OcE"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785840782; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nKutgePybnlH+8A2haWD06lSfu3uKvFzPtFXpOpTVls=;
	b=W8Gc8OcEVyk0/AgiuTa3nw9KdNn2cnLE/GEziMn9+IAFgYJh5oAysEETFQirBE1NIvq82V5rdAzePmb/OceZSz9kRm03Vy3JC9c8czIOoFTAS/6pVgLTb2o9EeBNUU0+qWJjU9J/0FOdAWqfdaHh3s9aJzZDCMEmXWO8moqR7Ig=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X8Nyz7I_1785840781;
Received: from 30.221.148.4(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X8Nyz7I_1785840781 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 04 Aug 2026 18:53:01 +0800
Message-ID: <d13a2edd-34eb-42cf-a4c5-626eb750a130@linux.alibaba.com>
Date: Tue, 4 Aug 2026 18:53:00 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: Fix spurious message about orphan cleanup on RO fs
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Tigran Aivazian <aivazian.tigran@gmail.com>
References: <20260803160037.64285-2-jack@suse.cz>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260803160037.64285-2-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/8/4 00:00, Jan Kara wrote:
> When orphan_file feature is enabled, ext4_orphan_cleanup() was always
> walking through the orphan file looking for orphan inodes. This is
> mostly harmless but for read-only filesystem it results in spurious
> "orphan cleanup on readonly fs" message and in other cornercases it
> could result in similar somewhat misleading messages. Skip orphan
> cleanup if the orphan file is empty to avoid confusing messages.
>
> Fixes: 02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
> Reported-by: Tigran Aivazian <aivazian.tigran@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good to me.

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
>  fs/ext4/orphan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
> index 64ea47624233..2a44998a6c2e 100644
> --- a/fs/ext4/orphan.c
> +++ b/fs/ext4/orphan.c
> @@ -388,7 +388,7 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
>  	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
>  	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
>  
> -	if (!es->s_last_orphan && !oi->of_blocks) {
> +	if (!es->s_last_orphan && ext4_orphan_file_empty(sb)) {
>  		ext4_debug("no orphan inodes to clean up\n");
>  		return;
>  	}


