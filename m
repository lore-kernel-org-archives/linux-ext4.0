From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
Date: Wed, 16 Nov 2011 10:51:59 -0500
Message-ID: <47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:53346 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517Ab1KPPwI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 10:52:08 -0500
In-Reply-To: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Nov 16, 2011, at 10:04 AM, Namjae Jeon wrote:

> If slab caches set to SLAB_MEM_SPREAD flags, The allocation is spread=
 evenly over all the memory nodes instead of favoring allocation on the=
 node local to current cpu.

And why do you think this is a good thing?   For mballoc in particular,=
 the data structures are used immediately and then freed immediately --=
- on the local node, so using a non-local memory just makes things wors=
e in a NUMA system.

=46or the pageio, they are used immediately, and may end up getting fre=
ed on the same CPU if the I/O interrupt (and hence competion callbacks)=
 happen on the same CPU that they are submitted on=85.

Regards,

-- Ted


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
