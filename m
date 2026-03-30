Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D20337C113;
	Mon, 30 Mar 2026 11:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.171.160.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774870165; cv=none; b=MQ/Lcmja+DMP8kRVAVFnX7Hq3El+HS8eQdF9X/ZmRPtOrbWb3E4oUCdqIChg6JyIHS+rMj/PB/KznMKO19n1os+TA0K/ymKDsGCofgYZH1XF2AgxEntEdWO7k4UDdJDBNvjxtBJZOMBlWZ5X/I/woKxqx+9AuPH8+E2Hshl4FZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774870165; c=relaxed/simple;
	bh=ryK/hkn6yU7hvIC8D6qqkwq/Eh/IykRy4A89vIotGfE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=o7BUzm8qqStmJ2jczyOu3I49MBwqbn2wJG53dNQswCMh002HubDYgMMYw6QX1ypMrBr5t6Yuztvq49ojokmv1mSr4+gF1RU10WRAdnvsT2PQ8wzzZXJBo3a5SmYvnSyaAwjUNyWTXe2cqCopTYwRqxbW7h0JePk6zIE0DCfmVG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp; spf=pass smtp.mailfrom=parknet.co.jp; dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=WpiWpc3A; dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b=xzICJuwm; arc=none smtp.client-ip=210.171.160.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="WpiWpc3A";
	dkim=permerror (0-bit key) header.d=parknet.co.jp header.i=@parknet.co.jp header.b="xzICJuwm"
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id E8A60209679B;
	Mon, 30 Mar 2026 20:29:19 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1774870160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=azxPziBoTu0EUy5OEpWIvHWwjmLYDV1JOaPD5UsQPw4=;
	b=WpiWpc3A06BWRRTu1Eh7H4/yLh3+uexv5nVL92NTJyzJfbkFH6Oi0cN9FhimLmyIIOB6Ti
	1QtJ1ATMAUR8PbQjSmcB0npyYgX2Z+H93FjcbUlAtNmqRk/uPpUEdnrHKDLhZn/na/pIqU
	+RBBCVhwuNg+qVa2WWROA2U6hxBPXWE71phYBZEMU8HDAxFwc8Krvsq47HSLtCu8AS+0Rr
	/V2TDpL1is/6n+GUyiVCfargkn2XXg4njcelY6rMuHDUEN+a8aMLgJAcXcSCNWG68LIAzU
	ofL8yE2PEhLLdExxd71eTHVgYk9TsbNgQtIJTBLetAna/qw6zh/dkU0r/7m0TA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1774870160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=azxPziBoTu0EUy5OEpWIvHWwjmLYDV1JOaPD5UsQPw4=;
	b=xzICJuwmbd2bwkmG4vWdifwyTBCo3WXeI70K7QBDEAQkYke/2C2LgEn+vOCw1ctSx1do3f
	1sOxI45CQB+75SAg==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id 75B19E000B8;
	Mon, 30 Mar 2026 20:29:19 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id 697E7220007A; Mon, 30 Mar 2026 20:29:19 +0900 (JST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,  linux-block@vger.kernel.org,  Christian
 Brauner <brauner@kernel.org>,  Al Viro <viro@zeniv.linux.org.uk>,
  linux-ext4@vger.kernel.org,  Ted Tso <tytso@mit.edu>,  "Tigran A.
 Aivazian" <aivazian.tigran@gmail.com>,  David Sterba <dsterba@suse.com>,
  Muchun Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,
  David Hildenbrand <david@kernel.org>,  linux-mm@kvack.org,
  linux-aio@kvack.org,  Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 15/42] fat: Sync and invalidate metadata buffers from
 fat_evict_inode()
In-Reply-To: <3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
References: <20260326082428.31660-1-jack@suse.cz>
	<20260326095354.16340-57-jack@suse.cz>
	<87ldfazqo2.fsf@mail.parknet.co.jp>
	<3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
Date: Mon, 30 Mar 2026 20:29:19 +0900
Message-ID: <87jyutwo6o.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jan Kara <jack@suse.cz> writes:

> On Sun 29-03-26 22:55:09, OGAWA Hirofumi wrote:
>> Jan Kara <jack@suse.cz> writes:
>> > There are only very few filesystems using generic metadata buffer head
>> > tracking and everybody is paying the overhead. When we remove this
>> > tracking for inode reclaim code .evict will start to see inodes with
>> > metadata buffers attached so write them out and prune them.
>> >
>> > Signed-off-by: Jan Kara <jack@suse.cz>
>> > ---
>> >  fs/fat/inode.c | 4 +++-
>> >  1 file changed, 3 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/fs/fat/inode.c b/fs/fat/inode.c
>> > index 3cc5fb01afa1..ce88602b0d57 100644
>> > --- a/fs/fat/inode.c
>> > +++ b/fs/fat/inode.c
>> > @@ -657,8 +657,10 @@ static void fat_evict_inode(struct inode *inode)
>> >  	if (!inode->i_nlink) {
>> >  		inode->i_size = 0;
>> >  		fat_truncate_blocks(inode, 0);
>> > -	} else
>> > +	} else {
>> > +		sync_mapping_buffers(inode->i_mapping);
>> 
>> Hm, why do we have to add this here? For FAT, if buffers are still
>> dirty, buffers will be flushed via bdev flush?
>
> The reason why I've put sync_mapping_buffers() here is the following
> sequence:
>   fd = open("file")
>   write(fd)
>   close(fd)
>     - now data gets written out, dentry & inode can get evicted from memory
>   fd = open("file")
>   fsync(fd)
>     - this should flush all dirty metadata associated with "file" but if we
>       didn't call sync_mapping_buffers() during inode eviction we wouldn't
>       have a way to do that.
>
> So in general I think sync_mapping_buffers() call is indeed needed.

Hm, it looks like not new issue, isn't it? Why we have changed now in
this series?

It is including trade off write amplification vs reliability (i.e. may
not call fsync()), for example. So I think we should not add it easily.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
