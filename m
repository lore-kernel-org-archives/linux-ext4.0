Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E06C6FD1C
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Mar 2023 11:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCNLfJ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 14 Mar 2023 07:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjCNLfH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Mar 2023 07:35:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800699AFE6;
        Tue, 14 Mar 2023 04:35:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3813721E8B;
        Tue, 14 Mar 2023 11:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1678793705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HSYroVqJpfDBDtAYsBz5VWYKwbIZ2RSRG2OfXtHR+MI=;
        b=U9ZzX+ocPjAlV0r1OGHLJbUSDiF6fjr6pPmZ2NVtTRA6vY6pStLwQ3/v1qk97fq0M5/o9r
        zlrSHKwTS9k7f6mTVHhvZA+9R03Ihmo8HLIAkrenYJiRdD10sA8wV9alnfcju0RUI29tYN
        Zd8/WJqPXpQOq1735tiomp7Q2w9VSfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1678793705;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HSYroVqJpfDBDtAYsBz5VWYKwbIZ2RSRG2OfXtHR+MI=;
        b=+KeUU3D/JHatauMFTgjH5qBZcSn0alfUtwMMsFMZaQH7MnvKd6w+uCdv+NtF7R8yKet0N6
        yVrNhFEQsyUatkAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2A9EA13A1B;
        Tue, 14 Mar 2023 11:35:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SlJgCulbEGRdNwAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 14 Mar 2023 11:35:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id B5B51A06FD; Tue, 14 Mar 2023 12:35:04 +0100 (CET)
Date:   Tue, 14 Mar 2023 12:35:04 +0100
From:   Jan Kara <jack@suse.cz>
To:     Zhihao Cheng <chengzhihao1@huawei.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.com,
        tudor.ambarus@linaro.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [PATCH v2 2/5] jbd2: remove unused feature macros
Message-ID: <20230314113504.xfo7q2uy6q623vzb@quack3>
References: <20230313132021.672134-1-chengzhihao1@huawei.com>
 <20230313132021.672134-3-chengzhihao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313132021.672134-3-chengzhihao1@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 13-03-23 21:20:18, Zhihao Cheng wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> JBD2_HAS_[IN|RO_]COMPAT_FEATURE macros are no longer used, just remove
> them.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>

I gave you my Reviewed-by on this patch (and a few others in this series).
Why didn't you include it?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
