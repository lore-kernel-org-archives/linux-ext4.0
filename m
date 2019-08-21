Return-Path: <SRS0=6yK3=WR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66929C3A5A1
	for <linux-ext4@archiver.kernel.org>; Wed, 21 Aug 2019 08:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C567233A0
	for <linux-ext4@archiver.kernel.org>; Wed, 21 Aug 2019 08:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfHUIRw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 21 Aug 2019 04:17:52 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58150 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726217AbfHUIRw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Aug 2019 04:17:52 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1i0Lnm-0003cr-QG; Wed, 21 Aug 2019 18:17:07 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1i0Lng-00061p-Pw; Wed, 21 Aug 2019 18:17:00 +1000
Date:   Wed, 21 Aug 2019 18:17:00 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "boojin.kim" <boojin.kim@samsung.com>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        'Eric Biggers' <ebiggers@kernel.org>,
        "'Theodore Y. Ts'o'" <tytso@mit.edu>, 'Chao Yu' <chao@kernel.org>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>,
        'Andreas Dilger' <adilger.kernel@dilger.ca>,
        dm-devel@redhat.com, 'Mike Snitzer' <snitzer@redhat.com>,
        'Alasdair Kergon' <agk@redhat.com>,
        'Jens Axboe' <axboe@kernel.dk>,
        'Krzysztof Kozlowski' <krzk@kernel.org>,
        'Kukjin Kim' <kgene@kernel.org>,
        'Jaehoon Chung' <jh80.chung@samsung.com>,
        'Ulf Hansson' <ulf.hansson@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/9] dm crypt: support diskcipher
Message-ID: <20190821081700.GA23138@gondor.apana.org.au>
References: <CGME20190821075742epcas2p4b9104e8249067c048d4050f2888da0a9@epcas2p4.samsung.com>
 <001b01d557f6$1c49fd40$54ddf7c0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001b01d557f6$1c49fd40$54ddf7c0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Aug 21, 2019 at 04:57:41PM +0900, boojin.kim wrote:
>
> Can you tell me which patch you mentioned? Is this?
> https://patches.linaro.org/project/linux-crypto/list/?series=22762

Yes this is the one.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
