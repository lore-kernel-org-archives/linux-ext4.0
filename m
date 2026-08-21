Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541193B05BC
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2026 07:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787298088; cv=none; b=fnK+NWUGTbpZKRwrqmmAHZDPwtrbbCp6HVA/K2K3/Ht/v77gjGOFmuB/awfzN4SQD5xgy14+0JH1ql7uoxdmkSHBkvRxaQMuzfZvd8SfZ44fdtgQdSUHdzKsQUH7fZuNKjvql1HvNXfVs7mfHorA2skYvivOJFNH57A4TvjbwEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787298088; c=relaxed/simple;
	bh=5xsOSJaFepAr2qF2CeyVENHROcR5+IDZz61tFR0EnIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l9SwRGzvUW7JcIzEqx0iET1C7CfDjpANO4lH+MZrnD8TujVz3mv1sBaGYw/aIMeEvWm1rsYccW0ZnqVqIoSfKwtqC6LXJIk4PZeaIji13zR2YJ/DX8m89zpQp43ZS6HZgE+3H5zMH3PSLj+p/G78Sht8d+6cwQWZAj2wgg9DnQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Ahh3VbRU; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Ahh3VbRU"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787298079; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0HfOoFU0Vm58pRLQnlslmxLSsCMKHJCQpUq/LMgCAbs=;
	b=Ahh3VbRUbYTWl/bMM4QaMBjmNoqdx59u8aC6fylckrYEk0LBhDyb4YWiMWimdC0Vc4PLZJg0BuagAnXesOKrG9lI6nnDbMGjIJgi+/UkP3RX+VsOMO1+uGXGrjm2cnZ7joOdO37jJqO1BtBdsttZ7caeMwQGJYp6k4jvOAIAGqU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X9La-pn_1787298078;
Received: from 30.221.131.126(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X9La-pn_1787298078 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Aug 2026 15:41:19 +0800
Message-ID: <d21df559-4080-4bb9-a47c-9188f162072d@linux.alibaba.com>
Date: Fri, 21 Aug 2026 15:41:18 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] ext4: Avoid entering writeback paths during
 fastcommit replay
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>
References: <20260820112532.757055-2-jack@suse.cz>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260820112532.757055-2-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/8/20 19:25, Jan Kara wrote:
> Fastcommit replay effectively happens in nojournal mode. This results in
> ext4_mark_iloc_dirty() setting I_METADATA_WRITEBACK flag and as a result
> we end up entering filesystem writeback functions. However during
> fastcommit replay s_writepages_rwsem isn't initialized yet and hence we
> crash.
>
> Fix the problem by avoiding setting I_METADATA_WRITEBACK during
> fastcommit replay. Journal replay flushes the whole block device after
> replay anyway so all metadata is properly persisted and replay is faster
> this way as a bonus.
>
> Fixes: c26339e1df33 ("ext4: Fix data integrity writeout issues in nojournal mode")
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Reported-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good, feel free to add:

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
>  fs/ext4/inode.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> Hi Ted,
>
> this has fallen through the cracks in VFS tree, now it applies cleanly to
> Linus' tree so can you perhaps pick it up and push to Linus during the second
> half of the merge window? Thanks!
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7a1f961cd11c..12ff84ab5741 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6408,9 +6408,10 @@ int ext4_chunk_trans_blocks(struct inode *inode, int nrblocks)
>  int ext4_mark_iloc_dirty(handle_t *handle,
>  			 struct inode *inode, struct ext4_iloc *iloc)
>  {
> +	struct super_block *sb = inode->i_sb;
>  	int err = 0;
>  
> -	err = ext4_emergency_state(inode->i_sb);
> +	err = ext4_emergency_state(sb);
>  	if (unlikely(err)) {
>  		put_bh(iloc->bh);
>  		return err;
> @@ -6425,9 +6426,13 @@ int ext4_mark_iloc_dirty(handle_t *handle,
>  	put_bh(iloc->bh);
>  	/*
>  	 * Mark that there's metadata writeout pending for the inode so that it
> -	 * gets properly flushed on fsync(2) and similar.
> +	 * gets properly flushed on fsync(2) and similar. We don't bother for
> +	 * fastcommit replay as that flushes the whole bdev afterwards anyway.
> +	 * It is faster this way and we avoid entering fs writeback paths which
> +	 * aren't fully initialized yet.
>  	 */
> -	if (!EXT4_SB(inode->i_sb)->s_journal) {
> +	if (!ext4_handle_valid(handle) &&
> +	    !(EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY)) {
>  		/*
>  		 * Inode didn't need to go through dirtying, make sure it is
>  		 * attached to wb so that writeback can handle it.


