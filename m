Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9433A3E96
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 13:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775221472; cv=none; b=RErGxcU4osxCAHo0QuSs3xbYqmvFW8E1lBSRZ2olrZBYvdyiZfY0dYC2Mx5lbaKQLeCmSWcZ5QzWYQr3Y7ryF66Apx/zW79d7CfBUaO6gvszNAifjYhac3io6N5rlrd4FhMLEKVg6tGYasVS+umdYaUtbX2OUUT6I5GeFhw1T18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775221472; c=relaxed/simple;
	bh=xQVDYruL8wwJYUfSlzBzEeh1suKcb9u8D1004mRY17M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J4TaR3VR6ehab1004qXMBIPpwM0mXpZQw7UMFe7OhUdIctQALaP35DldJgplzljEN38O3OCR6I4TiP28z/Yc3t/z64IDM2umOyN6n6JxhKo4E2RKrUrYvTtcdCm34IUZimGdxUcxtcG4OufLzoAoThx6zkt7T8FBvWXHW2L/E3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=IshiJhFV; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="IshiJhFV"
Received: from macsyma.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 633D4CPx032278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Apr 2026 09:04:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775221455; bh=LYZkTnoi1aTofONBpe4AonKQwhA2vCmJ1n5ctiy2dqY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=IshiJhFVKmj2fG8q7mTrYX+2azkR3ubFbKAx3sgh+yziaZqCkkdQkFFj9cFbc5cg7
	 R0N/iYy2vVJkTF03YkrpMNbyupVpsKVCjqimNoXiYTZuKMLBcRvXslLJo8KbIUVYSK
	 LWdm1KzGXYj6cm+L3Qz72R0QMmqels+FvEHJWt1prGVbVrWYt4h6we28DEblCfZb1M
	 pbY6fCU9xNY5/jxHHv9lMm0pngqC4Rkia+PTr8Hg5B7agG4l0FTHfQD/JJ3HbdDy+Z
	 Akedv+k/suFsjsbPxtLcIM016rB/j+POv05C3wwqE0wDQUt8fsxRnACCFZzX30lj12
	 3N1aR0MNdO5Tg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id E930D610133A; Fri,  3 Apr 2026 09:03:11 -0400 (EDT)
Date: Fri, 3 Apr 2026 09:03:11 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Ye Bin <yebin@huaweicloud.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH 0/3] show orphan file inode detail info
Message-ID: <20260403130311.GD12260@macsyma-wired.lan>
References: <20260403082507.1882703-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403082507.1882703-1-yebin@huaweicloud.com>

On Fri, Apr 03, 2026 at 04:25:04PM +0800, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> In actual production environments, the issue of inconsistency between
> df and du is frequently encountered. In many cases, the cause of the
> problem can be identified through the use of lsof. However, when
> overlayfs is combined with project quota configuration, the issue becomes
> more complex and troublesome to diagnose. First, to determine the project
> ID, one needs to obtain orphaned nodes using `fsck.ext4 -fn /dev/xx`, and
> then retrieve file information through `debugfs`. However, the file names
> cannot always be obtained, and it is often unclear which files they are.
> To identify which files these are, one would need to use crash for online
> debugging or use kprobe to gather information incrementally. However, some
> customers in production environments do not agree to upload any tools, and
> online debugging might impact the business. There are also scenarios where
> files are opened in kernel mode, which do not generate file descriptors(fds),
> making it impossible to identify which files were deleted but still have
> references through lsof. This patchset adds a procfs interface to query
> information about orphaned nodes, which can assist in the analysis and
> localization of such issues.

There are some concens which were noted by Sashiko review, including
races with unmountings, a potential deadlock, and some issues relating
to long pathnames, and a TOCTOU race that might lead to a file system
erroneously being declared corrupted.  PTAL:

https://sashiko.dev/#/patchset/20260403082507.1882703-1-yebin%40huaweicloud.com

Thanks!

						- Ted
