Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099684;
	b=ZHoArOOeuPcoolTRGpMmUgUW89LGib6yFXNtb5e425zYAsFgbNtWmNYXGMxwFLQZRFzE
	 DqpPiex3Zkp7+MvgDpCUlRZ2DTi7SxnCvRNkVAGSEK/VBhT3WJF8TM3h51XMmOCWDxOct
	 hjjXWmxmNfe/dSz+Rj5s8LbQzQ3f6lLYCEnnx9Vae+wvjV4TjrPA65wASteYvrUQrRKac
	 5MurfjDDkslEzjoEJm+h5S0ZufIJ9v0SD93a6IwN7xCnp1f+Eh3ywoWnnSmJKf9fXP/vO
	 DFWS1I27apT6eDLx96CB/f1cj/ZJSipfj0wrAypIuMFNd6z9lzs1MaB+kM+BZzR+rbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099684;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=BeMX/MOT9OyAQYE6flBYmZR2sc5ivVYEEnutd9LyRDY=;
	b=UV15bYGuZTj4WfDs3DEkag2RxZy8Iq1cT2IMblLxf7EWz0naWOX0/EJsnnzS+r00fepS
	 cjiqkRwUe7UvwecDnmPf5zTeqoUQ6+WISegnKd7/nrKaORKucEDOmT3O/WpqfdbM0pfvl
	 L+Yx8rALcbc9cuPOPn46HrjA06eAnJbCMmKSvA7q6SOeQjZxBnssVhcdaxVkN5oHEK6SR
	 nKQhV9hNtms7DN0QMFbnY+DjCLolx9B4SebKEyiS2970gb6hPfboyJcvSA+nUDhrbmyOj
	 6JThoYbRfB4aJXU30FkmUvyYd6t206lKKnALU02lymbpdOesNDhxVi6wgoGIVdJ/iqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=d66+Stlo;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0124606A337
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0124606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=d66+Stlo
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElfP2018101
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099663; bh=BeMX/MOT9OyAQYE6flBYmZR2sc5ivVYEEnutd9LyRDY=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=d66+StlojcBo6FR6QDYsFe4Fta6bZbyF5gibfV5sj/SrxhiIDJDXL7nuVLGXHRawB
	 OWIhbIdDj1SZD0jOMZLrwfAu86uA0AvqRPuQ2KuCXGSmTVRNKY7S64PdR0/MaBZH7Z
	 Sj/+6UiAHBIx65cxaE5s3ELz09a8qE/KgBE96dYt0on4rbPMXdy/pYAYRnT0a+GSZM
	 c+EBl6JtjhHgpMeLqYC2HT2wvQ6HRAAdQgFFYT7V0QZckW7w3NnoPgrq75EtLh/gbB
	 AEK59akus/nRL38v/57gpOxb5LusgjSj6ncyDx1VgetmglHiZ2KazdG2LGBVpQN9YT
	 W72KoT2jNqZ8w==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 332DD2E0188; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Kaixuan Li <kaixuanli0131@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Baokun Li <libaokun@linux.alibaba.com>,
        Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: stop verify_reserved_gdb() one entry short of the block
Date: Thu, 19 Nov 2026 09:47:05 -0500
Message-ID: <179509948685.1938961.16529317026300275980.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260919113940.1823559-1-kaixuanli0131@gmail.com>
References: <20260919113940.1823559-1-kaixuanli0131@gmail.com>
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


On Sat, 19 Sep 2026 19:39:40 +0800, Kaixuan Li wrote:
> verify_reserved_gdb() walks the backup group list, reading one __le32 from
> the reserved GDT block per iteration, and bounds the walk after the read:
> 
> 	if (le32_to_cpu(*p++) !=
> 	    grp * EXT4_BLOCKS_PER_GROUP(sb) + blk){
> 		...
> 		return -EINVAL;
> 	}
> 	if (++gdbackups > EXT4_ADDR_PER_BLOCK(sb))
> 		return -EFBIG;
> 
> [...]

Applied, thanks!

[1/1] ext4: stop verify_reserved_gdb() one entry short of the block
      commit: cbc5fe89227dca60c120a94c6c7d04c9d2438676

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
