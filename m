Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099689;
	b=v2o3zlKMumRrhWs6ttanTSRkq+968zS7pZaXd9zLdWxfCc+gPa00RrWcGV6e7NmS317T
	 xF8WZeKdyVuYuA5VToWPgHRVpov7HORQAydr9Sql0ucoBKVB+AkqCjTjC8oVVIDEf68zO
	 ij23XpSlCKoQsEB8JkI2ogWHLFLdezKR7h1RxwIurYY+G1Hc25BRJwLe3nVVDskrjRJt4
	 kRr47iHQ6SOpijhbcw7VJb3kCTU7hkFhE3k/DljV0jj+emNmJYKl5cGSov/15fbOOojZH
	 Uy6tkGLhG4ICgux6/rWEKZiH9FCUonvDMDcBPbqDQkCtcD4NfGmagPcob931t7OZ84A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099689;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=HKTq6oEJXodtoVTDdvuzIjZLLb0UI0cfbVYXccf1Neg=;
	b=Bvjzjt0G5WmiDzrOHEtkKxODmMS86v2jMLWeTEH3ypNNMRQDSKp4/FZA24dBfBjZ5E/z
	 xls+v659HTABz81+blWKQmQDAqPt+WVdiGN5Jp1qD3Y2JNVInEPiv/AAinZu/LokSLL2w
	 kvJXgPY5SfrdOJmSqNw7GWnvcLiw4wZBJU0Sco9EGf0JIdgmukDk7YmGWUJlUQaURkevC
	 cPZHpm5+uDfQOSFaQAUwef9+qGVAzlIvRdcZPmH+BI6fi1Ns02YFD6AoNeuTzfnUV9Kqa
	 0h1Y1mz3iMD0M7WXnXcExLrOvRnNF4PriFXub1PO1bKieyZG1BQjg0+xLIHvxeswPxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=XEMjRUqR;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509CD606E8B4
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 509CD606E8B4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=XEMjRUqR
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElc5N018033
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099661; bh=HKTq6oEJXodtoVTDdvuzIjZLLb0UI0cfbVYXccf1Neg=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=XEMjRUqRBVJqBuwIGgOor9qH3S0f64xzE3j0M8YoUnEY8dnuBcucNt3cFfJfYhHo3
	 WbSU/WTMeMJuqc0EFUS3XRv8Llj5EH0tl15wzTWI62F6hje/Hk1HX1dk1YLpItWMeD
	 MqgFUF3vFa2qg16wM1vCjS8mHzlglqmfGTvN40+Pcv8QDjjxfiG2ql4mjKzf/16xsL
	 MKUZyLij1ocABFkGjT2FKIu6AJiVuy7AdtO/9itObpWm5lMh4xw0w7qb//rNJj2RNn
	 bcXtsm9HHbiWDPpp2zD33wHTnMlVvmW5ruPcHiG8fejMaHJhEalZ64LYlJ88DYLtA+
	 iVSmTEAtZYecw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 1A0142E0161; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Hemanth Selam <hemanth.selam@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix typos in comments
Date: Thu, 19 Nov 2026 09:46:58 -0500
Message-ID: <179509948660.1938961.3323542812574739512.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907064046.36515-1-hemanth.selam@gmail.com>
References: <20260907064046.36515-1-hemanth.selam@gmail.com>
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


On Mon, 07 Sep 2026 12:10:46 +0530, Hemanth Selam wrote:
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.

Applied, thanks!

[1/1] ext4: fix typos in comments
      commit: ef7ad718020c6af4c5f62015e0d02407e5faf8a5

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
