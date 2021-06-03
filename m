Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC527C4708F
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Jun 2021 02:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B20A261246
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Jun 2021 02:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhFCCEJ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 2 Jun 2021 22:04:09 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45187 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229541AbhFCCEH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jun 2021 22:04:07 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15322DFx016671
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 2 Jun 2021 22:02:13 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 01DBC15C3CAF; Wed,  2 Jun 2021 22:02:12 -0400 (EDT)
Date:   Wed, 2 Jun 2021 22:02:12 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Daniel Rosenberg <drosen@google.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com
Subject: Re: [PATCH] ext4: Fix no-key deletion for encrypt+casefold
Message-ID: <YLg4JOlrNCRJhY6s@mit.edu>
References: <20210522004132.2142563-1-drosen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210522004132.2142563-1-drosen@google.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, May 22, 2021 at 12:41:32AM +0000, Daniel Rosenberg wrote:
> commit 471fbbea7ff7 ("ext4: handle casefolding with encryption") is
> missing a few checks for the encryption key which are needed to
> support deleting enrypted casefolded files when the key is not
> present.
> 
> Note from ebiggers:
> (These checks for the encryption key are still racy since they happen
> too late, but apparently they worked well enough...)
> 
> This bug made it impossible to delete encrypted+casefolded directories
> without the encryption key, due to errors like:
> 
>     W         : EXT4-fs warning (device vdc): __ext4fs_dirhash:270: inode #49202: comm Binder:378_4: Siphash requires key
> 
> Repro steps in kvm-xfstests test appliance:
>       mkfs.ext4 -F -E encoding=utf8 -O encrypt /dev/vdc
>       mount /vdc
>       mkdir /vdc/dir
>       chattr +F /vdc/dir
>       keyid=$(head -c 64 /dev/zero | xfs_io -c add_enckey /vdc | awk '{print $NF}')
>       xfs_io -c "set_encpolicy $keyid" /vdc/dir
>       for i in `seq 1 100`; do
>           mkdir /vdc/dir/$i
>       done
>       xfs_io -c "rm_enckey $keyid" /vdc
>       rm -rf /vdc/dir # fails with the bug
> 
> Fixes: 471fbbea7ff7 ("ext4: handle casefolding with encryption")
> Signed-off-by: Daniel Rosenberg <drosen@google.com>

Applied, thanks.

					- Ted
