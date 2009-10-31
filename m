From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: journaled quota file question
Date: Sat, 31 Oct 2009 21:59:44 +0300
Message-ID: <871vkj4cf3.fsf@openvz.org>
References: <871vkpwv4a.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:62927 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932755AbZJaR7f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 31 Oct 2009 13:59:35 -0400
Received: from dmon-lp ([unknown] [10.55.92.161])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KSE00KZ74U92E20@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Sat, 31 Oct 2009 21:03:50 +0300 (MSK)
In-reply-to: <871vkpwv4a.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> While looking to ext3/4 quota code I'm wondering
> Why do we have to place journaled quota file on fs root?
> In some situations it may be useful to place it deeper for example:
> /root/dir/quota_file
> The only reason what comes in to my mind is that some one
> may rename parent folder rename("/root/dir", "/root/dir2")
> Is this the only reason?
add an author in cc:
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
