From: =?GB2312?B?tqG2qLuq?= <dingdinghua85@gmail.com>
Subject: question about e2progs
Date: Mon, 26 Oct 2009 11:08:05 +0800
Message-ID: <7bb361260910252008m28baac3fj7566d792d33c84e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:55103 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbZJZDID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Oct 2009 23:08:03 -0400
Received: by fxm18 with SMTP id 18so11745567fxm.37
        for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2009 20:08:05 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hello, when i read e2progs code, i'm confused about the E2F_FLAG_RESTAR=
T flag,
we will restart the whole fsck routine if this flag set. The flag is
set in handle_fs_bad_blocks
& check_dir_block, is there anyone tell my why need to retart the
whole routine if the above
two situation happend, thanks.

--=20
=B6=A1=B6=A8=BB=AA
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
