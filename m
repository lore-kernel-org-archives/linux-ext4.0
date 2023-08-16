Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6133BC0015E
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Aug 2023 03:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241451AbjHPDEB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 15 Aug 2023 23:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241427AbjHPDDf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Aug 2023 23:03:35 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C07998
        for <linux-ext4@vger.kernel.org>; Tue, 15 Aug 2023 20:03:34 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-114-154.bstnma.fios.verizon.net [173.48.114.154])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 37G33NQK003058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 23:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1692155005; bh=SyA4+kfQ8Gj2iFyQIMozKMiUoxoX3Hobkxb7XSvpHfY=;
        h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
        b=Bcr3bIsEHdDo/cexvucboL6asyPxdZLPMaAbMRmYpZpzKh0Iae+8wdYJllY2iRUU/
         aDPh24uFPWlQgQNdq+jW/8WKk6bapBs2FD4Nv6VGfWHALkKZQVjYZWKPiQJdpxuLCh
         YQ94ASXYYw4JM35aLMiEefGn7/TiTiBBTfjuckMCwjZXttJsozmXddxaUlQg/ZWF5n
         KXLAtDoPjEgHPkMpW8eqVUi47IFeb++VqKd9v8uOoBTjvaqLnBqcWqiaNGmbkMuUiW
         Vf4m/R8POYHwEtWYpfZRS3K7wTrHFDbEHCBK0UmfqvQ182Kjx8pxMfw8n1SeDXwFC1
         MTc5zj96mzQnw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8AE5D15C0292; Tue, 15 Aug 2023 23:03:23 -0400 (EDT)
Date:   Tue, 15 Aug 2023 23:03:23 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Kemeng Shi <shikemeng@huaweicloud.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/13] ext4: add missed brelse in update_backups
Message-ID: <20230816030323.GK2247938@mit.edu>
References: <20230629120044.1261968-1-shikemeng@huaweicloud.com>
 <20230629120044.1261968-3-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230629120044.1261968-3-shikemeng@huaweicloud.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jun 29, 2023 at 08:00:33PM +0800, Kemeng Shi wrote:
> add missed brelse in update_backups
> 
> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
