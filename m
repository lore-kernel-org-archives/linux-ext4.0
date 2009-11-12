From: "Renato S. Yamane" <yamane@diamondcut.com.br>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Thu, 12 Nov 2009 18:06:54 -0200
Message-ID: <4AFC6ADE.30802@diamondcut.com.br>
References: <4AFC14D6.7080700@diamondcut.com.br> <20091112153017.GA32122@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, sandeen@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-01.mandic.com.br ([200.225.81.132]:41742 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbZKLUGu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Nov 2009 15:06:50 -0500
Received: from unknown (HELO [192.168.1.104]) (48XWxNa3qdTI2cq3yJaVop5Ok6I=@[200.228.134.10])
          (envelope-sender <yamane@diamondcut.com.br>)
          by smtp-01.mandic.com.br (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
          for <linux-ext4@vger.kernel.org>; 12 Nov 2009 20:06:52 -0000
In-Reply-To: <20091112153017.GA32122@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12-11-2009 13:30, Theodore Tso wrote:
> On Thu, Nov 12, 2009 at 11:59:50AM -0200, Renato S. Yamane wrote:
>> [please, leave me on cc because I'm not subscribed on this ML]
>>
>> I'm using Intel SSD X25-M on my laptop, and I always hear that is not a
>> good idea use journal on SSD (it decrease the life time).
>>
>> I ask Intel about this, but I don't receive any answer.
>>
>> So, I would like to know if is possible disable Journal on EXT4.
>
> It is possible to create an ext4 file system without a journal.  It
> would mean that unclean shutdowns would require a full fsck, which on
> a freshly created file system on an SSD isn't _that_ bad.  Depending
> on how full/fragmented your filesystem happens to be, it will probably
> be under 10 seconds.
>
> That being said, though, it shouldn't be necessary to avoid using a
> journal on the Intel SSD.  Intel says that laptop will last at least 5
> years with 10GB worth of writes per day...

Woww! Thank you so much Theodore and Eric!
I will keep using journal on my SSD X25-M.

Regards,
Renato S. Yamane
