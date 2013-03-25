From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Do not normalize request from fallocate
Date: Mon, 25 Mar 2013 14:26:54 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303251420480.23176@localhost>
References: <1363881045-21673-1-git-send-email-lczerner@redhat.com> <20130324001143.GB4000@thunk.org> <alpine.LFD.2.00.1303251051460.23176@localhost> <20130325125309.GE26792@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1740734292-1364218018=:23176"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, gharm@google.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757859Ab3CYN1B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Mar 2013 09:27:01 -0400
In-Reply-To: <20130325125309.GE26792@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1740734292-1364218018=:23176
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 25 Mar 2013, Theodore Ts'o wrote:

> Date: Mon, 25 Mar 2013 08:53:09 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, gharm@google.com
> Subject: Re: [PATCH] ext4: Do not normalize request from fallocate
> 
> On Mon, Mar 25, 2013 at 11:09:35AM +0100, Lukáš Czerner wrote:
> > 
> > Sorry for being dense, but I am trying to understand why this is so
> > bad and what is the "expected" column there.
> > 
> > The physical offset of each extent bellow starts on the start of the
> > block group and it seems to me that it's perfectly aligned for every
> > power of two up to the block group size.
> 
> Yes, but the logical offset isn't aligned.  Consider the simplest
> workload, which is where we are writing the 1GB file sequentially.
> Let's assume that the raid stripe size is 8M.  So ideally, we would
> want each write to be a multiple of 8M, starting at logical block 0.
> 
> But look what happens here:
> 
> > > File size of 1 is 1073741824 (262144 blocks of 4096 bytes)
> > >  ext:     logical_offset:        physical_offset: length:   expected: flags:
> > >    0:        0..   32766:     458752..    491518:  32767:             unwritten
> > >    1:    32767..   65533:     491520..    524286:  32767:     491519: unwritten
> > >    2:    65534..   98300:     589824..    622590:  32767:     524287: unwritten
> 
> If we do 8M writes, then we would want to write in chunks of 2048
> blocks.  So consider what happens when we write the 2048 block chunk
> starting with logical block 30720.  The fact that there is a
> discontinuity between logical blocks 32766 and 32767 means that we
> will have to do a read-modify-write cycle for that particular RAID
> stripe.
> 
> Does that make more sense?

Oh, now I get it :) Thanks a lot for explanation I kept thinking
about the physical layout and forgot that the logical is actually
misaligned.

> 
> Another reason why keeping the file as physically contiguous as
> possible is because we can now extent caching using the extent status
> tree.  So if we can allocate the file using 2 physically contiguous
> extents in instead of 9 or 10 physically contiguous extents, it means
> the extent status tree uses less memory, too.  For a 1GB file, that
> might not make that much difference, but if we caching 2048 of these
> 1G files (on a 2TB disk, for example), keeping the files as physically
> contiguous as possible means we can cache the logical to physical
> block mapping of all of these files much more easily.

Yes, that makes sense too.

> 
> Regards,
> 
> 						- Ted
> 

Thanks!
-Lukas
--8323328-1740734292-1364218018=:23176--
