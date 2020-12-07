Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD65C433FE
	for <linux-ext4@archiver.kernel.org>; Mon,  7 Dec 2020 17:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F9932388D
	for <linux-ext4@archiver.kernel.org>; Mon,  7 Dec 2020 17:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgLGRSG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:18:06 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52650 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbgLGRSG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2020 12:18:06 -0500
Received: from localhost (unknown [IPv6:2804:14c:132:242d::1001])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: krisman)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 084331F44D13;
        Mon,  7 Dec 2020 17:17:23 +0000 (GMT)
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Arnaud Ferraris <arnaud.ferraris@collabora.com>
Cc:     linux-ext4@vger.kernel.org, Daniel Rosenberg <drosen@google.com>
Subject: Re: [PATCH v2 01/12] tune2fs: Allow enabling casefold feature after
 fs creation
Organization: Collabora
References: <20201127170116.197901-1-arnaud.ferraris@collabora.com>
        <20201127170116.197901-2-arnaud.ferraris@collabora.com>
Date:   Mon, 07 Dec 2020 14:17:19 -0300
In-Reply-To: <20201127170116.197901-2-arnaud.ferraris@collabora.com> (Arnaud
        Ferraris's message of "Fri, 27 Nov 2020 18:01:05 +0100")
Message-ID: <87o8j57cyo.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Arnaud Ferraris <arnaud.ferraris@collabora.com> writes:

> From: Gabriel Krisman Bertazi <krisman@collabora.com>
>
> The main reason we didn't allow this before was because !CASEFOLDED
> directories were expected to be normalized().  Since this is no longer
> the case, and as long as the encrypt feature is not enabled, it should
> be safe to enable this feature.
>
> Disabling the feature is trickier, since we need to make sure there are
> no existing +F directories in the filesystem.  Leave that for a future
> patch.
>
> Also, enabling strict mode requires some filesystem-wide verification,
> so ignore that for now.
>

For some reason, I wasn't CC'd in the cover letter, only on the patches
themselves.  Anyway, in order to get more/the right attention, I think
you should CC Ted and Eric Biggers on the entire thread.

Can you send a v3 with a proper CC list?

I haven't taken a second look at the patches yet, but it is no my to list.

-- 
Gabriel Krisman Bertazi
