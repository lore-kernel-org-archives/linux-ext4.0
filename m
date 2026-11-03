Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.154.216.246
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793670139;
	b=iqvVHAgiBuvAWM9ahO4z3oxAFuPU0fb63Bj/HD3PRjzfLjYKfMwPaCeITyOB/YCLc9pg
	 +fT9nqCjXGXb9QKAfRLzLxtIcoMIzHwXLr7y9fMhcqxn2W2gki84hRQTnxgmkFR30Hf2Z
	 so+/7S2ubYimeNmum6j2hV+fcoIcLvFDk5Oio4D0vjO0zBghmJOD1YEe8BqGmPuLmg3gf
	 xuABkdQHmxn/xHEmPkfrOnjRXegHhLqnnxMLVkpLVZzgf3SGZnwDmOhAnwjao1Vtr5YkJ
	 2wHe9Jd98TFNHVRv/E8RW8le/3ad0Pg4vMDiNdIAoyQMnFSdvO5fF3SzDakoeDEU8GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793670139;
	h=DMARC-Filter:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Afkj5lR+dXFKMhy13iBEjjniqyBIKXdf8peXBygVbjw=;
	b=SM4vtsOYdXB6SGz9Qj7aB8Yn3mkw1ONl+hIUBTrGbZ3UG7mNsOy74aAxAyl1SBzhvLx8
	 xxKQ/KMdAb18bzNSOVdIJPGfHiD9qz1Szr4PvetCjogIGCxwoyT9viZxyw3d/axxykuJw
	 iqMaatPlGx7XQlGNAkd38F9lMv925Wl+EdmhgRCPO9uSN7xcs67VFwwoGFJVoofURPTKf
	 pyieLPDQ9TmMl0R1jeFaxv1iiYnv7gpU8rreGVrtZpdCavZFcCOh9nOJWeew5gwM0hNj8
	 7BIo4K0iydByKyKCk/ypwijT2wBTcQCQUSze7lZOT9P7+0WA1IP4ZcSf0aG3jyzKLpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=findhost.org;
	spf=pass smtp.mailfrom=findhost.org;
	arc=none smtp.remote-ip=195.154.216.246
Received: from hebergement-securise.com (hebergement-securise.com [195.154.216.246])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4318D606A329;
	Tue,  3 Nov 2026 01:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4318D606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=findhost.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=findhost.org
Date: Tue, 3 Nov 2026 01:42:07 +0000
From: Kevin Fernandez <kevin@findhost.org>
To: Elliot Berman <elliotjb@elliotjb.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Sasha Levin <sashal@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Yongjian Sun <sunyongjian1@huawei.com>, Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org, regressions@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	ntfs3@lists.linux.dev, Tom Bereknyei <tomberek@gmail.com>
Subject: Re: [PATCH 6.1.y 0/2] Fix NULL folio dereferences from IS_ERR()
 checks in 6.1.191
Message-ID: <auk775zR0FCl4L0X@hebergement-securise.com>
References: <20261102-ext4-ntfs3-null-folio-v1-0-4fd91ee23a4a@elliotjb.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-ext4-ntfs3-null-folio-v1-0-4fd91ee23a4a@elliotjb.com>

I hit the same oops on 6.1.191 on my server (x86_64, via
ext4_release_file() -> filemap_flush()) and reproduced it in a VM with
write/sync/drop_caches.

Is the series needed on 6.1.y at all? When it was dropped from
6.1.167-rc1 for this same oops, Yongjian Sun noted that 6.1.y lacks
060913999d7a ("mm: migrate: support poisoned recover from migrate
folio"), which introduced the race fixed by bdc56a9c46b2:
https://lkml.iu.edu/hypermail/linux/kernel/2603.3/05097.html

If so, reverting might be simpler. The two folio conversions and three
prep commits are only in 6.1.191 as Stable-dep-of: bdc56a9c46b2, and
a8d83471c560 fixes one of them, so they could go with it. All seven
revert cleanly. In a QEMU test (minimal x86_64 config, same
reproducer): reverting a8d83471c560, a3a7d360252c, 862483175d3d and
d34e4fd4e73f avoids the oops, while reverting a3a7d360252c alone does
not (the oops is in the conversions); also reverting the prep commits
1c0f0e2b9b69, e6b6cbe9f2fb and e394adafb089 leaves
fs/ext4/mballoc.[ch] identical to v6.1.190.

