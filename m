Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099688;
	b=GMicnifGtL+OPEXGu195pLjqgFcBr9J+opcfP86pA/90pvf8JCItwStBr5seUrI5/Mvk
	 rOD5J8N3p+TSkG3zIsLpFnPNz/sKDE0MsAkaCnjssrcUGX7YeDWPc9YHmOvzIu4Cr0S+5
	 O4TqVLzunq+5UeS/MfGCQAWcmuJpT0fmbe1N0SGqBEx5oTIxjxwxgKitfDXFCGU6QvwSW
	 0jafzPJBjcWKtY7ZAmF5u3AuzsBQa41wxQSUfRRPWQxh15vckcw1JA9ryYJbst3JE5tfe
	 WpMiGHc8zd8LXV4ijsNMbk7SuPrWsUNbzORHQfRyk3yztRI7O6YWITytwOyowYwS5tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099688;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=EHkqwJQmUyMHO6Yzr97eRMAuJ9jEHgpsYpjxNhoEI5U=;
	b=PAUBnCpvCEIWhZIDdl8skr4Gpv+4uYBTDTj+WdrofUZ7g+vrmftDhRi+BZyx4c2bBwJJ
	 BodGeGfkPMB+MUZ3dcNi3Jw23mM5hnddYB8tJ7Z3iRX+L+1+dmUcrdWRhnYE6X7HF2t56
	 ToBsbRbQ233rqbbzlH1//Vm2zdf6mjipRTypuvLL+FXYKl0aEAyVxjbsFFxx6QZTJcBVX
	 CidF3CzqLbmpOgSiekAvrlAWLcEWUo6QMCx/VRhoxyWtwHJLHhqBO02+2Ata1NNh7zCDL
	 5YA2LgbJM7XL4PH+5lOBZl2tEtQ47Y0t1el6hkQlit4R2qID/X6JJaQqrekpsE22S/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=GCbRc57Z;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72FD60A6F60
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D72FD60A6F60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=GCbRc57Z
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElfQv018140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099663; bh=EHkqwJQmUyMHO6Yzr97eRMAuJ9jEHgpsYpjxNhoEI5U=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=GCbRc57Ze452PGFTBp93hkjJnzgg6vTLbLkDwC1xuyzfhN2BGhnNNNlYMGegIwEmj
	 1J8vMkMi4jU9X55hSPY8EKuZoj8BxeVJ0FXfHWwzpx+n8SmVqLxGxd64o1QVH3H1Xm
	 IaY3g+KukkvRuKb1JvFKnmQydFSmwOIqAknkyRqJghJDdbWpCwpywjidGJxrJ21CRD
	 K2Bxy7UuqnUSZ11+b0Tw9BEDOHUFfi0jEW2TDxWVp4jZ9SVWiZw5FBTdhkCxy42A+n
	 uRnM01oQwN78SzuVGCW3MruCBG1ZapNujWkPTuHOom6hdIDqdKw5xjknYbJCxHgywO
	 OerSPFXM29foQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 3D5E52E018B; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Karl Mehltretter <kmehltretter@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: return an error when a journal block is not mapped
Date: Thu, 19 Nov 2026 09:47:08 -0500
Message-ID: <179509948708.1938961.10407267683582521579.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261016103726.98553-1-kmehltretter@gmail.com>
References: <20261016103726.98553-1-kmehltretter@gmail.com>
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


On Fri, 16 Oct 2026 12:37:26 +0200, Karl Mehltretter wrote:
> If the internal journal inode contains a hole, ext4_map_blocks() returns
> 0. ext4_journal_bmap() logs "journal bmap failed" and aborts the
> journal, but also returns 0 and leaves *block unchanged.
> 
> jbd2_journal_bmap() takes that as success and uses the unchanged logical
> journal block number as a physical filesystem block number. Journal I/O
> can then overwrite filesystem blocks outside the journal despite the
> abort.
> 
> [...]

Applied, thanks!

[1/1] ext4: return an error when a journal block is not mapped
      commit: 5fbfd161f88e6027338766014a268a19e4aa6607

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
