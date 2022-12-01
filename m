Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E597C43217
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Dec 2022 15:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbiLAP5j (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 1 Dec 2022 10:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbiLAP5h (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Dec 2022 10:57:37 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2712BF1;
        Thu,  1 Dec 2022 07:57:36 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2B1FumP0026524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 1 Dec 2022 10:56:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1669910211; bh=BJBqXWvl0cK6+0wdFT/7pqANGHNRFayz5Ambcbo7i2g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=hWUBP14Te5DMZdoxhwR7ad2mAnGVw7g68rpN9zOaP7sBIQB8ZBpHSdR+vQIKK98Bn
         ZRHp6nklxtGJ1UduEEutvtrSGotyhL/J8W/UgNchHOg8dz/KF4oaB5wr3ZnHU+wZ+C
         LQ+59Ix/aXR/RXFT+iB1qWOjx08EstjH6GOvXxDvGl2ZzwlIL5+y4W7CBKvRQUIY3E
         gGdetiHZCUpibXss57IxYTsYPKk/KsV93ax6HU5ZERIQc++EYjMhk1NugGnLMpy61n
         whv6eY+i6XJOEXY4X1D7axE2tS1tMe4cmWS+koJBODJpKapaSUy3jZIsB+IZymB86C
         ufBXmcBL7gbIg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id F055415C46FB; Thu,  1 Dec 2022 10:56:47 -0500 (EST)
Date:   Thu, 1 Dec 2022 10:56:47 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     "yebin (H)" <yebin10@huawei.com>, Ye Bin <yebin@huaweicloud.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+4d99a966fd74bdeeec36@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: fix WARNING in ext4_expand_extra_isize_ea
Message-ID: <Y4jOv26+x8o1MKgC@mit.edu>
References: <20221201084844.2855621-1-yebin@huaweicloud.com>
 <20221201121928.xk5tte4dj3vmxivs@quack3>
 <6388AB33.6050302@huawei.com>
 <20221201142143.yuxnld55qot4jv7b@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201142143.yuxnld55qot4jv7b@quack3>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Dec 01, 2022 at 03:21:43PM +0100, Jan Kara wrote:
> 
> You're right that VFS actually limits xattr size to 64k. So the chances
> that someone actually has filesystem with larger xattrs are slim. But I
> know that Lustre guys run with their modified kernels and they were the
> ones implementing ea_inode feature so maybe they'd bumped the VFS limit as
> well in their kernels. Dunno. Anyway using kvmalloc() (like the xattr core
> does) looks like a better fix.

I looked at this syzkaller report last night, and note that this was
trying to move an extended attribute from the inode to an external
inode block.  Since it was in the inode, the largest the extended
attribute should is going to be the inode size minus 140, plus or
minus.

So the real problem is that the xattr value size was completely
invalid, and we weren't checking the extended attribute before trying
to call ext4_xattr_move_to_block() or ext4_xattr_make_inode_space().

Cheers,

					- Ted
