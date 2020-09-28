Return-Path: <SRS0=iNsJ=DF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 288F2C2D0A8
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Sep 2020 17:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB73F2083B
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Sep 2020 17:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DwaoI+cD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgI1Rtp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Sep 2020 13:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgI1Rtp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Sep 2020 13:49:45 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05640C061755
        for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2020 10:49:44 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q13so9811055ejo.9
        for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2020 10:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=XFXCLiyHOGeoT2sI1Fi/a/qpwZnL844AFb1GsQGB3NE=;
        b=DwaoI+cD1bkuBLOQswML0c3JR0JkrDh6ZEQQ05rHFd8DS0Vpk0TH0NUgazrB1vAA6g
         KiDqdOkjd6CuqHrmMygJmlLxks9BSGVPXOJZFq9j81mLvYFEaGYWHZ/0dEg45g4upqt1
         HX5EuJRTj/T8eIM6Z8JdXyOZMXa35ZmGGx2FT5733xKFWANGEILd60V1dXTa7w8fsFgR
         LzJlDk9IFoim5u2Vsk/3veqOzHichqYq4XhTnLllh+44DQR6iM7rquOQuxzN1j0+HrYN
         O5okAnkOhXBUQRgnBkSz5nmt7YVxVekcVbdetqm0N/ppC1LIkUI8OD8Wgm9klvI0TLCl
         1I1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=XFXCLiyHOGeoT2sI1Fi/a/qpwZnL844AFb1GsQGB3NE=;
        b=WwhOSE2p6w2c2JURueRQmFKWhCA4iVhfMtMICNLTpxlPYDhGQ5Rij5vJEfdKWTa8EV
         5i0qpkCBnT4JxZiEJx5ygfbrOv5cmRGv7nWhIc4eHlqyS7f/C24EYwgTH+PHVk82yUtX
         EKKND7qfFbFyrJNknF8Or4lQTk4c51MCFXsGbTZfOLRN8TyPs81DN91tBVMeFWH3PBIn
         ylzHHkFpN8OXDi2BJNQAL3Lwy76otCOpKcGGaApLdlZ7huuwr7rqlrgWu4UhCnL2Pate
         z9ZL1qiudWOSKtn7uBAcKk1S4UpQ+RoYxVS6CzscgY400Am2h28niOM7NYFycyQe1SJ5
         /WRQ==
X-Gm-Message-State: AOAM530E8n1siQUJ+kAMCB/GDIb58nMqYF1quiJ+ZO9Fabaq9lfgLoWZ
        IsLV+aS965qXzo4oRmkjuqcTORQCFqMJb/e5
X-Google-Smtp-Source: ABdhPJySd/I+79HzSvX6dOe/L0DLl0PxpUX3N4Y57+TSrLmIb00lIav2Q6YMStzrkgRkaDRMIIe76A==
X-Received: by 2002:a17:907:72c5:: with SMTP id du5mr2878852ejc.469.1601315383312;
        Mon, 28 Sep 2020 10:49:43 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.googlemail.com with ESMTPSA id lc25sm2040216ejb.35.2020.09.28.10.49.42
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Sep 2020 10:49:42 -0700 (PDT)
Message-ID: <0e5ffd9bb29b018b2ed574381d194c4e7506f91b.camel@gmail.com>
Subject: ext4: how to make sure the LBA contiguous  allocation across a set
 of  files
From:   christopher lee <christopher.lee.eu@gmail.com>
To:     linux-ext4@vger.kernel.org
Date:   Mon, 28 Sep 2020 19:49:41 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hallo
I am recently encountering an issue with the ext4 usage case. I want
not only sequentially LBA allocation in a single file, but also expect
that the LBA sequential allocation between the two files, which means
that the last LBA of the previous file should be adjacent to the first
LAB of the block of the next file.

But from my testing, the sequential LBA of block allocation is easily
met, but the LBA sequential allocation between files is not to ext4.
The gab in LBA between two seq write (two files) is very huge,
sometimes the gap is over 2GB space. I notice ext4 never allocates the
LBA of the block between two files sequentially on my usage case.

who knows the reason of this? and if there is a configuration of ext4
related to this scenario? 
or please tell me which ext4 function I should study, and see if I can
find the reason.

thanks in advance for any suggestions.

Thanks,
Lee
 

