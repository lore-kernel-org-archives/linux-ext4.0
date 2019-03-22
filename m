Return-Path: <SRS0=oERZ=R2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEBB4C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 00:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D6DB213F2
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 00:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfCVX5y (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Mar 2019 19:57:54 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:42357 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725999AbfCVX5y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Mar 2019 19:57:54 -0400
Received: from callcc.thunk.org (180.sub-174-220-8.myvzw.com [174.220.8.180])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2MNv8Zd020502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Mar 2019 19:57:10 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 54854421A01; Fri, 22 Mar 2019 19:57:08 -0400 (EDT)
Date:   Fri, 22 Mar 2019 19:57:08 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        linux-ext4@vger.kernel.org, sfrench@samba.org,
        darrick.wong@oracle.com, jlayton@kernel.org, bfields@fieldses.org,
        paulus@samba.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v6 00/11] Ext4 Encoding and Case-insensitive support
Message-ID: <20190322235708.GA5675@mit.edu>
References: <20190318202745.5200-1-krisman@collabora.com>
 <05dfd6a7-49f0-81a7-cd68-ff9f07182461@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05dfd6a7-49f0-81a7-cd68-ff9f07182461@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 03:30:35PM -0700, Randy Dunlap wrote:
> I briefly scanned but did not look terribly closely:
> 
> Does this patch series ignore ext3 filesystems that are being handled
> by the ext4fs code?

Like all ext2/3/4 features, new functionality is gated by a feature
bit in the compat, rocompat, or incompat bitmasks.  A file system
implementation (e.g., in the Linux kernel, NetBSD/FreeBSD, Grub,
et. al) which sees a feature bit it doesn't recognize in an rocompat
bitmask will only allow the file system to be mounted read-only.  If
it sees a bit in the incompat bitmask it doesn't recognize, it won't
allow the file system to be mounted at all.  The kernel doesn't care
if it finds a bit it doesn't recognize in the compat bitmask; however,
e2fsck will not touch a file system that has a compat bit which it
doesn't know how to deal with.

Strictly speaking, there is no such thing as an "ext3 file system".
There are just file systems with a set of feature bits set.  And the
set of features supported by NetBSD or the Grub installer may not fall
neatly into the "ext2", "ext3", or "ext4" buckets. 

If by "ext3 file system" you mean a file system with those featire
bits set by mke2fs -t ext3 by default (e.g., not overridden by the -O
option, or by the system administrator editing /etc/mke2fs.conf), then
yes, this patch series will not result in any substantive change for
"ext3 file systems", since it by default "mke2fs -t ext3" or
"mkfs.ext3" will not enable the feature flag that turns on
case-insensitive support.

For more information, see the ext4 and mke2fs.conf manual pages.

Cheers,

					- Ted

