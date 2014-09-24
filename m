From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v1 5/10] ext4: Add DX_HASH_SIPHASH24 support
Date: 24 Sep 2014 19:31:13 -0400
Message-ID: <20140924233113.22784.qmail@ns.horizon.com>
References: <20140924153531.GK17784@thunk.org>
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:61362 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751012AbaIXXbQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Sep 2014 19:31:16 -0400
In-Reply-To: <20140924153531.GK17784@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>> Still, it would probably simpler to not try to assign
>>> DX_HASH_SIPHASH24 to be 6, and to leave better comments about how the
>>> hash values are used.
>> 
>> Is that "not try" supposed to be in there?
>
> Sorry, typo.  Yes, it would be better to assign DX_HASH_SIPHASH24 to
> be 6, and not to assign the code points 3, 4, and 5 just to be safe.

I thought so, I just wanted a retransmit rather than rely on FEC in this
case. :-)

Another option I thought of I'd like to get formally rejected would be
to consider all future hashes unsigned, so there's a +3 offset between
the on-disk value and the ext2fs_dirhash parameter.

That keeps the disk numbering clean and preserves the library ABI, but
(pick any two!) makes the source messier.  (Not as much as you might
think, because it just requires extening the current kludge, but still...)

> (I assume you're using tmpfs.)  There would be less overhead if you
> actually used a real ramdisk, i.e., /dev/ram0, which might reduce some
> of the variance and increase the percentage of the difference, but
> yeah, it's not that surprising that we're not seeing much difference.

Oops, forgot to say that.  Yes, tmpfs.  I didn't realize /dev/ram* had
less overhead; I'll try that.  Thanks!
