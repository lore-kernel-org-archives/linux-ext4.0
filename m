From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Fri, 01 Jul 2011 17:34:09 +0900
Message-ID: <4E0D8681.3060205@sx.jp.nec.com>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org> <4DFB62C7.5070008@redhat.com> <E94A4A11-B1FB-4D95-87C5-F18190EF333B@gmail.com> <4E008045.1040909@sx.jp.nec.com> <BANLkTinvConLV08CkaTSBOhM=2HFwF0wnw@mail.gmail.com> <4E044AB4.9010804@sx.jp.nec.com> <BANLkTinjKDWv4HdODzLSU5WQ-TYaDk2ABw@mail.gmail.com> <4E09AB2A.6000105@sx.jp.nec.com> <BANLkTikZwscrs4F1NeVRKBTPSouthhMgSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <aedilger@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	ext4 <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49019 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab1GAIfA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jul 2011 04:35:00 -0400
In-Reply-To: <BANLkTikZwscrs4F1NeVRKBTPSouthhMgSg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/06/28 22:53, Greg Freemyer wrote:
> While you're thinking about the issue:
>
> As I hope I've said before, for sparse file I think e4defrag should
> score and defrag one block_group at a time.  Thus if a VM backing
> storage file has 100 block_groups (as I'm using the term), then it
> should score each of the 100 separately and if needed defrag them one
> at a time.
>
> I can see no benefit from treating a large sparse file as monolithic
> for the decision process.

If e4defrag does defrag one block_group at a time, this block_group may be
allocated far away from the other block_groups. If so, seek time increases
even if the number of extents is less than before.

Of course, I'm aware of the advantage of your suggestion. I may also try to
consider it to defrag only a part of a file in the future, but before that
I think I should do the cleanup and bugfix.

> fyi: Is there an agreed on term for what I'm calling a block_group.  I
> believe e4defrag uses the term "extent group" in the comments, but
> sparse files exist in non-extent based filesystems, so it's not a very
> portable name.

e4defrag supports only an extent based filesystem, so I think it's no problem.
And I associate "block_group" with the physical layout of the blocks on the
disk. I guess we shouldn't use the same word with different meanings.

Regards,
Kazuya Mio
