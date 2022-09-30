Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35244C433F5
	for <linux-ext4@archiver.kernel.org>; Fri, 30 Sep 2022 03:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiI3DUm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 29 Sep 2022 23:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiI3DU2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2022 23:20:28 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7853719B;
        Thu, 29 Sep 2022 20:20:05 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 28U3Jlge002410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Sep 2022 23:19:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1664507989; bh=rUF+Kl+gbBxGziVIS/b1UjuTmXgFR9FEjDJ43g2Mryk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=R6fad2+xveZH+ZL1pFgAJN5WCzZLFvAkurb1sP64e34jH5Rw2+pOKI2txMIJf8YjZ
         iLCQTHDE9krF43OrWj0DBO5lwp0HZgCaknc9jT2RoaVE71Q+I4BU9ZiX/SGHd0Rfrt
         cXKgBJz/v/IuvYQ/UpnpsN5lI30KqbcOe4KWYJer+AEwVa+vcbqUJaumjBqa0SIKft
         1ByK3Fm2NCu8o30eULKmTYYwKgoorwKaHpKXKH6ZEyC4UTs1qLKVfxu5kTdQRow049
         UbUMZ2FRztiZs7Q7N8n9B04Xm00umthjnllE34gBSlcL/LjQnhvyJuTqG8keslIFJS
         j1MkPswsunjzg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8C97A15C3441; Thu, 29 Sep 2022 23:19:47 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     adilger.kernel@dilger.ca, riteshh@linux.ibm.com,
        cuigaosheng1@huawei.com
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: remove ext4_inline_data_fiemap() declaration
Date:   Thu, 29 Sep 2022 23:19:33 -0400
Message-Id: <166450797716.256913.13053655044634585764.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220909065307.1155201-1-cuigaosheng1@huawei.com>
References: <20220909065307.1155201-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, 9 Sep 2022 14:53:07 +0800, Gaosheng Cui wrote:
> ext4_inline_data_fiemap() has been removed since
> commit d3b6f23f7167 ("ext4: move ext4_fiemap to use iomap framework"),
> so remove it.
> 
> 

Applied, thanks!

[1/1] ext4: remove ext4_inline_data_fiemap() declaration
      commit: 3d17ba810cc18b611af8e39d35e8c3310a37f02a

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
