Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DEC2BE7B6
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 21:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775250660; cv=none; b=TIAz0bjIsw7qeamLBlyRS8w0Ha5EDEnHefoWbEchBiFnB9HRjuGOLSKydrdWqQm3m0smQVsxbNb4Fw0Ql0hmZwUz7p5aH9x3Bn0fjZPsoRKggi7Xtmbgm+9M5Q6/DAbIqKLWZLMxaN772grcJHQ2nNjsEdFSTjMATk0x4kgy88o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775250660; c=relaxed/simple;
	bh=R0zG13i2APk+38/9C02BBQ40SYVOp15vZfrwBEycE8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pHyNkfDiKb0KmZFlw6WkUkqolN2CA0mw+j3jdrxzcMB9KNgQuiNAj7QvrQkM1NdqBY1GGzYeGbKyiyhHp9culvfI+4H8sd8GIikXxLgY9TMTR30ry+R+Q1itvqqaSEoR4bcK2d4FaKDve4nlub4+My1KxgnxCX+n0Eanq5jHOqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=iOGJ1KR6; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="iOGJ1KR6"
Received: from trampoline.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 633LAoK5027298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Apr 2026 17:10:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775250652; bh=9WW5HqefH+h+kI3Rk+Oj9hZlBEOeVG2KOfcNWyp3hmg=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=iOGJ1KR6GQVk+i6mbXXGUEP3EV9fVMeyHUc+lvBzk9inFt1t5kQ7Zh0cbAK2uGCVV
	 7rPN1ssji85aOSURZ83wV6GyfRAFf758ONXhYPBo8OcvEaFp6RqAVbSklvNNBck8qi
	 xk9s6CLmbTGwxwaMdPsYFeUw7E7AQSsmhzlodXWLq08zCK2xh2Fzjz4jBduiUFFuwR
	 6ZiNVXMp0PbKPUz1YEbvvdUgdHjt0tDG5ZUMiezWGeRajPfigUtUI6MjBWdYHv2Wbm
	 8fybp+tyoxJZQVmBRVT6VdMY4MuPrJstTlqKDPiDPtZm2NkXYpuJQRW1nBdjz33823
	 SolUeccUFtRpw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id E30C22E00D6; Fri, 03 Apr 2026 17:10:49 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Alexander Zarochentsev <zamenator@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        Alexander Zarochentsev <alexander.zarochentsev@hpe.com>
Subject: Re: [PATCH] e2fsck: large dir rehash fix
Date: Fri,  3 Apr 2026 17:10:46 -0400
Message-ID: <177525063667.2437342.4994406272190796464.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260226201334.3260754-1-alexander.zarochentsev@hpe.com>
References: <20260226201334.3260754-1-alexander.zarochentsev@hpe.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 26 Feb 2026 20:13:34 +0000, Alexander Zarochentsev wrote:
> Use EXT2_I_SIZE() macro instead of direct access to i_size in
> fill_dir_block() and other functions. W/o the fix, e2fsck -D fails to
> optimise 4GB+ directories reporting "EXT2 directory corrupted".
> 
> Fixing a defect of overwriting the node limit and count by the first dx
> entry in calculate_tree().
> 
> [...]

Applied, thanks!

[1/1] e2fsck: large dir rehash fix
      commit: 0e4de3c7cb8cd1a4a26b0cafa647dd380da28864

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
