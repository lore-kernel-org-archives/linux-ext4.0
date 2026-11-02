Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640259;
	b=2qFn+DYIwNAliGUywPMY19ZWkYwYMez/hodNayfeEv/CyDfGI6+bsZ+/GnU/mlJ3e5rb
	 7EplpAO8wXBPSCoBmwWnYnzYa8VpeZtQGxsRXj5nFgM7F8xam3aHz3BFt3J47OJ+yMs/3
	 bQOxzSfFb8fBfKGoX3K21M21Il5iOycWoC4PfdKs9+6Ve3POnWmm/oGrTC5a9XmuLhI/+
	 rwVHR8M26cOcFQrZ8MJ2tiaT3FO4WXaUvq2L9OYy9T+3+Y/aIOFtnC6mNWVLd1Z+tfXkb
	 KZ1iOslB8Ev3oyF3R35gkzrazZb/GfowVUkXUnG4VROnG7n8GPFXHNGi2msGUq+yhdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640259;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=BBwVsAGDI2P1A8Xz+TjsiWaX1Q+VUcv4TW1ekog7gog=;
	b=WQZYylYUhCv37wxJK7HX+ruwbJLieSnctyYcdMdH2E6Uozy/D7Euk1HiRTvFVt5t9Lpc
	 QVJwSgHosMRAWaDKIxhTCHQGnagjdErtrSCZAY0cJAlG3GZcAFiZ3Nx/51i9eNG+GeLnG
	 BFV5GSyQoOpM9HeXMCYDfSebNRgLiZ7jKmZ7QSYnlEC5vPZv1EK5wC9SYQASf2C5tqIwp
	 0bwRXQv/dnBLqCpbtIF3texdUC05A8tuxnLuTnSOuQasqNgrf5CP+voBOETDNdXv8PPdm
	 BET0gOOibhtodkPsxsyskgTT2aBhpDugmY/jreSBUrUNSJAgekUBoy/hJLnXcGMDD/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b="Ny9x/sna";
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6536B606B907;
	Mon,  2 Nov 2026 17:24:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6536B606B907
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Ny9x/sna
Received: from [192.168.1.70] (unknown [4.194.122.170])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0090020B7166;
	Mon,  2 Nov 2026 09:24:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0090020B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793640244;
	bh=BBwVsAGDI2P1A8Xz+TjsiWaX1Q+VUcv4TW1ekog7gog=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ny9x/snajR4zT66QEVZqO52W0eHruSPt3TFkBD8xarvPIvaqMl/iFPnPggCvN4Ds6
	 +/LcieDxmQqtzktl0ypU2/GTpoT+v1vOU5Lwjmr5Hxd6DZKXHuvTWJZroZun8PxVYa
	 nto8Qxc5tXEeLmU3XWzeJfASzddzgvUbP3Icqob8=
Message-ID: <f81cdcf4-2e9c-404c-a698-448873b8edf5@linux.microsoft.com>
Date: Mon, 2 Nov 2026 22:54:13 +0530
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1] ext4: honor NULL returns from __filemap_get_folio()
To: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261102163341.2170232-1-namjain@linux.microsoft.com>
 <aujDuxgeH-TyEsXh@casper.infradead.org>
Content-Language: en-US
From: Naman Jain <namjain@linux.microsoft.com>
In-Reply-To: <aujDuxgeH-TyEsXh@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/2/2026 10:39 PM, Matthew Wilcox wrote:
> On Mon, Nov 02, 2026 at 04:33:41PM +0000, Naman Jain wrote:
>> The bitmap and buddy folio conversions assume that
>> __filemap_get_folio() returns error pointers. In Linux 6.1, however,
>> it returns NULL both when a non-creating lookup misses and when folio
>> creation fails.
>>
>> A cache miss therefore passes the IS_ERR() check and reaches
>> folio_test_uptodate(NULL) in ext4_mb_load_buddy_gfp(). Creating-lookup
>> failures can also dereference NULL in its slow paths and in
>> ext4_mb_get_buddy_page_lock().
>>
>> Restore NULL checks at all six lookup sites and return -ENOMEM when a
>> creating lookup fails. Preserve the folio locking and migration checks
>> without changing the global filemap API.
>>
>> Fixes: d34e4fd4e73f ("ext4: convert bd_bitmap_page to bd_bitmap_folio")
>> Fixes: 862483175d3d ("ext4: convert bd_buddy_page to bd_buddy_folio")
>> Cc: stable@vger.kernel.org # 6.1.x
>> Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
> 
> Elliot beat you to it:
> 
> https://lore.kernel.org/linux-ext4/20261102-ext4-ntfs3-null-folio-v1-0-4fd91ee23a4a@elliotjb.com/
> 
> Care to drop a R-b on his series?

Done.
I actually checked LKML in the morning for this :)

Regards,
Naman

