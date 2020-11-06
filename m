Return-Path: <SRS0=ylVP=EM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E75C2D0A3
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Nov 2020 18:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C12920728
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Nov 2020 18:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604686689;
	bh=CUAy/4GGBuJwzt3VtaNVZT/66W43SJeHWjpVtLIEq8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hxFJo/cd7HhmVgyWS4Nu1B2I0rLRjWEUu2h/IqZrP7EVYpcVIaomiQ/gFemW9wPXE
	 n59UyPEu4HH8lWbMIyH+y25hmAwgpRqpMgtUEHzMqlyEHxuPwE84fPHVZxNfdIETMt
	 wAwTdxezXhtHZmvcnTIR1ULxbYKP6dONHgu4G/nE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgKFSSJ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 6 Nov 2020 13:18:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:40972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbgKFSSJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 6 Nov 2020 13:18:09 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63D5820720;
        Fri,  6 Nov 2020 18:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604686688;
        bh=CUAy/4GGBuJwzt3VtaNVZT/66W43SJeHWjpVtLIEq8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Se4bh0561wvFb2RweQ0oeyXfOjV30DsUhl9tV9oRrF1P3u+rxg9SkpQOyJQPh4B6/
         P9/T87OOvy1sfPrzf4cHI4bB9ocsVhppxviFgijnNba5i+ypcDG1ZHyM/WASWfwu6m
         tsODG9khnaxUFg0SkMkcgwUchdUZ1xkS/EP/mNcY=
Date:   Fri, 6 Nov 2020 10:18:06 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Arnaud Ferraris <arnaud.ferraris@collabora.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 00/11] e2fsprogs: improve case-insensitive fs support
Message-ID: <20201106181806.GA79496@sol.localdomain>
References: <20201105161642.87488-1-arnaud.ferraris@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105161642.87488-1-arnaud.ferraris@collabora.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Nov 05, 2020 at 05:16:32PM +0100, Arnaud Ferraris wrote:
> Hello,
> 
> This patch series improves e2fsprogs for case-insensitive filesystems.
> 
> First, it allows tune2fs to enable the 'casefold' feature on existing
> filesystems.
> 
> Then, it improves e2fsck by allowing it to:
> - fix entries containing invalid UTF-8 characters
> - detect duplicated entries
> 
> By default, invalid filenames are only checked when strict mode is enabled.
> A new option is therefore added to allow the user to force this verification.
> 
> This series has been tested by running xfstests, and by manually corrupting
> the test filesystem using debugfs as well.
> 
> Best regards,
> Arnaud

Can you Cc "Daniel Rosenberg <drosen@google.com>" on future versions of this?
I'm not sure whether he's subscribed to linux-ext4.

Thanks!

- Eric
