From: Doug Hunley <doug.hunley@gmail.com>
Subject: status on 'tune2fs -I 256' ?
Date: Thu, 4 Jun 2009 19:51:34 -0400
Message-ID: <7284e2210906041651g10761a2fy7eda6d308b7ccb4d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:46632 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZFDXvd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2009 19:51:33 -0400
Received: by ewy6 with SMTP id 6so1660080ewy.37
        for <linux-ext4@vger.kernel.org>; Thu, 04 Jun 2009 16:51:34 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I recently converted my '/' filesytem to ext4 from ext3 using:
tune2fs  -O extents,uninit_bg,dir_index /dev/md3

I did *not* use '-I 256' as I'd read several reports of this causing
corruption. However, I've just checked the ext4.txt as shipped with
2.6.29 and it quite clearly states:
If the filesystem was created with 128 byte inodes, it can be
    converted to use 256 byte for greater efficiency via:

        # tune2fs -I 256 /dev/hda1

Is this now safe to do? Or should the documentation be updated to
reflect the current corruption issue? Would I be ok to run 'tune2fs -I
256 /dev/md3' (followed by a forced fsck)?

Thanks

-- 
Douglas J Hunley - doug.hunley@gmail.com
http://douglasjhunley.com
Twitter: @hunleyd
