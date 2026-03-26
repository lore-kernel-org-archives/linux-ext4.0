Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320F93C455D
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 11:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774526289; cv=none; b=sxmrl4yzTPEEn+V+KIp1eV18zDJw6TQCIChRPpcdEgJ7tsvAmDJvkOAnEBxGQ5fMkMSYXDt+cSD9PQ3XXYb23kS6okwkQRGN5njBKzhGa5qr+GSxBriw7EMG7tlkfHoJiotSMqgLxBh7bo/nvAS8PGKLl2zoLwc4sKmW6229nWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774526289; c=relaxed/simple;
	bh=oCmoDTvEbikoXtA/xHeQVV9HGNSSCRZwIzYz+9dIECE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qw5EoUNtZCcvCmSHfBszLDHA/zGP9gy40g0zEJeGzWA5W/o31J1oxMd2ufw2tYw4gu2J19Phmt9TDEe2hWnz6SIXqA9MBI/6SeAhU2nn3FU4iZkjG6eH0wUKYlXkJ7d/UJj1pisRHyBF1q+ZXlhsgr/Be62bhvPh+77whdyDtKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=g2/o4Ul5; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="g2/o4Ul5"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62QBvw9n020438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 07:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774526280; bh=AJGKOATFL/NqeKbJEJN3atmL5YQOj5AcMoGC1taBEek=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=g2/o4Ul5QOO3z/A+hWG4eeRCHvmVpvBWW74CL2Zk1B4UuqboS1TSxXjbtkDJRQQJv
	 JgqTu3I9xGVFKD9VAIV3y8WpRW9OwjuiQIocG3vyMgRzWYHolaYZSd3vsbgPAg+diK
	 knTV8IQmd4WtHWc+zarUk2CPwHCY2birQhIQGeL+g9c4NEISwnFTYBS1AyIAhJpLhz
	 JLN05aKzq0Cae85cgzJUJHYnuCCC64DAoqLN6m/8HjuU48cVCick+ftEEfPiJCzirL
	 S0Dv38gSI81JqOaMTPxoCd5v9qFnsatcBAEcJTpn9Eg0vEmfiZ4OhtTEV2GJsXbf1v
	 q5yCSj2uBUOiw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 055C42E00DE; Thu, 26 Mar 2026 07:57:57 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        Yuto Ohnuki <ytohnuki@amazon.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: replace BUG_ON with proper error handling in ext4_read_inline_folio
Date: Thu, 26 Mar 2026 07:57:50 -0400
Message-ID: <177452625028.1205486.8241953503891637067.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223123345.14838-2-ytohnuki@amazon.com>
References: <20260223123345.14838-2-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 23 Feb 2026 12:33:46 +0000, Yuto Ohnuki wrote:
> Replace BUG_ON() with proper error handling when inline data size
> exceeds PAGE_SIZE. This prevents kernel panic and allows the system to
> continue running while properly reporting the filesystem corruption.
> 
> The error is logged via ext4_error_inode(), the buffer head is released
> to prevent memory leak, and -EFSCORRUPTED is returned to indicate
> filesystem corruption.
> 
> [...]

Applied, thanks!

[1/1] ext4: replace BUG_ON with proper error handling in ext4_read_inline_folio
      commit: e8814f7f4646aa0bba3f9e9a446b07753e87117d

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
