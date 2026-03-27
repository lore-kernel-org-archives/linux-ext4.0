Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B4229BDA2
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 04:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774584399; cv=none; b=Ej3m9D+gHv7oY/hoXf7azAQdjT+rHjGTGiYi0WGecXJ3VeqaeH7rF5urKDcz2PzPofQeOk+DU3XIOt28JknWPhwTnvPMIgcJ0HwlEPkvJf1Zg6Kc8un/LHdDJDyLWKa+issnrq+VZAnmozLwV22Ur69UwsWiHjmfXkrb3uAi5aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774584399; c=relaxed/simple;
	bh=6Ry3dwQKdKT1UZsppqj9jQFd7RwLMTKdZKDRiTLMAms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AdSsjmBBUkzml5zz2QaWPIWMuBXtVlCeJAQBoRUSTzmxaS66V4OQMIYSTX0rPlc+711KTxBwcLPBacK5/56WPEE+vocP/lrS6/ZD5jEYQ0S7k9d4BLlwhQtyQmd35Qmr1vjt3Jf02Ew7kKLtRZKxhulpxHQb56nhFNpASpPBPwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=h+lNBiTX; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="h+lNBiTX"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62R46T24005940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 00:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774584391; bh=IyIBR42sDljg0//cWnCu3p00OdjhYIj0KKZl81kDHDs=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=h+lNBiTXIwUzDGBuI4LaL7CFvF6lbXW0SeAM51PXeneenN3nIloJ8tT8G+l+x8dV0
	 c3DlIoL0RpmiSRICEgBJuohzQAQjn79BTRWqH5sDiEjmxgBqKWpUNMEE/43Vc/1iZk
	 HQNKDjDG/Zqxm4B89kY3o5OTz3oJgfLYci3nb9n+tiuzNTHUWtnDGR7cBkSSZ2YQaF
	 k5KT8ljT/ejlVrZNqsTYhHbvD5UC99cLbsQHedeLwRNoKhKpu0shWdEB1hBx1Lu0Sr
	 w1FmmnTFoj3UhdwzEBPov+Xuz5NgqPInlao5dMJk3PLB0zfuaKXk/0jkYmzKC4g05w
	 5yDApNJ4Gj/sQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4C3192E00D4; Fri, 27 Mar 2026 00:06:29 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dan Carpenter <dan.carpenter@linaro.org>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: [PATCH v2] ext4: Minor fix for ext4_split_extent_zeroout()
Date: Fri, 27 Mar 2026 00:06:22 -0400
Message-ID: <177453546542.1226823.10157595996055874126.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260302143811.605174-1-ojaswin@linux.ibm.com>
References: <20260302143811.605174-1-ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 02 Mar 2026 20:08:11 +0530, Ojaswin Mujoo wrote:
> We missed storing the error which triggerd smatch warning:
> 
> 	fs/ext4/extents.c:3369 ext4_split_extent_zeroout()
> 	warn: duplicate zero check 'err' (previous on line 3363)
> 
> fs/ext4/extents.c
>     3361
>     3362         err = ext4_ext_get_access(handle, inode, path + depth);
>     3363         if (err)
>     3364                 return err;
>     3365
>     3366         ext4_ext_mark_initialized(ex);
>     3367
>     3368         ext4_ext_dirty(handle, inode, path + depth);
> --> 3369         if (err)
>     3370                 return err;
>     3371
>     3372         return 0;
>     3373 }
> 
> [...]

Applied, thanks!

[1/1] ext4: Minor fix for ext4_split_extent_zeroout()
      commit: 8c187915636da75f6223055d9933444cfa0cde83

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
