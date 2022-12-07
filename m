Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86A0C352A1
	for <linux-ext4@archiver.kernel.org>; Wed,  7 Dec 2022 11:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiLGLRc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 7 Dec 2022 06:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiLGLRa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2022 06:17:30 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2332BD9
        for <linux-ext4@vger.kernel.org>; Wed,  7 Dec 2022 03:17:29 -0800 (PST)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1D0C321C7B;
        Wed,  7 Dec 2022 11:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670411848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nl3cYnoVvIf50ZKL46F6ecGRdU1pjqEdzszMDzYGKFU=;
        b=AVDPXKGllvjKAC1hczPdpgK/XRWO8ALsxxugPSrmBfCSMPVkfwHMf9Jq5aihOeOFhUbHZy
        VZngxlI5hgGv8fa1nICQm/0ffdZwdoUZ0fSCj3wZHFzGuAY+Cajn7aEaEtTKNhTtexCoz0
        vJo1jR4GmVHkzGzmnxmTTNKVzKhepdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670411848;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nl3cYnoVvIf50ZKL46F6ecGRdU1pjqEdzszMDzYGKFU=;
        b=DjJzkIYaKfqprPFdDhKAZcdQqebXQMbn+7XbSY2ly00k5SZJLJk/BeAbAV5slJX2iP8ElD
        sqdCOwrRPL10hNAA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 0D2C8134CD;
        Wed,  7 Dec 2022 11:17:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id WXopA0h2kGPnJgAAGKfGzw
        (envelope-from <jack@suse.cz>); Wed, 07 Dec 2022 11:17:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 85784A0725; Wed,  7 Dec 2022 12:17:27 +0100 (CET)
Date:   Wed, 7 Dec 2022 12:17:27 +0100
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org
Subject: Re: [PATCH v3 11/12] ext4: Stop providing .writepage hook
Message-ID: <20221207111727.d5dbfq4mewm4njth@quack3>
References: <20221205122604.25994-1-jack@suse.cz>
 <20221205122928.21959-11-jack@suse.cz>
 <Y460RpKTCDuPKWmN@mit.edu>
 <20221206105225.nr734teqlkueqdph@quack3>
 <Y5BDCtdcZooiMhy5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5BDCtdcZooiMhy5@infradead.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 06-12-22 23:38:50, Christoph Hellwig wrote:
> On Tue, Dec 06, 2022 at 11:52:25AM +0100, Jan Kara wrote:
> > I don't expect any objection. The only reason we didn't export that
> > function when I've added it was that only blkdev code was using it and that
> > cannot be compiled as a module. Should I send a patch to 
> > 
> > I've added a patch to the series to export this function. It is attached.
> > 
> > I can also repost the whole series if these are the only changes that block
> > the inclusion.
> 
> I'd do an EXPORT_SYMBOL_GPL, but otherwise the export looks fine, and it
> would be good to get this conversion going!

OK, I've just copied how buffer_migrate_folio() is exported but I don't
mind a GPL export. I'll change it and push out new version of the series.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
