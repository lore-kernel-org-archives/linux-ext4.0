From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 4/4] block: Optionally snapshot page contents to provide
 stable pages during write
Date: Fri, 14 Dec 2012 18:06:50 -0800
Message-ID: <CALCETrVJd86oD=p6vnRVp=0g8JDbhfZTH2G-ZCCOHzrMMiembw@mail.gmail.com>
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
 <20121213080811.23360.98131.stgit@blackbox.djwong.org> <50CA8556.7030905@mit.edu>
 <20121214021048.GF9453@blackbox.djwong.org> <CALCETrWRqFmTpYNyDwUyzQpSVZjVEOCCZfHHohVR5uvHzS+s0Q@mail.gmail.com>
 <20121215020113.GK9453@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43730 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab2LOCHL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Dec 2012 21:07:11 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so5018286vcd.19
        for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 18:07:10 -0800 (PST)
In-Reply-To: <20121215020113.GK9453@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 14, 2012 at 6:01 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Fri, Dec 14, 2012 at 05:12:37PM -0800, Andy Lutomirski wrote:
>> It survived.  I hit at least one mm bug, but I really don't think it's
>> a problem with your code.  (I have not tried this workload on Linux
>> 3.7 at all before.  It normally runs on 3.5.)  The box in question is
>
> Would you mind sending along the bug report so I can make sure?

http://marc.info/?l=linux-mm&m=135553342803210&w=2

>
>> ext4 on LVM on dm-crypt on (hardware) RAID 5 on hpsa, which should not
>> need stable pages.
>>
>> The majority of the data written (that wasn't unlinked before it was
>> dropped from cache) was checksummed when written and verified later.
>> Most of this data was written using mmap.  This workload hammers the
>> vm concurrently in several threads, and it frequently stalls when
>> stable pages are enabled, so it's probably exercising the code
>> decently well.
>
> Did you observe any change in performance?

No.  But I'm comparing to 3.5 + butchery to remove stable pages.  With
stable pages on, this workload performs terribly.  (It's a soft
real-time thing, as you can possibly guess from my domain name, and
various latency monitoring things go nuts when stable pages are
active.)

Actually, performance appears to be improved, probably due to
https://lkml.org/lkml/2012/12/14/14, which I tested concurrently.

>
>> Feel free to add Tested-by: Andy Lutomirski <luto@amacapital.net>
>
> Will do!  Thanks for the testing!

My pleasure.  When these changes go in to an upstream kernel, they'll
represent a significant reduction in how much our kernel differs from
kernel.org's :)  Thanks for fixing this.

--Andy
