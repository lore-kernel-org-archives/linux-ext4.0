Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FBB1C433F5
	for <linux-ext4@archiver.kernel.org>; Thu, 19 May 2022 12:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237877AbiESMX5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 19 May 2022 08:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbiESMX4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 19 May 2022 08:23:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAF2BA55F;
        Thu, 19 May 2022 05:23:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 704251FA1F;
        Thu, 19 May 2022 12:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652963034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IPAtCGcgrcB1mkoJ46Ho86Pn7P+4ckrtre+w/sOYjSc=;
        b=hgFH50h7nXw+YiuyACmlDrXpQVGCVGXDdtf5BbehpyqnxguRuPZZVf6VWvbEnPt2aOt4M/
        KxDbQjGQ0w5Ys3ukJl7DCbViIIke7vcURjXvCHRTQR/I/N3JBf4XqU8/jOqZC1JXy33C9z
        HthrvV4ndKAFKOsf3gqJKn6zDa5K/Os=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652963034;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IPAtCGcgrcB1mkoJ46Ho86Pn7P+4ckrtre+w/sOYjSc=;
        b=crOO2ys6oPz4nN8wC+P4oB8IynXH2MtFDdUmqE6QNH4HcQFjgU8da1h4eeYo7mvG/uDwSx
        4cFGlruE/S6nEnDw==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5A4102C141;
        Thu, 19 May 2022 12:23:54 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id E228BA062F; Thu, 19 May 2022 14:23:53 +0200 (CEST)
Date:   Thu, 19 May 2022 14:23:53 +0200
From:   Jan Kara <jack@suse.cz>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: kernel BUG in ext4_writepages
Message-ID: <20220519122353.eqpnxiaybvobfszb@quack3.lan>
References: <49ac1697-5235-ca2e-2738-f0399c26d718@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ac1697-5235-ca2e-2738-f0399c26d718@linaro.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi!

On Tue 10-05-22 15:28:38, Tadeusz Struk wrote:
> Syzbot found another BUG in ext4_writepages [1].
> This time it complains about inode with inline data.
> C reproducer can be found here [2]
> I was able to trigger it on 5.18.0-rc6
> 
> [1] https://syzkaller.appspot.com/bug?id=a1e89d09bbbcbd5c4cb45db230ee28c822953984
> [2] https://syzkaller.appspot.com/text?tag=ReproC&x=129da6caf00000

Thanks for report. This should be fixed by:

https://lore.kernel.org/all/20220516012752.17241-1-yebin10@huawei.com/

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
