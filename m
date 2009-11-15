From: "Renato S. Yamane" <yamane@diamondcut.com.br>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Sun, 15 Nov 2009 19:46:21 -0200
Message-ID: <4B0076AD.9020008@diamondcut.com.br>
References: <4AFC14D6.7080700@diamondcut.com.br>	<20091112153017.GA32122@mit.edu> <878wea84lq.fsf@mid.deneb.enyo.de>	<4B006F8A.8000606@diamondcut.com.br> <878we7v651.fsf@mid.deneb.enyo.de> <4B00730F.5060503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Florian Weimer <fw@deneb.enyo.de>, Theodore Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-02.mandic.com.br ([200.225.81.133]:35943 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZKOVqK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Nov 2009 16:46:10 -0500
Received: from 189.114.151.225.dynamic.adsl.gvt.net.br (HELO [192.168.1.104]) (4s3fxNW2pdTI28e3yZjKop5Ok6I=@[189.114.151.225])
          (envelope-sender <yamane@diamondcut.com.br>)
          by smtp-02.mandic.com.br (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
          for <linux-ext4@vger.kernel.org>; 15 Nov 2009 21:46:12 -0000
In-Reply-To: <4B00730F.5060503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 15-11-2009 19:30, Eric Sandeen wrote:
> Florian Weimer wrote:
>> * Renato S. Yamane:
>>> How can I know the average writes per day?
>>
>> I used iostat (part of sysstat). Perhaps I should have checked first
>> if it is accurate. 8-/
>
> If you're running ext4, you can look at:
> /sys/fs/ext4/sdXX/lifetime_write_kbytes and
> /sys/fs/ext4/sdXX/session_write_kbytes

smartctl show me 229h Power_On_Hours (I buy it one month ago).
And /sys/fs/ext4/sdXX/lifetime_write_kbytes show me 19940467

So:
229h = 9,54 days
19940467 kbytes / 9,54 days = 2Gb/day

I think that it is too much. I use it on my laptop only to see my 
e-mails (Thunderbird) and use OpenOffice.org on my work environment.

Regards and thanks for all!
Renato S. Yamane
