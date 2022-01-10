Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E64CBC433F5
	for <linux-ext4@archiver.kernel.org>; Mon, 10 Jan 2022 15:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbiAJPRA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 10 Jan 2022 10:17:00 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:43830 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbiAJPRA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Jan 2022 10:17:00 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 091961F393;
        Mon, 10 Jan 2022 15:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641827819;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DGnaiRxaDsHKeCS/hu+whM0M0VdPlN99xIquzzMKJQ4=;
        b=jDV+Sj5XywVhkfrCXgeVMS0+71JXCQMb04rxRzfoPItzIXQcWAqG6VXSX1OeLij0LpcJLc
        dvnXWSpFn4N/JbL06CVrz3jU0WBHyOSyVP4l2Pse5NrkfYYeuSdLndLTR+Llo9ObgpONua
        rD9+SqtacQnQwg3zyC4l7QaxgyvxqH0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641827819;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DGnaiRxaDsHKeCS/hu+whM0M0VdPlN99xIquzzMKJQ4=;
        b=rVLEOeUxkyBDA/avbjvakAld4VzK0Pan6cxPW/3A1uvkdU5HKXgJRrVn42YQwz8NHPnaR3
        2Gn3P26Ga+pAswAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 88D3913D9D;
        Mon, 10 Jan 2022 15:16:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Sv2wHupN3GE7dwAAMHmgww
        (envelope-from <pvorel@suse.cz>); Mon, 10 Jan 2022 15:16:58 +0000
Date:   Mon, 10 Jan 2022 16:16:56 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     jack@suse.com, amir73il@gmail.com, repnop@google.com,
        linux-ext4@vger.kernel.org, kernel@collabora.com,
        khazhy@google.com, ltp@lists.linux.it
Subject: Re: [PATCH v4 0/9] Test the new fanotify FAN_FS_ERROR event
Message-ID: <YdxN6HBJF+ATgZxP@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20211118235744.802584-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118235744.802584-1-krisman@collabora.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi all,

v5.16 released => patchset merged.
Thanks!

Kind regards,
Petr
