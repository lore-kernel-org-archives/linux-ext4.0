From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Don't check io->flag when setting
 EXT4_STATE_DIO_UNWRITTEN inode state.
Date: Thu, 27 Oct 2011 04:00:01 -0400
Message-ID: <20111027080001.GY31921@thunk.org>
References: <1315984587-5039-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49418 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab1J0IAK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Oct 2011 04:00:10 -0400
Content-Disposition: inline
In-Reply-To: <1315984587-5039-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 14, 2011 at 03:16:27PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> When we want to convert the unitialized extent in direct write,
> we can either do it in ext4_end_io_nolock(AIO case) or in
>  ext4_ext_direct_IO(non AIO case) and EXT4_I(inode)->cur_aio_dio
> is a guard for ext4_ext_map_blocks to find the right case.

Applied, thanks.

						- Ted
