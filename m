Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C2C3CF97E;
	Tue, 26 May 2026 09:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779786484; cv=none; b=reX0X5obytfUaAe1A8zt9uLxUknHYZVH9MDOrXVbcsvbFUfC+3dGZsUPjnRDTDvvxIcqiNmnO8mSujjuw8BtGPnfPm7Apgm2oV0Pu370Atb9qbGUc+ABNZBv192O/PaMnCo9XOwTseirFfQmE6TwsUP5RpQ8TQWTdqi6oHuZ6Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779786484; c=relaxed/simple;
	bh=X6TpZOLSXA8qVc/rjxIu11TxqAw8DdSDhwJsuH09T2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RPvAtsE1CDghL4+nUlayCu2TndJCEsrxx3qFUlnXx2NfJq4eIBrr5lxg1uo9KTBUr7oDPH4lS7tFfse8Fp4WXi5Z/bAZCLZ6nqGkvr9oBQUE3RgRrbzM7WW8O0ZD4akicg/WsX/rxiIfRdkAMWk0WdsiWjJ4bHhESrCuwIPIues=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4L3b45L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4L3b45L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149631F000E9;
	Tue, 26 May 2026 09:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779786483;
	bh=E3IuDwl5tAtYnNYkYj5j7d2B5Zm0rnZXXNK3MzgO93Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=G4L3b45LFb5CO2u5R9Xl1xJap9aVa2z4PbrjWu9gzdpgVl3R6PRheaisHkyrfyHQx
	 dXzbsRqjihGstXmP/Td2LoRgR3SUK4F6b0oSJNJnPrcnVY7Y8hrScVRpORFN1GEPAe
	 RssppEmMScBipK+J3QXGKsIpJai+wRJNjhgBZzfRHjmq/KowXqlG1AzkoN6OmaAq6C
	 3BRlvSblC16VsL9ZP1cyJlu7Oe5D7Qk00murP3NMbysRTR5VIycOTMIFtnq+PYOlBO
	 6VH74RHZxyggGk7WkIpssO1Q+wV371Vi7IMRgKr5mtm0pGtIoVAq1IduUHHyFgJ/xX
	 HyDaQ/sUhpWGw==
Message-ID: <3cc6d65c-d5c9-4cf1-9d1f-a6cf05de11b5@kernel.org>
Date: Tue, 26 May 2026 11:08:00 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] jbd2: Remove special jbd2 slabs
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Mike Rapoport (Microsoft)" <rppt@kernel.org>
References: <20260525201321.21717-1-willy@infradead.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260525201321.21717-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/25/26 10:13 PM, Matthew Wilcox (Oracle) wrote:
> When jbd2 was originally written, kmalloc() would not guarantee alignment
> for the requested memory.  Since commit 59bb47985c1d in 2019, kmalloc
> has guaranteed natural alignment for power-of-two allocations.  We can
> now remove the jbd2 special slabs and just use kmalloc() directly.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Nice!

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



