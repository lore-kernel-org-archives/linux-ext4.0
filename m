Return-Path: <SRS0=eB64=B6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A41FCC433E1
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Aug 2020 11:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 435752054F
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Aug 2020 11:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="CBtkEJSi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730754AbgHTLnJ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 20 Aug 2020 07:43:09 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:60230 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729855AbgHTLnG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Aug 2020 07:43:06 -0400
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 1EB2D2E0A46
        for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2020 14:42:53 +0300 (MSK)
Received: from myt4-18a966dbd9be.qloud-c.yandex.net (myt4-18a966dbd9be.qloud-c.yandex.net [2a02:6b8:c00:12ad:0:640:18a9:66db])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id DY01YbK3f9-gqvi3a8K;
        Thu, 20 Aug 2020 14:42:53 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1597923773; bh=ZlKDzo/OIO/xnJNL3iOXX1LYtqsbUN7eFRtKkmN6n4E=;
        h=To:Message-Id:Subject:From:Date;
        b=CBtkEJSiUWIQdwKOcjWjCgfpx2w+2byhaqI3/hugqf7+iLCFxZr4U2RNoYugqSoui
         8Ljvca0Qn7jGZT2GtTbNdf9pzvL/jreSYz/WX3dBQs6p0kkEvTkBomYWPSn7vbZ6uW
         d076iynUz82PjfM+AjDBtGCevYjZGnNJfSa4Kv3s=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b080:6414::1:e])
        by myt4-18a966dbd9be.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id BMvoya4w7K-gql85u4K;
        Thu, 20 Aug 2020 14:42:52 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Petr Gusev <gusev-p@yandex-team.ru>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: FALLOC_FL_COLLAPSE_RANGE crash guarantees
Message-Id: <E592DDCD-E4A1-4E9B-BEAA-1D454F0D4889@yandex-team.ru>
Date:   Thu, 20 Aug 2020 16:42:51 +0500
To:     linux-ext4@vger.kernel.org
X-Mailer: Apple Mail (2.3445.104.11)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello!

I=E2=80=99m considering FALLOC_FL_COLLAPSE_RANGE for app log rotation =
and is wondering what I can get in the case of hard reset/power loss. Is =
it true that the hole with garbage can appear in the middle of a file? =
Fs mount options is 'rw,noatime,data=3Dordered'.

