Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2026F356773
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 03:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790220726; cv=none; b=rV1swCurkGyJNY8zMFfgFowDb2zXLTjfzDDDvoCuD8ZKRDINdCmHTybwN+kyiXb6xeGFR3v31zV+s7z/fItrRBlEf4F3sOWomBWNAv2j6acHALDWXy6jWJgcMYpXCAkCBznDGxwnfmG50znDw9Pfyfyi3zN4MDFc87oA0EhvnaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790220726; c=relaxed/simple;
	bh=br4Epr+VJpQMXdYIy9zU03xcSNu8Wp+UazwdmxUtmPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/PyoEEOiJCqvRnqIdjgFzgXYJEgNroR2GyEiySGIoBRPKPb7U2ifsT6gBcM5k3IfVIGyoftbluNpa2RKKI2loAVG7lTc6A7WlstIWUW3p4MTLTHhyLSD3O7nres8OEk7lhBsOGoxz1AmKWZ+ULu4Id/j6Qc8qfAHWi6sAgZDmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZxEgA208; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxEgA208"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d9004a1ac0so7208125ad.3
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 20:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790220724; x=1790825524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QbtwLXtGDZW5bj6EAhZpbLlhYFQEOQOAgcJ0D9VJbSQ=;
        b=ZxEgA2082e40a8gIPS+BoZ98QDX7ZSn+Rv4yUAbnqMxfrP+OAHthkOBeFDmQihJIkT
         p7ToNgWH3Y3yGa3y0QdVW8fgN9KrQ2pTgP4fBvHf/SkpjEHkBhJENlNVNYSw8V/0OiS6
         MaXjc1OstKmjGq5M9h0BwT2bJlqLQO0NFtw6ZjAVkLWV8ANYQ3xC047/dYCKeiILj85d
         0SApnng0pJEMpEC7V88QuwK1gSvsx4uPlzFCESiHhKOY6Hy/x+8QiBzRnUNBxWmrp92J
         0toGk+tIX86kc+2K7RLLZlUJpJVfFZyaCG+PrOPzWGd7V7GIusUWpppPnuFS/d4l7z7Y
         8dhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790220724; x=1790825524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QbtwLXtGDZW5bj6EAhZpbLlhYFQEOQOAgcJ0D9VJbSQ=;
        b=gmQsJookprs6VtEVmqmssBYSRgBXJojeUn5Af5HV4ZmtJsM1HphcvENSKD1Z26oBjp
         +mdDy/kt3tGmX0n/aAlvvPHbk/7rXov2D9GqcB5Sy9Z8lpSMVgrn2E+TnN+N99xnhaH5
         UwGCh6KjHd+FdpcfBqh7y1uayEwSFSdej7/ouvuO+xEKy/G1Rs95gZqhPQB6iWZhDVRw
         Rc9Zed/oXIv3TxG91zNawaSj53ikK+61jPa/JuqjdCEY5iVgGyJXFe7ssX/nsNvGK5fV
         5FoKmDho0xXvk0TJI1UTEgSgA8BHOwYIvXnmVKyUDC/3eLAn3RwSL5947O3CzLevaaQc
         KSSg==
X-Forwarded-Encrypted: i=1; AKwUvBxwouFH6/+zIYDKCSS20ronHpj50lF0KQw9lg67sa9RfNd6AUkF6EhXbUQeuRdTLyOgV9eeIhqY6J7m@vger.kernel.org
X-Gm-Message-State: AFuF++knu2Ov8TtZUX7ikqC+CVQsmUrF17CzfxlvH7P4Rfqo0koC69Ra
	/ITM5pjhIKpL4kaYfyC+fcSn88I++JE8oh90VQdSxOujlaVhuJKwYS5QUN3gZH27dGk=
X-Gm-Gg: AYBFou3Kq0nXEzV49c9sg5XV+72yiNSVO3n3FYEViEG2f3RnE5m5V0RLEIeZX5gHT6u
	D4u6HK1akIabgOOt4i1LqvIYESNQK561VqM93wH8JzWjtpesNc94dPJzeQNu9MDFfFF8UsrrMCV
	aGm26FYBUj2HSzZSjp9J+OxZFg+T6JgK1wSPnMNeG9H4KnM8udVCRN7NwZbemL/Y8DXw6q8gncu
	Lwlxrt/n9ccvQRAF7thN0EbmhbmOivslqZEK3rZbrKADpuxLPW3Lc14hLPE/WdJQMfvppvBMl1v
	eBbQmcRsmMjv9Sffn7Fo4xqwIxfmWe4gnUnk6wZE8lzWWonjxj60SAVgSbUaLutIFv4ta3Mz/5+
	X/D8zrRu7RfnGt6CiJZIwHVBPnDY/cg4zUEkoZCEj9LWDhp9X267FVZVIKpIEWi9V+SRCPwKZ9b
	ZtPjLgdb0lnENEzozRkTwluw61KvX4S9VWNJKatiZF9Bbbv4hle5Kne3rFs0pn54P8C6YboNogW
	OEulXadrU7wv2U478s0u1JAJI5sqtYaQnw2ColkZtGykbRHcYODi4NqH+U56oLEPDEx+1/j+2Hz
	AVcmLciZOrel2ovebpgOvZNmA7EA7IX1xUvl+ELDtjRCdkOKhGxFbxQJnORs5er9FahFxQ==
X-Received: by 2002:a17:903:244c:b0:2dd:ad74:ac29 with SMTP id d9443c01a7336-2df7e39facbmr9823075ad.27.1790220724183;
        Wed, 23 Sep 2026 20:32:04 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5a5157sm19729735ad.14.2026.09.23.20.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 20:32:03 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: name the ext4 dev branch
Date: Thu, 24 Sep 2026 11:32:00 +0800
Message-ID: <20260924033200.3615554-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <arSMwd1bGO1vrif-@mit.edu>
References: <20260923101749.3505886-1-matthias.goergens@gmail.com> <arSMwd1bGO1vrif-@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Sep 23, 2026 at 11:14:31PM -0400, Theodore Ts'o wrote:
> I also tried looking at the documentation, and I can't find any
> mention that the git branch could be specified.  Maybe we should
> update the documentation for T: in a separate patch to the MAINTAINERS
> file?

The header only says "SCM tree type and location", but the branch has
been used since hwmon named two in 2007, 109 of the 846 git T: lines
name one today, and get_maintainer.pl --self-test=scm has parsed it and
checked it with git ls-remote since 083bf9c56d06 (2017).

> I wonder if ext4 is the only tree which might have this issue...
>
>    git log --merges linux-next
>
> ... nope, apparently not.  I see a lot of branches which are merged
> into linux-net which are not mentioned in the MAINTAINERS file.

I'll take both on: patches documenting the branch, in the MAINTAINERS
header and where submitting-patches.rst sends contributors to the T:
entry, and patches bringing the T: entries in line with the branches
linux-next merges.  I'll Cc you on the documentation patches.

For the entries, my plan is to start with the roughly 160 T: lines
that name a repository whose HEAD is already in mainline while
linux-next pulls a different branch from it: one small patch per
repository, sent to that entry's maintainers as its own thread.  I'd
send a few first, to maintainers who usually respond quickly, and then
the rest in larger batches once the first ones have landed or drawn
comments.  You know far better than I do how maintainers take this
kind of tree-wide cleanup, so I'd welcome your view on that approach
before I start.

Thanks,
Matthias
