Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099688;
	b=P86Z0g4ZqYie5Z79ak+Q7WW0vej6qV/zn/MwI/LZPBeiQ/IFqx/j5iuJdDYxWRQOx4cZ
	 fSWUzR4Wc9+6IGojJz6C2QtDBbrz6lp0A3/+4sOi+Ks56XYJFKhLsNMsCM+8k/FFt0kWu
	 2r+XdF4Y8fRjXAAiNC1x2RI9uzvRRxphHz1mE/M27w4bxRZ8qe4Jlj06CPhC5dn8PI/Th
	 xrnGKnTlSaw94bwJK4H7YCZhN37BSxgkpE7GuGZuBcX5lPHTaY4u8Gs67ho8nkZQObKYp
	 +WRsxWwKbDYmNvNvZN3ooeIstPxEb/vMBfgw3m3IZDi8+LavjUjueBRkZQx9efrG19A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099688;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=TwK0BYz61Wq22ArIOv16qq8qjStjEa3rU12M8LJ1oIA=;
	b=0EvivArfmRrgW5lkS94tOKm4dWOr6ZdCLbQ1ZjBmpDHkutTS6CxKR2bR+3ktLYrZU8Q3
	 Joffuc03/zchQc8RGySoYsNkokKqnoS00w45h0rSehC6SN+WblxWCYSJwWJHxuiEkAVQZ
	 D2L0NO1j5qcVM33tO4a9bHRmkK5XMQ2XOIVEf+DtEYduwWeWuHDJen6GJX1ED9b+SqyXy
	 EKoJkejgiu5HQvZ/6U+K6p8a9rOJZrpw+OLSAIIwdw+Nr58jyZy3oRDt8ju5JbCn2JKLE
	 cZRfTuXnhtHiPc4m1aMc6/IOX9aCAaXaVl0bVdNMfy1pPBjsfwGzsdInleXfDbmxNvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=b6JIYUiM;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A1F60A6F5F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4A1F60A6F5F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=b6JIYUiM
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElcJN018032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099661; bh=TwK0BYz61Wq22ArIOv16qq8qjStjEa3rU12M8LJ1oIA=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=b6JIYUiMufeabNYQDhMPLPClx0cVCjUL1dwYaOryxBfyVtRoJJZaHvOKWtGnVsMmV
	 DI5o3nHEY2BYniE7OUHnVdycHNULYfERoxcGablxsP/XVqdaeGA/ryCS5zkEUm4uxJ
	 axsmBHZXNLes3lucTvfaGrZadE122vYgMWz82nl48keAOCYIhTFUXuCjSD9paqUzRs
	 J1LSsiDRxrdrayTJNsTLcyzvKpBuItS2QDyfbnbVmaJYGa3y4htQmZWG45Ph0d3ylW
	 /+D4wwmX590QWGZYJ1d47Mettj51TL7v0LQjvzbMccmvkfLaAeAbAROyVWS2qYkmi0
	 R4et33CTC29Hw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 1682F2E0160; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        stable@vger.kernel.org, Simon Brakhane <simon@brakhane.net>
Subject: Re: [PATCH] ext4: validate inode block references during fast commit replay
Date: Thu, 19 Nov 2026 09:46:57 -0500
Message-ID: <179509948719.1938961.2510357164621183821.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026164853.3125835-1-hamzamahfooz@linux.microsoft.com>
References: <20261026164853.3125835-1-hamzamahfooz@linux.microsoft.com>
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


On Mon, 26 Oct 2026 12:48:53 -0400, Hamza Mahfooz wrote:
> __ext4_iget() currently skips ext4_ext_check_inode() and
> ext4_ind_check_inode() when EXT4_FC_REPLAY is set in s_mount_state.
> As a result, an extent-mapped inode loaded from disk during fast commit
> replay never has its in-inode extent header or root extent entries
> validated before replay paths such as ext4_fc_replay_inode() and
> ext4_fc_replay_add_range() walk or modify i_data[].
> 
> [...]

Applied, thanks!

[1/1] ext4: validate inode block references during fast commit replay
      commit: 7b2eb8a438f6a29aeaf4322657248f21596e04e9

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
