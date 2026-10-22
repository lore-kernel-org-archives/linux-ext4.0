Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792711359;
	b=3Flf19m2pVFDcnngh7K9m5gJhLR6YOrPpURnedEvnN7VOBB9W5+8eLlX6i8BFCaKvhgK
	 Ew06UsSG3Yn28falAbi7URLne6C5cq41wP7gBhse8L5TldaNqY1iAyksVZHQey0bgfEJa
	 JbHdAZ67J6EQ0GKYO68jpWRagEOVmdKOaXLqrSXdqCRFFOHmeISip9V/UgwQe6IESbt1I
	 fr9uNZMKoDqJA4kl9EGlr06vDCSmQ702fxeiF5zvz0GkL5WRMVikvffXC2vPW6Edsi3rl
	 CyesnyQzsuTxKccKFtngi1c1NR3meaOWhQ0aznYfrQwh2rKUvte4uur4YhAO8omCVzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792711359;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Content-Transfer-Encoding:Message-Id:References:To:X-Mailer;
	bh=gXTTzdAYw5usCLkdrB3YykPUXiI6tN2n0TuuaI2M860=;
	b=3hWI7UXoJ75YebwZ3mfC/EuZZ2d1jHAuq6OeXlhLBdM4+x2jwFS3Vms6DhYOI7JcHvkS
	 tkZM+gE0SqEWjDB6hJ91NhqdE8noeDORnhJhsHlpWewRwClLE9sbXNzleRQPN7st4orWv
	 QWkHA7tsfIX5nJaZHD8CqNV66yqW+rCjveE5FvDs7IrIaOEW3kqd1CDG4EmZKY2Jy/QJY
	 RRlPPK0ePqfnD8Zr6P3rW/tYK4owFGH//qOy41mwcImAyds4KSC1n9eFsXg18JrIXuGvh
	 hwbt5L7tKDCWfJed0yYioTZJixfjKrGA9q0lhXqLESuQ3IYMNh0UvLO1mHOGbvN7TBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dilger.ca;
	spf=pass smtp.mailfrom=dilger.ca;
	dkim=pass header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=HnrSCOmS;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6179E606A319
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 23:22:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6179E606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=HnrSCOmS
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e831e86ebfso1513715ad.1
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 16:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1792711358; x=1793316158; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gXTTzdAYw5usCLkdrB3YykPUXiI6tN2n0TuuaI2M860=;
        b=HnrSCOmS0Ukh005bqiUOJRmz8QKPpF/jja0tisLntEzBJKA9K9ElWja0I52Y2ubqm1
         uTy5A7zOrlAk1CFjEX0FpVXw4orD81ad8vLU3fXI2ehXc4LJiJSfGu7bjoVVf/KcUsoM
         EdAAJ8e4hQIJT7golWkCrCMn2C6s//dB0TUspO+o4DXDqxssrZUZcRLFoHf7i25RhwCA
         Fqbu5MNIrJrtnQew6doXXiGxjBihzfTpz61q/8IY+UeoQG5fUeLjj4SaY0JyXWWNaJe9
         ZVl/JlXQzf1QBPkhaHWEhAyG+AdV4EPFpOlVkdpqsV30ILphovN+jS0pYyopoZmvLRGv
         evrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792711358; x=1793316158;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gXTTzdAYw5usCLkdrB3YykPUXiI6tN2n0TuuaI2M860=;
        b=W9l8pot78qek46iB4ig39mVXhtJbwa9DN1YlIeXUg28ecWRB/9kMSozAQBNqSrelyw
         IpeoNCBnqSc8VkYIsbIUPkl2CKAeelacng0qPWoEZnxWnJuSKHiHJiiwY7S6KUtjf+aJ
         0iPMJ4vHFcSUvmkuSpVE7LhMIqQ3n2RlhUqWgGk2cZy1VQ2V3rzAp4BNhl2F5zJMFp63
         h4vDWUKXvPCKcr1sgv7YS853/DaWc4gWH2IFyf3kb6SX2uSU8fZvSxH5zz8CYwIvhvBN
         /ph6K2WNZhMUWREylmBnUx7zlSVqnR2kwNS7tj7YR69ue3aqIOGKwsPsSysKVT0RNxa6
         X/PA==
X-Forwarded-Encrypted: i=1; AKwUvByKgjJ3K2v8LpdRB7G9eDVRxLoWbXcUh566g043tuOpCmNdh8wgAT1Yg/jq0AhBBapHb9+uHYuSlunF@vger.kernel.org
X-Gm-Message-State: AFq9FYLknEN4mtn6ase5Db7jBNV2lILigQ03Mv1PvxOgIbr5Pfx9XGEd
	mhrBe8WBH+ntOBvG2PnWmRrRWkQGVojDqc3QjxbgRtKpDjvA16v8MMbEx4ih00JfrFfRkWc9RCP
	nZJiJmrw=
X-Gm-Gg: AYBFou1Oy+AXkhE5DYRg4CxvqiTk7DtMto4Q4EY60SyV39Q887wwKpZTwl+bGF0XkMF
	nGf/znuQe4NDZOO5gQbliA7bKndPaeZqdkSU1klx+SFiD9HwmS8LpoRXKj/JHIObKsnm6BKYMIu
	9NmrlhKSDLZ+8ORcDfEm5NrO7uWVSsWc1xl04Y3+DMh18nqt8In/pnvZO1Q36ImM+StO4VUD50E
	9eGJBQOKHNge2TMCmQTDefRuFJi4farO3xVFrkgYIJgBW0Z/FcVL91QxTVbQkAmKJrtmYHw0zFC
	89BRTsI9WnVfz9dHKHhnIiWAfpg3RQ8Cbkhjgs5JApgv/dFelvZK4+0EyiPLwZiqqP3vVS5PvVO
	2VyfhOal3W8gpiy4bnj79TGJYBupjEo6qSALAbGhHQy7MirescYpu4JGDiyFkt9s/0voDmbncKu
	wqf3fUztiRITqDcjeQM+zFRTqBA6gjus6aPynGgHm4CBh5PrQYtPGVvYZup7FoFkc/eVDFviyb3
	Pq0raBsJ5ox+FdET+kmutxGRnb1udidWrtrDlmX0OpKxFJQ2dTYulMi9pe1rqgWMHxw/Hamxg==
X-Received: by 2002:a17:903:1b4b:b0:2e2:be61:a882 with SMTP id d9443c01a7336-2ea7d0c9533mr5798835ad.11.1792711357678;
        Thu, 22 Oct 2026 16:22:37 -0700 (PDT)
Received: from smtpclient.apple ([199.7.159.80])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7b3bd5a4sm3423535ad.53.2026.10.22.16.22.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2026 16:22:37 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.3\))
Subject: Re: ext4 data=journal deprecation: long-standing industrial use case
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <AM0PR03MB57141FD8462BD0C6D075863DDE672@AM0PR03MB5714.eurprd03.prod.outlook.com>
Date: Thu, 22 Oct 2026 17:22:31 -0600
Cc: Theodore Tso <tytso@mit.edu>,
 Gabriele Moabiti <gabmoa@gmail.com>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8B27CFE7-E4AD-4679-B772-6473C3849964@dilger.ca>
References: <CAAbJaeALOrZwWs++mz9Wv0pfvyDoHmfzPKyVHR0v6TwnzLkYGw@mail.gmail.com>
 <as0U-lfet5slrD8o@mit.edu>
 <AM0PR03MB5714FB8241C13A499E7D5155DE982@AM0PR03MB5714.eurprd03.prod.outlook.com>
 <4FAF6F56-F054-474C-8538-92D8309FAC08@dilger.ca>
 <AM0PR03MB57141FD8462BD0C6D075863DDE672@AM0PR03MB5714.eurprd03.prod.outlook.com>
To: "Korber, Markus" <markus.korber@anton-paar.com>
X-Mailer: Apple Mail (2.3864.700.51.1.3)

On Oct 19, 2026, at 22:18, Korber, Markus <markus.korber@anton-paar.com> =
wrote:
>=20
> On Oct 19, 2026, Andreas Dilger wrote:
>=20
>> are you running with delalloc disabled when testing ordered mode?
>> That might be the source of NULs in recently written files.
>=20
> No, we did not explicitly disable delayed allocation.
>=20
> The data=3Dordered tests were run with:
>=20
>   data=3Dordered,commit=3D2,noatime,errors=3Dcontinue
>=20
> so delayed allocation should have been enabled with the normal ext4
> default.

What I mean is that if you *do* disable delalloc then this might stop
the appearance of NULs at the end of a file after a crash.  The normal
"ordered" mode writes should sync data to the filesystem before the
size is updated in the inode, but delalloc does not do that.

Cheers, Andreas





