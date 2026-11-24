Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795530024;
	b=ZdFhWjYVrzKU5G509ALcAJNAVNHgxjglzyTipAJYglNehbE2wDH9aJ6TX3u0Ddcf5rmP
	 rL6SlSIXe3Uz22gd1l1EiEZbA6xuPXz6E5nFptXCIOAsxSmVJwX+sENksKDu1wDRAQoXr
	 nlWECVmfLpVY2MEUzDCtOr2PSAMPtDoZVdrxTS7zGD82vjXiL8HPzV13kDb6k1QsoNiBw
	 8UE8s+grVHaB7lAx+UeBrcjjEqiNF1lO3IyjWVsGJNUoYN2BHhMHC6Vrvc8k6u+zkBN1Q
	 LsyC/ErE95SxVCB+xxeyhVfKKG40JNkLLjN8Q3GTxbbrgwMK9ImUNFPi/i6HGO6VXUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795530024;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=U8S5nsZyhJNFS2TSo7fXNLIdGbaMnfEx5BvA7cV/x+I=;
	b=sFmzqtbg0zllWQjxyFwabBvg4UIzI2PQrdn+eHWkpRjRAVUoWPfb7Ltnd912KX7D5GK/
	 R9szwqUaHXMTTc/paxDz1qEoI+/aqJv0ANtJnxZA28apiuQF2q0YSYONhwNf4XExMGoQH
	 mQE/OmmW3Doz8XgRxoa/BYiI8qfvftY3ZyEH/l9iYCdN12fJqHMKvE9+0VVIFv4TZGQ7+
	 R06OSYcsaaPekmyDznJy4foUQX9FTgX9CzgTjkeu2SW3KxW27/8SV52iAKnn+cZNbjgZE
	 5w46Je8G3zRKH3xJkAKGC+CJFKhcQJkHyOszota/rPFk+HL1tSEAamxkGPRD6UwCCHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvafBuQJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75549606A31E;
	Tue, 24 Nov 2026 14:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvafBuQJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F851F000C4;
	Tue, 24 Nov 2026 14:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795530024;
	bh=U8S5nsZyhJNFS2TSo7fXNLIdGbaMnfEx5BvA7cV/x+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lvafBuQJWmRpZmeYJb0UsL8ws6VHwgVzANePzlfezF1Llc4+9DiGoI8eqr/AMjhcJ
	 89LQ3LpGeSR+l9qee+jwPQgs/lo3PV6MK1Z29Hh1e7DEr5J0l4WQOVfSkCobbOsqqN
	 U9yHldzpd4EJZwZMwUospDCDaXPv7NJvufAHOUt0=
Date: Tue, 24 Nov 2026 15:20:44 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Fusong Li =?utf-8?B?5p2O56aP5p2+?= <fusongli@ieiworld.com.cn>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	"sashal@kernel.org" <sashal@kernel.org>,
	Edward Adam Davis <eadavis@qq.com>,
	"cve@kernel.org" <cve@kernel.org>
Subject: Re: 6.1.y: missing "ext4: avoid infinite loops caused by residual
 data" (CVE-2026-31448)
Message-ID: <2026112424-idealness-sureness-6d9a@gregkh>
References: <JH0PR04MB74644C65BBF68069425C8B8392442@JH0PR04MB7464.apcprd04.prod.outlook.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <JH0PR04MB74644C65BBF68069425C8B8392442@JH0PR04MB7464.apcprd04.prod.outlook.com>

On Tue, Nov 24, 2026 at 09:50:37AM +0000, Fusong Li 李福松 wrote:
> Hi,
> 
> Upstream commit 5422fe71d26d ("ext4: avoid infinite loops caused by
> residual data") is in 6.6.131, 6.12.80, 6.18.21 and 6.19.11, but 6.1.y
> has no copy of it:
> 
> - c66545e83a80 added it to 6.1.y, and 9594622f8a39 reverted it in the
>   same release (6.1.168), together with the "get rid of ppath" series
>   that it was written against.
> - v6.1.193 still has the old code in ext4_ext_map_blocks():
> 
>       err = ext4_ext_insert_extent(handle, inode, &path, &newex, flags);
>       if (err) {
>               if (allocated_clusters) {
>                       ...
>                       ext4_free_blocks(...);
> 
> 
> 
> The fix does not depend on the ppath rework: on 6.1 it only needs the
> condition change on the old API, i.e.
> 
>       if (allocated_clusters && (err == -EDQUOT || err == -ENOSPC)) {
> 
> Could this be backported to 6.1.y? A patch adapted to the 6.1 API can
> follow if that helps.

You need to provide a working, backported, patch if you wish to see this
applied to this tree.

thanks,

greg k-h
