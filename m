Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BAB3FBB5F
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2026 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114464; cv=none; b=hq0nvLZwejzjSpBn2WzT2Yxcd0g0dt46E7ZZzNu5yFuvHBvZ2RHPMYcHDCVyVovHbQfGMMV4fxYCTCBu74KEZikpJjGbsXXDlDnYS1TwOIZWeTOz3dcQxtNH3WSPs92H1RIOzElHf/4K3ZEBPpZ8Y+GDhzgncINKsIWCye/BD7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114464; c=relaxed/simple;
	bh=56sWDZSA5ZNIBjB/oNotI09lBuHC1nOmFFOAgN/NOPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OZgeHOiPIyZtOkcdDquA0M9ZF3PsIApt0/3nF2TBEoUGQvbfRrDbhsDWUvcc6e6v0QZINXeZI1dhwSk0+AbJ+Eo9f3zrS6erS4C/xl/XQnNuWPpzb68R98idl18z78qgcMxfeGYE0bG2CT95xAWOfmWQATLxtzKI/znyDDseD7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bu1YOoyl; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bu1YOoyl"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-366be8040a9so894164a91.3
        for <linux-ext4@vger.kernel.org>; Mon, 18 May 2026 07:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779114460; x=1779719260; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NOAvfoTQyHNmhGQizKaH8ZeJlbp3fMLtJxwZtNlPMco=;
        b=Bu1YOoylQdoXGLSRGbc+FeNPAdYEXONPajxy10NEJ9/9pem+7ErubmIHLK8qYHYqbR
         M9BcN8nJmIj9WAtswHFYnL41+vyl/oFZ5K3YYQTU6yOhp10dNa3Z1lYLr9RYJuZ8bae9
         vu8SSalIxPwdicF3Zt+ROHKsdie6pYIpImxqhwsRcK5iQifVWH2fvg0LeJdH2wnnK1Y3
         C1Wxa+aZKUHS+1rTDROoxNsFgUe33Xt078+IE71KxRQXCZnLqpzTPqUOKUhUYNFzUKjB
         0Jf3BvfUG9VhqMRWI4UEOVIk0UPl+KDa3U/n3/H6eiydgdOwxwLziIPa4atUWkdVBo/v
         GaFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779114460; x=1779719260;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NOAvfoTQyHNmhGQizKaH8ZeJlbp3fMLtJxwZtNlPMco=;
        b=K9jT9bscSppl1e4nFBxH6hgFY8UBl4gI4tW8MDDso1Iy4c55CyY4GZ/fP9H0GEQX4V
         /+KeUYYL5d+3VSlS4jDMdMz8PJQ74p+BzBuEZnI0bW0S02GC6UXMkEC6j4US3acgcSqs
         cBfs2qyIm5LsEEpOyl/fBpmAjxAkdBE1XOqGXQlzPdvHE+Ue2J3PEKqZnFHfO3uxivXj
         KLop4lnbJjInUm49HJhXyCe75QSuKgy5vI0YU3gREtHKhHV4Od33R9yKWmsBsWzE5dsu
         DUyu/OkkdNNnUiuWiVYYvAOomU3+wUX73Fx2Kyhf2ZNYhCdsRHPueJd/K7b33Pm8yZep
         0RuA==
X-Forwarded-Encrypted: i=1; AFNElJ8dScyYACEpQseZm/T9T99AkS+woj/iFLFRw6Bj3oWWgjxl56DCVS0kb7sEhe/E4ZLGbxC+hpGc8ZcQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzY15SMu4obidKGHPBSgvZTUzJ+5+lCj4/OQubpdDySWQE9WmWw
	ScyIpiUDnNTXpDL4UobW+X5js41aD2RFqz+EhPke6RlrfgTkRqfsULu7
X-Gm-Gg: Acq92OG3mTCPnN6XoQlNa1Vja79RxT3LPV4hLdvJge+hhJno8ksXp5Rh/SpM9Nc+yZb
	bonVzLYqHbZfI5khn46qHrZNFh8AsJQr6P1/+N/ax2iUfkl2QKi3HntapxTARGthhj33rvSwf7P
	CDDn6jhdTpre/UNBEjBG1LjdOQylYp/HKufv1VyzmngSVx6vBiJ4s0B8rABYl293WoT+x27tR9B
	2VC70Fy8A+fUinkxKXSU6h6OLungH6sLqjuoc+TRXvu1hiERwrrP0wfGNFpkJyWS+F5pUJj5BKP
	0Bj1HTW/4oOrEdOPaikrF8bHcYQ+1QgWl6bmA2ihBy1hQ/V/2KQSVx2rJobCHDVRV6dcQvTqknI
	3y+6xNtfWyQjOAI5yFoieoU/ftVFL3FcTCIIpPudWIFHn6aXIOJdA1agMG4FDqRMSInPpgp8MrL
	0MzF1H91lCt6OOIxwWQ5OyGfLz+10=
X-Received: by 2002:a17:90a:a81:b0:369:73a:3266 with SMTP id 98e67ed59e1d1-369519e40bbmr10216834a91.10.1779114460408;
        Mon, 18 May 2026 07:27:40 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3695a09ed1dsm4205256a91.7.2026.05.18.07.27.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 07:27:39 -0700 (PDT)
Message-ID: <e4fcacb0-ec95-4289-a647-8e85bf432a2a@gmail.com>
Date: Mon, 18 May 2026 22:27:35 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/9] fstests: add test coverage for cloned filesystem
 ids
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com
References: <cover.1777357320.git.asj@kernel.org>
 <agK8gc2niqpTuHHt@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <agK8gc2niqpTuHHt@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/5/26 13:37, Christoph Hellwig wrote:
> This is missing a real cover letter saying what this series is trying
> to archive.

I should have copied from v1. See below [1]

SCRATCH_DEV_POOL support for non-btrfs was dropped in v2.
Instead, using the newly added helper  _loop_image_create_clone().

[1]
https://lore.kernel.org/fstests/cover.1772095513.git.asj@kernel.org/
-----
This series adds fstests infrastructure and test cases to verify correct
filesystem identity behaviour when a filesystem is cloned (e.g. via
block-level copy), covering inotify, fanotify, f_fsid, libblkid, IMA,
and exportfs file handles.

  - SCRATCH_DEV_POOL support extended to non-Btrfs filesystems
  - _mkfs_scratch_sized_clone() helper to create a cloned filesystem
  - _clone_mount_option() helper to apply per-filesystem clone mount options

New tests verify:
  - inotify and fanotify events are isolated between cloned filesystems
  - f_fsid is unique across cloned filesystem instances
  - libblkid correctly resolves duplicate UUIDs to distinct devices
  - IMA distinct identity for each cloned filesystem
  - exportfs file handles resolve correctly on cloned filesystems
-----

