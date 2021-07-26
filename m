Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C95ADC4338F
	for <linux-ext4@archiver.kernel.org>; Mon, 26 Jul 2021 18:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FC9A60F6F
	for <linux-ext4@archiver.kernel.org>; Mon, 26 Jul 2021 18:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhGZSFH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 26 Jul 2021 14:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhGZSFH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jul 2021 14:05:07 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5C4C061757
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2021 11:45:34 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c16so7185809plh.7
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2021 11:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=x/PW63LO0Rs/sJWyqC1OwVCOxoQFk/uyrOX6p2pQUTY=;
        b=qTdg7KoiUUbRWTdy51xCHVbUnisbc1s0coePlQo4YFYR2Zrv9k6ESIBJ0Ri9Xj2jnt
         SFcv8F+q+9I5KgDCBXohUvvkuAh0LDsI5KgUcECRJ0eNLvpaF9D2fpU+V1hGRvn+R0HP
         SAxNtVEY+3PYtJ7iRa/vRMg6/Uy2pJT/2fYhm0GhX28fm9A6aB0gMnUD/F5l5dl0RhAE
         03vNj1JFv+VaYF/zaIew8cZaxxmOQsnWuCw/Rp29s52ob/pfz7DsYWruEcZ8jdFrbYUk
         thLJVe78nbHgjSdXZ0GPVId6iP2TjFLSo5EcTFH+0yA7tDmiQHdkkoXmYDlkZVK8ulkm
         JvDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=x/PW63LO0Rs/sJWyqC1OwVCOxoQFk/uyrOX6p2pQUTY=;
        b=m4K0qNOhVg0UOWDu8oS3SkKR9gpvYqRzgR+nhXwcB2Hgac6Hd8TLdf30ysVlWdy1gA
         JFXzW7WnQ9LkH7F4sAvZLNLFQzatc9AiU+2TZ/V9LLJxer63IAorHC/PlHnyq32Qi7J1
         mZALbgwLQGKIZvrmSV3JVk4IAgkaEAKIIpXmyL0dbBWmGx+Pqdfc0o620jJCnzGqhqZe
         9vSq5/xEGOmjs5Q2PGXVtmzcHhLRnbYfh5falGMmv/vFUJxd7vIQb3bZmuO6vYkVc5FN
         ZTylxow9qA+E2+ODuFwrIkuIvwb+tvJ8mdkuDLlNfouR1KBYtHSB25ERwUhrVLH7sZZi
         oaCg==
X-Gm-Message-State: AOAM530AO/5A/W67E8pgUZpzDhpx9crI7AIjdmIXganYJ5XqXCfE5jwk
        uVXI7ylArcO/8gqRli4T8EHr59P8VlX41pdpTcUP184bxBUj/A==
X-Google-Smtp-Source: ABdhPJyQaYBnFwVY4Vd9Tt9Hc9NzdUzKugP8pvN3ePln8G5Y/9v7YdUTCyHzC+LEhc2J0nGphUJO35hC3+Z+lQXINrI=
X-Received: by 2002:a17:902:7144:b029:12b:24ce:a83c with SMTP id
 u4-20020a1709027144b029012b24cea83cmr15842006plm.54.1627325134151; Mon, 26
 Jul 2021 11:45:34 -0700 (PDT)
MIME-Version: 1.0
From:   Mike Fleetwood <mike.fleetwood@googlemail.com>
Date:   Mon, 26 Jul 2021 19:45:23 +0100
Message-ID: <CAMU1PDgNvW_3Jr91iii-Nh=DCuRytVG8ka3-J+a43gKwigx8Yg@mail.gmail.com>
Subject: Is labelling a mounted ext2/3/4 file system safe and supported?
To:     linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

Using e2label to set a new label for a mounted ext4 seems to work, but
is it a safe and supported thing to do?

Google search doesn't seem to know.

Thanks,
Mike
