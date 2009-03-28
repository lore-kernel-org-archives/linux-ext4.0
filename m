From: Theodore Tso <tytso@mit.edu>
Subject: Re: Once more: Recovering a damaged ext4 fs?
Date: Sat, 28 Mar 2009 09:09:23 -0400
Message-ID: <20090328130922.GE2155@mit.edu>
References: <p0624058dc5f2d7be08cc@[130.161.115.44]> <20090327224616.GD5176@mit.edu> <p0624058ec5f30b501efb@[130.161.115.44]> <20090328123035.GD2155@mit.edu> <p06240592c5f3caee289b@[130.161.115.44]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "J.D. Bakker" <jdb@lartmaker.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60562 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbZC1NJ1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Mar 2009 09:09:27 -0400
Content-Disposition: inline
In-Reply-To: <p06240592c5f3caee289b@[130.161.115.44]>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 28, 2009 at 01:53:35PM +0100, J.D. Bakker wrote:
> At 08:30 -0400 28-03-2009, Theodore Tso wrote:
>> Can you verify exactly what kernel version you are using? This issue
>> is being discussed at:
>>
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/330824
>>...
>
> Had the problem with 2.6.28, 2.6.28.4 and 2.6.29-rc6. After yesterday's 
> crash I've upgraded to 2.6.29. For completeness' sake, my ext4 RAID had 
> been created from scratch, not upgraded from ext3.

Thanks, I've updated your information on the Launchpad bug site.  If
we can get indpendent confirmation, it appears the bug was fixed
sometime between 2.6.28-rc6 and 2.6.28-rc8.

> Should I still apply the oneliner you posted yesterday on 2.6.29?

Yeah, it's definitely a god fix to have in hand.

> In the meantime I've tried mkfs -S, this complained about "File exists 
> while trying to create journal". fsck -y is running (has been for a few 
> hours) and appears to cycle through

Oops, I need to fix mke2fs to handle this case better.  (I assume you
were doing "mke2fs -S -t ext4 /dev/XXX", or something like that,
right?)

You should be able to work around the "File exists..." error via this
command:

	debugfs -w /dev/XXXX -R "clri <8>"

... and then retrying the mke2fs -S command.

Regards,

					- Ted
