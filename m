From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: EXT4_IOC_MOVE_EXT file corruption!
Date: Fri, 9 Apr 2010 13:15:44 -0400
Message-ID: <q2o87f94c371004091015ud3b91710o58f2ce050255084a@mail.gmail.com>
References: <20100405220220.GT29604@tux1.beaverton.ibm.com>
	 <20100409162028.GV29604@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f193.google.com ([209.85.222.193]:42240 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab0DIRPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Apr 2010 13:15:49 -0400
Received: by pzk31 with SMTP id 31so121926pzk.33
        for <linux-ext4@vger.kernel.org>; Fri, 09 Apr 2010 10:15:48 -0700 (PDT)
In-Reply-To: <20100409162028.GV29604@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 9, 2010 at 12:20 PM, Darrick J. Wong <djwong@us.ibm.com> wr=
ote:
> On Mon, Apr 05, 2010 at 03:02:20PM -0700, Darrick J. Wong wrote:
>> Hi all,
>>
>> I wrote a program called e4frag that deliberately tries to fragment =
an ext4
>> filesystem via EXT4_IOC_MOVE_EXT so that I could run e4defrag throug=
h its
>> paces. =A0While running e4frag and e4defrag concurrently on a kernel=
 source tree,
>> I discovered ongoing file corruption. =A0It appears that if e4frag a=
nd e4defrag
>> hit the same file at same time, the file ends up with a 4K data bloc=
k from
>> somewhere else. =A0"Somewhere else" seems to be a small chunk of bin=
ary gibberish
>> followed by contents from other files(!) =A0Obviously this isn't a g=
ood thing to
>
> It seems that if you mount the filesystem with -o sync this problem g=
oes away.
>
> --D

That implies to me that there is a missing block flush prior to a lock
being released.  That should not be too hard to find by code
inspection.

As conceptually interested as I am in ext4_ioc_move_ext, I have not
really gone through the code with any detail.  Maybe I'll contribute
by doing that.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
