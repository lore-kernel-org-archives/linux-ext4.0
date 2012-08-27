From: raphel johnson <iraphel78@gmail.com>
Subject: why online shrink is not supported with EXT4_IOC_RESIZE_FS?
Date: Mon, 27 Aug 2012 19:00:33 +0530
Message-ID: <CAMTyv-FXzP-r3Eq3kuUQQsE221aNR1nGsfyEZ=w8eHo1eBL1SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45291 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2H0Nae (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Aug 2012 09:30:34 -0400
Received: by obbuo13 with SMTP id uo13so8024876obb.19
        for <linux-ext4@vger.kernel.org>; Mon, 27 Aug 2012 06:30:33 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I was referring EXT4_IOC_RESIZE_FS ioctl implementation in linux
kernel ver 3.3.8.

It is given in the code that online shrinking not supported.

if (n_blocks_count < o_blocks_count) {
/* On-line shrinking not supported */
ext4_warning(sb, "can't shrink FS - resize aborted");
return -EINVAL;
}

I am new to ext4 file system. Could you please tell online shrinking
issues in ext4.

Thanks in adavance.

Regards,
Raphel
