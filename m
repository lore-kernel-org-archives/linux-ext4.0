Return-Path: <SRS0=bqz9=Q2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8BB6C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 19:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8EED20851
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 19:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbfBSTEU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Feb 2019 14:04:20 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44732 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfBSTEU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2019 14:04:20 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id B2B2327DB81
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        sfrench@samba.org, darrick.wong@oracle.com,
        samba-technical@lists.samba.org, jlayton@kernel.org,
        bfields@fieldses.org, paulus@samba.org
Subject: Re: [PATCH RFC v5 00/11] Ext4 Encoding and Case-insensitive support
Organization: Collabora
References: <20190128213223.31512-1-krisman@collabora.com>
Date:   Tue, 19 Feb 2019 14:04:15 -0500
In-Reply-To: <20190128213223.31512-1-krisman@collabora.com> (Gabriel Krisman
        Bertazi's message of "Mon, 28 Jan 2019 16:32:12 -0500")
Message-ID: <87wolv38i8.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Gabriel Krisman Bertazi <krisman@collabora.com> writes:

> Regarding Casefold, I am unsure whether Casefold Common + Full still
> makes sense after migrating from the compatibility to the canonical
> form.  While Casefold Full, by definition, addresses cases where the
> casefolding grows in size, like the casefold of the german eszett to SS,
> it also is responsible for folding smallcase ligatures without a
> corresponding uppercase to their compatible counterpart.  Which means
> that on -F directories, o_f_f_i_c_e and o_ff_i_c_e will differ, while on
> +F directories they will match.  This seems unaceptable to me,
> suggesting that we should start to use Common + Simple instead of Common
> + Full, but I would like more input on what seems more reasonable to
> you.
>
> After we decide on this, I will be sending new patches to update
> e2fsprogs to the agreed method and remove the normalization/casefold
> type flags (EXT4_UTF8_NORMALIZATION_TYPE_NFKD,
> EXT4_UTF8_CASEFOLD_TYPE_NFKDCF), before actually proposing the current
> patch series for inclusion in the kernel.

Hey Ted,

Any comments about this bit before I move on and propose a new version?

-- 
Gabriel Krisman Bertazi
