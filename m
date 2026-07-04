Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB00340401;
	Sat,  4 Jul 2026 02:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783130731; cv=none; b=qIuGR7gRL66upLbkuZmoJ/J/beDA1ui936kAafmdL9mATTLh1GteELPEkKMzIJE2RWsgLEd6gS4OhjrNO6kIkYHIcdpdEk0bAHW5h7rkcAU4W/T1lQx3eCs0fbdClRdAt6+X7SdohHbJgdGWh3zfZvOOqGKlp5LZzv8KDpQCKFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783130731; c=relaxed/simple;
	bh=d+jCZsvE2NN0h2KPqrxeTBa+OxYc/1gcZUHO9hIwJpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNS2aDJtWucOiqsSbeff4FKg05CT1JcNXx50gyxWKbKQEp0x7ojb4GJThhudQ3QitkcafUvamc83iQbAIkna474O+H+ACgy9GWEbW1sXPDnPQgYPIbPqGQcBmF/Mh2sxTbj+DDZBHnL1C+zwqFtKElysyagbyZykDjyVAD9mX90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0cxT74n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0cxT74n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C911F00A3D;
	Sat,  4 Jul 2026 02:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783130729;
	bh=ms16ql0lL617YAWUt52UQdJew+4Xrx7tESvlfR9hv3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0cxT74nmhw8y1cfHZSEwZ6T2U5/kQxrtdwROTt9SNbujOcyPzcLdpXUqvBTWBXKY
	 1rC1LCIA2s8edcx4xPsHgTU/iH5g9FYS3c3eXN73GWJeEP4ZCQ1mA2fwSp34E4F/cQ
	 Ys+xpEqf7+nGz0JPf5ZlpMdM5y1jyhL9Xd91L838AvBPJO3hfrQFY7afgx3A2SbWeC
	 uSSSsB4/ou7tXrk+Tz1n2i7eN+tca5OAuetOh1X/Px6ps1QLqQ/hFuxTVo/LCMV6J3
	 YmO7rBOdMG7JdM6lDM7yCVORCzgmX4DQxLVs8Shok16ufZd9fh2PO/pSzKrjUtXN2G
	 qQwDgN4ZYbOPA==
From: Sasha Levin <sashal@kernel.org>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Wang Jun <1742789905@qq.com>,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	libaokun1@huawei.com,
	25125332@bjtu.edu.cn,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ext4: get rid of ppath in get_ext_path()
Date: Fri,  3 Jul 2026 22:04:57 -0400
Message-ID: <2026070315-stable-reply-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026070315-crescent-factoid-616d@gregkh>
References: <2026070315-crescent-factoid-616d@gregkh>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Jul 03, 2026 at 10:20:35AM +0200, Greg KH wrote:
> On Fri, Jul 03, 2026 at 03:57:09PM +0800, Baokun Li wrote:
> > Either applying this fix patchset or reverting the incorrectly merged
> > commit should resolve the issue.
>
> How about submitting a revert so that we can start fresh and work from
> there?

I've queued upstream 6b854d552711 ("ext4: get rid of ppath in get_ext_path()")
for 6.6.y. It completes the partial series that went into 6.6.130 (which
stopped one patch short of it) and adds the IS_ERR_OR_NULL() checks to
ext4_free_ext_path() / ext4_ext_drop_refs(), resolving the reported oops. Yoann
Congal also posted a backport of the same commit yesterday.

Given that 6.6.y is nine patches into this series, completing it looked
less risky than unwinding all of them plus redoing the fixes on top.

Baokun, if the other two patches from yangerkun's April set
(ext4_force_split_extent_at() / convert_initialized_extent()) are still
needed on 6.6.y, I'm happy to take those as well.

-- 
Thanks,
Sasha
