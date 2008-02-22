From: "Bas van Schaik" <bas@tuxes.nl>
Subject: Re: e2fsck dies with error "this should never happen!!!"
Date: Fri, 22 Feb 2008 18:44:25 +0100 (CET)
Message-ID: <20832.81.207.193.3.1203702265.squirrel@guust.tuxes.nl>
References: <47BEBAF1.4090505@tuxes.nl> <20080222123852.GI20118@mit.edu>
    <47BECAC0.5010707@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from castor.sshunet.nl ([145.97.192.41]:60396 "EHLO
	castor.sshunet.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760561AbYBVRob (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2008 12:44:31 -0500
In-Reply-To: <47BECAC0.5010707@tuxes.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Theodore Tso wrote:
>> On Fri, Feb 22, 2008 at 01:07:13PM +0100, Bas van Schaik wrote:
>>
>>> Hi all,
>>>
>>> Currently, I have a big problem: e2fsck refuses to fix my currupted
>>> filesystem...
>>>
>>
>> The things that I would suggest first of all is upgrading to the
>> latest version of e2fsprogs.  If that doesn't fix it, I'm going to
>> need either a compressed e2image file (see the e2image man page) or
>> login access to see what is up.
>
> Thanks for the suggestion, I was naively assuming that e2fsck wasn't
> under active development. I've installed the statically linked 1.40.6
> from Debian Lenny and it's running. However, it will take quite a long
> time before it will actually hit the point where the old version found
> problems.
> I'll let you know what the results are!
>

Unfortunately it didn't work out. Apart from the e2fsck version number,
the output did not change:

> e2fsck 1.40.6 (09-Feb-2008)
> /dev/loop0: recovering journal
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Directory inode 268451937 has an unallocated block #1.  Allocate<y>? yes
>
> Directory inode 268451941 has an unallocated block #1.  Allocate<y>? yes
>
> Directory inode 268451945 has an unallocated block #1.  Allocate<y>? yes
>
> Directory inode 268451949 has an unallocated block #1.  Allocate<y>? yes
>
> Directory inode 268451953 has an unallocated block #1.  Allocate<y>? yes
>
> Directory inode 268451957 has an unallocated block #1.  Allocate<y>? yes
>
> Directory inode 268451961 has an unallocated block #1.  Allocate<y>? yes
>
> Directory inode 268451965 has an unallocated block #1.  Allocate<y>? yes
>
> Directory inode 268451969 has an unallocated block #1.  Allocate<y>? yes
>
> Directory inode 268451973 has an unallocated block #1.  Allocate<y>? yes
>
> Directory inode 268451977 has an unallocated block #1.  Allocate<y>? yes
>
> Directory inode 268451981 has an unallocated block #4.  Allocate<y>? yes
>
> XXX should never happen!!!
> Aborted

In a few hours I will hit the road towards France for a holiday, from
which I will return on the 3rd of March. I would be _really_ grateful if
you could assist me solving this problem.

Regards,

  -- Bas
