Received: from mail-pj2-f31.google.com (mail-pj2-f31.google.com [74.125.227.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F747315D53
	for <linux-ext4@vger.kernel.org>; Sat, 26 Sep 2026 06:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790403067; cv=none; b=EOnAyQJHqkUXQllZFuo+vWT0nTQffojyoM0K4PW2Xea+yBfuGF9MYpMZ7xxGPaaIrK6/v7chCi1zC11dAOnsjsy0H/Pbst21i830TWdZH+2nv5YGA06gwVccxFsx70K7tlJX1xdBC055N32MalMid75LLa8HwadVuNCzvlkmJJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790403067; c=relaxed/simple;
	bh=e0sh+X4uWKwxTqyDRgGWJxYmHS0sO2eyGPlL7vRQU2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzVvwbThhoOXTu2anOAujx4YbK6SMDWngeXEYpg4tThNy1xxX+0kR0Fgsc30Cf1AcBgW6rlspDx4/heLQroWh6h2tr6NJdhuG5mYh+xPochW15D1+/fi/pofqLskLIOex1pFQ/jluzpBrz6d/gTPD5OKzFUZnxz/+riA3Iv1cSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZL4cHaKM; arc=none smtp.client-ip=74.125.227.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZL4cHaKM"
Received: by mail-pj2-f31.google.com with SMTP id d9443c01a7336-2dd53691be5so10791135ad.1
        for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2026 23:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790403065; x=1791007865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HTuLRD4gLUkoEoxiCXvjrXSgPMj/yc7Cgjfx4veeJDA=;
        b=ZL4cHaKMVnQMxHXZaDukFIJcqbyTAR3BxYavJ9REc8TZdRE7yXV4lnYbM53SxdtttA
         eR+RFolosCA2coJNK3b7OZ7Mc9zlExfd8z4KNFWk4E/r0DNlnGTqPulq/1TeuE6kRsOG
         WLo0t8sU3kpYnaSWrQ+7ywQ1jK90aDTAehEmNPSWmb0FabWf1HL7iayhPE3AYxarqZKW
         ujs4xSviKtHi6ql26WGMSR8LPRE6Cy6O8XYBjjCRU5/nHtrXcKDcdQ1mM9Qzw2SVqHEL
         pnDNfDaRkv2KzYaBg5Jj0G5Wu06UQhKop146DTQeO17nqrw7gwH8pdq/KEOK/FHcBEKd
         FNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790403065; x=1791007865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HTuLRD4gLUkoEoxiCXvjrXSgPMj/yc7Cgjfx4veeJDA=;
        b=DnbiBsylfgawFjxVbOAVGxMFjW+EUB4b/0Tvyu3cs38adciFvM5q98N6E0y1H8vTfY
         RGfcOj9U2sGJU5hLz2jHHX3wIRGEuzdGDwLmXYL4JTCOV962KvPqt/DhpxbGkaF0jaWU
         GKjwgH/2XxxZLjEsMmPxKFdeFvlrat5hb14cB05zrJsqq1Yd/qodxwYKikmwjhAmuXIM
         +mVNHgsc87X81nNNAFeFXoPF3JkjqksODNq7cbLNMWWPF9v7WKa/2oEvOcqzKsxBCH+W
         KpxZWIpG7YyYi47D/awt1sNI4JA3ZjxfOZVq1ZLgJYmMuUyHHNs2oNgHH0euKGt67yeQ
         iQLA==
X-Forwarded-Encrypted: i=1; AKwUvBzTf1DcPq+UH1ifEkSm92IqlEFgEvVzb6VRwoNXPdRZ0hLBRIrIO2APnJ1VwKp/TmDY1wm0RxjTK1h0@vger.kernel.org
X-Gm-Message-State: AFuF++md0Q1yxK8guvGzsgHLsGXOJPWtC8k3z5F2CEYK+M1m9zfLQX0r
	pmMVRzWmiqeiCtfljKNfYRWcxjTUaVsDpiNZGd+DRHh2K2mR/O2SCPkr
X-Gm-Gg: AYBFou2gBGTN1ycw3i/Tq6suNwoqE5uZPhS+xUhXGFglLsAIgqtdeZKNYHxHpr5bTOT
	Ru6Ii+/qW61z9T886pVmNi2hbcK/H4+THhctSbGMhI8rPTlePR7m3ENMh6wApCHd+G5x0fl1CJX
	R6q6qULppdoRdvcTWfXh8KyQaoLFKjZoN68rkUzj3knYmOgPEiVuh2MDgDI03aLJO9dr3exbVAa
	TwCVNYzeYyPBAhjkhtITUTQe1lC/dThTNBH2x2zNln93jqX58TsUwJzuUdpf1ViuKQ03iNrW3g4
	ujqXoafm82AA7KYOFvyO5fPYnDPoM0EbIJEEGF62cIkjTJ035OP3H+A4sM8e01ZktDWwHuaFQp/
	d8lHZ+oa/Z1rk+QCiuLbjA8NVkfrHmma4hgq2pP0KzLo3yJFBtVCyKNVAk+9xPNY/Y+osexYliI
	LISJGdJwgN61Kj9EibqlqRs82VWAheeniD4cVFzm6sDH8fj87evK6lbmD8Db41eqKGsrBvuQ2yn
	cBJmXlBhWBk9VZ8ZoSMKhTpVsFUTajFhs6iCTz5Pm70wAKFMpeyUZ1PmFtZVcXjpyY0KeV7VHmQ
	2Sm2tVjKCf2kqwLWHG16OCdfLHXIMjvhehzxjEpmEHAhiWoyAK4DfkQldB8=
X-Received: by 2002:a17:902:e884:b0:2df:425b:3082 with SMTP id d9443c01a7336-2df94c4f0a2mr31166575ad.57.1790403065120;
        Fri, 25 Sep 2026 23:11:05 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df91423df7sm19001435ad.43.2026.09.25.23.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 23:11:04 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Niklas Cassel <cassel@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org,
	dlemoal@kernel.org
Subject: Re: [PATCH] MAINTAINERS: name the ext4 dev branch
Date: Sat, 26 Sep 2026 14:11:01 +0800
Message-ID: <20260926061101.3812389-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <arZx1GSVS61EFaiQ@ryzen>
References: <20260923101749.3505886-1-matthias.goergens@gmail.com> <arSMwd1bGO1vrif-@mit.edu> <20260924033200.3615554-1-matthias.goergens@gmail.com> <20260924040030.GB5048@sol> <arZx1GSVS61EFaiQ@ryzen>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Niklas,

On Fri, Sep 25, 2026 at 03:06:28PM +0200, Niklas Cassel wrote:
> For the record, there is no need to use a gitolite specific command,
> regular:
>
> $ git remote set-head libata for-next
>
> works.

Did you mean this as a way to change the server's default branch, or
for each consumer to run in its own clone?

For the server, I tried it with a scratch bare repository that has
master and for-next, and it looks to me as if set-head only moves
refs/remotes/origin/HEAD in the clone where it runs.  The server's HEAD
stays on master, and so do ls-remote and a fresh clone.  With git
2.55.0, this script:

  git init --quiet --bare --initial-branch=master server.git
  git clone --quiet server.git work
  git -C work commit --quiet --allow-empty --message one
  git -C work push --quiet origin HEAD:master HEAD:for-next
  git --git-dir=server.git symbolic-ref HEAD
  git -C work remote set-head origin for-next
  git -C work symbolic-ref refs/remotes/origin/HEAD
  git --git-dir=server.git symbolic-ref HEAD
  git ls-remote --symref server.git HEAD
  git clone --quiet server.git consumer
  git -C consumer symbolic-ref refs/remotes/origin/HEAD

prints

  refs/heads/master
  refs/remotes/origin/for-next
  refs/heads/master
  ref: refs/heads/master  HEAD
  (object id)  HEAD
  refs/remotes/origin/master

For each consumer's own clone, it works, as long as the consumer knows
which branch to pick; for tools that read MAINTAINERS, that is what
naming the branch in the T: entry would tell them.  Have I missed
something?

Thanks,
Matthias
