From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Sun, 15 Nov 2009 17:01:44 -0500
Message-ID: <20091115220144.GG4323@mit.edu>
References: <4AFC14D6.7080700@diamondcut.com.br> <20091112153017.GA32122@mit.edu> <878wea84lq.fsf@mid.deneb.enyo.de> <4B006F8A.8000606@diamondcut.com.br> <878we7v651.fsf@mid.deneb.enyo.de> <4B00730F.5060503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Weimer <fw@deneb.enyo.de>,
	"Renato S. Yamane" <yamane@diamondcut.com.br>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53779 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbZKOWBr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Nov 2009 17:01:47 -0500
Content-Disposition: inline
In-Reply-To: <4B00730F.5060503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 15, 2009 at 03:30:55PM -0600, Eric Sandeen wrote:
> Florian Weimer wrote:
>> * Renato S. Yamane:
>>
>>> How can I know the average writes per day?
>>
>> I used iostat (part of sysstat).  Perhaps I should have checked first
>> if it is accurate. 8-/
>
> If you're running ext4, you can look at:
>
> /sys/fs/ext4/sdXX/lifetime_write_kbytes and
> /sys/fs/ext4/sdXX/session_write_kbytes

For an umounted filesystem, you can also do this:

dumpe2fs -h /dev/XXX | grep "Lifetime writes"
dumpe2fs -h /dev/XXX | grep "Filesystem created"

Then use a handy-dandy date calculator to figure the number of days
between the file system creation date and today, and then divide...

	    	 		      - Ted
