Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CBC3DA7D5
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834345; cv=none; b=APFK2SfFfY33jcGOTYqaLKfJJ830e7K8YulbenW/WPkknONVXQ0+fkT5XkMFZAB9JLGHMBeXpYb8gADYqTbgrdkSnhlOb1JCCIqI+UqdhTo619V/LEl0mWsbS59JlldYuzYpZ/UeMuIbVUt2cfQMKBodABX8PSVqg1rl8L80cUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834345; c=relaxed/simple;
	bh=zI4Rt0MdjCHmKaCtcxqC4SgBZR0yPQw8LHhpley8eHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ARU/pVCI6eynFZ3ZXvT7XYMJ7WEGmEShsCQrjkMAwZjrdVoI3B5pfdGb/3U/3x5v665b/s7c/jLbUHC2HH2EMTfen3YS8NaZLsrZ7LKK1aDADuaj9bNEVW13Qkqzzdm24iuV/NqP2qGqCokbTL3YgGD29jlL9hqvEqfkivkeGGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=bRb0qSrD; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="bRb0qSrD"
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFIm1Y015770
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834330; bh=PdmlhI7rIxD51gswBNIzrv/lx4zfdh7ygdVGzeoJkt4=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=bRb0qSrDvoY90GiQXFpmxRIXAnih4vYtLTLWHfkKohEBi0be0u19D4ZmMCibRSVqT
	 qzYVmsoQSLrGTDoTyVxjR34QKRHtzD9Rm9iwW4lsRoXW/rjyDA57s0dowcSh1YJNZN
	 aO7jrCckqgSGx1rVbrp+jyF9b3bV2k1PPMDhDBPQHaUhxvDJ/o+BxdC6wUtTKhqB6r
	 weERqkipt+C/RCuqYd+ixjUs06sqv3e7XUqW9CcwI09KwWCNJ+EYZUW4TrDdW2lkul
	 Lgv4Jia69EH1XyD9UvgSXbIKctxwIo7L6+8bIUHyPqDhZQPvQ4EFrn6Dy0Pj2VUJ6P
	 QzWemhuAjpbSQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id E3BE62E00D6; Fri, 10 Apr 2026 11:18:47 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: dilger.kernel@dilger.ca, Weixie Cui <523516579@qq.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Weixie Cui <cuiweixie@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v4] ext4: simplify mballoc preallocation size rounding for small files
Date: Fri, 10 Apr 2026 11:18:30 -0400
Message-ID: <177583430855.2758959.14090262103571091712.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <tencent_E9C5F1B2E9939B3037501FD04A7E9CF0C407@qq.com>
References: <tencent_E9C5F1B2E9939B3037501FD04A7E9CF0C407@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 25 Feb 2026 13:02:31 +0800, Weixie Cui wrote:
> The if-else ladder in ext4_mb_normalize_request() manually rounds up
> the preallocation size to the next power of two for files up to 1MB,
> enumerating each step from 16KB to 1MB individually. Replace this with
> a single roundup_pow_of_two() call clamped to a 16KB minimum, which
> is functionally equivalent but much more concise.
> 
> Also replace raw byte constants with SZ_1M and SZ_16K from
> <linux/sizes.h> for clarity, and remove the stale "XXX: should this
> table be tunable?" comment that has been there since the original
> mballoc code.
> 
> [...]

Applied, thanks!

[1/1] ext4: simplify mballoc preallocation size rounding for small files
      commit: af1502f98e2cdd43504596cd438f3aa6d0be8712

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
