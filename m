From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: RE: [PATCH] ext4: FIBMAP ioctl causes BUG_ON due to handle
 EXT_MAX_BLOCKS
Date: Tue, 1 Apr 2014 06:52:22 +0000
Message-ID: <C26C67884C4B7A48980D574635594864E18B2E@BPXM20GP.gisp.nec.co.jp>
References: <C26C67884C4B7A48980D574635594864E16DD8@BPXM20GP.gisp.nec.co.jp>
 <20140401051516.GO4911@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Cc: "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:61679 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaDAHku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Apr 2014 03:40:50 -0400
In-Reply-To: <20140401051516.GO4911@thunk.org>
Content-Language: ja-JP
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2014/04/01 14:15:16, Theodore Ts'o wrote:
> We should be returning an error when we pass in an lblk >=
> EXT4_MAX_BLOCKS in ext4_map_blocks(), long before we even get to
> ext4_ext_put_gap_in_cache().  And if we fix it there, we may catch
> other cases which might lead to the BUG_ON() firing.

Agree. I'll send the fixed patch latter.

> Did you check whether the same bug can be triggered via FIEMAP?

FIEMAP ioctl is safe because ext4_fiemap() has the following check.

        last_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
        if (last_blk >= EXT_MAX_BLOCKS)
                 last_blk = EXT_MAX_BLOCKS-1;

AFAIK, FIBMAP is only the way to pass the block number specified by a user to
ext4_map_blocks().

Regards,

Kazuya Mio
