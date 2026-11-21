Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795279480;
	b=nX6K2GXgcPf+LBwNvgWsvCYJoSyuqp442QuS/QmTUcuQsvPaR8wSFLloDZH6/YKITEKF
	 7Q/qEodydUAsncswz5sQEXc7VS7WiIt5HIz6A5C9FWFDFVoazeTYuNQfMEmuxbLpOCyLx
	 +ys5+9HdDMRNj+CRuBXqxGgpi9ygKUcB5gJW0cCOe3XN6lC9TOzbzIVlhOg7fQwx9UDwI
	 /3QMa+gnhw/8zJNdhZdzgTWPlCc4boOGbgpKMupdH/HnQdOvY7W1NAcjdRYw8FYo1Wsh2
	 fFy+sr2mIe7YGxWLiH/YEtCbcJYOvMwCnCRqrP5Nz+YrtVHyTFwGSBpiJOG+pvITIMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795279480;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=s2vyU3vFrC0NUh7tVrPidneeWbqOaMwhYs4Bn+HJRNw=;
	b=Ui5uyDg8HunPyzNCckSbeBizm6NzwDMWJmYh8UVZ7zfLjO1YEJaLDi6MzxZG5CWdP1jf
	 jlHB4Z81LzMWXJ0UL9pspgPzj2YuQcvOaVDQ9g7Mt982XnNbj3Dg9d+yc586H8iYKa7/X
	 Ybnme0+7qYkKGiVT6Kw1kgVpO7qAFNRomx/kLwUWbgCgvDLcbvpgX3fUS6BXcSBEDhCOB
	 tuF6yAEKMfVp2D61VR5yZFKCOGHfpiGGp+3ABmG9z9lrjCLZsvbiWGJZ2cVEWzQn4WJ9z
	 THTG2BCkVLwaMSPwj68pnFdSjHPx7eoc0Rl8uR7dBlGWaHiJtYFYvB1jMYz3QvZegPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V3hESoHs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E7E606A337;
	Sat, 21 Nov 2026 16:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V3hESoHs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802481F000C4;
	Sat, 21 Nov 2026 16:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795279480;
	bh=s2vyU3vFrC0NUh7tVrPidneeWbqOaMwhYs4Bn+HJRNw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V3hESoHsfIFyhVVUq9Nbw76xQwwdkkosH3PAFFajdKtfYnYXuEeqkTldM2EgmV8Ln
	 LIbBkNRkerRa94S3OuiWCZTIz4Kac2J+ex80ehWYjNrtLa2HfUOnCasVVO8kuhyzvq
	 6V+qjIS6H0ZYWKrZS5/rcX482eDlsXgr1sy81p5v5l2/vVRjhDriVXj0OP7l4Jn4gm
	 kD2+R0gCpirlkenGbmota9uaBoGX/m4gEkTLKWHVvsNWWTDpTQ7Jl3G0gwY0SUSG5e
	 e6SoDIGiQR6MUhB+BEsJAY2pYcctqVteeYe8eVAiIrTukyV1a6W3ykkfvJwVD5/e4S
	 jJiLvnXtpOxsg==
Message-ID: <f8cc1652-7577-4ace-97ed-081ecd65a031@kernel.org>
Date: Sat, 21 Nov 2026 17:44:34 +0100
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
Subject: Re: [BUG] mm/gup: WARNING: mm/page-writeback.c:2678 at
 __folio_mark_dirty on v7.4-rc3
To: Yi Wen <shicenci@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 Jan Kara <jack@suse.cz>, John Hubbard <jhubbard@nvidia.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <CAPHJ_V+_=Av8pAM+N+oc4JRmtqBjhcimh3B_pSy_N+5qecm6Mg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAPHJ_V+_=Av8pAM+N+oc4JRmtqBjhcimh3B_pSy_N+5qecm6Mg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/26 15:49, Yi Wen wrote:
> Hi,
> 
> I am reporting a kernel WARNING triggered by a syzkaller reproducer on
> Linux v7.4-rc3.
> 
> The reproducer triggers a WARNING in ext4_dirty_folio() when
> process_vm_writev() writes to a file-backed mapping.
> 
> The call trace shows that the warning occurs during the GUP page
> unpinning and dirtying path:
> 
> process_vm_writev()
>   -> process_vm_rw_core()
>     -> unpin_user_pages_dirty_lock()
>       -> folio_mark_dirty()
>         -> ext4_dirty_folio()
> 
> A second WARNING is subsequently triggered in __folio_mark_dirty() in
> mm/page-writeback.c.
> 
> This appears to be related to the interaction between GUP-based page
> dirtying and filesystem-managed folio metadata. In particular, the GUP
> dirtying path may mark a file-backed folio dirty without ensuring that
> the filesystem-specific metadata required by its dirty_folio()
> implementation remains available.
> 
> This may be related to the known issue where GUP-based page dirtying
> does not properly notify the filesystem through page_mkwrite(), as
> well as the interaction between GUP dirtying and
> filemap_release_folio().
> 
> Before these warnings, all four ext4 loop devices also report delayed
> block allocation errors and abnormal free block accounting. These
> errors may indicate an additional filesystem inconsistency and are
> included in the console log for further investigation.
> 

Hi,

thanks for the report.

Did you only find this through syzcaller or by the help of an LLM?

I'm asking because the timing is interesting; this should be one of the problems
discussed by:

https://lore.kernel.org/r/20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de

CCing Pedro, John und Jan.

-- 
Cheers,

David
