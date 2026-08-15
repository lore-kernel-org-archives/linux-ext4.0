Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDD634B682
	for <linux-ext4@vger.kernel.org>; Sat, 15 Aug 2026 01:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786758318; cv=none; b=OrLDIlQOUMObcKPDbdsRRmr/18OSahd7c1DG5SSM81tDIWvNCiePWwomYcamVpmPop3Zz3XlGWfvARyrs/ZxhD+NKr8KhFZdhy5Uvih2mwhoW6PxMUUKZJPSDbXMzUjBp39fW+Iv53dxL+coZZOFNH7VFcL60+MoMjVZ0bRVlmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786758318; c=relaxed/simple;
	bh=4RIoDeHBVOD+kLksU++uG1J5IlT4gTIBM1eF5JyadJs=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MOYo3W1eb6Tj+nPLZZBq/wW2qfcNSrrzLqSUTG4m4DjZ7eOM2TYyunLC3VwkyQk/UQ8s+EJRCe8X0bA4D87LG9dMEX8xaLb7l3HBAIJqmpaJFiaHTKSihl/Q//kjudC4HrnLZnVfox/8v1mi8VYX5s4tXdjX1ppH7VTLCaQHd/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=XbuAHLoW; arc=none smtp.client-ip=43.163.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="XbuAHLoW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786758305; bh=i++KO7NMWMmnoixRRncNWNCa82uvXhZgEVMgd4sQtYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XbuAHLoWG428tPcXyGylMCHBnj0yBhzzqrH/bX/UsLux7yhV2fxDC5kwoTVkr7YC1
	 Qm0GvHdaW03ftkgtzNCJYqT1wOXKi6WnK0hmHQnR1/b1h97geZYxWBk+NJYXeKUTQ8
	 oGchqzqCsS4SntlIt5lVIHtbd+2FwcFpeDMWnvgE=
Received: from DESKTOP-AT5F202.localdomain ([183.242.132.32])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id AF08EEC7; Sat, 15 Aug 2026 09:43:48 +0800
X-QQ-mid: xmsmtpt1786758228tya888lsm
Message-ID: <tencent_7A0B62235E38C5907A080BE3D56A59C9FD06@qq.com>
X-QQ-XMAILINFO: MllZffuBkEb5Gw6hKu0AUwmtEt98tRR/olwfps2Eo3ke9ev6KONhi4JF4ud8v5
	 qHTLRbRPYQB8ePU8HUdWZ59hSMZNrA6mXnTkkGoP08bx6ZjLohDZ1ULJikmmiZKXmUB6W9xfheH+
	 kp499jDvOwLpw2ZIWQFz0BGxW9hYiO7+knKIvI2Kne8AFm5xVdFt+985cK/bEcnDyCDgq45M9ncI
	 PS79+dplz+VsP1XhXi7gtemqC4Fks5MKy30ZOpRgd5vj6LVFrizTe/w5yF3w+YuAUbUMezXMjcWD
	 z/zrRne/G+7oeuqc0hR03g/7fINJdsWngdk1585mYP3sa+tk6Vb5TnhyhpKolN+8gYlUmBESY/hT
	 AKPSVqqUwFYQSe2cq58uZppH63aEEeAwnjhi4KAfMQb3DYScg0KQi9fBq5pRb4wjbIIop6sQA9oX
	 qmGWTONY3x0ehHTrZmXrUEw3xPlgj+EAdwRdu9JjDhwOVnPRBRj/y8GoWe3HFJ/ZNpMD36EV7xiX
	 iRh9QX2i+2su6BwmqYleXMDSdgNgAm184L50ubOhpVIpjhOgpAYCe0Uc62vlNvM1vIcFmpiWk9ax
	 JEB2zBgh4SrUoaGkZ/5gUiGa7LyAAMLR3JbusL+TCyKUiC09ZXokIY5tOZKBqaZ7rIJmJdcxCIJA
	 MgmmsXRTzSi4cL2VDPD06AR9zjJ+YgIVRKZTReMCAhv/ZNAx/pVFYyVI1t2HZYLSL5nN/IlrWZ0z
	 bl9Xftl+trmyfa8SHxy5dsFLw3hmdd2hBBgupW51klQzkUFTRoHd5LhwiUBbDXZT+UxeczYvCaee
	 r8HKSoX5s79WG7I9WP8bC9/TYuVSvpCcryQdbTOE5OPfZ39mWQ47MnAcQlJ/2H7yamD9nvk21jVt
	 0IUDPntwcZZYPhkqD4rfpwPhQ5D3Ci+84SgoVSsRYqn9F1ChnxU6Ziiwc2c5oTrLdyYS+AVgRU7/
	 f1wtGo5XBYD3KpPW8pujDIJxy0HC/OUt0asJutJwrk4cHdb+dg/DpNSftKWUrruXvFVKKoTAveE9
	 +4BkgMkyxtCdI9+e+bUUI/xpRjHts=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
Date: Sat, 15 Aug 2026 09:43:49 +0800
From: shuo chen <1289151713@qq.com>
To: Theodore Tso <tytso@mit.edu>
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
X-OQ-MSGID: <an_EVRqm82PaTv1o@DESKTOP-AT5F202.localdomain>
References: <tencent_321031C6B9D5D092C8978B46D9F0BBA18607@qq.com>
 <an5_shcksPF6uIaW@mit.edu>
 <tencent_9121249A3171F5A424EC25B7912A3C794805@qq.com>
 <an8ejrZ4Q-xLShzo@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <an8ejrZ4Q-xLShzo@mit.edu>

On Fri, Aug 14, 2026 at 09:57:33AM -0400, Theodore Tso wrote:
> On Fri, Aug 14, 2026 at 04:40:02PM -0500, shuo chen wrote:
> > Because ext4_convert_inline_data_nolock() has already called
> > ext4_destroy_inline_data_nolock(), the inode is no longer in the inline
> > state. So we need ext4_create_inline_data() to rebuild the inline state.
> 
> There are other ways to restore the inline state than calling ext4_create_inline_data().
I get it — keep a backup of the inode and restore on rollback.
But I prefer your second (safer) approach — allocate first, then convert.
I'll send a v2 following that.
> 
> Cheers,
> 
> 					- Ted

