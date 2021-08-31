Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF188C4320A
	for <linux-ext4@archiver.kernel.org>; Tue, 31 Aug 2021 03:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85DD961039
	for <linux-ext4@archiver.kernel.org>; Tue, 31 Aug 2021 03:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239707AbhHaDDl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 30 Aug 2021 23:03:41 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52282 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232054AbhHaDDS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Aug 2021 23:03:18 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17V326xp029013
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 23:02:06 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 2BE3615C3E7E; Mon, 30 Aug 2021 23:02:06 -0400 (EDT)
Date:   Mon, 30 Aug 2021 23:02:06 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Zhang Yi <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, jack@suse.cz,
        yukuai3@huawei.com
Subject: Re: [PATCH v4 6/6] ext4: prevent getting empty inode buffer
Message-ID: <YS2brqdSIO8mQs3U@mit.edu>
References: <20210826130412.3921207-1-yi.zhang@huawei.com>
 <20210826130412.3921207-7-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826130412.3921207-7-yi.zhang@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Aug 26, 2021 at 09:04:12PM +0800, Zhang Yi wrote:
> 
> So this patch initialize the inode buffer by filling the in-mem inode
> contents if we skip read I/O, ensure that the buffer is really uptodate.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/inode.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3c36e701e30e..8b37f55b04ad 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4446,8 +4446,8 @@ static int ext4_fill_raw_inode(struct inode *inode, struct ext4_inode *raw_inode
>   * inode.
>   */
>  static int __ext4_get_inode_loc(struct super_block *sb, unsigned long ino,
> -				struct ext4_iloc *iloc, int in_mem,
> -				ext4_fsblk_t *ret_block)
> +				struct inode *inode, struct ext4_iloc *iloc,
> +				int in_mem, ext4_fsblk_t *ret_block)


In this patch you've added a new argument 'inode'.  However, if in_mem
is true, and inode is NULL, the kernel will crash with a null pointer
dereference.  Furthermore, whenever in_mem is false, the callers pass
in NULL for inode.

Given that, perhaps we should just drop the in_mem argument, and then
instead of

	if (in_mem) {

we do:

	if (inode && !ext4_test_inode_state(inode, EXT4_STATE_XATTR) {

with the comments adjusted accordingly?

I think it will make the code a bit simpler and readable.

What do you think?

					- Ted
