Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55DD48FF74;
	Wed, 16 Sep 2026 16:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789576351; cv=none; b=OgFAj1ZB9Vdm4WPu0Npo5PFbVQWUlWnGMNgGAFhbWKstqRfDDg5fg0t/XN6Va92Xxk7LsHeEWhGKYVlCXdct7Wyz62hdu5l3EKUm2oTlg3t/azkmuemCMfVL84CtEoyx6GnKMAOQ5qTEs4nYQ3E+RBfJ7oRnSkzudI47CFS3CQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789576351; c=relaxed/simple;
	bh=WzXGglNQVOTmQY3/V7nXQ5QTkI3a/mwkPOJRADZYHSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IxGWLEg+aPxg0XKD8K3eZ90Z1OUKkjYdwi/y5AZEfYwjfLLY6W/ruMGDGPremjbr0cSlapSvPJYEWKMYlT0e39eQvo6uh3zSMyQhNirSlGPrzeFOZIU0lrUGWuHNWqNhRpAK/xh3XHC+z97WBjXUm139zmv7lpSwaLUC0cSFpXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E99ZSdn5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E99ZSdn5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=tmIphHeRA2nKyALzRWIY0v5eqHkCNdmZX159JWKJ5MQ=; b=E99ZSdn5Jv8h18MN6Op0wxTHtI
	LMKUe9mIaXDHW4X/MxzG/uY7ubmww5VrLHEMKqFbbk9fvtWM55dUkCQbBlyhVpiwOFKaJxjt568A/
	ZmcC5JwbBsyB27YnFfQ3IDwgBGz+NzZH8j8z+gbUWL4HhmecJpLVmj0Vzf50NJshQPEtWZFyOiOrw
	1NfxOLDnBUOnojCjnE/M+3Y/3Gyt67lMjZoL5cTlUp2oau+5CmaBwr6CXOuezI3DuhBZiI1lp6Iol
	QZxb/IPLECW08GGJ/vNDQ7WyXAOTaDXqlt14UBfiOVPkByqq51SsqS6k5giXz8JuwaudLeZYQ3qc5
	e6XewzrQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6sYO-00000009kPN-1dyu;
	Wed, 16 Sep 2026 16:32:12 +0000
Message-ID: <c49886f1-25b1-491f-9670-f072209c75ab@infradead.org>
Date: Wed, 16 Sep 2026 09:32:10 -0700
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ext4, doc: remove unnecessary bracket
To: Manuel Ebner <manuelebnerli@mailbox.org>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260916104251.296148-3-manuelebnerli@mailbox.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260916104251.296148-3-manuelebnerli@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/16/26 3:42 AM, Manuel Ebner wrote:
> Fix sentence structure to improve readability
> 
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> Reviewed-by: Jan Kara <jack@suse.cz>
> CC: Randy Dunlap <rdunlap@infradead.org>

LGTM. Thanks.
Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
> @Jan Kara, is the reviewed-tag ok even though I changed the patch?
> 
> [v2]
>  Incorporate Randys suggestion.
> 
> [v1]
>  https://lore.kernel.org/all/20260902143254.702971-2-manuelebnerli@mailbox.org/
> ---
>  Documentation/filesystems/ext4/directory.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/ext4/directory.rst b/Documentation/filesystems/ext4/directory.rst
> index 9b003a4d4..6d8021309 100644
> --- a/Documentation/filesystems/ext4/directory.rst
> +++ b/Documentation/filesystems/ext4/directory.rst
> @@ -429,7 +429,7 @@ block (precisely the length of one dx_entry) are used to store a
>  ``count`` entries in the dx_root/dx_node structures are adjusted as
>  necessary to fit the dx_tail into the block. If there is no space for
>  the dx_tail, the user is notified to run e2fsck -D to rebuild the
> -directory index (which will ensure that there's space for the checksum.
> +directory index, which will ensure that there's space for the checksum.
>  The dx_tail structure is 8 bytes long and looks like this:
>  
>  .. list-table::

-- 
~Randy
