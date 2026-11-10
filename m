Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794339846;
	b=4btNE/5zG5lgwe+AbPtQOxF8FnzU/93C7IyzWmuDMf1kiiQx9amYc8x44p151ENCYIFq
	 yfIRTjZxaEnoUEC1ydakezlXNGnqIB+2CHpvix8HrxFhStd+udf+7T6LMm4v+Jopn3JRt
	 0dCQwj64NtoplVPGKdQhuxbdV3YCFJhdJSDnsfojHC4iyXMPhuCFXgq9jaEHRo1UtfnXC
	 FmyDJH6/Gsx5CHuORHZTj2gfQKHxKO5lTG4BR6wT+lbqjd3+Lki3tilDjtAr3H5zq+3ip
	 yvFLa4wbviDFwHUZlh0jigp3LwD2LgGaoFpcIZvnZ/JDD6hL/mt6/Ht1fOlkT0wabhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794339846;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=KPnL/mnp7A0ULLFZ8Tm/YNV7A6CH4m+3DtWZvUlkDdA=;
	b=dFWu/g4IQwpWIyJHNtrC44frKAo0sb/ArgsIhOCWhC1QuuN4iM8ZOoptLTqMMQnGw4PD
	 tgAhLrtMcn/9G7NV2ZZ5bhkGp41wfFI3ouAV7WFrjE5inKE4SbVQMtmo5DU+pv0jIK7lr
	 O5MfGYGx2HvUSFtYBT+3JdBQpGl28ntAvo3Q8zl8j0IPCKx320pmi1xwC7vrynO/9KFg+
	 +LPzBkLZBBl2fSVuAuumOXlr11YjTaYA37rtFhqjRUON9ByBYjhGbLX4f3piObZXOzdWT
	 4PVVIxmIFayoVvpH1LA3/qv/qPCCFgwBiVts8q/P3JoJdC6ojIx2qi+QiLd4BtNnusg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=URIY+dDo;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36843606A31C;
	Tue, 10 Nov 2026 19:44:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36843606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=URIY+dDo
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KPnL/mnp7A0ULLFZ8Tm/YNV7A6CH4m+3DtWZvUlkDdA=; b=URIY+dDoVUJXttGdGxzqOwLcKx
	9rlobrUw5L5dQU6DQQv2NOpfNVKvldh2HxCZ2cQFAfl2BgUjSYZPrWWs93+dZBGcLTQGzKlQ0tKPp
	861ACr33uzlpSHD7EfhABkxg467jCfbU5AlFVNOHgculPX66xPBlfHFbx1v0uvLVcRK5ivciKdIVx
	srCWFMYojQNUKcuRJ+4u6QZeAwhEUajboCkYQuY8VSeMt/l35BTf4PLwBE7Xj1s530WXLDVZOq8YC
	sH+JuZix8huivEvljhBCqehYh7hbjhsL8R+CajGqVqOtvKbMv53V1YLSPHirjnY7Q4OFkJ5Ixqeko
	cXIh5cwQ==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xQrlC-00000000hLL-1RMe;
	Tue, 10 Nov 2026 19:44:02 +0000
Date: Tue, 10 Nov 2026 19:44:02 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Aleksandr Panfilenko <lexpasss@inbox.lv>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] ext4: fix NULL pointer dereference in
 ext4_mb_load_buddy_gfp()
Message-ID: <avN0AsI3MM0XLyl0@casper.infradead.org>
References: <20261110193711.3106773-1-lexpasss@inbox.lv>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110193711.3106773-1-lexpasss@inbox.lv>

On Tue, Nov 10, 2026 at 10:37:10PM +0300, Aleksandr Panfilenko wrote:
> We have hit a kernel NULL pointer dereference in ext4_mb_load_buddy_gfp()

https://lore.kernel.org/linux-ext4/20261102-ext4-ntfs3-null-folio-v1-0-4fd91ee23a4a@elliotjb.com/T/#t
