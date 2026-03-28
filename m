Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E9519B5A3
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 05:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774675886; cv=none; b=XmIELiaL1GrIZlAOJ8W8OE8feMmGo0w1o+rPSHJNIycsAfg8PzVD+8YYuT+hXBHm0LHL5czQl/clVh+cnz3AhW9DjYZ5itdvGqOcJOr/Hz7sesv/uJNENCl/6HH//CgqWTuwURTuLW9s4G53tQgm1ZpqD2m/7jAbExPTj/ZLUnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774675886; c=relaxed/simple;
	bh=E0ka8+W3VTPT6KGB6FaYW18vwt2oq7hr10xeXU8I7HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MWh8/gMgXmBrqxlZjMDR4L4WAuzEI66+euBtUBwCLkmVDth2t9VxwJtS5yGedJhRvwIUQe+hATFvViZPGJDtsDX0ogrhwu3ywjMDms1Iiu55UlPXa1K/dOgqVIVc/gGRqS1AU6Xw0Q+OUJfrZy1GBR5qjMlt7jpmqR7YCZfqYYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=SoxKo2e3; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="SoxKo2e3"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62S5VFNW013533
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 28 Mar 2026 01:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774675878; bh=WIlJw5R1CNKV2QWwleowrV2wf3ILUtQV/UU8ArVkhuE=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=SoxKo2e3erHbA6FaTLklbuLHKjCVzCFlZHNtTdguhUMRJ4c64Xki+p/shf8+hYh4c
	 nZ+AqxpvjxX/VKwklpsyn+KInCF9xiNlwCEGaa7A2Zr3WHyCbr2wOaxwvQWzItpulL
	 adoAi2Krtur8twWIizpNJVlLXcMjPwMiKyO6jknvHCW7NPINY4osLnz0S65pDYx9Pk
	 t2SjGna0sNutaq+H0PIJuIBVgiriU3+npVIqo8MtVT9mezE9ubdop5MoEJ1R2auZ1e
	 89mRmH5KX64KzY5lvbi0odAu0P3r03sCx0IGgXKmjMMNOVihZHfwoIH4eqfs1iN0y9
	 8PhmPAU7KKYdg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0365E2E00DA; Sat, 28 Mar 2026 01:31:15 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-dev@igalia.com,
        syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com,
        Helen Koike <koike@igalia.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: reject mount if bigalloc with s_first_data_block != 0
Date: Sat, 28 Mar 2026 01:31:07 -0400
Message-ID: <177467585134.1335526.2873326767268319303.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260317142325.135074-1-koike@igalia.com>
References: <20260317142325.135074-1-koike@igalia.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 17 Mar 2026 11:23:10 -0300, Helen Koike wrote:
> bigalloc with s_first_data_block != 0 is not supported, reject mounting
> it.

Applied, thanks!

[1/1] ext4: reject mount if bigalloc with s_first_data_block != 0
      commit: 3822743dc20386d9897e999dbb990befa3a5b3f8

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
