From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: A question about the naming of e2fsprogs/tests
Date: Wed, 17 Oct 2012 21:13:51 +0800
Message-ID: <20121017131351.GA22794@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab2JQNCr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Oct 2012 09:02:47 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so7154566pbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 17 Oct 2012 06:02:46 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

Now I am trying to create some regression tests for e2fsprogs to test
inline data feature.  I have a question about the naming of
e2fsprogs/tests.  I notice that in tests dir there are a lot of
directories, which have different prefixes, such as d_loaddump,
e_brel_bma, f_baddir, m_dasd_bs, r_move_itable, t_mmp_1on, and u_mke2fs.
As far as I can understand, d_ is for debugfs, f_ means test for filesystem,
m_ is for mke2fs, r_ is for resize2fs, t_ is for tune2fs, and u_ is for e2undo.
Could anyone tell me what e_ stands for?  If I misunderstand something, please
point it out.  Thanks.

Regards,
Zheng
