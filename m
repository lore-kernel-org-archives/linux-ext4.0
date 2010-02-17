From: =?ISO-8859-1?Q?Ga=EBtan_Podevijn?= <gpodevij@gmail.com>
Subject: Ext2 and ext4 preallocation / mballoc
Date: Wed, 17 Feb 2010 16:46:19 +0100
Message-ID: <dda2e1011002170746x6cad8cekee6dcb7079002e10@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:43727 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0BQPqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Feb 2010 10:46:43 -0500
Received: by fxm7 with SMTP id 7so8843094fxm.28
        for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2010 07:46:40 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Reading this http://web.mit.edu/tytso/www/linux/ext2intro.html I
understand that ext2 preallocates 8 blocks when a writing data to a
file. Ext3 uses the windows reservations method, but is that ext3 also
preallocates 8 blocks when writing data ?

Moreover, this page
http://kernelnewbies.org/Ext4#head-b2148d2a96d22a1bd7e376e6c08e4a38d08f=
b157
explains that ext3 allocates one block at a time and ext4 uses
multiblock allocation that is, allocates many block in a single system
call.

What is the difference between preallocation on ext2 (and ext3 ?) and m=
balloc ?


TYA,

Ga=EBtan

PS : I'm sorry for my really bad english
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
