Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DAE2FBE
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2026 01:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786325660; cv=none; b=rbByYHm6yDfI98nfzqlrc+/YklmtYvTCc6fBpS8e4kv3Ln9DnpCH8ef3FrqcIvpYiBtRmmbdzDdptvA57GYmi2lfDBwG/5Wvrj4ZbtykBzppsy/nmjq7JvmyhHsqqVKdCEC7XTNfQqm+NhXdUKTcKyVoGKAHVzlNk2OLv5S9pFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786325660; c=relaxed/simple;
	bh=ZUhVr9Tm/LS8hKznKSBqbOw0t8rC4OGjfMpoUuumaQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o/Wpr77uoM/b/Id3DhtSad28TV67ORRuBHd8753xDcqEanoFCZ+hqNZxfmR6R7YEczPKO1ccZBOIrBfoOL0CUYbd4fycARc6FspXxhl/khl7TFPBfOvWK/r5mM0r+C6y3WiURstN5v8EofhyJIP9UL7qmlqbvmUYVta9TVi4zJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=cF1FywIJ; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="cF1FywIJ"
Received: from trampoline.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 67A1XqdC015878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 9 Aug 2026 21:33:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1786325634; bh=HBuLGVCM46l4TZis51i5ElYp02T/mQ62GWtqU/BH0nc=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=cF1FywIJl4AlN4rGptGiBB9e2jT5xJZrdNdA5m+Uhc4vS2eEPbfr3h1zQ/G1Ffp0r
	 CTyJM7lQMTmI3SjyfrEIC+BiOfGOLWwTrW9ED398OIh8Hmm33dEMiRijmJkR1YCftk
	 +o9jhGEGhPyFkVla6SI6eixJ8tUZinnGZJtupCjXURKasH88HFi+tLe1hG2MNOLIwI
	 J6NB9Gv0K8ktuT7cBxtyNkHv3s32j0LXR3IxUsvSdbAy1X40+aJzUQ82/NeRkKzcVk
	 yr1pJkFahNZQIK6czNeivGUXRWppy2XlDS67bclaqYsSc+XCqAqdarDE92UPh00QP0
	 NZD37UOeMJ4bg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0DF672E3D2E; Sun, 09 Aug 2026 21:33:52 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yi.zhang@huawei.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 0/3] ext4: Fix credit estimates for extent tree modifications
Date: Sun,  9 Aug 2026 21:33:48 -0400
Message-ID: <178632560650.1021605.3694902133748235095.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260805153202.29814-1-jack@suse.cz>
References: <20260805153202.29814-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 05 Aug 2026 17:35:46 +0200, Jan Kara wrote:
> This patch set fixes credit estimates for extent tree modification during
> convertion of unwritten extents on writeback completion. Otherwise we are
> occasionally seeing assertion failures during extent conversion in end io
> completion callback due to insufficient transation credits.
> 
> Honza
> 
> [...]

Applied, thanks!

[1/3] ext4: Teach ext4_meta_trans_blocks() about number of allocated extents
      commit: 25b2a7e8d420c49fc46f25b6f953603e4dae1dbf
[2/3] ext4: Fix transaction overflow during writeback
      commit: 46e8e31771f4f1c5e1cdec37a889a6730e42e9f1
[3/3] ext4: Fix estimate extent index blocks in ext4_ext_index_trans_blocks()
      commit: 9091c97be34083587a75db174aab51551d8e8543

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
