From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: Create helper function for
 EXT4_IO_END_UNWRITTEN and i_aiodio_unwritten.
Date: Mon, 31 Oct 2011 17:32:35 -0400
Message-ID: <20111031213235.GL16825@thunk.org>
References: <1317375716-6125-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33552 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab1JaVci (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Oct 2011 17:32:38 -0400
Content-Disposition: inline
In-Reply-To: <1317375716-6125-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 30, 2011 at 05:41:56PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> EXT4_IO_END_UNWRITTEN flag set and the increase of i_aiodio_unwritten
> should be done simultaneously since ext4_end_io_nolock always clear the
> flag and decrease the counter in the same time.
> 
> We have found some bugs that the flag is set while leaving
> i_aiodio_unwritten unchanged(commit 32c80b32c053d). So this patch just tries
> to create a helper function to wrap them to avoid any future bug.
> The idea is inspired by Eric.
> 
> Cc: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, applied.

						- Ted
