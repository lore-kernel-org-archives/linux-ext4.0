Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099689;
	b=JIoJnx2DBDaTfL+PyNmUyqqqHauxEfB+RVeBToIh+4iz7mnrwjYjLs370z+nUMJe+2E8
	 5NH7xa0ylTHE4TPJmQitQ3HmOyNPgLy9gLjp0j77esS7ehkQKH6X0FBz9a7CIOUDr10vF
	 aJNII07RZq37HXEn69JTwDOmjEB+8qKiu0423Nx+uwNzXQkzYFaBWAtblAFJpC2ai2Qhc
	 C+CNOyEN2DH/6lbiCdNbxpHvx00Hnudx/Qd+yAQyFxignR8e9KRQeRq7G9IYdpiI6RWcZ
	 g/6bCv48foLFYbr7002uARRnfGfIH+is3Fg6r8miVGGqzq31G8I+kTGJ9ZxthyUyW0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099689;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=FHBIIDIHL74egQuLoM5AO9TehkVh9TZFFvJ3N3XL1tw=;
	b=wHrmV3HY3xX7wAny0ny9sfq/FX8bzkngCIZTHvrOHIYqKhj84MvefOxbfgD9nAd6dAr1
	 P9ZwUjbo5NW5zr20ztMk5HbjQmgg5feaD+oAZZvGCy2Dfik2AJe+czN/CBoRrAUGJThUc
	 yzzoFCCIiqAuzPCuvY8dnSFGTF3qUe+eU9wvfLyZs1hSjiHg/8MI2y6mCC8GbHOAvzDiN
	 8Vgq6bXKuzRdyv2oE8OWqMyyFPeDAn+Q83mzRyUhgHi5j46H9QVHQTIhr6OBBRWomHnKv
	 iOB3QrizJyZXFqnEXvKHX4cK7EgLL0M+OGAj8dH3+58PSjiXuRugBJl6lYwvtxRd1Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=ajw+ORFf;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A130760A6F7C
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A130760A6F7C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=ajw+ORFf
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElaZU017850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099658; bh=FHBIIDIHL74egQuLoM5AO9TehkVh9TZFFvJ3N3XL1tw=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=ajw+ORFfwzTbIRwpU3IJoYGwEWvnTdvsSdPnvkH7zFpq1pA9B7BrAVf4GXHGIN41m
	 /zHh934EKNo/sI2zvvimvCJQMXoXUr5NF5k0/eSI8jAFOoisAhHLE5XCTgN72L9pDS
	 Nw/WiLLdLIRV4NPhwXHx91kU01s+gZq6TK7Ibkk6F59lSTzWi260fdNiXsg2IXaOKZ
	 GDJNBd4uj8J/OJQyxwBtIbW/j8sFKARBTkpoh8sxV2Bc/DC/Emb9puNgK8XqQSEH7u
	 TmEF12cpQdipPXmzUIIEwTVBpKOf+WS3JzsV+xkEuTfNnIzZ4mTtgnaf/dNzOap+ul
	 cmcYYpsqmel+g==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id BE7CC2E0147; Thu, 19 Nov 2026 09:47:32 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, 781735889@qq.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca, jack@suse.cz,
        libaokun@linux.alibaba.com, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com,
        harshadshirwadkar@gmail.com
Subject: Re: [PATCH v3] ext4: propagate errors from fast commit i_blocks replay
Date: Thu, 19 Nov 2026 09:46:35 -0500
Message-ID: <179509948675.1938961.14932981002320654292.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_ECF4DA918377A7A0D8863B860B0F3025C106@qq.com>
References: <tencent_ECF4DA918377A7A0D8863B860B0F3025C106@qq.com>
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


On Tue, 15 Sep 2026 09:57:46 +0800, 781735889@qq.com wrote:
> ext4_ext_replay_set_iblocks() breaks out of its mapping loop when
> ext4_map_blocks() fails, but then continues with a partial block count
> and unconditionally returns success. The fast commit replay caller also
> ignores the helper return value.
> 
> Stop the count immediately on mapping errors, leave i_blocks unchanged,
> and propagate the failure to abort inode replay.
> 
> [...]

Applied, thanks!

[1/1] ext4: propagate errors from fast commit i_blocks replay
      commit: 33dfb57dc9acbb2913287367c46943262a6fd7ed

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
