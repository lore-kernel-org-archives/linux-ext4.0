From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH, RFC 0/3] Introduce new O_HOT and O_COLD flags
Date: Sat, 21 Apr 2012 19:56:05 -0400
Message-ID: <CAHGf_=oWtpgRfqaZ1YDXgZoQHcFY0=DYVcwXYbFtZt2v+K532w@mail.gmail.com>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu>
 <4F912880.70708@panasas.com> <alpine.LFD.2.00.1204201120060.27750@dhcp-27-109.brq.redhat.com>
 <1334919662.5879.23.camel@dabdike> <alpine.LFD.2.00.1204201313231.27750@dhcp-27-109.brq.redhat.com>
 <1334932928.13001.11.camel@dabdike> <20120420145856.GC24486@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-mm@kvack.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58058 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2DUX40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Apr 2012 19:56:26 -0400
In-Reply-To: <20120420145856.GC24486@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 20, 2012 at 10:58 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Apr 20, 2012 at 06:42:08PM +0400, James Bottomley wrote:
>>
>> I'm not at all wedded to O_HOT and O_COLD; I think if we establish a
>> hint hierarchy file->page cache->device then we should, of course,
>> choose the best API and naming scheme for file->page cache. =A0The o=
nly
>> real point I was making is that we should tie in the page cache, and
>> currently it only knows about "hot" and "cold" pages.
>
> The problem is that "hot" and "cold" will have different meanings fro=
m
> the perspective of the file system versus the page cache. =A0The file
> system may consider a file "hot" if it is accessed frequently ---
> compared to the other 2 TB of data on that HDD. =A0The memory subsyst=
em
> will consider a page "hot" compared to what has been recently accesse=
d
> in the 8GB of memory that you might have your system. =A0Now consider
> that you might have a dozen or so 2TB disks that each have their "hot=
"
> areas, and it's not at all obvious that just because a file, or even
> part of a file is marked "hot", that it deserves to be in memory at
> any particular point in time.

So, this have intentionally different meanings I have no seen a reason =
why
fs uses hot/cold words. It seems to bring a confusion.

But I don't know full story of this feature and I might be overlooking
something.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
