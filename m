Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26EA3F1ABE
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 14:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779979145; cv=none; b=lSPs1MqcQxvecfkXIh+NDJg8udBkIJE5iSbQKjfPTLr5/yR1O3VBohRSVq+aOK3VHcoPkGzZdZb+Zt/Nh6fLnARVXfc9FItZ2S+M8N8TIfChQY0rkYBTBnl62jJWO78XJTQ515Fbjyte1Ue9enQjXYq87H7srv44d5t75Lrq57w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779979145; c=relaxed/simple;
	bh=PL8ZggmBsM2GK6JkfPEi429AlSD4Zx1vPEt4hJBvBLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bNkyIIgsNQ3/aiIfUi3dCPrK4hzZGWby2tjxNEvrUYtlWhYjj1izLU84vZ17TWzLEc/m7EccnBZpPh3ouOv8ILtcTlrIpcXc3UtusxFOdRvdOOCwxXEKXXVunYpjg90TPcqbILzv2pv7kr2zhqdojDAMW6B3TLgnwpWMv7w1puw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=gTwuesFw; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="gTwuesFw"
Received: from trampoline.thunk.org (pool-173-48-119-150.bstnma.fios.verizon.net [173.48.119.150])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 64SEcgbq004825
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 10:38:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1779979125; bh=S9yihcpOhzkXTIYeIz2NTr88JdCigT9wrVOoD+kyTKU=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=gTwuesFwsMk4cLHVriIXSp/Mgs7I+KyHiiEFyJi46/k9YzjRzetADQ8rvKmOuzJ5v
	 PydYDRSnVbsZ2i9PRg4ANl0JCZSfQHLu+Vo/EcjjG+9G/k/HGlV6LDGcOo+dI9jHJ+
	 TIpNt1wcUG+RuZ6SawS6iIDivRE+Z6xFBR3oJBLoWFi/6+84PgULkMwDyuQycrNh4S
	 v1lh5ZRXiZPYbpbTE3GLS1MIFAlFS/9EZZn2IKIUgwbpn/m5s8s++sJs48xVjVxwS/
	 txr53garXiew26qMR4dKMQwHHQbVLJ5W1fd/8kubOJQNZOxdiZw8FwgD189gXuMrUd
	 W648ZXSTjFMUA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 949502E00CA; Thu, 28 May 2026 10:38:42 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        Ryota Sakamoto <sakamo.ryota@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Replace KUnit tests for memcmp() with KUNIT_ASSERT_MEMEQ()
Date: Thu, 28 May 2026 10:38:39 -0400
Message-ID: <177997910349.258983.2452786297027021237.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260127-fix-fs_ext4-memcmp-v1-1-5c269ae906b6@gmail.com>
References: <20260127-fix-fs_ext4-memcmp-v1-1-5c269ae906b6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 27 Jan 2026 23:23:23 +0900, Ryota Sakamoto wrote:
> Replace KUnit tests for memcmp() with KUNIT_ASSERT_MEMEQ() to improve
> debugging that prints the hex dump of the buffers when the assertion fails,
> whereas memcmp() only returns an integer difference.

Applied, thanks!

[1/1] ext4: Replace KUnit tests for memcmp() with KUNIT_ASSERT_MEMEQ()
      commit: eef9fb4e19bf99252232339183ee167c63457c57

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
