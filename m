Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC6539891F
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2026 22:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778623869; cv=none; b=ExbFqeIrswPGWiSMYNsmvNoKfDvAbN6pwshrpWXD/QONG+Eayhs04GAJC2qJGuvOU9VbYnGlVJPwiIEzWWZF8VkDgZBOUCk5HPE7kntD0na2L4POJFKt+BwqBZcxzCOWoIs6TxfEbSETrAQXY1lfIzaakYJKZzN0r4isrk9N5UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778623869; c=relaxed/simple;
	bh=fKXRzsyPrMDCepYl/y2S1DD8oCfDl/6FZvmP/4LbbX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WgsDe6RIZ38IU4L2Vq12LcYJk+rMnfSxTj4jtQ+mCUlvGbAvk/ZS4Gxuwv3skb6htnIvwJHQ1kCgFYEudoNq0oO9G1GXqr4joYoK1du64g+W+Ebk1ETpZdbalt9IcYXKlw+he3m8WR6cqaaWtoTrz24UznTzW4fcZ0sJUI5Lpaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=sWHKl8YJ; arc=none smtp.client-ip=195.121.94.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="sWHKl8YJ"
X-KPN-MessageId: 745c291c-4e4f-11f1-89ea-00505699b430
Received: from smtp.kpnmail.nl (unknown [10.31.155.8])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 745c291c-4e4f-11f1-89ea-00505699b430;
	Wed, 13 May 2026 00:10:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=KFY+NLisTxw88P/4n/HvkB0xQgcjZ1+4M/U1TJ4/PLU=;
	b=sWHKl8YJSxV4UJ2M6kUuJbc2oOKpRMqhqJhPH7u+gVNf0CJIYDmIMas8GcJ+UBj+HBO8oo2IR2X39
	 2QrlO27qWd/3tDwB7XEZVyeRnIXiW63+ox5/dkrMhYOyIKItM205NbwHHrB8QCvhhmR/lR4Pq0Us4g
	 dgkmklt2QnnoCJUf5Fwou9Lw4zt/UwI8F8RitfnI7QSKBSv6KscbvgYrdlyQS9FfRGWt5sCpb5XHj8
	 PvOmMnK6Ae8c26hsea8Ja8C0i61BkrJy0Ipqi0alcrksW2PPAYg0nmBCP9cYs/nOSiO8YvrskMwXlU
	 d1VlsV6iYhNxeNGqajJ6Lhf7edPmUkg==
X-KPN-MID: 33|s0AxYYjSZj8Cir1UdRPTDQDefg7mHDpS4VpcwdRwuDmVtYbeOUf4k/moiX1d6ID
 W96I1/ggiNxQfshKlVFSfp1gHK2hlxt5KfHI4XbusdWM=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|/av9dgq7tIV2pvFC0vhxLDL8A6WmOC+tNflbBtXBGRSU/x+I2vyWfEFjWUYfkdt
 uVJ99O2+zS1Kom01dFCxkvw==
Received: from localhost (unknown [178.226.150.234])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 743aaffa-4e4f-11f1-9c0c-00505699d6e5;
	Wed, 13 May 2026 00:10:58 +0200 (CEST)
Date: Wed, 13 May 2026 00:10:52 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Abdellah Ouhbi <abdououhbi1@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, me@brighamcampbell.com, 
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] ext4: Use %pe to print PTR_ERR() in namei.c
Message-ID: <agOecLx8tAm8zwIw@lt-jori.localdomain>
Mail-Followup-To: Jori Koolstra <jkoolstra@xs4all.nl>, 
	Abdellah Ouhbi <abdououhbi1@gmail.com>, tytso@mit.edu, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, me@brighamcampbell.com, 
	linux-kernel-mentees@lists.linuxfoundation.org
References: <20260424152245.142308-1-abdououhbi1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424152245.142308-1-abdououhbi1@gmail.com>

On Fri, Apr 24, 2026 at 04:22:45PM +0100, Abdellah Ouhbi wrote:
> Fix coccicheck warning
> ./namei.c:150:25-32: WARNING: Consider using %pe to print PTR_ERR()
> 
> Replace %ld with %pe and PTR_ERR(bh) with bh pointer.
> The %pe specifier automatically converts error pointers to
> human-readable error names instead of raw error codes.
> 
> Signed-off-by: Abdellah Ouhbi <abdououhbi1@gmail.com>
> ---
>  fs/ext4/namei.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 4a47fbd8dd30..c0cabf172020 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -145,9 +145,9 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
>  	if (IS_ERR(bh)) {
>  		__ext4_warning(inode->i_sb, func, line,
>  			       "inode #%llu: lblock %lu: comm %s: "
> -			       "error %ld reading directory block",
> +			       "error %pe reading directory block",
>  			       inode->i_ino, (unsigned long)block,
> -			       current->comm, PTR_ERR(bh));
> +			       current->comm, bh);
>  
>  		return bh;
>  	}
> -- 
> 2.51.0
> 

OK, this looks fine. I do wonder if using %pe really makes sense here
since this thing never gets to be a pointer, so if I read this and don't
notice the IS_ERR(bh) I might think that bh could be a pointer there if
I'm reading quickly.

Thanks,
Jori.

