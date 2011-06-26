From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Sat, 25 Jun 2011 22:16:54 -0400
Message-ID: <BANLkTinjKDWv4HdODzLSU5WQ-TYaDk2ABw@mail.gmail.com>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org>
 <4DFB62C7.5070008@redhat.com> <E94A4A11-B1FB-4D95-87C5-F18190EF333B@gmail.com>
 <4E008045.1040909@sx.jp.nec.com> <BANLkTinvConLV08CkaTSBOhM=2HFwF0wnw@mail.gmail.com>
 <4E044AB4.9010804@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <aedilger@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	ext4 <linux-ext4@vger.kernel.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49763 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab1FZCRZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Jun 2011 22:17:25 -0400
Received: by bwd5 with SMTP id 5so549148bwd.19
        for <linux-ext4@vger.kernel.org>; Sat, 25 Jun 2011 19:17:24 -0700 (PDT)
In-Reply-To: <4E044AB4.9010804@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 24, 2011 at 4:28 AM, Kazuya Mio <k-mio@sx.jp.nec.com> wrote=
:
> Hi Greg,
> I'm sorry for the late reply.
>
> 2011/06/23 20:16, Greg Freemyer wrote:
>>
>> For a sparse file, can you explain why you treat the head and tail
>> extents of a block group differently?
>
> Could you tell me what "block group" you said means?

Kazuya,

Sorry if I've got the terminology wrong.

I'm talking about sparse files.

Where you might have:

block_group1 - hole - block_group2 - hole - block_group3.

Block_group2 has a head and a tail extent.  In my mind, from a
performance perspective, they are symmetric.  Meaning that having a
small extent at the beginning is no better and no worse than having a
small extent at the end.

> If "block group" means the ext4 block group, I will treat the head an=
d tail
> extents of a block group the same way.
>
> And if "block group" means the chunk of the extents whose offset is
> continued,
> I will treat only the tail extents as a special case.
>
> # filefrag -v /mnt/mp1/file
> Filesystem type is: ef53
> File size of /mnt/mp1/file is 285212672 (69632 blocks, blocksize 4096=
)
> =A0ext logical physical expected length flags
> =A0 0 =A0 =A0 =A0 0 =A0 =A034816 =A0 =A0 =A0 =A0 =A0 30720
> =A0 1 30720 65536 =A0 =A0 =A0 =A0 =A0 =A02048 unwritten
> =A0 2 =A0 65536 =A0 =A067584 =A0 =A0 =A0 =A0 =A0 =A04096 unwritten,eo=
f
> /mnt/mp1/file: 1 extent found
>
> The case is not fragmented. The length of #1 extent is a little bit s=
hort,
> but there is no point in doing defragmentation because of the hole
> existence.

Please consider this caseL

Assume for a minute  a large sparse file with lots of holes.  This is
one like a VM might create.  And that in the middle of the file is a
block_group with a hole in front of it and a hole after it.  Assume it
is 1 extent long exactly, and that one extent is a maximum extent (ie
128 MB with 4KB blocks I believe).

Now assume the VM writes a single short extent at the end of
block_group.  Your logic says full_extent+small_extent, no need to
defrag because its already optimal.

I agree with that.

Now assume instead of the block_group being extended at the tail, it
is extended at the head.

Now you have:

   small_extent+full_extent

Your logic as I understand it will score that as not as good as the
first case.  I disagree,  Both are optimally defragged and both should
get the same score.

>
> Regards,
> Kazuya Mio

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
