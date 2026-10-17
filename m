Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E2A3C1087;
	Sat, 17 Oct 2026 03:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792206052; cv=none; b=rxzUXCcK/m3OYT8Zt9IR1WM+BXgyB7q/gUi+I6ECxTrkk6QMs5A1f8YjI1K1VwKPMCH7zhESdBi9cpdDpaHgbCIdxmmwGmLdk76lWFYOLo98pbSEGcjVsXMZw1wqjkyw5vUZBZR4zhmAqlGV+13LzFDMAGxllZa0QMyrKaNzRE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792206052; c=relaxed/simple;
	bh=2lDC6qhzL6NZZKbJQ4jlOI7PbsGW9LinTxIbKgX/GU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFiJ2c65KfKoV1M+onGihO21sqs6Rgs9fY72NaFrTRvbZi9Ajxhqtjz3OfRn7YXoAzdCJxzF44EFnJOqPR1UdvjE6F/sDdDsLY+MvPiEdUPiKA0eF0fdxe0as4+q7AMJWYWRzI3OoY6b4rG59Ncx8HbHQbud7o8kJelr7SVD1Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQFxRbNM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQFxRbNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A52F1F000D1;
	Sat, 17 Oct 2026 03:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792206045;
	bh=kswBNL6PSlWAbDf9ZHL7txVlDHOqZGITC5Re3cMuX9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQFxRbNMhCLo8he9Y+eH2iiNd9SAE4UXdzCTrlxKHiCp7/jZzmrE2gCfcFmTgdxBN
	 BdazD1/eJjCj4THVcD+Qs8eGkq/DAhblBBJxFDXCKpPiApsRkhSkjXy51Fb/lyeT2M
	 PVSFS3OQRJBUrZRB7/iWTuCcYQb7bG8X3wYOjWehGl+AR6/6RFE0hbOL7IsqLlmLe+
	 ZSnZwdu/+LD6JBm/+7WzB8PnbKa2jmPI7ssJiMj09ulny+QNrcKjHs4fokeFauZYlw
	 s60ymrw2yNwRZkpYdRBX62nGEt4aaDYs0XnmfWg6x2SS08yINdK0jO01MoUQTD4q2Z
	 Tbw71aW1HfLow==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	stable-commits@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	Eric Biggers <ebiggers@google.com>
Subject: Re: Patch "ext4: switch to using the crc32c library" has been added to the 6.12-stable tree
Date: Fri, 16 Oct 2026 23:00:21 -0400
Message-ID: <2026-10-16-1-daily-reply-0016-ext4-crc32c-drop-6-12-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261016171849.GA122880@google.com>
References: <20261016171849.GA122880@google.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Nack.  Missing prerequisite commits and didn't Cc the mailing list.

Dropped, thanks.

-- 
Thanks,
Sasha
