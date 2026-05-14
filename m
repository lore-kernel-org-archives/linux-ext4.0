Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DD4384CD0
	for <linux-ext4@vger.kernel.org>; Thu, 14 May 2026 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778770921; cv=none; b=Zb98Ut5YSGm+U1LpB0PSA6Fgx1ZlXxCTm9AYxTCmlEQum10Bf7gw+qvKwVMkex2RoI1u0oYONsRYbaspZcm/WO4DkFeB1AiV7BY60rZP7gsRK1i2MfVYAAu/jQiWpX58OvwYQ6mKwlIVIptKQAncz7wfR3EOh/JetmEGzJeMHrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778770921; c=relaxed/simple;
	bh=Fj9YCGmYvNJCmvt3/bx6f1pCMI4BzS8OVMGmLRETOVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AFDkS7PwNZHIvh/MhtVF40t1W6WMypLs9CDWuNgPluuVj/4YbNq/WYFcuJ9KnvGa2y4zXsZ5gcuhpCux7tqisr1i4x9vNCsQupP4H5K+onBC1j4Iq0GerG+toDjy7uSAb+n+r7xCzrst0A3e9wCVVo+vJff0QPbNZU++Amkumd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=gCjHm5aB; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="gCjHm5aB"
Received: from trampoline.thunk.org (pool-173-48-114-144.bstnma.fios.verizon.net [173.48.114.144])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 64EF1isv009201
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 May 2026 11:01:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1778770907; bh=zKGp6Q0Phf3WuvVwZq3HE/QhI363fUuqfOuaNHuLwNM=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=gCjHm5aBWn3whq0ztyE2yC9KpsXAchX7cRnDEc0ma7LIA3kpc+bOMyC3946IIc+ch
	 oE3r1MtE37hxRNsxwZoZJmYChSJUKzG0QW802I4JpRX8F8ZiZw5HfJalKe9JQ7k+7G
	 EYfuNzEoOhREM4DzXwydzP49Q0og09g/9L61ksi23A9fB24/QJMTt8TxIEAmBjcYmz
	 taOV0LNOSnr0J5hwiAND2BHp6bPs0olzzN6weBBFGHwB1sT1VUzWtNx5L65b0ro3D5
	 6h1K0DrAQqzQgU+TnYPsBGYSeaE1PmdLc5kqzYynEXYxHVUpK3FFDSkTcKU7/hQGbZ
	 8CEq7GJ4lRD0A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id BE0352E00CF; Thu, 14 May 2026 11:01:44 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        jinzhiguang <jinzhiguang@kylinos.cn>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] doc: correct date in release notes
Date: Thu, 14 May 2026 11:01:43 -0400
Message-ID: <177877088149.2991662.15741501327491125756.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260324091259.1167-1-jinzhiguang@kylinos.cn>
References: <20260324091259.1167-1-jinzhiguang@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 24 Mar 2026 17:12:59 +0800, jinzhiguang wrote:
> Correct the date in the RelNotes/v1.47.4.txt from 2025 to 2026.

Applied, thanks!

[1/1] doc: correct date in release notes
      commit: c22405c8880b31fd4c8574feccea989643e588f1

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
