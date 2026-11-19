Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099669;
	b=aQeX21pqkhmTM38SzEOjyq/C0+Qfc6KMcwuI3WP1BtTLzAR3ycwKZio7o4USmQ3GCdhQ
	 iIdez5j36HbyqivzZkA2qzmtPCdwQKudKZcPVHyb7Iq1DlbnpVctZ5sU3Jtlj7OcorZlE
	 2zxwIiGPxWOFF9zIOq95mogyIxXONJUuMa6SuS0MCq7iWv0MjDvv2TJqLIAMRzP/tlhWf
	 EIoJ68HhruyVh4Npm0RMlHG0EyQuaa0UxpI/e72Ed/y9LkUJQ+NyGpfOzHL60U9LavK/K
	 q6qoA/b59PvdaaN6AmNt38VwV8f7SHTPnBwj7kST2JjGdy+BguGdFVBuDrAImZWRa3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099669;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=3nHY67iqluqq842kywPXatZ3MUjjShwgw9PgPvsa7AY=;
	b=MR6U8DtYqZAPSsoWeTu4gQDGIOG31a+BtLL4a3nxO0AWmqFpXW05F8ZPKhcqBpJZ2KcA
	 DeiVccdrzyEIeLXZZc8uKNtkcCAV1AI6fwLmGyEnzm5SRdPABnuF/VRbxnTmxQrFhAyvH
	 VWml4vB3af8UDwQLZDcidiLHLHb4FARKEzoPxGjQnb6O1k0Ld0fSNMUGb493K4gdg0J3t
	 cuS3gr7HvipS2vgLcrbO9IeAfCRJFMzdy+SRFlnq2rFjWJ7+86udEuMWgvKHVE2wF85Gs
	 az8exbk6Mw+1NtcmfvZ3wgWWlOhODRXw7FZ8pEMpy4mv2g6jbAs2EK6JjBByYustFHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=TSrE7f7S;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855C560A261A
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:47:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 855C560A261A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=TSrE7f7S
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElfGU018152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099662; bh=3nHY67iqluqq842kywPXatZ3MUjjShwgw9PgPvsa7AY=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=TSrE7f7SBq0hLctASJJogJSZQCC/PKFNgUGBCGVU3zYulhhXbDk8zYh+cNh+td5Ae
	 A+DkOqbksW1Lnbukbp/Un82TnRe9FC5yy2YYUcd2bfb+YD2GWGFbiZBYdYcm0eYAJI
	 nV0M28nAiWVaLmSKPZpb9dVSirbCRUeFdXXA9sMnECl/klMkwlscxh6oP5u6Vo7qOv
	 B1KgyC8jvkV4uX7vc53m8CcROO6leFqt+rBRbKSc3uRgiBfaT/JyiV622Y+n4SDvmS
	 z9A4k1+FSk6BS637Yt/6mDOFZRxgbjjOFUuqxp06vi54ioo2cdrHVYgd611f8cLvB7
	 SRGdeAbTobXeQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4430C2E018D; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Lukas Czerner <lukas@czerner.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 0/2] ext4: fix error handling of failed migration
Date: Thu, 19 Nov 2026 09:47:10 -0500
Message-ID: <179509948717.1938961.2476042053313783296.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261025201803.3043712-1-lukas@czerner.cz>
References: <20261025201803.3043712-1-lukas@czerner.cz>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Sun, 25 Oct 2026 21:18:01 +0100, Lukas Czerner wrote:
> When converting an inode from indirect blocks to extents (the
> EXT4_IOC_MIGRATE ioctl) fails, two problems can show up.
> 
> ext4_ext_swap_inode_data() can fail after the temporary inode's extent
> tree has already been copied into the original inode. The error path
> then frees the extent tree blocks via the temporary inode, leaving the
> filesystem with multiply claimed blocks. Fix it by resetting the
> temporary inode's extent tree and i_blocks right after the copy, so the
> cleanup can neither free the original inode's extent tree blocks nor
> truncate its data.
> 
> [...]

Applied, thanks!

[1/2] ext4: fix failed migrate freeing extent tree blocks
      commit: 7c1f0eea4a9bbedd4c57e15b6e736f74ce194878
[2/2] ext4: don't lose the error of a failed migration
      Dealt with by another, earlier patch

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
