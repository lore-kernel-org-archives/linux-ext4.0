Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC27BC8E6;
	Sat,  4 Apr 2026 15:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775316461; cv=none; b=urzm2SecZoxqbGUD9ZfPCFymLjS3Ljm8BFFJE+62df6lqIQq89Rk9TYBdOXVtJorTqdmzquwUdMe2FMqqwjIXPiBNbZlsFymQ8v88kvXJG7PaXVbqzp2ExL5w5zRQ35qINd8YuzO1O/BZkWBwYq1SXM+UbKPsxREZlBqoo46Jl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775316461; c=relaxed/simple;
	bh=YGRt012qr0du0L8F+GQbZnl8zXR4jO6pz+okydoqoY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gy6lPin3VfdhKl7usCjZ8UuZWWt9QIka3RiM45/Kx4wTOYbviwEH+g4mq+Zr4bk2fDfsdmlWafhK0zNnPr0ybbquWDmExs5Ps/tKsR6Kl7K2syQmm8H1XKUyAMlF3HAyEMxBIU9PlFjsQ+PKVULyVudMiNy+oTBimIgD0Z2paqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from [10.88.16.7] (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id C9EDC23372;
	Sat,  4 Apr 2026 18:27:37 +0300 (MSK)
Message-ID: <90fe3801-7723-553c-6384-c6a42a5932cc@basealt.ru>
Date: Sat, 4 Apr 2026 18:27:37 +0300
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 0/2] ext2: fix WARN_ON in drop_nlink() triggered by
 corrupt images
To: Jan Kara <jack@suse.com>, Andrew Morton <akpm@osdl.org>,
 Alexey Dobriyan <adobriyan@gmail.com>, linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20260401220837.2424925-1-kovalev@altlinux.org>
Content-Language: en-US
From: Vasiliy Kovalev <kovalev@altlinux.org>
In-Reply-To: <20260401220837.2424925-1-kovalev@altlinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/2/26 01:08, Vasiliy Kovalev wrote:
> A crafted ext2 image can contain a directory entry pointing to an inode
> whose on-disk i_links_count is zero. ext2 mounts such an image without
> error. Any subsequent syscall that decrements i_nlink on that inode
> triggers WARN_ON inside drop_nlink() in fs/inode.c.
> 
> These patches prevent the warning by validating i_nlink before decrementing
> it in ext2_unlink() and ext2_rename(), reporting the corruption via
> ext2_error() instead.
> 
> The issues were found by Linux Verification Center (linuxtesting.org)
> with Syzkaller.
> 
> Vasiliy Kovalev (2):
>    ext2: validate i_nlink before decrement in ext2_unlink()
>    ext2: guard against zero i_nlink on new_inode in ext2_rename()

Syzkaller found a third trigger via ext2_rmdir(). Rather than adding
another guard in namei.c, I fixed the root cause in ext2_iget() instead 
- a single check there covers all three cases at once.

New patch: 
https://lore.kernel.org/all/20260404152011.2590197-1-kovalev@altlinux.org/

If the previous two patches have not been picked up yet, please
consider this one as a replacement for the entire series.

>   fs/ext2/namei.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
> 
> --- [Reproducer for PATCH 1/2: ext2_unlink] ---
> [...]
> 
> --- [Reproducer for PATCH 2/2: ext2_rename] ---
> [...]

-- 
Thanks,
Vasiliy
