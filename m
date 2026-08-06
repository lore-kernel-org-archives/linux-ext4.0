Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BA1376463
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 15:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786028486; cv=none; b=Z+gap/4cqxjPLFkPkN4w+mgOUjzmKe41QYTa6DuidEW3/HCohTA/qybONszbi05vlOB53eHDnJS+SLLfaUY90cK5Q5FnVMrZQGUGNz9ff+HAYI6s1OEEBPVjTtGWWzAlOcjFsFKFdPX+Ft4QJ4XfvYpbdP/WciKZ34qM4UL8Rac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786028486; c=relaxed/simple;
	bh=UjEmRG7guv/+vR2cp5PdnnwOKecYToBGyU0GtJLFbGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HMp/V06UMnXSiT8/jfF6NWUG0dvLJ/32ElodZnXMScZSdKWwtg+o1zQm7O5ZDVnDcbyLT0H5ke5JINnouBuvGgskPg2K3RtP/nghwe3QYerecsrpYem0kaDiNIRAN+PXypex47tOnUAwtceWkNTJGqVKVJKYJVKup9uYRhrXJV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=QFBuk+S2; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="QFBuk+S2"
Received: from trampoline.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 676F16H0011299
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 6 Aug 2026 11:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1786028467; bh=aNS7uXu2/z2euSDzIvTlHAF5Bwcy9438i0NkKz9+SSo=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=QFBuk+S2e5cADnwDsDmTsJGKykTFNEX94Sk9qTZnmOdqogNVu1pRoaVw73FcXnStc
	 Y0c1rLGBKO5iGWglSr0aMUUAWr3d4P4lohT0MNFxxAVv1zEeH24tA+kP/B3EV4Im1p
	 CokxR+tpFa0P9aWp+5kebagBOZL/k+G9rSCv+/SxmgvKzYoOQiBOIqKNFwfDxosqk6
	 0zFz1GcWzb1kS7T+UpA7J8qMGYPBIA2ZhxpFzos33vt+LlZ7qwQr/I+FNgGBELTQO5
	 YS3vW6+BTM4z6ujLwC2Yf5ZLWKhe/ADZEe5L0yMParyu9ImyPi5uWdBvzt84y1Zmde
	 8M9wQyLLEMNOQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0B0DD2E00CD; Thu, 06 Aug 2026 11:01:06 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Tigran Aivazian <aivazian.tigran@gmail.com>
Subject: Re: [PATCH] ext4: Fix spurious message about orphan cleanup on RO fs
Date: Thu,  6 Aug 2026 11:00:57 -0400
Message-ID: <178602814514.965683.9220868344730400750.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260803160037.64285-2-jack@suse.cz>
References: <20260803160037.64285-2-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 03 Aug 2026 18:00:38 +0200, Jan Kara wrote:
> When orphan_file feature is enabled, ext4_orphan_cleanup() was always
> walking through the orphan file looking for orphan inodes. This is
> mostly harmless but for read-only filesystem it results in spurious
> "orphan cleanup on readonly fs" message and in other cornercases it
> could result in similar somewhat misleading messages. Skip orphan
> cleanup if the orphan file is empty to avoid confusing messages.
> 
> [...]

Applied, thanks!

[1/1] ext4: Fix spurious message about orphan cleanup on RO fs
      commit: 5aa98f874c013bcce9bb84ffded2f0ef886e4e33

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
