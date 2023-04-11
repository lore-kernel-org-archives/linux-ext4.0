Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065C1C76196
	for <linux-ext4@archiver.kernel.org>; Tue, 11 Apr 2023 13:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjDKNwh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 11 Apr 2023 09:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjDKNwg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Apr 2023 09:52:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5074196
        for <linux-ext4@vger.kernel.org>; Tue, 11 Apr 2023 06:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D93561EEE
        for <linux-ext4@vger.kernel.org>; Tue, 11 Apr 2023 13:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B662EC433EF;
        Tue, 11 Apr 2023 13:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681221154;
        bh=mmJAaSzEcSzoNJzLVMY4GW4zPm2OwVzXH1enm4loLvY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XkkUNCebmRp0AVdoOuQVeoovJJFg4fUcvz7/hZ6kCGlE3CINNfweyXpg6Y6Q/NnVY
         g799RR/zIX13PqJEqT/aQXYDXkvWVMkW2xspwYCxtrEIVmga/1mtC2214vdDg5y9yK
         /UQ5GQZH74DJMyjPpRGPE7Q0QPcyHZGoggT7UxSq0x7VWSa0OY0mcrV8brrT0W1afU
         VVzmqqMCjMH950kPo9la8vqIvniLQloRJdi32P9+aUdAFye+pPSd7AGcelsJx38H/F
         E1c9GjAfLVwIWXh1cPsTWn6/QCjcsC2BX8mIL2Vz6JJoCRSKkvQ3Ckuj9Aue/f7C/s
         euxLnZWRsT7kQ==
Date:   Tue, 11 Apr 2023 15:52:30 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        syzbot+aacb82fca60873422114@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: Fix lockdep warning when enabling MMP
Message-ID: <20230411-unbeeindruckt-erleben-96b048352735@brauner>
References: <20230411121019.21940-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230411121019.21940-1-jack@suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 11, 2023 at 02:10:19PM +0200, Jan Kara wrote:
> When we enable MMP in ext4_multi_mount_protect() during mount or
> remount, we end up calling sb_start_write() from write_mmp_block(). This
> triggers lockdep warning because freeze protection ranks above s_umount
> semaphore we are holding during mount / remount. The problem is harmless
> because we are guaranteed the filesystem is not frozen during mount /
> remount but still let's fix the warning by not grabbing freeze
> protection from ext4_multi_mount_protect().
> 
> Reported-by: syzbot+aacb82fca60873422114@syzkaller.appspotmail.com
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
