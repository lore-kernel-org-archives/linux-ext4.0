Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312EF3E4C8E
	for <linux-ext4@vger.kernel.org>; Thu,  2 Apr 2026 14:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775138457; cv=none; b=LlKtYY64mqjuNYS+8Yx5dexIuFot2d0sUigeI7a0uMKilQddHsoiNR7ucyPmLDZq4R1snFDo0OFe8ux2aBeSQE+7GI9/Q2bJi5XNoc226V/EsE5PlN/ovXuLu07573kMCXFM0iB5p57tiIXixPgaA/T53MUi7TbNpY7r3A28h4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775138457; c=relaxed/simple;
	bh=YfGF1AAhUHqFVMXaivx3STmJz5PfgMch9qPz6gz6B4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HwwndNIoysJPnb6TW4lf250/Orb6HJ11a4HDpwmeLIRpaw8cihon97wMtwcNLLD3bST+FAfBq02fsSc9GEpZdg/vvJtusFyqJeG8IWcYzvC9Ftzl6Yigrrw4f++dFHa44MbkQcdUMX8ZLufMSnxoW6CkdAxH4NrwZ1pJgi1LW2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=KzA4FUzF; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="KzA4FUzF"
Received: from macsyma.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 632E0mXl011264
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 2 Apr 2026 10:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775138450; bh=zEY8j9Yk0vgogzj3Iy68OGA3h4kn24NhUT9tRHjAie8=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=KzA4FUzFbOp6rwQ1D9w9vMYIv2paFhnZXDP6evGgcvoISMQS+khJmU1/4C0fneV5e
	 Kg7nfFsP/lz36dDuat8TfTDogQ+zKU1ntdvKliois1BTBbDRfcZ4Zs/D4DWXcAtRKZ
	 31F4icxIgNxjoikcsAB1w4z81eovme3BLUciUXlVmji1RvvJ848Bu2TH/l8SVlLStQ
	 nNjFOy+N3yQX38i4odt5h7CQb0MTIfknj3lI94nrNYf4jOjUHpZK53vQIilQC2q81F
	 d6j8wUXYGK8kCSOlW+a4iwaLCLI9q3ppf/HKLa0SW2aKKjyyOfM1r4L3D8IVbf4lYH
	 SO36h8oVLQIDw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id ABC8E60D9DBB; Thu,  2 Apr 2026 09:59:48 -0400 (EDT)
Date: Thu, 2 Apr 2026 09:59:48 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL 6/9] fuse2fs: improve operation tracing
Message-ID: <20260402135948.GE15407@macsyma-wired.lan>
References: <20260312205728.GA6004@frogsfrogsfrogs>
 <177334916604.3254574.11968947765826043346.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177334916604.3254574.11968947765826043346.stg-ugh@frogsfrogsfrogs>

On Thu, Mar 12, 2026 at 02:00:58PM -0700, Darrick J. Wong wrote:
> Hi Ted,
> 
> Please pull this branch with changes for ext4.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> The following changes since commit 9476b1377d887872f96d7144a81d2107cff3df1f:
> 
> fuse2fs: adjust OOM killer score if possible (2026-03-08 19:14:05 -0700)

Thanks, merged into the next branch.

					- Ted
