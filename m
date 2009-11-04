From: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: one way to dmesg
Date: Wed, 04 Nov 2009 16:19:15 +0100
Message-ID: <1257347955.2852.13.camel@zwerg>
References: <1257344804.2852.11.camel@zwerg>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47502 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755850AbZKDPTP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2009 10:19:15 -0500
In-Reply-To: <1257344804.2852.11.camel@zwerg>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Mittwoch, den 04.11.2009, 15:26 +0100 schrieb Alexey Fisher:
> Hallo,
> this is sort of continue of discussion about unified way to mount fs
> readonly.
> I wont to know how about dmesg/printk. I see ext[234] produce different
> logs on mount even it use same code. I feel like i have some time to
> digg in. My target is easy to parse dmesg.
> Firs question: is it really important to print function in ext3_warning?
> Or is it just ok to do it ext4_msg way?
Ok forgot this question, i found ext4_warning. So i will just add
ext2_msg and ext3_msg

Regards,
Alexey

