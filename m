Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21C8C0018C
	for <linux-ext4@archiver.kernel.org>; Mon,  7 Dec 2020 12:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B676F23381
	for <linux-ext4@archiver.kernel.org>; Mon,  7 Dec 2020 12:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgLGMEg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:04:36 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49540 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbgLGMEg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2020 07:04:36 -0500
Received: from localhost (unknown [IPv6:2804:14c:132:242d::1001])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: krisman)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id C15CF1F44F9F;
        Mon,  7 Dec 2020 12:03:53 +0000 (GMT)
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Daniel Rosenberg <drosen@google.com>
Subject: Re: [PATCH] libfs: unexport generic_ci_d_compare() and
 generic_ci_d_hash()
Organization: Collabora
References: <20201204233940.52144-1-ebiggers@kernel.org>
Date:   Mon, 07 Dec 2020 07:03:47 -0500
In-Reply-To: <20201204233940.52144-1-ebiggers@kernel.org> (Eric Biggers's
        message of "Fri, 4 Dec 2020 15:39:40 -0800")
Message-ID: <87v9dd7rh8.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> From: Eric Biggers <ebiggers@google.com>
>
> Now that generic_set_encrypted_ci_d_ops() has been added and ext4 and
> f2fs are using it, it's no longer necessary to export
> generic_ci_d_compare() and generic_ci_d_hash() to filesystems.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>


-- 
Gabriel Krisman Bertazi
