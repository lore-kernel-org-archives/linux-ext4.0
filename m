From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: tune2fs -o noatime /dev/sd_
Date: Wed, 17 Dec 2008 12:15:33 +0100
Message-ID: <20081217121533.30951131.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:56751 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbYLQLd6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2008 06:33:58 -0500
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id 9082F4A8074
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2008 12:15:30 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 75A309377C
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2008 12:15:29 +0100 (CET)
Received: from taeuber.bbaw.de (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id 3AD2893753
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2008 12:15:29 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hallo developers!

I just would like to ask for a feature request for the ext[234] filesys=
tems.
There are some usb-sticks used by me that are formated with ext2. All r=
ecent desktop enviroments let me mount them quiet easy but without the =
chance to tell them to mount it with the =C2=BBnoatime=C2=AB option. Bu=
t I liked them to be mounted with this option because of their flash ch=
aracteristics.
It seems there is some space left for an EXT4_MOUNT_NOATIME option in e=
xt4.h for all the ext[234] file systems.
What do you think about this?

Thanks
Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
