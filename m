Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6B13F7E8E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 11:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774526298; cv=none; b=MTa32VqxiHGoASgVoiB+QCNukVP6cgzH9WnvKUIhxZWyZvKssUrBOq3hs2zR3gzpSx9wl7XRyMH2oN0CO3Tsw9aYVO/JVAGSBKmduo3v01eMGbpbFBjutaT2DIJxzuwRO7auCrwRubsQ+IDgJ9BPeAQ9q2xQpX1xFChes9Iszxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774526298; c=relaxed/simple;
	bh=GmvKz2VCp59xhoXOpAYSmYG5VcUHgJxS+oswXYcLJmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V0fTyS8bpN2wLSJ42mFtmJ/9+nbwAW61pRcVDuE1BC04ulgx/+/OdP0N/i5Ode8iAp5xlZf+xnXGVZ9F2UEmMScLIuQhSYisJHaBsV++Kyo0ZI7pwNbU47HKds0YqgwNGMbmPJqg1qZiJJxBY+7/CKAvSFtMDgMIAscJwMwFYM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=c6LWasJh; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="c6LWasJh"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62QBvwKV020431
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 07:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774526281; bh=7MNZy5F5RfESsts/31jNRVo3JpZjGMR7ryiRikHJy7Q=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=c6LWasJh5+bola9MxfJEpx8KjPEBzVcJKvGsCG042ZEDvFMPnWeMBtvOEvU0NVuUY
	 7KaxjUQeX1AXDWsbtWAwzdDdXXql/cmfxdUkXX583TBPXf62YucCjhrvvzHtniOMr3
	 u55hFQQOzJKw2elPXAt9vwZNL49OFiJUXUqaBN5NPVmXjPJOkIpPq+I00VLH7B8rGF
	 KV8kiy7no4p3FgnP3OSTHnCnRVS8pfC/sl12NgqCs1zYx5PUaZzfZXqt3XPui+j+QS
	 5HgBXeYWXCM5ls9ukggeaD/2u02s3xF2Km4bMhg2PEXyJPEK9SFuVO6KB/mvpOkho/
	 FIjNMf/5Mv77g==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id F3C902E00DC; Thu, 26 Mar 2026 07:57:56 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        adilger.kernel@dilger.ca, Simon Weber <simon.weber.39@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, tahsin@google.com, ebiggers@kernel.org,
        Anthony Durrer <anthonydev@fastmail.com>
Subject: Re: [PATCH v2] ext4: fix journal credit check when setting fscrypt context
Date: Thu, 26 Mar 2026 07:57:48 -0400
Message-ID: <177452625026.1205486.14747133814960688498.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260207100148.724275-4-simon.weber.39@gmail.com>
References: <20260207100148.724275-4-simon.weber.39@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Sat, 07 Feb 2026 10:53:03 +0100, Simon Weber wrote:
> Fix an issue arising when ext4 features has_journal, ea_inode, and encrypt
> are activated simultaneously, leading to ENOSPC when creating an encrypted
> file.
> 
> Fix by passing XATTR_CREATE flag to xattr_set_handle function if a handle
> is specified, i.e., when the function is called in the control flow of
> creating a new inode. This aligns the number of jbd2 credits set_handle
> checks for with the number allocated for creating a new inode.
> 
> [...]

Applied, thanks!

[1/1] ext4: fix journal credit check when setting fscrypt context
      commit: cb8c10c17a8b339423cd950a04841c5b3287f346

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
