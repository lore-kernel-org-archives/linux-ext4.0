From: luvar@plaintext.sk
Subject: corrupted fs, one nonreadable file after fsck
Date: Mon, 28 Mar 2016 16:05:17 +0100 (GMT+01:00)
Message-ID: <1878773164.36091459177517419.JavaMail.root@shiva>
References: <1562711781.36071459177448171.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.plaintext.sk ([85.248.156.6]:56429 "EHLO
	shiva.plaintext.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbcC1PK4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2016 11:10:56 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by shiva.plaintext.sk (Postfix) with ESMTP id 1D1869A01C
	for <linux-ext4@vger.kernel.org>; Mon, 28 Mar 2016 17:05:18 +0200 (CEST)
Received: from shiva.plaintext.sk ([127.0.0.1])
	by localhost (shiva.plaintext.sk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6N8GfdeMGYtK for <linux-ext4@vger.kernel.org>;
	Mon, 28 Mar 2016 17:05:17 +0200 (CEST)
Received: from shiva.plaintext.sk (shiva.plaintext.sk [85.248.156.6])
	by shiva.plaintext.sk (Postfix) with ESMTP id 811249A019
	for <linux-ext4@vger.kernel.org>; Mon, 28 Mar 2016 17:05:17 +0200 (CEST)
In-Reply-To: <1562711781.36071459177448171.JavaMail.root@shiva>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi here, I have trouble with one lost file. fsck does not print any problem, but cat on file will print "No such device or address". diff prints something like "is a block special file while file".

Background:
I have raid10 (layout -n3) on mdraid. On top of that some lvm and in one volume I have ext4 fs. I have had some problems with out of sync mdraid, which I have fixed, so I do not know why fsck found a while ago some problems. They are all now "fixed" and fsck -fFn founds nothing.

fsck.ext4 -V
e2fsck 1.42.9 (4-Feb-2014)
        Using EXT2FS Library version 1.42.9, 4-Feb-2014

Thanks for info,
LuVar
