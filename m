Return-Path: <SRS0=2QqD=6J=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1B1C55185
	for <linux-ext4@archiver.kernel.org>; Sat, 25 Apr 2020 11:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44B00206A2
	for <linux-ext4@archiver.kernel.org>; Sat, 25 Apr 2020 11:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgDYLto (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 25 Apr 2020 07:49:44 -0400
Received: from smtprelay0048.hostedemail.com ([216.40.44.48]:53252 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726060AbgDYLto (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 25 Apr 2020 07:49:44 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Apr 2020 07:49:44 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave06.hostedemail.com (Postfix) with ESMTP id 814AF800DDE3;
        Sat, 25 Apr 2020 11:47:21 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 372BA18029124;
        Sat, 25 Apr 2020 11:47:20 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: level16_22c4775d3930b
X-Filterd-Recvd-Size: 3038
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Sat, 25 Apr 2020 11:47:18 +0000 (UTC)
Message-ID: <67d97b191f3e015bf6a1ef0472cc30c4f57fdaaf.camel@perches.com>
Subject: Re: [PATCH 4.4 091/100] ext2: fix empty body warnings when -Wextra
 is used
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Date:   Sat, 25 Apr 2020 04:47:17 -0700
In-Reply-To: <326458310dc7c982d2f2210e057f69d6bc0169c7.camel@perches.com>
References: <20200422095022.476101261@linuxfoundation.org>
         <20200422095039.371486451@linuxfoundation.org>
         <326458310dc7c982d2f2210e057f69d6bc0169c7.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, 2020-04-25 at 04:43 -0700, Joe Perches wrote:
> On Wed, 2020-04-22 at 11:57 +0200, Greg Kroah-Hartman wrote:
> > From: Randy Dunlap <rdunlap@infradead.org>
> > 
> > [ Upstream commit 44a52022e7f15cbaab957df1c14f7a4f527ef7cf ]
> > 
> > When EXT2_ATTR_DEBUG is not defined, modify the 2 debug macros
> > to use the no_printk() macro instead of <nothing>.
> > This fixes gcc warnings when -Wextra is used:
> > 
> > ../fs/ext2/xattr.c:252:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> > ../fs/ext2/xattr.c:258:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> > ../fs/ext2/xattr.c:330:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> > ../fs/ext2/xattr.c:872:45: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
> > 
> > I have verified that the only object code change (with gcc 7.5.0) is
> > the reversal of some instructions from 'cmp a,b' to 'cmp b,a'.
> 
> It'd be better to use the ext4 style defines:
> 
> fs/ext4/xattr.c:# define ea_idebug(inode, fmt, ...)                                     \
> fs/ext4/xattr.c-        printk(KERN_DEBUG "inode %s:%lu: " fmt "\n",                    \
> fs/ext4/xattr.c-               inode->i_sb->s_id, inode->i_ino, ##__VA_ARGS__)
> fs/ext4/xattr.c:# define ea_bdebug(bh, fmt, ...)                                        \
> fs/ext4/xattr.c-        printk(KERN_DEBUG "block %pg:%lu: " fmt "\n",                   \
> fs/ext4/xattr.c-               bh->b_bdev, (unsigned long)bh->b_blocknr, ##__VA_ARGS__)
> --
> fs/ext4/xattr.c:# define ea_idebug(inode, fmt, ...)     no_printk(fmt, ##__VA_ARGS__)
> fs/ext4/xattr.c:# define ea_bdebug(bh, fmt, ...)        no_printk(fmt, ##__VA_ARGS__)
> 
> So the output logging won't be split across multiple lines.

And beyond that, why is a -Wextra warning being fixed in -stable at all?


