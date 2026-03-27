Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FEA3750A4
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 04:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774584406; cv=none; b=lc8NMCMMWCMVcAfrHNUfnVGIqhxnhKVRbMHEItLQA/Nf/68tE3XR1vlSgV+3heGI8LP3IC17FzXgGj6xfre5HamaICD90pHawYbyHq+ngEsoY+N3Or5wStqQOyIyj5AHI+a5PzwFZKFsl4NLgOBfWgZaylYP5PmpAYQuGWfS/rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774584406; c=relaxed/simple;
	bh=mdty/nU6DAHFlbdxupRpNrqX7pH3hYcFPanNsRdBUG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jEdK7K8wywewULVhrThvfIYb3HmsDQBL4STBF5pHeyGETcdi16n+b+oWuFjHiwqt6PC12/cYYasPoiKqqrDv20Q+rThZqHZS4OihnbUXcjr/isGGwkoTJgnA++wahPavJEl7JZ76zIOIB/h1ZC1asojY2NsTgFS/NmtTcbzE9e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=VIq7GiA2; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="VIq7GiA2"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62R46TEN005937
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 00:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774584391; bh=dD1rIYX6BpA2CD0bhhc1IxMXs3KcmYFN28+dVKWZkic=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=VIq7GiA2TRZ3qn/q7ZADj9RU3Zj1F/1MEsziJeoe2nj2V8YprO3vz/QixHIogY03x
	 OBe5feRgKL5rciYGqa/c1+pzoxFhQoA/1BI7vUd23Njm0kyQFuMlrrEB2o+fJQHIO1
	 b5x+wpPddpkdtEkSXyXqIWP1vs8bHenuUQld51ByoccRVgLXTfozqVUNpbPQgTpQ6/
	 OmXI+ArGgWHCJO8G8xbIh9Sy2RJKIGzaV8H9Pf+E6G/3qPH02NTCc/Zf5fenwUnAnB
	 GgSLqsE1OvXNROzQmkko9GrZ+KWwn1m8nwg28HX50B1VgB6MWThKR97SU2xaxIe9er
	 TS/PPM9rEMJtQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4A46C2E00D6; Fri, 27 Mar 2026 00:06:29 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: jack@suse.cz, Edward Adam Davis <eadavis@qq.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, brauner@kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v5] ext4: avoid infinite loops caused by residual data
Date: Fri, 27 Mar 2026 00:06:21 -0400
Message-ID: <177454194755.1228042.6904864995689919812.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <tencent_43696283A68450B761D76866C6F360E36705@qq.com>
References: <tencent_43696283A68450B761D76866C6F360E36705@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 06 Mar 2026 09:31:58 +0800, Edward Adam Davis wrote:
> On the mkdir/mknod path, when mapping logical blocks to physical blocks,
> if inserting a new extent into the extent tree fails (in this example,
> because the file system disabled the huge file feature when marking the
> inode as dirty), ext4_ext_map_blocks() only calls ext4_free_blocks() to
> reclaim the physical block without deleting the corresponding data in
> the extent tree. This causes subsequent mkdir operations to reference
> the previously reclaimed physical block number again, even though this
> physical block is already being used by the xattr block. Therefore, a
> situation arises where both the directory and xattr are using the same
> buffer head block in memory simultaneously.
> 
> [...]

Applied, thanks!

[1/1] ext4: avoid infinite loops caused by residual data
      commit: 86709d389530941e5816505e3c12c757ceca374d

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
