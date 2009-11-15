From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Sun, 15 Nov 2009 15:30:55 -0600
Message-ID: <4B00730F.5060503@redhat.com>
References: <4AFC14D6.7080700@diamondcut.com.br>	<20091112153017.GA32122@mit.edu> <878wea84lq.fsf@mid.deneb.enyo.de>	<4B006F8A.8000606@diamondcut.com.br> <878we7v651.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Renato S. Yamane" <yamane@diamondcut.com.br>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Florian Weimer <fw@deneb.enyo.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbZKOVa7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Nov 2009 16:30:59 -0500
In-Reply-To: <878we7v651.fsf@mid.deneb.enyo.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Florian Weimer wrote:
> * Renato S. Yamane:
> 
>> How can I know the average writes per day?
> 
> I used iostat (part of sysstat).  Perhaps I should have checked first
> if it is accurate. 8-/

If you're running ext4, you can look at:

/sys/fs/ext4/sdXX/lifetime_write_kbytes and
/sys/fs/ext4/sdXX/session_write_kbytes

too.

-Eric
