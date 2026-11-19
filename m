Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099695;
	b=dgm2f+JCf4A8xAwVITOv6HOpOlIKGMKf2aOKRmJYyb7KmVVcZ/UFeP6VYNL8jd275CiJ
	 0Ry5AaQs3WeepXmoONXEii5E2wXMLXrr3doY/YoqTOysGnH/BeSMHVuoa5Yc5nuZWuNE4
	 1u6VI8h3T1n3csTatbqyX7J+0yGUnOyEQtng/ANKX9gizO2TukJDRXOGj1kGUfjZdu7ON
	 Sfd1+/okL2yNuL5soh58ZUJXrhzi55B0U9c0G4D8Rru2WG4llngSBuukrM3CMdS47u+kG
	 P06xRZdOa6JXERrR1c5/RfAPbUoWwN/04Vw/so9r65H3lHPPtUj3DbYFivtzCKhkKJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099695;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=IjWdZXIg1W0QHOMjvZ83940GxcKbGWLs7Sg8ti09W8g=;
	b=G9Ks/fIE+9z960Vh5XJ5EyVRe8fC7rqK7IrpXaymtvkuCpK9u5XLiTRnBSbuKxtrmHi2
	 TrPw6/ztHzEr9a/459IlZ+7VPKFkYpwzyrWr1yL+ADJgcqfKZpSxgzx/QrV0gp91XzurH
	 8IrQ5VPtT6Oj8ds4nVh9EIk1Uu0Fxq553QL68U0QmL8k6ssT8n6odDl4uufO1Q3gdsenH
	 Uja/o83XHTJwPoHYctODGjLAXkMCUM5aFFU/Y9YRUtA3DjhGuxdAUYy7QoITWWbsvsTLP
	 qUKHo7tRl0HJ2d7DGBRVggTF3SLPa3neDA3kRzXGsgbV+YBXu+sDkUV+o7geFHwCD+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=ggr6h9cF;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE90E606C31C
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE90E606C31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=ggr6h9cF
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJEldei018043
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099662; bh=IjWdZXIg1W0QHOMjvZ83940GxcKbGWLs7Sg8ti09W8g=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=ggr6h9cFeIau9KRBXmm9FVX40Jdr95UhLR10VrOi1+eXMeMWFDMtSt6sDZX8JAZcJ
	 Dsnv+Fb1IcnfsHHNNQGZzu9384fMyjsWfPh0/TEolCddcR0q7rAn84JRs4SSbxaRJb
	 +Dj3l7BQjn66NS5HXCoRgkkjllBewWkpn6r3VAOYM/kpzCP1UiQQ4MkuosOz2OVTua
	 2pFVnx+hMUEeoTV4GzB8X+uEG9w8Dtypm7Nt4id/wmq2aIt9UOCEImFTB9RGVS8brl
	 N7CXqzyOkTCT5ISv5uNnxixRrylmbwvnGOWET+kImCb4JjAiXMfCWTHeF5XJKktCmS
	 8/xs99QQumzMA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 2475D2E016B; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Hengyu Liang <hengyul@cs.unc.edu>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com, yi.zhang@huaweicloud.com,
        yizhang089@gmail.com, dave.hansen@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] ext4: do not advance i_size on a buffered write that copied nothing
Date: Thu, 19 Nov 2026 09:47:01 -0500
Message-ID: <179509948723.1938961.17110187157751787862.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030040520.4138904-1-hengyul@cs.unc.edu>
References: <20261030040520.4138904-1-hengyul@cs.unc.edu>
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


On Fri, 30 Oct 2026 00:05:20 -0400, Hengyu Liang wrote:
> Commit 665575cff098 ("filemap: move prefaulting out of hot write path")
> made generic_perform_write() call ->write_begin() and ->write_end()
> before it finds out that the source buffer cannot be read.  In that
> case ->write_end() is called with copied == 0.
> 
> However, ext4_write_end(), ext4_journalled_write_end() and
> ext4_da_do_write_end() set i_size to pos + copied without checking
> copied.  As of now, a buffered write() past EOF that fails with EFAULT
> grows the file to the write offset, and the new size can reach the
> disk.
> 
> [...]

Applied, thanks!

[1/1] ext4: do not advance i_size on a buffered write that copied nothing
      commit: 66998b3184cdfcb7fa0f28deb4c0c6ea1236b501

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
