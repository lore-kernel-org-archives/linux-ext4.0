Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E28C18871F;
	Wed,  8 Apr 2026 02:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775615241; cv=pass; b=BzryrqGHbFadUum+gfzjDqe+i59ocy01XUZcHO5MI+pAQGV+iZCEUu9qWLFwtc8ktbkb9eXl6n7uBuy+Xe+dpg+B832KHOxOmHRHHGlXH/eCPEbIPlDIMtdiUfl8noBlLgk7En3rmAl2au7aXXFXAyhiTsTqZ8hgcNQTWttrtK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775615241; c=relaxed/simple;
	bh=N/ltqINkh2/c/d168k2F6BYTluvcvXKv64rdp8sdKnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COaxuhvUXWg6jij/JKZ8feeAdFDvK8Pctf0PkjZV9wkhesyfx1Go2SLQ0DSIGKQYoovlfy0xTR0it3idL6rKN+uusHn50VrplIEvgnNO57UGt2OWVK2qHSHvCVNE8VQ0q/IU77o/wIa1eda9uJQa5MqDjvZAi4QGGFw9s7+08RU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=NZjcjA7l; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="NZjcjA7l"
ARC-Seal: i=1; a=rsa-sha256; t=1775615222; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=OD56zDbUuOy9ZrVwvp0U6+2y9lDQCQ8IsPzXwGwibGUBbUNbVrQKj44EC4FwlvKUHVnWCA38upURzLWM8SIAm4U0l/fB7itnrzGfp15+WO7ANgfwYSaX6bAvn0CLLa759VTjGhNrMJBhg+bYFmLy+LDL3zf5gIIfIxo8ze7lopQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1775615222; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=N/ltqINkh2/c/d168k2F6BYTluvcvXKv64rdp8sdKnA=; 
	b=haSLwAPP7r9pBn15VcoNUgLk074yOrRZu4vVjXlVvPB1/tGP/AC8rwtJrbBjt2F62L+1v2JFmiFfJ/zOAN1SuDo0fjvWzJvO7+P/CBNJDiFRHfL9QjCbXFIv6RTkEE/lIjXbUOVT1vCGG9WODKAOzzqZM9CbemdEsQ6qm/UZoeo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775615222;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=N/ltqINkh2/c/d168k2F6BYTluvcvXKv64rdp8sdKnA=;
	b=NZjcjA7lQAhde4g++tBnPWE8o74b+lmpiz1n0eAFup5+GT9uPBHuuv830kbodCXu
	XdbvFrLtTbJ8mZ5gJbzH+pCMSlxMsCxYlvHYtMEzTRWuztnpqhGva3JjRol27qg4+TN
	N3ONYSnm26f9DHgZORy625bfiEJ9kv9RoTlYAqHg=
Received: by mx.zohomail.com with SMTPS id 1775615218815883.4975175356943;
	Tue, 7 Apr 2026 19:26:58 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	Mark Fasheh <mark@fasheh.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev
Cc: Andreas Dilger <adilger@dilger.ca>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] jbd2/ext4/ocfs2: lockless jinode dirty range
Date: Wed,  8 Apr 2026 10:26:45 +0800
Message-ID: <20260408022645.2070599-1-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260306085643.465275-1-me@linux.beauty>
References: <20260306085643.465275-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Hi,

One more note: if there are any remaining concerns or comments on the
series, please let me know and I'll address them promptly.

Thanks,
Li
