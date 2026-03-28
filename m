Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B5B24677B
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 05:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774675901; cv=none; b=roZbfu3DXOtlKgvk5D2OvQ3uJAan2wHOxFNbCi/f90kHozxlpkPQwWN5OlH4mDecTGwvNnBy1lnUxZbu5qIgPjYPJ6v+tPiQ/XHpsw57HXTQ2/RGBadugiJlIbPyxnFjOdtnVv57JnDuqaa7boSVW7XLrQsQTOnyBsfA9jVvRUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774675901; c=relaxed/simple;
	bh=U0Q6eA2s4LMEKbmqR6dit7AoRaZXK1H1Agyx/sxnZJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sSf0zGYTef78GLsnAMPvanvR0qgggqFmlQ/JTZRZE6KPsbn+bqUmLtIpD1SCie0HTCLjBGWVeRJ7MiWGumg8dNNwb8JfCmKrCLDOAvHd1nCQAnB5oaH5AYft0XIoHEJbg5L8BhMWDBlWmzxd/rUU1SkDUVaAjnRglarSl8vOjkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=hj32yOri; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="hj32yOri"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62S5VFbe013523
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 28 Mar 2026 01:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774675878; bh=6YxS/OhFVTs+ouO6ifGF2bLg+hy/LSaJ643kdWxLc2E=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=hj32yOriAoOxgGBBWpjqz7vIOPBuGoKQ+AkKJwNRUuTzS8aes/XjKkyjvpvDKEcMv
	 h1GhzfTih1Wj0FVsgDRed6i3bOIBoA+OCU0+/4pRh2i5+1rRZl40ICgNxoPu1AqYz6
	 TrgH7ghdnOG99gW+kegqlWxiwNw8I6Yvn+hELj+eGFZJ+rFG0yQArJCf0Hi/PcvSOU
	 o4V4zxBHDSNe9VzUSieJPvZaTFdbEo6+0IZHXOK+LQ8Nv/6eGvWlIllbWVEjCMCggi
	 apP7ct3ckkKytjzWdX3VImHkOxvhS5XORXth+SMIMPHq9ZPlPPpjAnbtXX1hwb7DLk
	 9vm/kqXZUuV8w==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id EF3F42E00D6; Sat, 28 Mar 2026 01:31:14 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, jack@suse.cz, yi.zhang@huawei.com,
        ojaswin@linux.ibm.com, hongao <hongao@uniontech.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] ext4: skip split extent recovery on corruption
Date: Sat, 28 Mar 2026 01:31:04 -0400
Message-ID: <177467585141.1335526.2821362088564124448.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <EF77870F23FF9C90+20260324015815.35248-1-hongao@uniontech.com>
References: <EF77870F23FF9C90+20260324015815.35248-1-hongao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 24 Mar 2026 09:58:15 +0800, hongao wrote:
> ext4_split_extent_at() retries after ext4_ext_insert_extent() fails by
> refinding the original extent and restoring its length. That recovery is
> only safe for transient resource failures such as -ENOSPC, -EDQUOT, and
> -ENOMEM.
> 
> When ext4_ext_insert_extent() fails because the extent tree is already
> corrupted, ext4_find_extent() can return a leaf path without p_ext.
> ext4_split_extent_at() then dereferences path[depth].p_ext while trying to
> fix up the original extent length, causing a NULL pointer dereference while
> handling a pre-existing filesystem corruption.
> 
> [...]

Applied, thanks!

[1/1] ext4: skip split extent recovery on corruption
      commit: 3ceda17325fc2600f66fd85b526592bc8a9dfb9d

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
