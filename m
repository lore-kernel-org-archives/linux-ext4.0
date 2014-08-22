From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Potential bug in fs/ext4/inline.c?
Date: Fri, 22 Aug 2014 15:29:12 +0800
Message-ID: <20140822072912.GA4042@gmail.com>
References: <20140821220126.GA3597@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:45526 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaHVHT4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Aug 2014 03:19:56 -0400
Received: by mail-pd0-f173.google.com with SMTP id w10so15568059pde.4
        for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2014 00:19:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140821220126.GA3597@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 21, 2014 at 06:01:26PM -0400, Theodore Ts'o wrote:
> In ext4_find_inline_entry(), there is the following:
> 
> 	if (ext4_get_inline_size(dir) == EXT4_MIN_INLINE_DATA_SIZE)
> 		goto out;
> 
> Am I missing something, or shouldn't this be:
> 
> 	if (ext4_get_inline_size(dir) <= EXT4_MIN_INLINE_DATA_SIZE)
> 		goto out;

Hi Ted,

The original design idea is that the size of inline data shouldn't be
less than EXT4_MIN_INLINE_DATA_SIZE (60 bytes).  That means that the
inline data will occupy the whole i_block[] space.

If we create a new dir with inline data feature, the disk layout will
looks like below (ext4_try_create_inline_dir()):

i_block[0]: parent ino (4 bytes)
i_block+4:  dir entry (ino 0, rec_len 56 bytes)

Regards,
                                                - Zheng
