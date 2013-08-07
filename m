From: Reece Dunn <msclrhd@googlemail.com>
Subject: unsigned/signed type mismatch in init_bg overrun variable
Date: Wed, 7 Aug 2013 11:12:05 +0100
Message-ID: <CAGdtn26yE+zuCVKLG8rbDTBooDDDhOXG2wWA6bJ_CE_hq=VqOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:62717 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab3HGKMH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Aug 2013 06:12:07 -0400
Received: by mail-we0-f180.google.com with SMTP id p61so1358443wes.39
        for <linux-ext4@vger.kernel.org>; Wed, 07 Aug 2013 03:12:05 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This was initially reported to the Android project at
http://code.google.com/p/android/issues/detail?id=58674 by someone
else.

284 u32 overrun = bg->first_block + info.blocks_per_group - aux_info.len_blocks;
285 if (overrun > 0)
286     reserve_blocks(bg, info.blocks_per_group - overrun, overrun);

Here, |reserve_blocks| is always called unless |bg->first_block +
info.blocks_per_group == aux_info.len_blocks| as overrun is unsigned
and the expression is signed.

The suggestion in the Android bug report was to change |overrun| to |s64|.

Thanks,
- Reece
