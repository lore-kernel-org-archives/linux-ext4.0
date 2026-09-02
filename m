Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AB5361DBE;
	Wed,  2 Sep 2026 17:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788370290; cv=none; b=eVYSjuZzaxHZtavrtTStDZHVVhbmnKmhm5I4RVHAWRCZa+pSD2ldycjnb7uFbfCh/J9oS2eU3jqV3O/pkL23kToQjwTkYbo9J//YGD4efplpHDTSUBqnpJQ9pkPskriQIIe2qCXGUZPiwvub/TWYttUbHoXfTgqvAuyqmxBp8wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788370290; c=relaxed/simple;
	bh=AeI3SjLAkvauDjKl3tD+y7hjEy6XY86wKPiB4bjeopA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kQyJJAcYC9mgKft5n2QdItq/jAkpgW/sHs4Vl0ZGFGFUdE2bSk7D2AhXrPgHQEU+WRiGBq6Z/Qrlv/fopxOExUrCMF2JLU5YAXuE1DC9LQVU9Jv1TMH6ie49bP36vkXdJI+0SENmJl1DsblBDCHAsHXnVkr38/6ppxqdeT0BQWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dO3jdndw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dO3jdndw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=hX8qibbD5PzBnhbueOeCOvtZ45adC0oK6JtciUg44RE=; b=dO3jdndwa3g1gGHdZSjrOsN119
	VxEq8vTuYNcuAdLzGNwWdhjyYFOVZGa6o2qFa4v9RMLckJaIRC1W1kOoN5nT8g7ufCApF34ndoeZ/
	Evqmwu2oNcMK7ND+I9526S8o1PweRsvbS23nDGS+svqGo4eg6dC5BfiGgdG4N1yYVNbE9UDcYlimq
	a+aasPh5MTEz2AtFlhNHSXFn7jO7wGvJlgdOPffLFgS5XKhVGhGWUT6QL787TqaGyCEUFLxc9SZo9
	RKcidPHYmdi1oKcgy+FJjgWSqxIQCLDYccDHgJYL8D747m9FBxYz22GGPHPKIBHrNLrzjRLKDnN81
	A0Fe3X0A==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1onz-0000000FRWk-3q1t;
	Wed, 02 Sep 2026 17:31:23 +0000
Message-ID: <01566086-6101-4e60-a4b0-5ef29d09ae61@infradead.org>
Date: Wed, 2 Sep 2026 10:31:23 -0700
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4, doc: remove unnecessary bracket
To: Manuel Ebner <manuelebnerli@mailbox.org>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260902143254.702971-2-manuelebnerli@mailbox.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260902143254.702971-2-manuelebnerli@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/2/26 7:32 AM, Manuel Ebner wrote:
> Remove needless '('.
> 
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> ---
>  Documentation/filesystems/ext4/directory.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/ext4/directory.rst b/Documentation/filesystems/ext4/directory.rst
> index 9b003a4d4..f3eeca844 100644
> --- a/Documentation/filesystems/ext4/directory.rst
> +++ b/Documentation/filesystems/ext4/directory.rst
> @@ -429,7 +429,7 @@ block (precisely the length of one dx_entry) are used to store a
>  ``count`` entries in the dx_root/dx_node structures are adjusted as
>  necessary to fit the dx_tail into the block. If there is no space for
>  the dx_tail, the user is notified to run e2fsck -D to rebuild the
> -directory index (which will ensure that there's space for the checksum.
> +directory index which will ensure that there's space for the checksum.

To me, it needs either a closing parenthesis or a comma, like:

   directory index, which will ensure

>  The dx_tail structure is 8 bytes long and looks like this:
>  
>  .. list-table::

-- 
~Randy

