From: Masato Minda <minmin@jprs.co.jp>
Subject: How many files to create in one directory?
Date: Mon, 27 Jan 2014 16:16:01 +0900
Message-ID: <52E607B1.2060206@jprs.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from off-send01.tyo.jprs.co.jp ([202.11.16.150]:49615 "EHLO
	off-send01.tyo.jprs.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaA0Hme (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jan 2014 02:42:34 -0500
Received: from off-sendsmg01.tyo.jprs.co.jp (off-sendsmg01.tyo.jprs.co.jp [172.18.8.32])
	by off-send01.tyo.jprs.co.jp (8.13.8/8.13.8) with ESMTP id s0R7G1bq027217
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jan 2014 16:16:02 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear Ext4 Developer;

I've copied the files from VxFS to EXT4, I saw the message =93Directory
index full!=94. I've checked the search engine and found these mails.

  http://www.spinics.net/lists/linux-ext4/msg25058.html
  http://www.spinics.net/lists/linux-ext4/msg25069.html

Our Ext4's block size was 1024. I've changed the block size from 1024 t=
o
4096. Our problem was solved. But I have question.

How many files to create in one directory in 4096 block size?
I think that it is about 3 million files with perfect hashing.

  16*(4096-16)/8*(4096-8)/8*3/4=3D 3M

Is this correct?

Thanks in advance.

--
Masato minmin Minda <minmin@jprs.co.jp>
Japan Registry Services Co., Ltd. (JPRS)

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
