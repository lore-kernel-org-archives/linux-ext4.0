Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.171.160.6
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793853983;
	b=wOn6FwLufLKWBxOMVju6hElLzbExbwlUkfVn8sPBq9atB85PqjhFiGL3Jg+pLLNHUnUJ
	 LUyjgENXozJyPhKuq4BbvHvHNP+iBRU24GjHFyEL8ALoObpIWsighO5qoQTzGetKnO6B9
	 z8jkLmuB3Uz6CKXWM9WlAvd4ZwAwXANOKMQ9T7ghpuEWk4f5/YpRWwXMmXHI6eQcFG1w7
	 ZDShBwKzhP0lrDaKIns/+UXXvnugyG/B1KDpsUbv1ycmbpLoHIoegIKfkTnCKW/A8SjZp
	 JGfPxG58G+x1HgX97DaWMGgyVLQCPpGuOo9Kaxt5CtE+9P8qBgvpa1vXB/yJay9bP9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793853983;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 User-Agent:MIME-Version:Content-Type;
	bh=UEhvz5qnVJcOEvOQ5Tc4seJIA3lfMk/hJ4EDh4hKsfI=;
	b=qO4LVN/YCjeuNt5fiUjLFb+eMDhjno5PKFPnRNENTiNGJfM8gCRJyErlYda67JGa054d
	 ll2wKckZuYx1rKWhTqBrNIB6T706/8aV+Lv+2NxFLwdAJJun5phZDj8s+7WsONkbGtybH
	 AGvxtG8msZtUo4pnOdMNMFgpin9JOQmq1+2/A2h1+8ahAVCeWCSN3PUC+z2EL75TbhKt6
	 21R3BpR81KOtRmiQO6A+Q8uOzaYxSkJgOUPVURvwI9Zn1SmBYNleu/eAHYESV4U4BgHiv
	 t2oip2bOjsRNNKUEW/SYD3VdvH5tdF+tmgyrCXcGkMTQvn0FuML+v5v/qRZWnKLXRiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.parknet.co.jp;
	spf=pass smtp.mailfrom=parknet.co.jp;
	dkim=pass header.d=parknet.co.jp header.i=@parknet.co.jp header.a=rsa-sha256 header.s=20250114 header.b=AzU3k0xM;
	dkim=pass header.d=parknet.co.jp header.i=@parknet.co.jp header.a=ed25519-sha256 header.s=20250114-ed25519 header.b=Rdc2RTcK;
	arc=none smtp.remote-ip=210.171.160.6
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67471606A32D;
	Thu,  5 Nov 2026 04:46:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67471606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=parknet.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=parknet.co.jp header.i=@parknet.co.jp header.a=rsa-sha256 header.s=20250114 header.b=AzU3k0xM;
	dkim=pass header.d=parknet.co.jp header.i=@parknet.co.jp header.a=ed25519-sha256 header.s=20250114-ed25519 header.b=Rdc2RTcK
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id 45A6026F765F;
	Thu,  5 Nov 2026 13:46:18 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1793853978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UEhvz5qnVJcOEvOQ5Tc4seJIA3lfMk/hJ4EDh4hKsfI=;
	b=AzU3k0xMre3huuujnXb7O4iBaA+saDtxcD7ekZ22W1lV3TiIKDuxQjyYtO8mGqP8zXW3UF
	wT9t7n8DAB7OP6dCtKzlYJfljlkrJbF9yvxu/1RDX/0dk6qY2R5+No1FHtBFzKxVsCDMrj
	+34FkgcEYX5f+cBLPS4RSyRf1tzYa9zMGz4CnCyPQ9/eeExlYtW2ryEZFMPXrNBbdjg+gG
	mXMmaZh3g5I+7meqAEFe8LMp4IAarAdZFkLBo+/Fo7cBVaZJJ63P10000vh4gi1Tp32OPL
	uar2Db9B8PthiFsPJ0cqHghWU2DvyYgUHJxENnE+xnegBbTWYd7wNGJsso3AUA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1793853978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UEhvz5qnVJcOEvOQ5Tc4seJIA3lfMk/hJ4EDh4hKsfI=;
	b=Rdc2RTcKOFkoTJP+bE9GoCYl8pWdaetk4ehiCYgpPSFQO91vWdH8Wuk96iVyVO6r7X4cME
	V1oP1w0KC4m4BhBw==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id B7E87E000B0;
	Thu, 05 Nov 2026 13:46:17 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id AD4F722000AE; Thu, 05 Nov 2026 13:46:17 +0900 (JST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>,  linux-fsdevel@vger.kernel.org,
  Josef Bacik <josef@toxicpanda.com>,  Chris Mason <mason@kernel.org>,
  linux-ext4@vger.kernel.org,  Andreas Dilger <adilger.kernel@dilger.ca>,
  Baokun Li <libaokun@linux.alibaba.com>,  Ojaswin Mujoo
 <ojaswin@linux.ibm.com>,  "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
  Namjae Jeon <namjae.jeon@samsung.com>,  stable@vger.kernel.org
Subject: Re: [PATCH RFC 8/9] fat: sync the inode in fat_free_eofblocks()
In-Reply-To: <3xsybk6czpjtovswdd46bvoug73ojrzshh5hkdjkfszyjl3x5h@j2l7dqxoorhi>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
	<20261029-work-inode-metadata_writeback-v1-8-7d6c678a585d@kernel.org>
	<oilqmzo3vpddohxp46x3pjzf3wtoebahirtjqmt3izdw6ua5iq@ghdbk27wuf5f>
	<87v76co5dv.fsf@mail.parknet.co.jp>
	<3xsybk6czpjtovswdd46bvoug73ojrzshh5hkdjkfszyjl3x5h@j2l7dqxoorhi>
Date: Thu, 05 Nov 2026 13:46:17 +0900
Message-ID: <87pkwjopgm.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Jan Kara <jack@suse.cz> writes:

>> In my understand, the result of this change only affect to crash case
>> (FAT has no guarantee about it with non-sync mode). And this doesn't
>> lost data actually - lost some free blocks (maybe fsck would be
>> recoverable).
>
> The result won't be lost free blocks but rather reference from inode to
> already freed blocks after a crash (and thus possibility of a block used by
> two inodes). So it is definitely an unpleasant filesystem corruption after
> a crash but as you say there are really no guarantees without fsck...

Ah, sure. Possible if the block is reused and flushed without flushing
EOF mark. However, broken parts usually would be outside of i_size.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
