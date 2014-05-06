From: Younger Liu <younger.liucn@gmail.com>
Subject: Why does not freeblocks number change after deleting a big file?
Date: Tue, 06 May 2014 11:32:12 +0800
Message-ID: <536857BC.3010002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33495 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933740AbaEFDcT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2014 23:32:19 -0400
Received: by mail-ig0-f172.google.com with SMTP id uy17so5674840igb.5
        for <linux-ext4@vger.kernel.org>; Mon, 05 May 2014 20:32:19 -0700 (PDT)
Received: from [192.168.1.109] ([219.146.73.4])
        by mx.google.com with ESMTPSA id d10sm34046784igc.8.2014.05.05.20.32.17
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 05 May 2014 20:32:18 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi:
  Analyze ext4 filesystem with "debugfs -R "stats" <device>",
Why does not free blocks number change after deleting a big file?

The big file:
# stat test
  file=EF=BC=9A"test"
  size=EF=BC=9A290554084       blocks=EF=BC=9A567496     IO block=EF=BC=
=9A4096

before deleting the file "test":
# debugfs -R "stats" /dev/sdb
=2E..
Inode count:              243593216
Block count:              1948728320
Reserved block count:     97436416
=46ree blocks:              406830314
=46ree inodes:              151667854
=2E..

deleting the file "test"
# debugfs -R "stats" /dev/sdb
=2E..
Inode count:              243593216
Block count:              1948728320
Reserved block count:     97436416
=46ree blocks:              406830314
=46ree inodes:              151667854
=2E..

     Younger
     thx.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
