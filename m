From: "Renato S. Yamane" <yamane@diamondcut.com.br>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Mon, 16 Nov 2009 17:00:39 -0200
Message-ID: <4B01A157.8080900@diamondcut.com.br>
References: <4AFC14D6.7080700@diamondcut.com.br> <20091112153017.GA32122@mit.edu> <878wea84lq.fsf@mid.deneb.enyo.de> <4B006F8A.8000606@diamondcut.com.br> <878we7v651.fsf@mid.deneb.enyo.de> <4B00730F.5060503@redhat.com> <4B0076AD.9020008@diamondcut.com.br> <20091115221146.GH4323@mit.edu> <20091116184003.GA12268@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Florian Weimer <fw@deneb.enyo.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-01.mandic.com.br ([200.225.81.132]:42580 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZKPTAg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Nov 2009 14:00:36 -0500
Received: from unknown (HELO [192.168.1.104]) (48XWxNa3qdTI2cq3yJaVop5Ok6I=@[200.228.134.10])
          (envelope-sender <yamane@diamondcut.com.br>)
          by smtp-01.mandic.com.br (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
          for <linux-ext4@vger.kernel.org>; 16 Nov 2009 19:00:36 -0000
In-Reply-To: <20091116184003.GA12268@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 16-11-2009 16:40, Theodore Tso wrote:
> Theodore Tso wrote:
>> If you've only had the disk for a short while, then the initial writes
>> to install your system is probably biasing your results.  So far you
>> have approximately 19GB of disk writes.  I'm guessing that at least
>> 3-4GB is from the initial installation of software on your system.
>
> I just did a default Ubuntu Karmic x86_64 install, and it writes a
> approximately ten and a half GB to the root partition.  It also (for
> no explicable reason) apparently zero's out the swap partition, which
> (a) takes a long time, and (b) results in useless, pointless writes to
> the SSD.  Someone should complain to Ubuntu about that...  the
> workaround is to not configure swap during the Ubuntu install process,
> and to manually configure it yourself later.
>
> (Or to not use swap at all, if you have enough memory in your system.)
>
> In any case, given that means that only 8.5GB worth of data was
> written to your system, so over 30 days, your usage levels is
> averaging to 0.283 GB per calendar day.

I'm working with my laptop by 9h right now (this is my tipical business 
day) and /sys/fs/ext4/sda1/session_write_kbytes show me "324732"

So, I think that you is really right.

Renato S. Yamane
