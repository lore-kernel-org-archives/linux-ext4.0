Return-Path: <SRS0=nKtQ=YP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A40DCA9EA0
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Oct 2019 05:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC39F2089E
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Oct 2019 05:36:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="TsmsDYX8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731001AbfJVFgf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 22 Oct 2019 01:36:35 -0400
Received: from sender3-pp-o92.zoho.com.cn ([124.251.121.251]:25770 "EHLO
        sender3-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbfJVFgf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Oct 2019 01:36:35 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1571722579; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=elWVXuZ5DIIuwhkBidniQ4q30rjoikxwsU2TViQ4n3ncGBDbethRAFDJzV/iJKXLdgXjr7Z51iy8WoEYJdzRbwDgEWbgXgJsOnYdGcXJu4lLMyP2yJpPSWMGWGPdDFgnG95n8OAmSYjBVW7QE+PuFGGkR9hYcBIlLL9f1TXXaG8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1571722579; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To:ARC-Authentication-Results; 
        bh=UMCtnXKp+wwDbWddncCsDub/KDwoKgBRjvwsYUv2piM=; 
        b=oBTLOWwvVtYpKOS2NlOP1MXwr449zzQtqNuzNjQQQk6OskvrX8V9GuXnNhjZI4/g8wqwCsKVaPWJTAQK1KGlAp6bmLUaeR5dO4RGdOpYE/GkJTBQPLx1x2fjhWKZqUsnUI4jYmRBf3fbxDeZ0FqMHuJWs7sciVHBsxsAeRV3To8=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1571722579;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        l=1114; bh=UMCtnXKp+wwDbWddncCsDub/KDwoKgBRjvwsYUv2piM=;
        b=TsmsDYX8ogzOAg/tSwYikX3wuXvGWaJ6sc/PDHFTomxVNfJbZf+y+wbJdrFgBlyJ
        9F4qVc+UGSdmJxo4fiDt3a67JybpmeJvd4+qo+qXljZ/wAHVoftJoBD7Oztk5XZJALW
        /jInXO7O4OL6WJfiFZMIpPYnKDBObE7wXCAz1Yh0=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1571722578697508.42916244145624; Tue, 22 Oct 2019 13:36:18 +0800 (CST)
Date:   Tue, 22 Oct 2019 13:36:18 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Jan Kara" <jack@suse.cz>
Cc:     "jack" <jack@suse.com>, "linux-ext4" <linux-ext4@vger.kernel.org>
Message-ID: <16df1f74b07.d3ade7d625647.885482535351431524@mykernel.net>
In-Reply-To: <20191021091800.GC17810@quack2.suse.cz>
References: <20191020232326.84881-1-cgxu519@mykernel.net> <20191021091800.GC17810@quack2.suse.cz>
Subject: Re: [PATCH] ext2: adjust block num when retry allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Priority: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=80, 2019-10-21 17:18:00 Jan Kara <=
jack@suse.cz> =E6=92=B0=E5=86=99 ----
 > On Mon 21-10-19 07:23:26, Chengguang Xu wrote:
 > > Set block num to original *count in a case
 > > of retrying allocation in case num < *count
 > >=20
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > > ---
 > > Hi Jan,
 > >=20
 > > This patch is only compile-tested, I'm not sure if this
 > > kind of unexpected condition which causes reallocation
 > > will actually happen but baesd on the code the fix seems
 > > correct and better.
 >=20
 > Yeah, you are right that we should reset 'num' back to *count. Although =
the
 > practial effect of this is minimal - we take this code path only when th=
e
 > filesystem is corrupted. But still... Patch applied. Thanks!
=20
Thanks for your review. I found another relevant bug in ext2_try_to_allocat=
e()
today, I'll fix it up and  also plan to do some code cleanups for the alloc=
ation logic.
Do you prefer two separate patches for bugfix and cleanup or just put all i=
n a patch series?

Thanks,
Chengguang






