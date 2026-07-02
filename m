Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAF723EA84;
	Thu,  2 Jul 2026 00:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782952722; cv=none; b=A6qDlaoSxDI0G7rBcv67De6ZzyXSHgjyN2SZm6Ev94Zu/cz3R0TkYtEYEfSciDT+2Avl9KkoLaxvs5vF9JeAsnJCEl0LuwpdTxAUFu0TTwums+abCSPW94P9p08Yzi9ahANrKp6V6kw5+LeQabx35BzrTxlL/g9AZk+Ja104S5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782952722; c=relaxed/simple;
	bh=a6vCZh7qQ5ltEbHUkQzu66tNw9GjojCxbWkvzXLnnS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STBUVjlKEQiZ5qIqPWdYSX7KtT6Jpl7EAG5eKkyyvNFrWKWbix/2JUXyo7odO2b3rWB79zITjz3AqmQ6hNvh4TX4LyLKGtk7VoEFEJF4lrMJToDU8KFn1rMWzL3zCuEowdvVw6GKsPVTfxs9hDLxx7rF4eYZQhMwKlXFW9ccp5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WFVLZ4Lr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WFVLZ4Lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265D41F00A3D;
	Thu,  2 Jul 2026 00:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782952720;
	bh=FirefrJifF+hN9FiUE8KWPoLfzeDTpIGvbAYAcbCzTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WFVLZ4Lrywfp5yJF2+YAwdE31CZckQ5r1f/Sqkn+Gc8pw2XQVwg0bxwtpzKcy+NbK
	 usr8Ch6ssEmvHGMbFI2tO6M0W4PBMs6w9QHHif041QNnPf1jIycs8zmTWDswqRRkDi
	 ZrCkS+a4E/UWtNtqSDd08vv0nb6CzGU+XLDVgvPpbik/AJ6+x5NVbVaXOqYax1KxZo
	 xIQ4+X1XaGfUxpdb4qc7yoRkplE1g1HbRrjGeXhKpGMah1lV4SD1LXEYlxpzKZ6/vf
	 ddt5Z17ijj1ujmuUPEx+sCvfF8qz4jz+JD9RO+Nrc/+Q9nI7TnjS6fp+53bApwh3gk
	 flx5YbTW8VR+Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuto Ohnuki <ytohnuki@amazon.com>
Subject: Re: [PATCH 5.15.y] ext4: add bounds check for inline data length in ext4_read_inline_page
Date: Wed,  1 Jul 2026 20:38:25 -0400
Message-ID: <stable-reply-ext4-inline-515-20260701193800@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260630163923.50039-2-ytohnuki@amazon.com>
References: <20260630163923.50039-2-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Add a bounds check after computing len, returning -EFSCORRUPTED if the
> value exceeds PAGE_SIZE.
>
> The upstream commit replaced a BUG_ON(len > PAGE_SIZE) in
> ext4_read_inline_folio(). In 6.1 and earlier, the function is still named
> ext4_read_inline_page() and the BUG_ON was never present, so this patch
> adds the bounds check directly.

Queued for 5.15.y, thanks.

-- 
Thanks,
Sasha
