From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: confused by delayed allocation and ordered journal
Date: Sat, 25 Dec 2010 18:43:27 +0200
Message-ID: <AANLkTikRNrnrzam6DugT-uyfBeNZqJD1yr6nMzYLciZx@mail.gmail.com>
References: <AANLkTi=2S3JsAOP290_1ASMNGKMFZK+Srt4v5Qs474dB@mail.gmail.com>
	<20101225143916.GD2595@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43330 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0LYQn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Dec 2010 11:43:28 -0500
Received: by qyj19 with SMTP id 19so9306526qyj.19
        for <linux-ext4@vger.kernel.org>; Sat, 25 Dec 2010 08:43:28 -0800 (PST)
In-Reply-To: <20101225143916.GD2595@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 25, 2010 at 4:39 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sat, Dec 25, 2010 at 09:15:28PM +0800, Yongqiang Yang wrote:
>>
>> I found that if a block'allocation is delayed, and is not allocated
>> when journal flushes it, then journal just redirties it and return i=
n
>> journal_submit_data_buffers.
>>
>> If I understand right, how to guarantee that the journal mode is ord=
ered?
>
> The primary goal of ordered mode is to make sure that stale data is
> not exposed after a crash. =A0To the extent that delayed allocation a=
lso
> achieves this goal, it's fine. =A0The fact that ext3 forced data bloc=
ks
> out as part of its jbd commit function was always an implementation
> detail.

Hi Ted,

=46YI, Yongqiang is researching move-on-write of extent mapped files
data and opportunistic de-fragmentation on rewrite
and this is the context of his question.

As I mentioned to you on Plumbers the ordering requirements for move-on=
-write
are a bit stronger than "not exposing un-initialized data".
In the process of move-on-write, the extent must always map written dat=
a blocks
and traditional 'ordered' mode can be used to guaranty that.

Yongqiang,

I believe in the case of delalloc move-on-rewrite, on write_begin(),
you only need to reserve blocks (in-memory)
and on writepages(), you do the actual move-on-write, modifying the
extent from one valid data blocks range to another.


>
> In the long run we'll be getting rid of ordered mode even more so, by
> writing the data block first, and only then updating the file system
> metadata. =A0At that point there will be no ordered flushing at all, =
and
> in fact ordered mode will go away as a journal mode supported by ext4=
=2E
>

And that can simplify move-on-write implementation as well.
But until that happens, snapshots will require 'ordered' mode.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
