Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F95FC43217
	for <linux-ext4@archiver.kernel.org>; Mon,  7 Nov 2022 14:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbiKGOJD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 7 Nov 2022 09:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiKGOJC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2022 09:09:02 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C714D1B9E6;
        Mon,  7 Nov 2022 06:09:01 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6F4CD220FE;
        Mon,  7 Nov 2022 14:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1667830140; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LO1zxWnY9+/5ve5/yjzWxZu7y80ZAaMIi5i5Mc7a2IE=;
        b=RH6twAdhmeXWeZ6yNZc8izlA9niIVTClP7P75Z7NZ6uMf/G+8mlqya0yJr08tXtH6rSOqa
        9wQgpIDZpagr6HI0IliLz175ntBST0mvpoRq2rSh4K8HbLeycKHV0etO2ikm+KFNGHI7Hx
        9Ns9f4OWA37nsdtQsaegad3+PL4o7s0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1667830140;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LO1zxWnY9+/5ve5/yjzWxZu7y80ZAaMIi5i5Mc7a2IE=;
        b=LszfF74DBGlEjV2GvJnOczziN7VvrNntdvfbJ5nk4aVO3IC9x+mO10ZbvxYQG1qyJw0ZEO
        1y6ZDUMiTsETT/AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 574DC13AC7;
        Mon,  7 Nov 2022 14:09:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VglIFXwRaWNdcgAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 07 Nov 2022 14:09:00 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 7408FA0704; Mon,  7 Nov 2022 15:08:59 +0100 (CET)
Date:   Mon, 7 Nov 2022 15:08:59 +0100
From:   Jan Kara <jack@suse.cz>
To:     syzbot <syzbot+bd13648a53ed6933ca49@syzkaller.appspotmail.com>
Cc:     gregkh@linuxfoundation.org, jack@suse.cz, lczerner@redhat.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable-commits@vger.kernel.org,
        stable@kernel.org, stable@vger.kernel.org,
        syzkaller-android-bugs@googlegroups.com, tadeusz.struk@linaro.org,
        tytso@mit.edu
Subject: Re: kernel BUG in ext4_writepages
Message-ID: <20221107140859.lk7sok74nxs6srxe@quack3>
References: <000000000000c3a53d05de992007@google.com>
 <000000000000bc92bf05ece0af6f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000bc92bf05ece0af6f@google.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 07-11-22 04:37:28, syzbot wrote:
> This bug is marked as fixed by commit:
> ext4: Avoid crash when inline data creation follows DIO write
> But I can't find it in any tested tree for more than 90 days.
> Is it a correct commit? Please update it by replying:
> #syz fix: exact-commit-title
> Until then the bug is still considered open and
> new crashes with the same signature are ignored.

#syz fix: ext4: avoid crash when inline data creation follows DIO write

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
