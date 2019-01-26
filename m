Return-Path: <SRS0=T0j3=QC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F2CC282C0
	for <linux-ext4@archiver.kernel.org>; Sat, 26 Jan 2019 01:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2023A21855
	for <linux-ext4@archiver.kernel.org>; Sat, 26 Jan 2019 01:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="ccjUFGed"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfAZBFr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 25 Jan 2019 20:05:47 -0500
Received: from mail-40130.protonmail.ch ([185.70.40.130]:38073 "EHLO
        mail-40130.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbfAZBFr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jan 2019 20:05:47 -0500
Date:   Sat, 26 Jan 2019 01:05:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1548464745;
        bh=HadiSusPsChtp3xvTKvNwnhHxeEdXOcaTRIABH0EPu8=;
        h=Date:To:From:Reply-To:Subject:In-Reply-To:References:Feedback-ID:
         From;
        b=ccjUFGedo8PKqqvSE4bX9S0QlrENXgGeFMJ2Cy5q4nw5zi7wmPoidkQFnGA7+i4Rc
         PnMaLu7DrSo/B5iaGhkTvPi8RjIH7fjXs3UGO3xAw0W2qWXCHk9+Q8S6Y5Dsqi/XhF
         mn2dHn8aCPqiFIEgT31yyre7Gszr3pd3JzPxC6Lc=
To:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
From:   Fedja Beader <fedja@protonmail.ch>
Reply-To: Fedja Beader <fedja@protonmail.ch>
Subject: Re: Mapping bad sectors to damaged files and metadata with debugfs
Message-ID: <YSHl21eLrbp4cNJwsAVzgU1tw67IZVF8IPNLZ5XGrqi4kv3HOQbsyFCk52oq-f94umWsVjjEGxeF7tTAgS25wg==@protonmail.ch>
In-Reply-To: <tiftrgc60XsZ86vnazKgWPb052qaGzAhH-SiNGKI5f7li-WQ29WzGYDSNwgTpgxgxRQY11lm5TBuCr_YaaDeFg==@protonmail.ch>
References: <uXbvtHxFZd89nVEfBMggkMBdYrr0WN0i7BC8QsEC93nJ_ovrC5II6anYz3ECVZEGhhSNYspC4H-LlI8fMVv-FA==@protonmail.ch>
 <tiftrgc60XsZ86vnazKgWPb052qaGzAhH-SiNGKI5f7li-WQ29WzGYDSNwgTpgxgxRQY11lm5TBuCr_YaaDeFg==@protonmail.ch>
Feedback-ID: -L-TZdAWyKm9T9TlpFzSU8fKTYzKLGsXsnnbxE45IGOq-K3Q56ZjHKtfgfHprDH4K4Ol3x8Z6XXNVjs0u_owvA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

*bump*


- Fedja

=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original Me=
ssage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
On Saturday, April 21, 2018 9:50 PM, Fedja Beader <fedja@protonmail.ch> wro=
te:

> Is there a shortcut to "testb X", "icheck X" -> X Y, "ncheck Y" where X i=
s the block inside a damaged filesystem? Is there a way for ncheck to also =
tell me the offset into the file if the damage is inside a file?
>
> In case the former is not possible, is it possible to somehow turn down d=
ebugfs's verbosity so it can be automated more easily?
>
> -Fedja


