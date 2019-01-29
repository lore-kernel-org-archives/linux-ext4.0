Return-Path: <SRS0=tjTT=QF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C27C169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 16:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C09E20881
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 16:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfA2QyG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 11:54:06 -0500
Received: from fieldses.org ([173.255.197.46]:54370 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbfA2QyG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Jan 2019 11:54:06 -0500
Received: by fieldses.org (Postfix, from userid 2815)
        id 77EF91B9A; Tue, 29 Jan 2019 11:54:05 -0500 (EST)
Date:   Tue, 29 Jan 2019 11:54:05 -0500
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     tytso@mit.edu, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, sfrench@samba.org,
        darrick.wong@oracle.com, samba-technical@lists.samba.org,
        jlayton@kernel.org, paulus@samba.org
Subject: Re: [PATCH RFC v5 00/11] Ext4 Encoding and Case-insensitive support
Message-ID: <20190129165405.GG19683@fieldses.org>
References: <20190128213223.31512-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128213223.31512-1-krisman@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jan 28, 2019 at 04:32:12PM -0500, Gabriel Krisman Bertazi wrote:
> Following Linus comments, this version is back as an RFC, in order to
> discuss the normalization method used.  At a first glance, you will
> notice the series got a lot smaller, with the separation of unicode code
> from the NLS subsystem, as Linus requested.  The ext4 parts are pretty
> much the same, with only the addition of a verification in
> ext4_feature_set_ok() to fail encoding mounts when without
> CONFIG_UNICODE on newer kernels.
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

For what it's worth, knfsd will just pass through pathnames unchanged
the client, and the Linux client will pass them on to applications
unchanged.  I don't know what other clients might do.  But it's hard for
NFS clients and servers to do anything more clever, because behavior of
exported filesystems varies, users have preexisting filesystems with
random encodings, and on the client side in the Linux case, the kernel
doesn't know about process locales.  So, whatever behavior ext4
implements is likely the same behavior that will be seen by an
application on a client accessing an ext4 filesystem over NFS.

--b.

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
> Practical things, w.r.t. this patch series:
> 
>   - As usual, the UCD files are not part of the series, because they
>   would bounce.  To test this one would need to fetch the files as
>   explained in the commit message.
> 
>   - If you prefer, you can checkout from
>      https://gitlab.collabora.com/krisman/linux -b ext4-ci-directory-no-nls
> 
>   - More details on the design decisions restricted to ext4 are
>     available in the corresponding commit messages.
> 
> Thanks for keeping up with this.
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
> -- 
> 2.20.1
