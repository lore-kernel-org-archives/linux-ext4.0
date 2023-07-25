Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04058C001E0
	for <linux-ext4@archiver.kernel.org>; Tue, 25 Jul 2023 10:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbjGYKA1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 25 Jul 2023 06:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbjGYKAV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Jul 2023 06:00:21 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9208810E2
        for <linux-ext4@vger.kernel.org>; Tue, 25 Jul 2023 03:00:20 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-307d58b3efbso4041243f8f.0
        for <linux-ext4@vger.kernel.org>; Tue, 25 Jul 2023 03:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690279219; x=1690884019;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=WWdk5t2R7llazZurwmu8BVsYGp0tl7yfBCSxk+CkYJs=;
        b=XoapnJCNCsnV1JzdA4+FFv6nqQneE7i+5TVEI27tBcwqTgS5orHLfIRrJ3PdBlpHfb
         Ltw2tWj/PwmMQO5oBuvkcdLjka67tjptk8EKgdB7cXUoTsHhQpQhj7nHTVQ1nXDyCGpm
         bPgwvzUavuBn35SjU5d7XWjPiEkgAg51B7zO5hpV5uWQDk08I0FZAsD7EynImy+eydpg
         Xd0VW9JG1XLqZkEgSa+RSU89EbSLfQtcj4icUoh3mgaLzjmyPHZguNLOkmxXPmtYs25/
         mY9j/DaIG5lMc0lHkEZ2Cs8CGbYBlthBtbwYHezAOxLPRiE1GVBBDv54VAfK7l4EkXPe
         Xoug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690279219; x=1690884019;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WWdk5t2R7llazZurwmu8BVsYGp0tl7yfBCSxk+CkYJs=;
        b=hJzD+NpRNWOrse6oP9VDUQL4nPdE3smskpz9xvuR/eTkyTAYK+L2gs9wv3vYIIdqpA
         RFBoD2P7QTfYhuc7WK3DWRrCO/TV3uAMZC9BXn/74Z+HwI08r4seQ7OxAW6trWTAKBoZ
         CRqx5F3FZ0wNzg9Wv9qahn3hNzKUYkohTqzrh4gSzTYffJok7aYgHZsabvW1YHK3PEph
         UACghU25MQl1hzXkJr2bDjzmDdQwr7Ge4naLbx25/5ka8Uiw7LTfWu9mvdxuO43AHKd0
         o2/Xmi2YYkb8zJi3jfNolxEusCXnC17zDQHakvHWaJy5/qb1/T4MZy96dYknUkEAtdTs
         vvIw==
X-Gm-Message-State: ABy/qLaYD8PdpxLjHr/sAeejvD4WkGAolQFmtbp4Ng7W9E9hk16Tl1r6
        uebUsYzlRd36gMinIVdd1UqNuQKVoXY4Aw==
X-Google-Smtp-Source: APBJJlE0CzuafnoJ/6Gb0uHbzwV5lgAdqmOqyRFr0HBwWn8hhXInzkBFNf2dtWkatVIvyHkBEbnCXQ==
X-Received: by 2002:adf:ef48:0:b0:312:74a9:8262 with SMTP id c8-20020adfef48000000b0031274a98262mr9938819wrp.62.1690279218711;
        Tue, 25 Jul 2023 03:00:18 -0700 (PDT)
Received: from torreasustufgamingpro (209.pool90-77-130.dynamic.orange.es. [90.77.130.209])
        by smtp.gmail.com with ESMTPSA id h17-20020adffd51000000b0030fa3567541sm15848463wrs.48.2023.07.25.03.00.18
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 03:00:18 -0700 (PDT)
From:   =?utf-8?Q?Oscar_Megia_L=C3=B3pez?= <megia.oscar@gmail.com>
To:     linux-ext4@vger.kernel.org
Subject: I know you are busy, but have you found time to look at my patch?
Date:   Tue, 25 Jul 2023 12:00:17 +0200
Message-ID: <871qgwpaz2.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

My patch was: e2fsck: Add percent to files and blocks feature.

Do I need to change something or it is not accepted?

Regards
Oscar Megia L=C3=B3pez
