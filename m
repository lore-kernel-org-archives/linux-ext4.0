From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Tue, 28 Jun 2011 09:53:20 -0400
Message-ID: <BANLkTikZwscrs4F1NeVRKBTPSouthhMgSg@mail.gmail.com>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org>
 <4DFB62C7.5070008@redhat.com> <E94A4A11-B1FB-4D95-87C5-F18190EF333B@gmail.com>
 <4E008045.1040909@sx.jp.nec.com> <BANLkTinvConLV08CkaTSBOhM=2HFwF0wnw@mail.gmail.com>
 <4E044AB4.9010804@sx.jp.nec.com> <BANLkTinjKDWv4HdODzLSU5WQ-TYaDk2ABw@mail.gmail.com>
 <4E09AB2A.6000105@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <aedilger@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	ext4 <linux-ext4@vger.kernel.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49761 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab1F1Nxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2011 09:53:55 -0400
Received: by bwd5 with SMTP id 5so204727bwd.19
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jun 2011 06:53:54 -0700 (PDT)
In-Reply-To: <4E09AB2A.6000105@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 28, 2011 at 6:21 AM, Kazuya Mio <k-mio@sx.jp.nec.com> wrote=
:
> 2011/06/26 11:16, Greg Freemyer wrote:
>>
>> I'm talking about sparse files.
>>
>> Where you might have:
>>
>> block_group1 - hole - block_group2 - hole - block_group3.
>>
>> Block_group2 has a head and a tail extent. =A0In my mind, from a
>> performance perspective, they are symmetric. =A0Meaning that having =
a
>> small extent at the beginning is no better and no worse than having =
a
>> small extent at the end.
>
> Thanks for your kind description. Your point is right. I'll think a l=
ittle
> more
> about the fragmentation score.
>
> Regards,
> Kazuya Mio

Kazuya,

While you're thinking about the issue:

As I hope I've said before, for sparse file I think e4defrag should
score and defrag one block_group at a time.  Thus if a VM backing
storage file has 100 block_groups (as I'm using the term), then it
should score each of the 100 separately and if needed defrag them one
at a time.

I can see no benefit from treating a large sparse file as monolithic
for the decision process.

fyi: Is there an agreed on term for what I'm calling a block_group.  I
believe e4defrag uses the term "extent group" in the comments, but
sparse files exist in non-extent based filesystems, so it's not a very
portable name.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
