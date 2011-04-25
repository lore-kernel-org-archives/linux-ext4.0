From: Zhao Cai <zhaocai@me.com>
Subject: ext4_put_super is not called during system shutdown or restart
Date: Mon, 25 Apr 2011 00:12:02 -0400
Message-ID: <BEC5ADCE-0B2E-4CE2-8654-9D2F7B787684@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from asmtpout025.mac.com ([17.148.16.100]:52573 "EHLO
	asmtpout025.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1DYFNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 01:13:16 -0400
Received: from cai-zhao-2.umelst.maine.edu ([130.111.219.42])
 by asmtp025.mac.com
 (Oracle Communications Messaging Exchange Server 7u4-20.01 64bit (built Nov 21
 2010)) with ESMTPSA id <0LK600JAMWZSU660@asmtp025.mac.com> for
 linux-ext4@vger.kernel.org; Sun, 24 Apr 2011 21:11:54 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I would appreciate if anyone can give me an answer. Is it designed to b=
e like this?

Detailed situation: The system is ubuntu 11.04 installed in VMware. I n=
otice that ext4_put_super() is called when I unmount a non-root ext4 pa=
rtition. But it is not when I restart or shutdown the system.=20

Thanks=E3=80=82

--
All the best,

Zhao Cai


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
