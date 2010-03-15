From: Evgeniy Ivanov <lolkaantimat@gmail.com>
Subject: Using parts of ext2_fs.h in BSD licensed code
Date: Mon, 15 Mar 2010 19:42:06 +0300
Message-ID: <e1e08eb01003150942s6350c04fn6b3d696fed8b7fc1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56065 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612Ab0COQmJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Mar 2010 12:42:09 -0400
Received: by fxm19 with SMTP id 19so3383287fxm.21
        for <linux-ext4@vger.kernel.org>; Mon, 15 Mar 2010 09:42:08 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I'm working on ext2 implementation for Minix3, where BSD license is
desirable (AFAIK folks from *BSD are interested too). Most things are
already implemented, while working I looked through linux and hurd
implementations, but didn't use anything from there (I just learned
some internals of ext2) and read http://nongnu.org/ext2-doc/ (thus my
implementation mostly based on ext2-doc).
Flags, constants, data structures are available in ext2-doc and
ext2_fs.h. As I understand GPL license I can't just take it from
ext2_fs.h and use in BSD licensed code, since it violates GPL (it was
confirmed on #gnu). Is it correct? From another hand code based on
ext2-doc can't be called derivative work. Is there any other header
similar to ext2_fs.h (or any documentation except
nongnu.org/ext2-doc/)?

Do you think I can ask copyright owners for permission to use
constants(data structures) from ext2_fs.h? Can somebody please send me
Remy Card's email (in sources it's incorrect)?

-- 
Evgeniy Ivanov
