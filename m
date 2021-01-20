Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB4FDC433DB
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Jan 2021 04:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 526AC22DD3
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Jan 2021 04:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbhATE7Q (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Jan 2021 23:59:16 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41216 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729027AbhATE4P (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jan 2021 23:56:15 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 10K4tQ6S021661
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 23:55:27 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 77B3915C35F5; Tue, 19 Jan 2021 23:55:26 -0500 (EST)
Date:   Tue, 19 Jan 2021 23:55:26 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Romain Naour <romain.naour@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] libext2fs: add gnu.translator support
Message-ID: <YAe3voa3OCFbtSoc@mit.edu>
References: <20201102130319.1434330-1-romain.naour@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102130319.1434330-1-romain.naour@gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Nov 02, 2020 at 02:03:19PM +0100, Romain Naour wrote:
> The support of setting (and reading) of passive translators from
> GNU/Linux has been added to the Linux kernel by the commit [1].
> The name index '10' has been reserved for GNU/Hurd.
> 
> Hurd passive translators are stored as a xattr value with name
> "gnu.translator" [2].
> 
> If "gnu.translator" xattr value has been set before calling
> mkfs.ext2, it will segfault since "gnu." is not present in
> ea_names[].
> 
> $ setfattr -n gnu.translator -v "/hurd/exec\0" ${TARGET_DIR}/servers/exec
> $ mkfs.ext2 -d ${TARGET_DIR} -o hurd -O ext_attr rootfs.ext2 "1G"
> 
> Adding "gnu." to ea_names[], allow to create ext2 filesystem
> for GNU/Hurd with passive translator already set.
> 
> [1] https://git.savannah.gnu.org/cgit/hurd/hurd.git/commit/?id=a04c7bf83172faa7cb080fbe3b6c04a8415ca645
> [2] https://lists.gnu.org/archive/html/bug-hurd/2016-08/msg00075.html
> 
> Signed-off-by: Romain Naour <romain.naour@gmail.com>
> Cc: Theodore Ts'o <tytso@mit.edu>

Applied, thanks.

					- Ted
