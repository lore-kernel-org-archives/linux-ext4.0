From: Vitali Lovich <vlovich@gmail.com>
Subject: Re: question about i_dtime being used as an orphan list pointer
Date: Wed, 25 Aug 2010 14:25:37 -0700
Message-ID: <AANLkTi=6tfTpDLqiYpvkOwcWZsWRqru9bHOeOdP=ghf0@mail.gmail.com>
References: <AANLkTi=3hK1RLRJ+2Kt0ju=HEr-LdkO9eX_YxLfp0wea@mail.gmail.com> <20100825203914.GF4453@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50163 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab0HYVZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 17:25:58 -0400
Received: by gwj17 with SMTP id 17so406728gwj.19
        for <linux-ext4@vger.kernel.org>; Wed, 25 Aug 2010 14:25:57 -0700 (PDT)
In-Reply-To: <20100825203914.GF4453@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 25, 2010 at 1:39 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Aug 25, 2010 at 12:22:22PM -0700, Vitali Lovich wrote:
>> So I've run into this problem where the clock was reset into the 197=
0s
>> on my system, causing e2fsck to get confused & think a file I delete=
d
>> actually had an orphan list inode pointer stored in the i_dtime
>> instead of the deletion time, causing e2fsck to get all confused &
>> return an error code.
>
> Are you worried about solving this problem as a one shot deal, or as =
a
> long-term design issue. =C2=A0The long-term proper solution is run yo=
ur
> clock so it is correct. =C2=A0:-)
Right :).  The problem is we haven't completely root-caused the issue
of why the clock had the wrong time, so I wanted to put in a robust
fix that makes the failure-mode more graceful.  I don't like using the
number of inodes as the threshold since that might change thus getting
back to that problem of putting inodes on the orphan list that
shouldn't be.

>
> In the short term, probably the easist thing to do is just run e2fsck
> -y and let those inodes get populated into lost+found, and then delet=
e
> them by hands afterwards.
This is an embedded device - not an option to do anything by hand.
When e2fsck fails we assume that there was a catastrophic failure & we
brick the device to avoid any potential corruption of user data (this
is only when e2fsck fails on the root or boot partitions right after
we unmount them after an OS upgrade).

>
> For a long-term fix, it probably would make sense to patch ext3/ext4
> so that when we delete a file, and the current time is less than
> number of inodes, that we set dtime to 0xffffffff.
Is the i_dtime actually used at all?  Could we just patch it to always
set that as the i_dtime always?  I grepped the source, & no one is
actually using the i_dtime field.

>
>> Even a value of midnight 2010 corresponds to a limit of only about 1
>> billion files (1 262 304 000). =C2=A0Thus it seems if you delete a f=
ile on
>> a partition with more than a billion files, it will make e2fsck thin=
k
>> you've got a corrupt file-system even though you don't.
>
> And if you assuming the smallest possible inode ratio, that's a 4.5TB
> file. =C2=A0If you use the default inode, that's a 18TB. =C2=A0Ext3 i=
s limited
> to 16TB, so that's not even an issue....
Depends on the block size, but yes, I don't think this is a super
important issue in general with respect to ext2/3 - not sure how this
affects ext4 since it, AFAIK, supports much higher capacity
partitions.

Thanks,
Vitali
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
