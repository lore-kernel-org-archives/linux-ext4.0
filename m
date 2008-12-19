From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: tune2fs -o noatime /dev/sd_
Date: Fri, 19 Dec 2008 11:01:14 +0100
Message-ID: <20081219110114.aedf7b29.taeuber@bbaw.de>
References: <20081217121533.30951131.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:33234 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbYLSKBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Dec 2008 05:01:08 -0500
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id 76CEF4A8072
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2008 11:01:03 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 8801F937BE
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2008 11:01:04 +0100 (CET)
Received: from taeuber.bbaw.de (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id 6F144937B4
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2008 11:01:04 +0100 (CET)
In-Reply-To: <20081217121533.30951131.taeuber@bbaw.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry for the noise.
Might have been a silly idea.

Happy Christmas to you.
Lars

Lars T=C3=A4uber <taeuber@bbaw.de> schrieb:
> Hallo developers!
>=20
> I just would like to ask for a feature request for the ext[234] files=
ystems.
> There are some usb-sticks used by me that are formated with ext2. All=
 recent desktop enviroments let me mount them quiet easy but without th=
e chance to tell them to mount it with the =C2=BBnoatime=C2=AB option. =
But I liked them to be mounted with this option because of their flash =
characteristics.
> It seems there is some space left for an EXT4_MOUNT_NOATIME option in=
 ext4.h for all the ext[234] file systems.
> What do you think about this?
>=20
> Thanks
> Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
