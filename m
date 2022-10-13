Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0653C433FE
	for <linux-ext4@archiver.kernel.org>; Thu, 13 Oct 2022 23:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJMXpj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 13 Oct 2022 19:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJMXph (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Oct 2022 19:45:37 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6E26707C
        for <linux-ext4@vger.kernel.org>; Thu, 13 Oct 2022 16:45:34 -0700 (PDT)
Received: (Authenticated sender: gabriel@krisman.be)
        by mail.gandi.net (Postfix) with ESMTPSA id 9CE5A20005;
        Thu, 13 Oct 2022 23:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=krisman.be; s=gm1;
        t=1665704733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6AoRxkw5VMVRk5KeY67RfUOX9XRHNeBTxQdmVl/KoLY=;
        b=XItFjwiglg9Yb+V7d7AuJUzWGUG+sDNMOIgL4E1L/uGjP7HNzhjoQ5AqE3E2042Bf+vCEc
        umH7bGcmJZir1vk54lAxPiJOGhiHpA7OxBygOfrgUWkiKmRY3JUcVAnHPjZRVQbI9XKzVb
        GEjfmofDGOZdukOaEVj2Pij+jrUIlVbRiydJlId3B1798lpHPzUmyk0o8ZLscabGX6S/TV
        i5zaOemBSxUUsd9uioD3tCcgNeDjtfD1NgTlwtI9HyU9mOG5ypWYnfGXdIZerzzUIRXSPA
        uRrz3vSaB9v0/qIVfx6inDREoD7pRu7iaZIQzRn5K6ebeuCKXDL0c6kLZpMq/w==
From:   Gabriel Krisman Bertazi <gabriel@krisman.be>
To:     tytso@mit.edu
Cc:     Eric Biggers <ebiggers@kernel.org>, adilger.kernel@dilger.ca,
        jaegeuk@kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel@collabora.com
Subject: Re: [PATCH v9 0/8] Clean up the case-insensitive lookup path
References: <20220913234150.513075-1-krisman@collabora.com>
        <Yy0t8WYhM+Dv3gX1@sol.localdomain> <87fsgi2lax.fsf@collabora.com>
Date:   Thu, 13 Oct 2022 19:45:29 -0400
In-Reply-To: <87fsgi2lax.fsf@collabora.com> (Gabriel Krisman Bertazi's message
        of "Fri, 23 Sep 2022 10:54:30 -0400")
Message-ID: <87tu47thie.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Gabriel Krisman Bertazi <krisman@collabora.com> writes:

> Eric Biggers <ebiggers@kernel.org> writes:
>
>> On Tue, Sep 13, 2022 at 07:41:42PM -0400, Gabriel Krisman Bertazi wrote:
>>> Hi,
>>> 
>>> I'm resubmitting this as v9 since I think it has fallen through the
>>> cracks :).  It is a collection of trivial fixes for casefold support on
>>> ext4/f2fs. More details below.
>>> 
>>> It has been sitting on the list for a while and most of it is r-b
>>> already. I'm keeping the tags for this submission, since there is no
>>> modifications from previous submissions, apart from a minor conflict
>>> resolution when merging to linus/master.
>>
>> Who are you expecting to apply this?
>
> Hi Eric,
>
> There are three groups of changes here: libfs, ext4 and f2fs.  Since the
> changes in libfs are self-contained and only affect these two
> filesystems, I think it should be fine for them to go through a fs tree.
>
> The bulk of changes are ext4, and Ted mentioned on an earlier version
> that he could pick the first patches of this series, so I'm thinking it
> should all go through the ext4 tree.  If Jaegeuk acks, the f2fs changes
> are safe to go with the rest, or I can send them afterwards as a
> separate series once the libfs code is merged.

Ted,

Does the above plan work for you? Do you intend to pick this up for the
next merge window?

-- 
Gabriel Krisman Bertazi
