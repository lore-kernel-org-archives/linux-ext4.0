Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F87C001DF
	for <linux-ext4@archiver.kernel.org>; Fri, 28 Jul 2023 15:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbjG1PKM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 28 Jul 2023 11:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236826AbjG1PKL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Jul 2023 11:10:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA33346B9;
        Fri, 28 Jul 2023 08:09:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C029921995;
        Fri, 28 Jul 2023 15:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690556987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sA4eJEf2xtyfEhJkx23SMukgQxsneaFm9EcZ0cTMKRI=;
        b=iQPTmO15cm6iO2LUNlg3WXCC7CJjexQsl8DFdCm1Pc2irpbHp7oJdIOSqiLWCLzfxAdxqi
        vwTk1wdaXkGF2PZ6/HQfK3AujXJn/T96Fk38LlR1Ug0VaA9xLVCxhdmELjg+nGzR7VpmOL
        5Ry7NJVS3JDlYbwcRtzZF8UxVQGDcTc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690556987;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sA4eJEf2xtyfEhJkx23SMukgQxsneaFm9EcZ0cTMKRI=;
        b=YCoC3Q3VNtgGzzPxNZnYCl5uUrm9iaukksnbNGYCyRsNl5bWUzElVwPvPg/ClmoVOJ7BhU
        frCH2Q6CRI73M6BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8B0F3133F7;
        Fri, 28 Jul 2023 15:09:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3qp1HDvaw2RWPAAAMHmgww
        (envelope-from <krisman@suse.de>); Fri, 28 Jul 2023 15:09:47 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Christian Brauner <brauner@kernel.org>
Cc:     viro@zeniv.linux.org.uk, tytso@mit.edu, ebiggers@kernel.org,
        jaegeuk@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: [PATCH v4 3/7] libfs: Validate negative dentries in
 case-insensitive directories
Organization: SUSE
References: <20230727172843.20542-1-krisman@suse.de>
        <20230727172843.20542-4-krisman@suse.de>
        <20230728-beckenrand-wahrlich-62d6b0505d68@brauner>
Date:   Fri, 28 Jul 2023 11:09:46 -0400
In-Reply-To: <20230728-beckenrand-wahrlich-62d6b0505d68@brauner> (Christian
        Brauner's message of "Fri, 28 Jul 2023 15:06:30 +0200")
Message-ID: <87r0os139h.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Christian Brauner <brauner@kernel.org> writes:

> On Thu, Jul 27, 2023 at 01:28:39PM -0400, Gabriel Krisman Bertazi wrote:

>
> Wouldn't it make sense to get rid of all this indentation?

I'm ok with making this change. I'll wait for more reviews and Eric
before sending a new version with this done.

Thanks!

-- 
Gabriel Krisman Bertazi
