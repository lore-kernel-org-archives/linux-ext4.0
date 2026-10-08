Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FB3446C17;
	Thu,  8 Oct 2026 08:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448362; cv=none; b=o7omL1GEhCVU9ZCeqXRJb1zPaMKJqQetLrfJUou6Z420YZAfTORkCvcgXl2DHYwM0ygJlNr0wH+Nfb1VFQ6o2PbrjgIJmQ29uKbCFMIoVN2wsN2OU9zR/xPwLsqHvTnYjj5YsnYBR2qaTUNzpQa7yvTwwRfjj7bKELmbYZVN1gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448362; c=relaxed/simple;
	bh=7P7iWy/+DamT2NQ9Bj8/DDfUMMe8C7U2IRJGSKrX3+Q=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=RsKjO0XeLv+SZohNJd0N6ZqpsnmE3qmrqXNqRvqlBBJaz8Q93UAPtBzVkf/KEP3VWxqPLFFQLPRJRHMdCADxOMsGtU/2l7qPClz9ey1BzXriSckd6cjLM9vxD3nhGgJ90dHbqne04bAosjUDZWOTt5dJbbm/RhqroNXqpAzxEQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=p/JH/BYn; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="p/JH/BYn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1791448337; x=1792053137; i=markus.elfring@web.de;
	bh=gcwdd+V7RVPtcYh5OQn0S7t6lPNKcr+oFeG1qmJQ1HI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=p/JH/BYnlTzFPd1C2opzItHYSUd4GEwr8ldm9GMPRly5WhYti+pIoFLIr/5LVPin
	 QaC73Q7yjYHoq0sE7BIFx8T7FSdmEKJ52Vz1ud++ExOja0WYHSMENqXb1FSy2z+jt
	 UzKGqzGP++ePes32MeG12EbTOT4bfXLOGEc1ks5ALdPFkFa2dCcASB4hhH+ItaK6I
	 zgYEIcKXibNiQOuyiu9mwbMUkh8cTf687u5H4/vMIhR9rDwszFUhqNWABJlF8pY1N
	 Jk80Q/UqhJrFRC1ECLJNnAnOfEiJl2DAeqSwmYDniEBG/eKuUJ+nn/usYeBT0UlV8
	 OKZVUjuzcyjKsVDt4Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M76bb-1xJOe60btv-00GA75; Thu, 08
 Oct 2026 10:32:17 +0200
Message-ID: <23514bc7-e2b1-4796-a107-a5674dede5b0@web.de>
Date: Thu, 8 Oct 2026 10:32:06 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Karl Mehltretter <kmehltretter@gmail.com>, linux-ext4@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani
 <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>
References: <20261004180629.27213-1-kmehltretter@gmail.com>
Subject: Re: [PATCH] ext4: return an error when a journal block is not mapped
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20261004180629.27213-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6L6RKXUqKkZW/Hd2NCk9rCyIea719OkVtN5/VBNSKyPqsVnBlth
 +16Fv0PPKsxwJpqobXWBI0MRzst2iTOS+Re6NCTtnpAwHV8R/W3rYrRudTOnMpVjDsBiyKA
 PzcWMLgCjs4wn/Z+4eXt9Ap2bWB17Ysmw6zVRC3HtPca3oRE0tIRkcrhhBhWjoyTFTIO0X+
 ckGRDlWmLiCkm0Lexe7ow==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ucJ7U1WUkBE=;/uzp0F+xvKfCXu6ySD5W12Xpq4V
 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

=E2=80=A6
> +++ b/fs/ext4/super.c
> @@ -5967,7 +5967,7 @@ static int ext4_journal_bmap(journal_t *journal, s=
ector_t *block)
>  			 "journal bmap failed: block %llu ret %d\n",
>  			 *block, ret);
>  		jbd2_journal_abort(journal, ret ? ret : -EFSCORRUPTED);
> -		return ret;
> +		return ret ? ret : -EFSCORRUPTED;
>  	}
>  	*block =3D map.m_pblk;
>  	return 0;

Would you expect that an optimiser will avoid a duplicate expression here?
How do you think about to adjust this implementation detail another bit?

Regards,
Markus
