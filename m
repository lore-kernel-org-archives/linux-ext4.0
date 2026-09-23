Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA573803F7
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 04:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790139289; cv=none; b=misFEqHMF/JkWC/GQlB8ENylZs+RVkuXdIp05JDmV/nuNpDdtAqeve/KyKrf1k/7cgDhIb6p5e2Na047uy478SLykY3hMWCt/rgPgSeGKZm5F7rouZHHl5L2lrtp50SXG61YjKPmVBYnKNeeJVPxGz6c8cmXCzUCemYuddvyKVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790139289; c=relaxed/simple;
	bh=0rlRhax30fz54d8kAn7qF91dJvcw2rT5sjy9NHguqqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AX7XQc8UAh01YTnftt3yGpkk2wlSiMZ11CywobOoeDWKqbYJ69+8HCBOGeBgUxSFUj80rwdvkGSdYtmnoRj1yyh42jAOGzMFoHiqFC80xSJonJRb+Ej7QFxOq5h4jzpqP/NmjiklGHQJXXdB3bjdUI0d8TMlSlA3ySeiMIJbyDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxhXFsTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxhXFsTz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5B1AB1F000FF;
	Wed, 23 Sep 2026 04:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790139286;
	bh=X3BYLtIE2ZsaOKTfQ28/EelLe3+DOo/a4KLu1eW0/c0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LxhXFsTzbybEmg27WopdvpDl58+YpnQz58Pa97HrOZbaykDKw/yMdcowl3V54ovOp
	 MC75pbIoveo0DZc8Cb/T9IUv3FBQDEGI/g7UVfDZbU1Nza60OQ16jsOA81VrPAEcvI
	 xMiNuR/8rIpya9vtGQFUrrLHdiCB91tRr1MGybTCuF9KZYQTvCLjXSPHiSBDxGGixx
	 n4XKmLz26ZPq6akCP83hKMeTDuTdijmciLcZ7XJrFf9tPLsiWh9q6KoZeVGC7cFJEl
	 cpe2hCAtWOdb6nbF85qBUKRvOLVI5mK6Fs7tk17pILUaUEVNwl+uz0SpASXAQ+LmRT
	 VGyiSabvKSacw==
Date: Tue, 22 Sep 2026 21:54:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL 2/4] fuse4fs: run servers as a contained service
Message-ID: <20260923045445.GY6283@frogsfrogsfrogs>
References: <178919524467.1033422.11195342952336631864.stg-ugh@frogsfrogsfrogs>
 <arL6faQ3Nq8MJHvg@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arL6faQ3Nq8MJHvg@mit.edu>

On Tue, Sep 22, 2026 at 08:46:50PM -0400, Theodore Tso wrote:
> On Fri, Sep 11, 2026 at 11:41:59PM -0500, Darrick J. Wong wrote:
> > libext2fs: fix MMP code to work with unixfd IO manager
> 
> So a quick comment about this:
> 
>        * It's also broken if the unixfd IO manager was passed a string with a
>        * file descriptor number instead of a /dev/fd/XX path, but the
>        * internet thinks there are no users of the manager outside of Google.
> 
> Specifically, it's not Google, it's "Android", and it's used for a
> similar reason as unprivileged containerized use case --- namely
> security.  In the case of Android, a volume server daemon passes the
> file descriptor over a unix domain socket so that the fsck can be run
> on the file system without giving it wider access to the system.  The
> difference is that Android didn't care about MMP, so they never tested
> or cared about that particular corner case.
> 
> Honestly, MMP only really makes sense when you have specialized
> hardware where the storage device can be simultaneously connected to
> two host servers, and you want to do block device level failover
> between devices.  This doesn't really make sense for Android or for
> the containerized fuse service, so _not_ supporting it for FUSE (or
> Android) is a perfectly valid choice.
> 
> Even in the software defined block device world for Cloud VM's, you
> generally don't need it because this can be handled at the control
> plane level.  For example, Google Cloud's Persistent Disk has an I/O
> fencing feature where if one of the VM loses network connectivity, you
> can do a forced failover where the backup VM can "take over" the cloud
> disk, and the previous VM that had exclusive writer access will have
> its access cut off before the secondary VM gains exclusive write
> access to the disk.  If you have this, you don't need MMP.

<shrug> So what should we do?  I'd be fine with dropping the patch and
simply not supporting MMP in containerized fuse*fs.  It's a rather niche
feature anyway.

--D

> Cheers,
> 
> 						- Ted
> 						
> 
