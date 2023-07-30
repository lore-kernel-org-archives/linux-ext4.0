Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7BDC001DF
	for <linux-ext4@archiver.kernel.org>; Sun, 30 Jul 2023 10:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjG3KMs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 30 Jul 2023 06:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjG3KMr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Jul 2023 06:12:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2831BDC;
        Sun, 30 Jul 2023 03:12:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A1E560BB8;
        Sun, 30 Jul 2023 10:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA156C433C8;
        Sun, 30 Jul 2023 10:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1690711966;
        bh=WpJsh3fyEuGUo6PH6fN0EFyznVrVxs5GaJUXkqK1ArM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r0ZG1YBo7p3AhQ7nCHn4uhQ7Hm7JZrQlbuYQsyASaUYbv1fr1arLvsa/zEP1IFYyX
         T50mHgXA2ipNp2yDKfCOYbDwi68Hb7WY52dPDkG8P+joHA8i+luLhQiq+4ZLw48ZSQ
         JwcrqD1u/ORhlVJXW5jsGt36Rf/WRMuyzex2aP9M=
Date:   Sun, 30 Jul 2023 12:12:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Oscar Megia =?iso-8859-1?Q?L=F3pez?= <megia.oscar@gmail.com>,
        kernel-janitors@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: Contributing subsequent patch versions
Message-ID: <2023073013-remix-outscore-c4f9@gregkh>
References: <877cqlmdpg.fsf@gmail.com>
 <8ef54195-4102-0c6c-e14d-efc9bc45cddc@web.de>
 <877cqk5zdt.fsf@gmail.com>
 <20230728181014.GA607743@mit.edu>
 <87tttlncib.fsf@gmail.com>
 <85938916-305c-c8b9-89db-45e522616526@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85938916-305c-c8b9-89db-45e522616526@web.de>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

This is the semi-friendly patch-bot of Greg Kroah-Hartman.

Markus, you seem to have sent a nonsensical or otherwise pointless
review comment to a patch submission on a Linux kernel developer mailing
list.  I strongly suggest that you not do this anymore.  Please do not
bother developers who are actively working to produce patches and
features with comments that, in the end, are a waste of time.

Patch submitter, please ignore Markus's suggestion; you do not need to
follow it at all.  The person/bot/AI that sent it is being ignored by
almost all Linux kernel maintainers for having a persistent pattern of
behavior of producing distracting and pointless commentary, and
inability to adapt to feedback.  Please feel free to also ignore emails
from them.

thanks,

greg k-h's patch email bot
