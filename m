From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: remove misleading argument from	ext2fs_bg_flags_clear
Date: Thu, 03 Sep 2009 00:13:52 -0500
Message-ID: <4A9F5090.40406@redhat.com>
References: <4A9EE6E4.2000307@redhat.com> <20090902232811.GG4197@webber.adilger.int> <20090902234243.GC30497@mit.edu> <4A9F313E.8030605@redhat.com> <20090903051235.GL4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:16603 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbZICFNu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Sep 2009 01:13:50 -0400
In-Reply-To: <20090903051235.GL4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Sep 02, 2009  22:00 -0500, Eric Sandeen wrote:
>> What about perhaps just these 3:
>>
>> ext2fs_bg_flags_zero(fs, group) /* zeros bg_flags */
>>
>> ext2fs_bg_flags_set(fs, group, flags) /* adds flags to bg_flags */
>> ext2fs_bg_flags_clear(fs, group, flags) /* clears flags in bg_flags */
>>
>> and remove the original ext2fs_bg_flags_set / ext2fs_bg_flags_clear.
> 
> Yes, this is exactly what I would expect from this kind of interface.

Ok, I'll try to get that sent out tomorrow, and any other similar 
interfaces.

Thanks,
-Eric
