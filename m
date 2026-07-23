Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D68419ABC6
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812166; cv=none; b=CG5iVz425Vt7O5MT+YQpHW6z2HfbYdkgt6jXSU65vJUIXvSZAYX7Gcosxi/AMVEt4FetrlgyW2Cb3WReocnKSjqPERpVs6LqKSH3HeqW8kqqvVPZuLyyYphFuWujEE5xJyv3HYslSQ7fuHoSdKkmaOAf4Lh7sL477aSkVW4Ogv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812166; c=relaxed/simple;
	bh=ex6i92ygfC4UDWUNsvlNOyFJmXwd8GTBWpDdmITlBGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SEzyOOlCKk4gyZBd4GH6gDHoRy3Kop0OtAFrzXcDJ1JNgxsFUeUXKMoj0/BXjG9WpicXJ70ntw+Yb+MUSjwKZT8jCO/tXEQNy2NA0cvWEnv51Eart76oTlT/T5DProugzF8sStv1hHn8bv7Aw07Cdt8By1seZZkzmInSdvlGHKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=kFd1OArv; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="kFd1OArv"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND92RT017915
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812145; bh=ZVtxjc77y0UfveUmoo3vlvxnKRCiWBDdyW1qA/88xo0=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=kFd1OArvnk94wjO4ekaVg0opdqrj9uiA7Lic854QCnXMu7sVO38S/ptt4UL1yCvec
	 jgTPay25KBAdJOj3V3IM49jsitY/9GvKklvLibCf+XSj4R/6XnfrleY+leXEfaoprh
	 YcxC0sZX1AJdUtVZwcneemvo47rqmnVlANuVYjAnVXMENFmGZGEUxxLHvWDd52/AqH
	 5aVF9nhxaDkys9Ah5qQMjIOKFavGhp94zQ9VFyEzTkurXTdBt27xw47651BDg3jAsH
	 FPoheKzn6g5wbtFwdFd8E6l1TZoILAKPGMFS7L2dxc3euoC1Vr0ixSuAhdYiEaRxzZ
	 UQbWvjECgtpRw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id C21462E3F1C; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca, jack@suse.cz,
        yi.zhang@huawei.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH v2 0/3] ext4: tighten mount-time superblock geometry validation
Date: Thu, 23 Jul 2026 09:08:44 -0400
Message-ID: <178481171718.796182.10777865397953156413.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608111150.827117-1-libaokun@linux.alibaba.com>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 08 Jun 2026 19:11:47 +0800, Baokun Li wrote:
> Changes since v1:
>  * Patch 1: Removed a spurious newline in the error message format string.
>  * Added Patches 2 and 3 to fix additional issues reported by Sashiko
>    (independent of Patch 1).
> 
> v1: https://patch.msgid.link/20260608061112.392391-1-libaokun@linux.alibaba.com
> 
> [...]

Applied, thanks!

[1/3] ext4: reject mount if clusters/inodes per group are not 8-aligned
      commit: d42dc7726a003262b73ffef2b744ff57a5488799
[2/3] ext4: reduce max cluster size to match documented 256MB limit
      commit: afa3caf2fbc417f755f36e271c4b3c2d45ccda9d
[3/3] ext4: reject mount if inodes per group is not a multiple of inodes per block
      commit: a34de48f329b29dba2d407ad4168ca604d4768e1

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
