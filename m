Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AEB47FAE7
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 03:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791862296; cv=none; b=MhNGtCnP/DJYIT3O+hOQkUTkkdQ6EfbNutMNC48kImiGYVcov99f5eDxbr3F9xiLoPAqB6dmagET6N2em4Q7oVZg58KGpulHDZliRXHrt+xHzk3U7xMRVHC6IMQyRPsgi5MLwjgB81/uWyalTTuoZwboCkmKQgdgQGY2ZjX9W7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791862296; c=relaxed/simple;
	bh=cjyBjRJkApVsOaANK3jfZk+FCb9JFAhCOpaDsfDJ12s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hhKHOsmuaQSP5kJh98gVm3ZzdGcS329fao0I0Q2t6LawRmMuOSPkZdShhWCOrAxhBw7TNiO0wBD73pWmGKizzXoagBV+CNEgHsUBciL8vmwbuoSFATbyb1EGWlBEq2wzplNDweVMg5njKdmidJx5uaa6Ws6n84P/jPnku4sNz3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=eWUN1mCY; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="eWUN1mCY"
Received: from macsyma.thunk.org (pool-173-48-111-204.bstnma.fios.verizon.net [173.48.111.204])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 69D3VPQV026428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 23:31:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791862288; bh=d4H1hHVaQBRXson3FwMJdk9nzEsQQmVUiNyZKfJ6bNw=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=eWUN1mCYULi7ZnKjU3d2UCy6E14hFO95ypvxx0FutOyDf2C9kXSYgW1Oq1YczokIz
	 me8Ma8dWsMJ5NYEdT6h4p0RSMRrnj1ColeXRnHL5O1mDwkmfHg4z79AkC37H0b8XJz
	 WUTnyxElFYDF0l2evtl6OqIR3VJq++KGTBceRWSzUBBxgl3ogy0vu7gakzL6C5YDwy
	 WVnq75i/lviMtxQEgVaXNM3CODPKbncR/rMOolahFqhwpj6Q4KBXjf4WMAHlIn6TvT
	 JyYLRS5j7KCGW5ksH/HJPV0sE8N99oKQ9ZYS9iiMmIuTiofxBawZY7phu6hzmLUdzs
	 6x/w6QuHMXnHw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id B3BB320508A9; Mon, 12 Oct 2026 23:30:25 -0400 (EDT)
Date: Mon, 12 Oct 2026 23:30:25 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Guanglei Zhu <zhugl3@xiaopeng.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, guozh23@xiaopeng.com
Subject: Re: [PATCH] ext4: check CAP_SYS_ADMIN in ext4_ioctl_get_tune_sb()
Message-ID: <as2h06UOO7zRzrHk@mit.edu>
References: <20261012060844.836001-1-zhugl3@xiaopeng.com>
 <20261013020145.1297074-1-zhugl3@xiaopeng.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013020145.1297074-1-zhugl3@xiaopeng.com>

On Tue, Oct 13, 2026 at 10:01:45AM -0500, Guanglei Zhu wrote:
> 
> You are probably right that reading these parameters is not
> sensitive on its own: most of them are already visible through
> /proc/mounts or statfs(), and the superblock is readable by anyone
> with read access to the block device.  The argument of my patch was
> the asymmetry with the SET side rather than an actual leak.
> 
> I'm happy to drop this patch if Ted confirms that the missing check
> was deliberate.

Yes, it's deliberate, precisely because the parameters are visible in
/proc/mounts and in /proc/fs/ext4/<block>/options.  (The latter shows
*all* of the mount parameters currently active, whereas the former
show those mount options which differ from the defaults.)

There should be nothing in the file system parameters which are
secret; things like keying information for fscrypt are not passed in
the mount options, for Very Good Reasons; instead we use the Linux Key
Management facility[1].  As far as I'm concerned, storing passwords in
the mount options ala cifs[2] is an anti-pattern.

[1]  https://man7.org/linux/man-pages/man7/keyrings.7.html
[2]  https://man7.org/linux/man-pages/man8/mount.cifs.8.html

     	   	 	       	      	       - Ted
