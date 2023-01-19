Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5592BC46467
	for <linux-ext4@archiver.kernel.org>; Thu, 19 Jan 2023 15:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjASP1Z (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 19 Jan 2023 10:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjASP1V (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jan 2023 10:27:21 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4777C8088B
        for <linux-ext4@vger.kernel.org>; Thu, 19 Jan 2023 07:27:20 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 30JFRBTa011471
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 10:27:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1674142033; bh=ov5jSuVip94X9Kkt3tYuPf3c1Bco5Y9G++nBm4wB7lE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=VLXfZ08fVGoBqzTwSiP/jyqz1p0Se95mNd2QVZnMhbKxgETsEDCL67khjOwiwIduY
         39mW3Fu2qWWagVhYTz56K6PRb+ZbutQ06cUArjqF4NK2/d8z8mVdxW3dXMEg6FfdiM
         MfBTG1q+VeqpUknZ3fGO1kY0jhf2PvQvh0bv5wR+rep9LtRlOWZeWczMnBBBgJvnok
         jWP6aM3vX48jJMeOCXfPyuMPAuUbr9CWlfvI0z4ampPLo29MeXYiET6RddhGENT0mH
         G6wz7f2cI5oYXov+NhLiO1+d0j11hzziipE60RDrF1jPOjOWYOpkt/DZhrth0VELNA
         hAm2YR5CueVSw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6FEA415C46A7; Thu, 19 Jan 2023 10:27:11 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        =?UTF-8?q?Ulrich=20=C3=96lmann?= <u.oelmann@pengutronix.de>
Cc:     "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [e2fsprogs PATCH] debugfs.8: fix typo
Date:   Thu, 19 Jan 2023 10:27:07 -0500
Message-Id: <167414201626.2737146.5272741039461261567.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20221104095835.1057703-1-u.oelmann@pengutronix.de>
References: <20221104095835.1057703-1-u.oelmann@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, 4 Nov 2022 10:58:35 +0100, Ulrich Ölmann wrote:
> 


Applied, thanks!

[1/1] debugfs.8: fix typo
      commit: 5c22148e2c60638c63b7ad74b8eb65de0d121425

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
