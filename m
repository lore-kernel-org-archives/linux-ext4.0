Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F42C423162;
	Fri,  8 May 2026 21:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778274720; cv=none; b=U14dROaxfJQfahhLFvuY2bYV0R1/hxyFAwNjWkoApKdzXvajSptP4V4lu0KTvhlNZVZAWGbhEfJDFcHhiZ26Wmh1dXc8e/1Ykl4snA5v+zrhsui9f6Fr/D5f9Ykl69Fo76vnpomfZ0roG9SG4diWPhkUAWUrVuSaRu4G4xjOIDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778274720; c=relaxed/simple;
	bh=8UOZ4FJeYIixJHL6agUsws6xAPG4Wb3t0PeSh49HEFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMByRoXQm3TI23q7YAXkrcbGxcpnoNDKAjXD4dB4g/mG/W+s4Q5RbUPPjS6c8w6lEFj1pOw5c2R0pMxaoJ39Sn5d7UYZoI5OriZ2hSBJCjFdaSjFIjiJ8UnzMedNOq4FFtBGrJFwu2Ea2rJHOuZMR1pLVGDSmcVjygSDStEb/3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lHM/fU3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lHM/fU3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A705C2BCFA;
	Fri,  8 May 2026 21:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778274718;
	bh=8UOZ4FJeYIixJHL6agUsws6xAPG4Wb3t0PeSh49HEFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHM/fU3la3qeYTmzwgTZ++rGJ1Ek5CpWY6bgvEU0Uhb3IgWxTxwUd0UUL6hUljrB4
	 qHbYXsRocfppXpLiT7zIld9RiD+cfZFNUAzE3XsOYWxwqzUaPTvX7LV7x8nuxr+JUE
	 6rKu5Yf8qzrqcVnFzOkXmlqplqZIeAf74/KOyLSy9mZJcH57Lh3MW+lyLwynwUU5LL
	 EjXk/TlqYdQO4LI6FjS5qdjVJyzNGnh98yhksqoNwTM7OqvrJMb+MzTKV/h14gVZdH
	 66uaCa6CS4HyfgyQ7DJ7SCHMys0qnqmrSkGlTtDZWhOOAKTMYFr8TSPbloeCAkp3/l
	 86b/iQZyFMtIg==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	tejas.bharambe@outlook.com
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	Jianqiang kang <jianqkang@sina.cn>
Subject: Re: [PATCH 6.6.y] ext4: validate p_idx bounds in ext4_ext_correct_indexes
Date: Fri,  8 May 2026 17:11:44 -0400
Message-ID: <de25b3e20974fadd-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260508065845.3031006-1-jianqkang@sina.cn>
References: <20260508065845.3031006-1-jianqkang@sina.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Subject: [PATCH 6.6.y] ext4: validate p_idx bounds in ext4_ext_correct_indexes
>
> commit 2acb5c12ebd860f30e4faf67e6cc8c44ddfe5fe8 upstream.

Now queued for 6.6 and 6.1, thanks.

--
Thanks,
Sasha
