From: Evgeniy Ivanov <lolkaantimat@gmail.com>
Subject: Re: ext2/ext3 different block_sizes/i_size/e2fsck question
Date: Fri, 26 Mar 2010 01:43:35 +0300
Message-ID: <e1e08eb01003251543r8ea9b34v3837da8f158d3df6@mail.gmail.com>
References: <e1e08eb01003241227p35e84777q622996b861009ecb@mail.gmail.com>
	 <20100325015503.GJ2159@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:54859 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0CYWnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Mar 2010 18:43:37 -0400
Received: by fxm23 with SMTP id 23so1649710fxm.21
        for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 15:43:35 -0700 (PDT)
In-Reply-To: <20100325015503.GJ2159@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 25, 2010 at 4:55 AM,  <tytso@mit.edu> wrote:
> On Wed, Mar 24, 2010 at 10:27:24PM +0300, Evgeniy Ivanov wrote:
>>
>> Sorry for bothering list with my ext2 questions.
>> I got into trouble with my ext2 implementation and filesystem with
>> 1024 block size. Sometimes when I write files they're written
>> correctly (md5sum is the same as original, i_size is correct either)=
,
>> but e2fsck changes i_size to another values (which breaks files). E.=
g.
>> 67445000->67446784 or 67445248->67446784. I see that new sizes are
>> numbers of multiples of 1024.
>> Strange thing is that I can't reproduce this problem with 2048 and
>> 4096 block sizes. I thought the problem was in trash in unused part =
of
>> last block (actually it is zeroed), but then it would be reproduceab=
le
>> in fs with another block size.
>
> E2fsck will adjust i_size if it is smaller than the number of blocks
> than you have allocated. =A0So in the case of 67445000->67446784, you=
r
> file probably had 65866 1k blocks, and since 67445000 is less than
> (655865*1024)+1, e2fsck assumed that your i_size was wrong, and so it
> asked for permission to fix it.
>
> Put another way, if you have 2 blocks in 1k file, and i_size is 1024,
> it clearly must be wrong. =A0If it's 1025, maybe we're only using 1 b=
yte
> in the last block; but if i_size is less than or equal to 1024, then
> why was the 2nd block allocated in the file in the first place?

Thank you for your explanation.
My problem was in miscalculation of first triple indirect block. I
used following thing "triple_ind_s =3D doub_ind_s + pow(addr_in_block,
2)" and it was a bad idea to use pow() instead of multiplication or
shifting. It was ok with gcc (and libc), but caused a problem with ACK
(I get value of 1 less, thus each last double indirect block became a
hole instead of data). Since that was both in reading and writing md5
sums were correct (and in Linux I checked them only after e2fsck).
=46unny bug :)


--=20
Evgeniy Ivanov
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
