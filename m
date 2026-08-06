Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5463AEB5F
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786028507; cv=none; b=DQXLChGnWjEvKtmNi8zgRIXwszd97rLIVww5HwjFXPXDVYBn81FxUEm2UWRJYtFVOyo1ABEH1vKaJtLwLYrEJwue5zYjPUbQu0abgVAj44mqIrExBfU6UDXc3pTkROcy4uQIBUuEaLWHj2/ryUIf8aNVP6076C/0jSLiyX1Lz18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786028507; c=relaxed/simple;
	bh=XTquTqzEr99lzp49gNZVt3kwRzjxRreFTDgzWkzH3a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cADv220yJBfzis//220YbIQJBoAmSKlqSA4W1Yu8ceCNyCcA2OMgoqZ7jcpONdrZe5sPv7OUDU+C5zbZvX+m+h1lWz+ZUIURWYpGBremrcoH90UH5RyQTWH6NqRpUgEVcHhMvpjDTxF7pyXLGQajSJe9LCwPES7gRu1A3KOsvNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=BotrDorm; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="BotrDorm"
Received: from trampoline.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 676F16X6011317
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 6 Aug 2026 11:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1786028469; bh=P945Wtth2cvh7IF5oIceKUtyKthIRRk4+ivJQUvo8Es=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=BotrDormdWAjFtJHNk6zkVNsAkelsliTHOkSAEW4pS+9HT8LrRTzrFOq/KiRqWDUA
	 N07HrniEcBUAvB234hf3oZZLHHH4M7UopVRqyIRlMoWG6gJGBtokVQ3FyhM/wVMOA8
	 1I9tt4SWJMFYLn3oW00ndQIHF1iOi/ZKLKGP6FqEXdTQCOBS7S76rqj7NAFACUtK09
	 qqRNK/iWcfdcRLpkK2RrKadd3sEeR9aTSQxmg8DOi+9+FGdOucJluyFHsavGy6+Q/D
	 NMTBD/tG2JAP5+RgZhw6mwQz+xtXLP+7pKzFgtgZacJYesZ+V4f9+aYcVykwElTbQy
	 gu1fSbnCgqVWA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 159B22E3F18; Thu, 06 Aug 2026 11:01:06 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org,
        Matthias Goergens <matthias.goergens@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, jack@suse.cz, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        ojaswin@linux.ibm.com,
        syzbot+e68dbebd9617a9250e8d@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: stop retrying saturated xattr cache entries
Date: Thu,  6 Aug 2026 11:01:00 -0400
Message-ID: <178602814513.965683.133971697206051481.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260802065941.1726052-1-matthias.goergens@gmail.com>
References: <20260802065941.1726052-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Sun, 02 Aug 2026 14:59:41 +0800, Matthias Goergens wrote:
> ext4_xattr_block_set() retries when a cache entry selected for reuse
> has a saturated reference count after taking the buffer lock. The retry
> returns to the mbcache lookup without making that entry ineligible, so
> it can select the same unusable entry indefinitely. A task spinning
> there can hold the parent directory's i_rwsem and leave concurrent
> rmdir callers blocked.
> 
> [...]

Applied, thanks!

[1/1] ext4: stop retrying saturated xattr cache entries
      commit: 54b6bd40898de7906acb2bccc9a96d1b8e6b4323

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
