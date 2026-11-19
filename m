Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099733;
	b=u04MfVnevpgKw9cAyrBEWoSxT+xaAPa0HIM2/XwAiGpXf9GSHnU+fBTLeZ8/jVOWcD8G
	 fr3NketPo4Y8ZaL0zujpVWw+D0Lw8VXLxul6g5N6KFbIcI8wkgIBtQuOPll2X38MnraGl
	 vi/xpqB6Oz15ew0+Tv/rvukqaVji4H9lKUH7VSnMqkTo/FAlDkZW2xBd8P2nXNdeAACk7
	 8vfRM6Pno7r+eL5gSKFeOEHeA5zbJcUEPR4+NVLE4rk0x0cEqFRqtjBV1iDPLFYOBOoC1
	 /Z0A8rfYZq/10A1S7Ivl9pBb6Y090dQnhrDo0UtBZTF0mqRZJAXcdthd9BHQY9270aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099733;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=befu2j0yHcfdVbU6gt+JwzZUF/sP7PNcYDPydZiGXKA=;
	b=Jb/FvF3+XEqSqImWlO2+ziNscwf1e7XSTgNoW10395xQ+Ka4xUA5hZDpfD9fgslDw0kl
	 pOur0tKgTXMkTKZ/dAWiOuP+OfJFWvx99yRjSB/17zWsALloHwAPWrlJc8SN2eFPm/zve
	 tQ82qrZ2FWuLaOUlU/rm7WMh5V6b7RSNTftIfVmBgZkI/SAT0kxFEtN4slPHpz+dycuQw
	 XYAdxD83R8qL03QeySrmLrWO51Fl40R6omyCcN3gsbSCxiDPqWmvGjs+qRzrxIjIXHbtj
	 sLDRvmZfq8VjYyQJgIV116hb00V5rHNwxiSpFpnethaFbat7i/92yCnQ1xi6XlhfO8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=iEvUXx86;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAB3606A324
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EAB3606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=iEvUXx86
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJEleKl018075
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099662; bh=befu2j0yHcfdVbU6gt+JwzZUF/sP7PNcYDPydZiGXKA=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=iEvUXx86CvlCEpfqUXs8YAPUScszPfL/QLK+X43MxP/y/4RhQQMrFPDbDrGo0K/nV
	 PbC4Pou4VcYpauxewVqK4IY6jQMk5IA/D60JIkxertUBZ0sVS7f8xeV+GeDywld58j
	 dAJ0gnW93lYYNFbTSL4fYc3fcJmrpg3rvhDbsDrqXXoUUzH6+mbD32mHvv4bSUGzQs
	 QRm1zjPLPbtl206Xc2BLPW0pRrT4jkh9n40k6RCKhTH4ND6y8ASACgMHkTbupLjPda
	 v1TzHHpJYGw8UKzorvTxbdLhAYUy8PiGRTTdtjXzDOosmLaSfXNTId2oSkdIbBaikJ
	 2RqnJ2ZYsdFLA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 2B8422E0186; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>, ritesh.list@gmail.com,
        Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] ext4: save converted extent before merging
Date: Thu, 19 Nov 2026 09:47:03 -0500
Message-ID: <179509948689.1938961.12237161801270801958.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930134516.397754-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260930134516.397754-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 30 Sep 2026 13:45:17 +0000, Jérémy Jean wrote:
> In ext4_split_convert_extents(), merging can release the leaf holding
> the extent pointed to by ex. The later extent status cache update can
> then dereference freed memory, causing a use-after-free. KASAN reports:
> 
>   BUG: KASAN: use-after-free in ext4_split_convert_extents.constprop.0+0xb98/0xc80
>   Read of size 2 at addr ff11000002547034 by task fixture/65
> 
> [...]

Applied, thanks!

[1/1] ext4: save converted extent before merging
      commit: 15b9540d445893c028a616f8e98606195c67db91

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
