From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/5] ext4: disable merging of uninitialized extents
Date: Mon, 4 Mar 2013 22:26:02 +0800
Message-ID: <20130304142602.GA13843@gmail.com>
References: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
 <1361808463-25471-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55289 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3CDOK4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Mar 2013 09:10:56 -0500
Received: by mail-pa0-f41.google.com with SMTP id fb11so3205939pad.0
        for <linux-ext4@vger.kernel.org>; Mon, 04 Mar 2013 06:10:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1361808463-25471-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 25, 2013 at 08:07:40PM +0400, Dmitry Monakhov wrote:
> Derived from Jan's patch:http://permalink.gmane.org/gmane.comp.file-systems.ext4/36470
> 
> Merging of uninitialized extents creates all sorts of interesting race
> possibilities when writeback / DIO races with fallocate. Thus
> ext4_convert_unwritten_extents_endio() has to deal with a case where
> extent to be converted needs to be split out first. That isn't nice
> for two reasons:
> 
> 1) It may need allocation of extent tree block so ENOSPC is possible.
> 2) It complicates end_io handling code
> 
> So we disable merging of uninitialized extents which allows us to simplify
> the code. Extents will get merged after they are converted to initialized
> ones.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

After applied this patch, xfstests #275 will print a warning message.

kernel:EXT4-fs (sda2): failed to convert unwritten extents to written
extents -- potential data loss!  (inode 13, offset 1537212416, size 524288,
error -28)

But IMHO we don't need to worry about it because it is hard to be
trigger.  I hit it because I run xfstests #275 several times.  So just a
note here.

Regards,
                                                - Zheng
