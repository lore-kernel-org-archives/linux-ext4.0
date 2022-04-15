Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C87C433F5
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Apr 2022 00:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348233AbiDOAxg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Apr 2022 20:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348224AbiDOAxd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2022 20:53:33 -0400
Received: from mail-4323.proton.ch (mail-4323.proton.ch [185.70.43.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6464E9D07B
        for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2022 17:51:05 -0700 (PDT)
Date:   Fri, 15 Apr 2022 00:50:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mcgov.dev;
        s=protonmail; t=1649983862;
        bh=nRg1rGGKTHwwwMz7dHwIsyPgFa89CdtikGbpSnunfhE=;
        h=Date:To:From:Reply-To:Subject:Message-ID:From:To:Cc:Date:Subject:
         Reply-To:Feedback-ID:Message-ID;
        b=d19ktSKdSiFg+EOkCiUiWfBsmSGRqhdCaX/OvOAyHqhBoqxyW/Ki5UiiPPZ8OkjxY
         WgAmDdxwB/Vall8mRTJnNPedUYOCWgJ27vZcRaW6/EfBI0ppluLyitZfXNnVh7AkR3
         jCoLVElZOrm2cDvf82n24Uq34v7xGlEdL17eH+xJJcQqnyo2eKfOV/GEhb0x/5ibJY
         +788fGBFm0p14PeS/7d9+op2uWvLQ8tKeLyUirGaWqNY85okT2usk5SIN9L/BeV1Ge
         fHVEqXAo9LF13nMWwodTrpaxLYDv9Rl6U0UgJ7peuhtMjLYvi6OZ/hIFEdKksgBCN5
         YCuy3vovxyvdg==
To:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
From:   Matthew G McGovern <matthew@mcgov.dev>
Reply-To: Matthew G McGovern <matthew@mcgov.dev>
Subject: [PATCH] Ext4 Documentation: ext4_xattr_header struct size fix
Message-ID: <pvZcd0oHwCKt92jKr8OMUPT_Y9-UIziM36-74bg8vvEEOKgIW6_KiAdMKw7eRn5L8Tc4AKOSOOcaFmcVCAQ1TYM7gmYI0ZNmNqX_7tkqIE8=@mcgov.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: "Matthew G. McGovern" <matthew@mcgov.dev>
Date: Wed, 13 Apr 2022 15:48:15 -0700
Subject: [PATCH] Ext4 Documentation: ext4_xattr_header struct size fix

An ext4 struct has the wrong array size for a field in the docs.

- Document correct array size (3) for ext4_xattr_header.h_reserved

Signed-off-by: Matthew G. McGovern <matthew@mcgov.dev>
---
 Documentation/filesystems/ext4/attributes.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/ext4/attributes.rst b/Documentation/=
filesystems/ext4/attributes.rst
index 54386a010a8d..871d2da7a0a9 100644
--- a/Documentation/filesystems/ext4/attributes.rst
+++ b/Documentation/filesystems/ext4/attributes.rst
@@ -76,7 +76,7 @@ The beginning of an extended attribute block is in
      - Checksum of the extended attribute block.
    * - 0x14
      - \_\_u32
-     - h\_reserved[2]
+     - h\_reserved[3]
      - Zero.

 The checksum is calculated against the FS UUID, the 64-bit block number

base-commit: 96485e4462604744d66bf4301557d996d80b85eb
--
2.25.1
