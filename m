Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3692F44C4FF
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2026 11:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787313523; cv=none; b=dRFQPx9KJp7tEwIcE7Zv0kX9OB1VwWF64Z75i16ZFMVXVnC5WOlgKOf9mj3a3Fwor793zRF9CHWQVHg2OxCC8PYPm1MOXEy1A2/oCye6I0y/pGdPZz9FOP/cltmkGMJzdZEb+uVA4N7dbId30W5z5+K5xY9eVldMujYniIeywlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787313523; c=relaxed/simple;
	bh=UvM4eLVVy5ASZwvqCc6tFdRALsGCNC4SrLkU2BRuGl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KTfwD4E6OcfWcQi25s/6mu3UVuODubKTcnis3hHOrCaSujMXcgcK5050Hk3ac1ygT1UDyPzd8BP28FM7L7KGk9XiXHGWnTQSp+hbsMzUVgtmUo9D/kIgtDwsLrSIc5zIYT5TJ4C7Nm1Pc9DFADxoYBgzpO5VEE9lUpAxwrAS7P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wu9q1mgI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wu9q1mgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C385B1F00A3A;
	Fri, 21 Aug 2026 11:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787313518;
	bh=I9huejkXvNmDTCklCrN7CDyHZOFjtzYTFl6Aw9Zuc0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wu9q1mgI8CnK0v/hVGHPxKq5BHBbFpeD23mD5IPhST+smWMOIf95WTlQ1iau/W6oN
	 4oZQ9jXhGrTYwyIdki1CvhSYdEKmKC1g5z//rhmc0gFWpxRjM9tXr/cp69bU6HOpzL
	 4uWeKxTigjj0VmbklQy6KeFPPft56YnLSGb1EskVpZcBO3hVbaPQBubtyJbBXFtBGI
	 HNpi6fJDq9MBd8YLTLijy39BLZH8sTnEpc42dwdQ1N6zwSugTmDBOpYGtcdJ6iDG4M
	 Q/1m4i/yT8TyTLs0WJVBGRMxRn5GUYQ6SuJGVg2eczJlX8xNch5xiiMBlGgk5/oB+L
	 MWt/QfNq6i5cw==
Date: Fri, 21 Aug 2026 13:58:34 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH] ext4: Avoid entering writeback paths during fastcommit
 replay
Message-ID: <20260821-habseligkeiten-rohrleitung-erloschen-032a83e4dcba@brauner>
References: <20260804104112.93202-2-jack@suse.cz>
 <modcan55tuaiafsm7ki7zpvulvicck5aqt7msu26indxzyj2sk@dqcm62sh3y4n>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <modcan55tuaiafsm7ki7zpvulvicck5aqt7msu26indxzyj2sk@dqcm62sh3y4n>

On Mon, Aug 17, 2026 at 03:55:31PM +0200, Jan Kara wrote:
> Hello Christian!
> 
> With all the vacations going on this fixup to apply on top of vfs-7.3.sync
> branch seems to have fallen through the cracks (I guess the note below the
> changelog was too hidden, next time I'll try to indicate this is a fixup
> inside the subject - maybe like [PATCH FIXUP vfs-7.3.sync]). Anyway, can
> you please pick it up and push it to Linus later during the merge window?
> Thanks!

Yes, sorrry I missed this! Picked it up now. Thanks for reminding me!

Christian
