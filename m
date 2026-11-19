Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099678;
	b=CpH2RPog7kyFlFdpNBn9Ep3BWRr5XlzrrFDEqnX55VLcf0Hr0yCvcmSlB11ArSFBgNGP
	 dbz3OEceHegixzOT3u3lmwTBd1PcKVoUCVe8JLDQJfFZutjq+A4GiIbZFqtj+7DQ3rLwF
	 FuF2A7WvwT67NeN8cOtAElsrgO/V6iUoaktEQJ9t362EaajKAgtNlDdFgPFGShyvHaN2J
	 PfQmqLrBiYrV+msUeUvhOt27VbQjWlLhXXcD8qzDxbWqxtrSB+6HqVpo7NmFqthzwH3Fp
	 OBz+HjiFzaeCtw3quk1CCu+2a7Vrj6IbLBEM20n3WlrRJkTDUNeBC1BC+YUUWvxN2Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099678;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=Q7GXtYQNrYbuKdV0Kh+O/FFO/tpzNiLA2pmpmvbStjo=;
	b=EH7sDL3TGsoCCpUlBhb+jjf4HJyL8YoGIH0jycPB+6r2hcZZHhahrdwKoCZwXUMBzeQg
	 9Kfg0ygHYmDO/rEWoLEO7SZxomr4JXPqSoz5/aTos1Cn6YgFjMb5m/lhDyXM3xGaukKW7
	 g9IZv9SMc1RPIwz9qhvCJMKR2+GLC9gcx2piOS7aEtENSMvIeEP+RJT4Mg1Kjbfsj9sft
	 h/WKiZDBzhmtXGdROcfJOgV/BNq9KOWAz+E9KA0SHfJB0ZHnPqP801vm3DHxOW8TGL2ny
	 H4G6tx/+IV8HA3C62fp7ypiQb0U35OeyEFUC/xbOnnbiu3yJiu/tJN1CIFGE/A0H4xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=hgTLBv82;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C9360A2609
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:47:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4C9360A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=hgTLBv82
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElgXd018240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099664; bh=Q7GXtYQNrYbuKdV0Kh+O/FFO/tpzNiLA2pmpmvbStjo=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=hgTLBv823sTQybbxTwxzBJTE0IZQuICwA3AHO9YbF+uAP6A5Emwpmu/+ON9eEkTDk
	 LEKsIT+T6vZRoB2Vd7nhvRe69MThSjlBbVEZO7OU0avdJrXTxE+1s6HPIs/j/m5i66
	 memXcTaSx7fJfwr0Ent0NqczW/dte3jUpXRwC/OFPm+K0PAgQ2BP+kUNzLsaN7aELJ
	 B1n+tLb7U+M+g/0gvU1LkK6/p1r+5cUzA3a5u6h4bRI+gPimayc4uKnt0blcEqZXhI
	 wVkwOxhs2eGswrOBgplbmpI9W0mK/iMpw70/5S58CU9NVwb8SfGYCDcEc/kc8xODlL
	 ppZ4BSbhF1pfw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 695412E0198; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Stephen Kitt <steve@sk2.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: ext4 filesystems can be converted to 64-bit
Date: Thu, 19 Nov 2026 09:47:21 -0500
Message-ID: <179509948707.1938961.8287579133944800661.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014162921.450235-1-steve@sk2.org>
References: <20261014162921.450235-1-steve@sk2.org>
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


On Wed, 14 Oct 2026 18:29:20 +0200, Stephen Kitt wrote:
> Since commit fe12931 ("resize2fs: convert fs to and from 64bit mode")
> in e2fsprogs, which shipped in version 1.43, resize2fs can convert
> filesystems from 32-bit to 64-bit and back, so the mention in the
> checksum documentation that this is impossible is obsolete. This fixes
> that.
> 
> 
> [...]

Applied, thanks!

[1/1] docs: ext4 filesystems can be converted to 64-bit
      commit: c9db324f2051c0aa3aea5bd2cec299ae9c9d79e7

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
