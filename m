Return-Path: <SRS0=E3Xq=SZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 593FBC282DD
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 04:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3171020843
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 04:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfDWEHR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 23 Apr 2019 00:07:17 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49604 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbfDWEHR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Apr 2019 00:07:17 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 5BB00261176
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH] debugfs: fix encoding handling in dx_hash command
Organization: Collabora
References: <20190422210124.181075-1-ebiggers@kernel.org>
Date:   Tue, 23 Apr 2019 00:07:12 -0400
In-Reply-To: <20190422210124.181075-1-ebiggers@kernel.org> (Eric Biggers's
        message of "Mon, 22 Apr 2019 14:01:23 -0700")
Message-ID: <85o94xs6tr.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> From: Eric Biggers <ebiggers@google.com>
>
> Fix the following bugs:
>
> 1. 'encoding' and 'hash_flags' are not initialized, causing a segfault.
>
> 2. 'hash_flags' incorrectly uses a __bitwise type.
>
> 3. The optstring doesn't contain "c" or "e", so the -c and -e options
>    aren't recognized.
>
> 4. The code that handles the -e option always returns.
>

Ugly. Thanks for finding it.

Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>


-- 
Gabriel Krisman Bertazi
