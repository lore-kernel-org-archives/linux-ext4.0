Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A4EC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 22:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FE6A21916
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 22:30:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ORxgYshZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfCUWam (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 18:30:42 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38438 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfCUWam (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 18:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ryfww38RmJrD5XBDDJEMLnZCmoB7i9MAX1norNnn3cY=; b=ORxgYshZtH1edkye7HrAkWZEF
        5cm8KXeqcPjc3PCE9N63kbbV5nh4KlwrHuy9rWZvw9pg2fDMhfzHDVj05TIOdYIiW3dikLWWDHJ6Q
        2jU04qz9PfUOrAF7LFMKn3Wg+qToeC15/qpqsooTQr/Isjy7JKd+2EwQDP2vUBUfPmSZ+hBAupBr/
        i4cPIR4OlUmzXIN0lZO5evNzsWgztS54ZAuI/6PCjbzs7c/8w0ox/DD8mjAFg7YxolEHwuJVeoFhM
        T0spUWh8HBn7YDkDRPT4vWyqnrZDspJIGn+4RKL+41hkqy8kHcCZtTfiF6nOCeQIsyn/xDNwGqgrt
        iI6xZAG8w==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h76Cr-0001kS-Vn; Thu, 21 Mar 2019 22:30:38 +0000
Subject: Re: [PATCH RFC v6 00/11] Ext4 Encoding and Case-insensitive support
To:     Gabriel Krisman Bertazi <krisman@collabora.com>, tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org, sfrench@samba.org,
        darrick.wong@oracle.com, jlayton@kernel.org, bfields@fieldses.org,
        paulus@samba.org, linux-fsdevel@vger.kernel.org
References: <20190318202745.5200-1-krisman@collabora.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <05dfd6a7-49f0-81a7-cd68-ff9f07182461@infradead.org>
Date:   Thu, 21 Mar 2019 15:30:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190318202745.5200-1-krisman@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 3/18/19 1:27 PM, Gabriel Krisman Bertazi wrote:
> Hi,
> 
> This version pretty much the same as v5. I am resending cause as the
> previous version didn't grab much discussion on the main topic of moving
> from KD to D.
> 
> Same as version 5, at a first glance, you will notice the series got a
> lot smaller, with the separation of unicode code from the NLS subsystem,
> as Linus requested.  The ext4 parts are pretty much the same, with only
> the addition of a verification in ext4_feature_set_ok() to fail encoding
> mounts when without CONFIG_UNICODE on newer kernels.
> 
> The main change presented here is a proposal to migrate the
> normalization method from NFKD to NFD.  After our discussions, and
> reviewing other operating systems and languages aspects, I am more
> convinced that canonical decomposition is more viable solution than
> compatibility decomposition, because it doesn't ignore eliminate any
> semantic meaning, like the definitive case of superscript numbers.  NFD
> is also the documented method used by HFS+ and APFS, so there is
> precedent. Notice however, that as far as my research goes, APFS doesn't
> completely follows NFD, and in some cases, like <compat> flags, it
> actually does NFKD, but not in others (<fraction>), where it applies the
> canonical form.  We take a more consistent approach and always do plain NFD.
> 
> This RFC, therefore, aims to resume/start conversation with some
> stalkeholders that may have something to say regarding the normalization
> method used.  I added people from SMB, NFS and FS development who
> might be interested on this.
> 
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
> 
> For the record, I am aware that unicode 12 was released 2 weeks ago. The
> world can't live without a new set of emojis every 6 months.  I will
> withold updating the unicode version until we get something
> upstreamable, then I will update to the latest version and send a new
> version.  This way I avoid having to update versions that will never
> actually be used.
> 
> Practical things, w.r.t. this patch series:
> 
>   - As usual, the UCD files are not part of the series, because they
>   would cause the email to bounce.  To test this one would need to fetch
>   the files as explained in the commit message.
> 
>   - If you prefer, you can checkout from
>      https://gitlab.collabora.com/krisman/linux -b ext4-ci-directory-no-nls
> 
>   - More details on the design decisions restricted to ext4 are
>     available in the corresponding commit messages.
> 
> Thanks!
> 

Hi,
I briefly scanned but did not look terribly closely:

Does this patch series ignore ext3 filesystems that are being handled
by the ext4fs code?

Thanks.

> 
> Gabriel Krisman Bertazi (7):
>   unicode: Implement higher level API for string handling
>   unicode: Introduce test module for normalized utf8 implementation
>   MAINTAINERS: Add Unicode subsystem entry
>   ext4: Include encoding information in the superblock
>   ext4: Support encoding-aware file name lookups
>   ext4: Implement EXT4_CASEFOLD_FL flag
>   docs: ext4.rst: Document encoding and case-insensitive
> 
> Olaf Weber (4):
>   unicode: Add unicode character database files
>   scripts: add trie generator for UTF-8
>   unicode: Introduce code for UTF-8 normalization
>   unicode: reduce the size of utf8data[]
> 
>  Documentation/admin-guide/ext4.rst |   41 +
>  MAINTAINERS                        |    6 +
>  fs/Kconfig                         |    1 +
>  fs/Makefile                        |    1 +
>  fs/ext4/dir.c                      |   43 +
>  fs/ext4/ext4.h                     |   42 +-
>  fs/ext4/hash.c                     |   38 +-
>  fs/ext4/ialloc.c                   |    2 +-
>  fs/ext4/inline.c                   |    2 +-
>  fs/ext4/inode.c                    |    4 +-
>  fs/ext4/ioctl.c                    |   18 +
>  fs/ext4/namei.c                    |  104 +-
>  fs/ext4/super.c                    |   91 +
>  fs/unicode/Kconfig                 |   13 +
>  fs/unicode/Makefile                |   22 +
>  fs/unicode/ucd/README              |   33 +
>  fs/unicode/utf8-core.c             |  183 ++
>  fs/unicode/utf8-norm.c             |  797 +++++++
>  fs/unicode/utf8-selftest.c         |  320 +++
>  fs/unicode/utf8n.h                 |  117 +
>  include/linux/fs.h                 |    2 +
>  include/linux/unicode.h            |   30 +
>  scripts/Makefile                   |    1 +
>  scripts/mkutf8data.c               | 3418 ++++++++++++++++++++++++++++
>  24 files changed, 5307 insertions(+), 22 deletions(-)
>  create mode 100644 fs/unicode/Kconfig
>  create mode 100644 fs/unicode/Makefile
>  create mode 100644 fs/unicode/ucd/README
>  create mode 100644 fs/unicode/utf8-core.c
>  create mode 100644 fs/unicode/utf8-norm.c
>  create mode 100644 fs/unicode/utf8-selftest.c
>  create mode 100644 fs/unicode/utf8n.h
>  create mode 100644 include/linux/unicode.h
>  create mode 100644 scripts/mkutf8data.c
> 


-- 
~Randy
