Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF66411F90
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 08:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536227; cv=none; b=YVizgWs9LahEV/gvcc2MexMJHVaQkotgj9XZKfYCCg51ZK8dvchNxQyfckIYvzEfsTDkZOQSMs89pZ++/SwiOiVrKPfwpAVRMY/vHfFiD5zeuzXPn3WEVi48vXCywcLHCn0Z7mJLDRokxgmLoK+qUED8vH1gjHB1Q21csrytzs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536227; c=relaxed/simple;
	bh=8sQ5pm0f1VPejXFr27NNS0t2QbQ3hQ4tw0bd9PgfU4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dIhG5mZltfWUhyQ3h21pnOsXEshN6Kg4LYdrcdGS6JxW47f+V7OLMWvzXRi74u3jAYZTKbl3r/5uTxle/Z3WsSomHh14sF1jVI+34q7DSQP9NAjqYNRqL+yT6bvZTTHoMSdEu4KwVMhpQsbxhxFgdIsXKfGnZdpF6orYlSPFswY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=c15MAigQ; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="c15MAigQ"
Received: from trampoline.thunk.org (pool-173-48-119-87.bstnma.fios.verizon.net [173.48.119.87])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6998uVQR014137
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 9 Oct 2026 04:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791536194; bh=S1NoGtgsKqUzNvbPHBTuZzU+Q0fNWdDvvzJGX2I7OA0=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=c15MAigQTVwsXyjTjpOKvHDNqh0XkcbQneGVgXkO7RKepzaSvF5EcUzpmpws5BxhY
	 rdYWV5Qf0HHXsHv4PkpoYI66YavtgdZvmNMhCrj6x5TKejw4KLpAz4RtjX5kW6i2xX
	 m+IEyQXuQVcs4/Sw1IHJMoNSyfZTgpf+HmNeaZTCyzucOMRwLt0LdVqWjqCi15nq+4
	 RobuSsHQrSv89k1d7H7mRfNO9Gd6H/MapiDnyWUouNG3pD/02HDuSvHX5eIMp8vgh4
	 wvrR+SSxlDncd8iVkmbDZbNc/DZOFoDFtomaN8iYr8RqZ/RM37VNk+lEgr6zF1Hxjs
	 E1bGlxZVpZYbQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4D2212E00BB; Fri, 09 Oct 2026 04:56:31 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, Daejun Park <daejun7.park@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, jack@suse.cz, yi.zhang@huawei.com,
        ritesh.list@gmail.com, libaokun@linux.alibaba.com,
        ojaswin@linux.ibm.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, amonakov@ispras.ru
Subject: Re: [PATCH v3] ext4: don't report delalloc data as a hole on indirect-mapped inodes
Date: Fri,  9 Oct 2026 04:56:17 -0400
Message-ID: <179153611727.860602.3370975390471708724.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260827084829epcms2p6ecc0c39a71d0c3eebf9cb1ade77314f6@epcms2p6>
References: <20260827084829epcms2p6ecc0c39a71d0c3eebf9cb1ade77314f6@epcms2p6>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 27 Aug 2026 17:48:29 +0900, Daejun Park wrote:
> When a plain lookup finds no block, ext4_ind_map_blocks() sizes the hole
> it reports by counting the empty subtrees under 'partial' in the on-disk
> indirect tree.  That count knows nothing about delayed allocation, so a
> range holding delalloc data that has not been written back yet is
> reported as a plain hole.  The extent-mapped path does not have this
> problem: it trims the hole it found at the first delayed extent before
> returning it.
> 
> [...]

Applied, thanks!

[1/1] ext4: don't report delalloc data as a hole on indirect-mapped inodes
      commit: aed43f47e1edeee1454eea86006a8c09480e5ed3

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
