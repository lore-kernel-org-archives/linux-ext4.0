Received: from relay3-bqueue-q.mailbaby.net (relay3-bqueue-q.mailbaby.net [68.168.210.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49CC346A1F
	for <linux-ext4@vger.kernel.org>; Wed, 20 May 2026 19:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=68.168.210.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779306678; cv=pass; b=Cr8zJQnNf4HaEt+9uEQ179+iQzzLKjoh6crz/tKi8IPUj594/d/pg6zWRHYoCT0zdb/cyh7iHG/cJl/2i1bJZ05ZXb5jmCz+irjmElgEkAXr0FnVYAHNtfCLvnJC5jDI7oZODzGoVwAA5tkmMoUe4IDabg62ETD8+BsKcGxacn4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779306678; c=relaxed/simple;
	bh=Dnv70gKF+9iqSmEfvo/HWBaqzsm6hs/SkCywC5me2to=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rR2V+SEGQG1fn9HvnmEuQV1MXDK3+0TpbbtcMrCa/yV6fAw7cMoeDfSRcYMoL3nF2XfIcxM4T936xNVEBJoaycdaneHf+T24DoaJtk7crnxWNh8z15J/VlUIYHeix9MrmeE3ZdJu3Q0is2OqKiEEm6+U/jBNMptqJqjbilWFOpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=agatha.dev; spf=pass smtp.mailfrom=agatha.dev; dkim=pass (1024-bit key) header.d=mailbaby.net header.i=@mailbaby.net header.b=qFI9FEQU; dkim=pass (2048-bit key) header.d=agatha.dev header.i=@agatha.dev header.b=h5G10O/h; arc=pass smtp.client-ip=68.168.210.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=agatha.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agatha.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mailbaby.net header.i=@mailbaby.net header.b="qFI9FEQU";
	dkim=pass (2048-bit key) header.d=agatha.dev header.i=@agatha.dev header.b="h5G10O/h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbaby.net;
 q=dns/txt; s=key2; bh=2w6HGaO36EDcrY4et/DG50qbmUBZzcp9XzaDSNrVQos=;
 h=from:subject:date:message-id:to:mime-version:content-type:feedback-id;
 b=qFI9FEQU039pbzkJ2FDAtbJjrLpQQoUDscC70JvkVwYxRhufGqfbLtS8TjW7s5ztXGrjTN/Dc
 X+vZD426UiBSH1zo18+C1vzSmFfwJNjEcGzlGpxkWngggPbzXiRfukwpxvsBV6/00EwS0LLOm5d
 cTHZS1FrkMnoW+kXRi/+/7A=
Received: from mb-nj-kvm1.internal (mb-nj-kvm1.internal [10.10.2.10])
 (Authenticated sender: mb6724)
 by relay3-bqueue-q.mailbaby.net (MailBabyMTA) with ESMTPSA id 19e46ec330900071cb.002
 for <linux-ext4@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Wed, 20 May 2026 19:45:45 +0000
X-Zone-Loop: 3e39f7a5c49c4d7f517a538cbad29ae8c51733204816
ARC-Authentication-Results: i=1;	rspamd-cluster22.mailbaby.net;	auth=pass
 smtp.auth=mb6724 smtp.mailfrom=code@agatha.dev
ARC-Seal: i=1; a=rsa-sha256; d=mailbaby.net; s=detka; cv=none;
 t=1779306345;
	b=IyFQ5WPp3F62cIGeTe3MWoESMyFeEVHoWr/SJ8n0DmR21hRkFOds6VLwiM+5BREc7m7wL3
	fIv+RUHmK5kXApuC2UmTiv34SAsFjFxOSH4K1gv6eRdvocOXdqoXUJxVuq0fz8gALD6fIZ
	HE4ZCeOaQs+P6F7GHbAdwn3oQB3qqgaxTPlqsTfZcInvOzT1ZVPlbRzj9ZkzPySfEuPtsw
	OSEx7qr2VSHCeUXORkj2Ib4XfPjwLeTLvUpBTAl6qfOsSwRmDvISm+XrnP05b3k8cz/DAW
	SzmYmElS9T0k65RrZbEPAB3ham+ZaZe/m+vjEXpHoT3Qy0HMrYZecT4f4pY+3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailbaby.net;	s=detka; t=1779306345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 dkim-signature; bh=2w6HGaO36EDcrY4et/DG50qbmUBZzcp9XzaDSNrVQos=;
	b=g1eweTUe6KDFteHXQ6Q0ufvVes0OV3G5ejBuYgSGaPPpj2i/UfDUgSMZStI5b2rzpilflk
	o6iNCORUflgrLDyzPAJjXF2Sj0TFqZGzZcnHZE/JRUI1thVGkn5qRkSsvUEh76dyXNmF8l
	hnbeczQn3PsmvBYnsRbOKnVblCRibjT4+kYJPLQixUVLAVsbUxj0z/KK7FQX1lxzJgOcMg
	iuNiOJdi5BDSqKUYNd+KuPuT5db+6hnmPVwEjOLaGOSLbt8NjSyncpJgPBDVtGPbc7nTgu
	nIIPiMr0aCOVnkKCJ20pvM10lPPZcEkXhd4Q5b+8nkWXPnMhW/VJbm6AQp5HZA==
X-MB-ID: mb6724|me@agatha.dev
X-SPF: pass
Feedback-ID: mb6724:19e46e:507c5a5c5e5d585f7d5a5951:mbaby
X-MAILBABY-ORIGIN: PASS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=agatha.dev;
	s=default; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:Sender
	:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2w6HGaO36EDcrY4et/DG50qbmUBZzcp9XzaDSNrVQos=; b=h5G10O/hhxlIR1Z3KTPrS6ytDI
	Xpe77E/Emg5Zi0Cg6r7rL7n8MZ+reUDkb+mkQBPnzg1pjJ08uBk6l0ypwUkQFHx7yhIAcCXkRijRl
	Y7+L3JWB9ol8wOZ+3ZaDzPlE0cV6xltYH+b+IvTYmk374VYUyT5vv8puKoJBN6f05an+d0HKZUkAp
	uFwZs1NJjk52/Yup2/B8VI2KL6CdAUERapE5Rt5M9gc+Lk0UJ9oA9oe6fE/IKRIO+GU+8hh/vbWvb
	O53TRhyfOcgWTAd0qhh0ebi+R+GeyJSVRzwsJX8gC6Vag7x+qCNVIPe9aswEctwJ59JvKoU6qU7tG
	m1ETnpGA==;
Received: from [170.254.153.136] (port=34429 helo=guidai)
	by nyc3000-r.dnsiaas.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.2)
	(envelope-from <code@agatha.dev>)
	id 1wPmrT-0000000EPaQ-0erX;
	Wed, 20 May 2026 15:45:44 -0400
Date: Wed, 20 May 2026 16:45:35 -0300
From: Agatha Isabelle Moreira <code@agatha.dev>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	shuo chen <1289151713@qq.com>, Theodore Ts'o <tytso@mit.edu>, 
	linux-kernel-mentees@lists.linux.dev, shuah@kernel.org, patch-reply@agatha.dev
Subject: [PATCH 0/2] fs: refactor code to use clear_and_wake_up_bit()
Message-ID: <ag4PEP52c8rxrYPc@guidai>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-AuthUser: me@agatha.dev

Refactor code to use `clear_and_wake_up_bit()` instead of manual calls
to:
       	clear_bit_unlock();
	smp_mb__after_atomic();
	wake_up_bit();

The helper function `clear_and_wake_up_bit()` was introduced in
'commit 8236b0ae31c83 ("bdi: wake up concurrent wb_shutdown()
callers.")' as a generic way of doing the same sequence of operations,
but several pieces of code still remain.

Replace manual calls to the operations by a single call to
`clear_and_wake_up_bit()` to deduplicate code and standardize pathways.

TESTING
=======
Boot-tested on an x86_64 QEMU virtual machine. Basic filesystem
operations (create, delete, sync) were performed on an ext4 filesystem
with `data=journal` modes. No issues were observed.

Suggested-by: shuo chen <1289151713@qq.com>
Link: https://lore.kernel.org/kernelnewbies/agzoqV835-co4kAN@guidai/T/#t
Signed-off-by: Agatha Isabelle Moreira <code@agatha.dev>
---

Agatha Isabelle Moreira (2):
  fs: buffer: use clear_and_wake_up_bit() in unlock_buffer()
  fs: jbd2: use clear_and_wake_up_bit() in journal_end_buffer_io_sync()

 fs/buffer.c      | 4 +---
 fs/jbd2/commit.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

-- 
2.53.0

