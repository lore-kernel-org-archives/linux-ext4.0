From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: why unlikely(rsv) in ext3_clear_inode()?
Date: Mon, 27 Oct 2008 16:52:12 -0700
Message-ID: <1225151532.6685.31.camel@mingming-laptop>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>
To: Mike Snitzer <snitzer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:34441 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYJ0XwN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 19:52:13 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e38.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id m9RNpUf4018322
	for <linux-ext4@vger.kernel.org>; Mon, 27 Oct 2008 17:51:30 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9RNqDU6131658
	for <linux-ext4@vger.kernel.org>; Mon, 27 Oct 2008 17:52:13 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9RNphN7028845
	for <linux-ext4@vger.kernel.org>; Mon, 27 Oct 2008 17:51:44 -0600
In-Reply-To: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-10-27=E4=B8=80=E7=9A=84 18:29 -0400=EF=BC=8CMike Snitzer=
=E5=86=99=E9=81=93=EF=BC=9A
> Please see: e6022603b9aa7d61d20b392e69edcdbbc1789969
>=20
> Having a look at the LKML archives this was raised back in 2006:
> http://lkml.org/lkml/2006/6/23/337
>=20
> I'm not interested in whether unlikely() actually helps here.
>=20
> I'm still missing _why_ rsv is mostly NULL at this callsite, as Andre=
w
> asserted here:
> http://lkml.org/lkml/2006/6/23/400
>=20
> And then Steve here: http://lkml.org/lkml/2006/6/24/76
> Where he said:
> "The problem is that in these cases the pointer is NULL several thous=
ands
> of times for every time it is not NULL (if ever).  The non-NULL case =
is
> where an error occurred or something very special.  So I don't see ho=
w
> the if here is a problem?"
>=20
> I'm missing which error or what "something very special" is the
> unlikely() reason for having rsv be NULL.
>=20
> Looking at the code; ext3_clear_inode() is _the_ place where the
> i_block_alloc_info is cleaned up.  In my testing the rsv is _never_
> NULL if the file was open for writing.  Are we saying that reads are
> much more common than writes?  May be a reasonable assumption but
> saying as much is very different than what Steve seemed to be eluding
> to...
>=20

i_block_alloc_info as the structure to keep track of block
reservation/allocation,  is dynamically allocated when file does need
blocks. So rsv remains NULL even if file is open for rewrite,  until
file is about to do block allocation.

Mingming
> Anyway, I'd appreciate some clarification here.
>=20
> thanks,
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
