Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60282FF170
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 04:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774584408; cv=none; b=EowpqzkaXVPP/zcwVa5AMEohNmdUMq+wjW9iae+pmbpAGIMVsvPVyfFAn4y92JzjzMH4pJiyY1560bKq7NyP8SeUWCk4f5QJOlMLO6kjVG7LfTOKO/oVBGo7u3ldmzbbIMZtEXgHewKKttn09GfyIGDgm/izomKu2+A7M2+2By8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774584408; c=relaxed/simple;
	bh=vgQMJuqIGcSOKUUvCyFz8Uhgs2nFmvTJBwLvnWX3olc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jw9Rehd/zWRGIKSFxW44HWKsAZrJQeiFH/npuUOgY09ZOvg1CN1g4d/JMyrwK6QetrymQpbuKLlqAKyGflgBy2t3C3tT6LopT64DYTve99eFuUW8b4+CudacpKgEA0js7qrtanHtGZFZQDt83v+x1u4gcrMUD0HhRO6u/QbSMMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=QzwYkpaz; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="QzwYkpaz"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62R46TH4005938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 00:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774584391; bh=WDEFF26BMe7rQGFXxCq4Uqz4xQIkJOa1T3JUK8vskgE=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=QzwYkpaz1ynwPoCqTPSHhNhnSORoLP1DkVSLyenC7UD+kHLNGJrTeU3JYa8Y1XB+X
	 o4jgIrz4jyXm9W3q3u4IZ9nj1t3TY4J6wLZkEq8T5bA1jVyfHlT9x12ZWBMW0+1W2W
	 InHUj2gQt/NHlHzwrWIrK600TBoG3Wh6yigeK+zyoywywkiApR3QxTcx4Pm2ueua2i
	 3LYrQbQl5knniYBJscN22GCP2IXEpPg8pq+sGZzHPSpIw+vyu2UPXTD26gRWudj8k0
	 L/2up8JdIPx44bUC4kA83jEK4wEMLaFHRLXpDLPq1+wkhgYeXoux2RJq1TMVBn9xOv
	 +zzD3M29Nzu5g==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 54FAC2E00DB; Fri, 27 Mar 2026 00:06:29 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        Ye Bin <yebin@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, jack@suse.cz
Subject: Re: [PATCH -next v3] ext4: test if inode's all dirty pages are submitted to disk
Date: Fri, 27 Mar 2026 00:06:25 -0400
Message-ID: <177454194753.1228042.5641597114059972163.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303012242.3206465-1-yebin@huaweicloud.com>
References: <20260303012242.3206465-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 03 Mar 2026 09:22:42 +0800, Ye Bin wrote:
> The commit aa373cf55099 ("writeback: stop background/kupdate works from
> livelocking other works") introduced an issue where unmounting a filesystem
> in a multi-logical-partition scenario could lead to batch file data loss.
> This problem was not fixed until the commit d92109891f21 ("fs/writeback:
> bail out if there is no more inodes for IO and queued once"). It took
> considerable time to identify the root cause. Additionally, in actual
> production environments, we frequently encountered file data loss after
> normal system reboots. Therefore, we are adding a check in the inode
> release flow to verify whether all dirty pages have been flushed to disk,
> in order to determine whether the data loss is caused by a logic issue in
> the filesystem code.
> 
> [...]

Applied, thanks!

[1/1] ext4: test if inode's all dirty pages are submitted to disk
      commit: 7d7ddac60e99f0506ad0dc6ce9138e0c8f9cee94

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
