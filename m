From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: handle NULL p_ext in ext4_ext_next_allocated_block()
Date: Mon, 10 Oct 2011 08:28:23 -0700
Message-ID: <CAO81RMbLGDUihKORjQ5rGeRHPHg5ivvQtOGJL_oBe4QUiiO0hg@mail.gmail.com>
References: <1318122074-16056-1-git-send-email-curtw@google.com>
	<alpine.LFD.2.00.1110100841380.4851@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:43684 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab1JJP21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Oct 2011 11:28:27 -0400
Received: from wpaz5.hot.corp.google.com (wpaz5.hot.corp.google.com [172.24.198.69])
	by smtp-out.google.com with ESMTP id p9AFSPU7008104
	for <linux-ext4@vger.kernel.org>; Mon, 10 Oct 2011 08:28:26 -0700
Received: from qyk31 (qyk31.prod.google.com [10.241.83.159])
	by wpaz5.hot.corp.google.com with ESMTP id p9AFSO9Q020269
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 10 Oct 2011 08:28:24 -0700
Received: by qyk31 with SMTP id 31so9659336qyk.3
        for <linux-ext4@vger.kernel.org>; Mon, 10 Oct 2011 08:28:24 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1110100841380.4851@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Lukas:

On Mon, Oct 10, 2011 at 12:19 AM, Lukas Czerner <lczerner@redhat.com> w=
rote:
> On Sat, 8 Oct 2011, Curt Wohlgemuth wrote:
>
>> In ext4_ext_next_allocated_block(), the path[depth] might
>> have a p_ext that is NULL -- see ext4_ext_binsearch(). =A0In
>> such a case, dereferencing it will crash the machine.
>>
>> This patch checks for p_ext =3D=3D NULL in
>> ext4_ext_next_allocated_block() before dereferencinging it.
>>
>> Tested using a hand-crafted an inode with eh_entries =3D=3D 0 in
>> an extent block, verified that running FIEMAP on it crashes
>> without this patch, works fine with it.
>
> Hi Curt,
>
> It seems to me that even that the patch fixes the NULL dereference, i=
t
> is not a complete solution. Is it possible that in "normal" case p_ex=
t
> would be NULL ? I think that this is only possible in extent split/ad=
d
> case (as noted in ext4_ext_binsearch()) which should be atomic to the
> other operations (locked i_mutex?).

Yes, unfortunately, it is possible in "normal" cases for p_ext to be NU=
LL.

We've seen this problem during what appears to be a race between an
inode growth (or truncate?) and another task doing a FIEMAP ioctl.
The real problem is that FIEMAP handing in ext4 is just, well, buggy?

ext4_ext_walk_space() will get the i_data_sem, construct the path
array, then release the semaphore.  But then it does a bazillion
accesses on the extent/header/index pointers in the path array, with
no protection against truncate, growth, or any other changes.  As far
as I can tell, this is the only use of a path array retrieved from
ext4_ext_find_extent() that isn't completely covered by i_data_sem.

> However this seems like an inode corruption so we should probably be
> more verbose about it and print an appropriate EXT4_ERROR_INODE() or
> even better check for the corrupted tree in the ext4_ext_find_extent(=
)
> (instead in ext4_ext_map_blocks()), however this will need to disting=
uish
> between the normal and the tree modification case.

What we've observed many times is a crash during a FIEMAP call to
ext4_ext_next_allocated_block(), which appears to me to be during a
race with another thread that's splitting the extent tree.  This
causes the machine to go down with the inode in a bad state.  But of
course, fsck won't detect and fix this, so when the machine comes back
up, and a FIEMAP call is done on this same inode -- without any other
threads -- it'll crash again.  Hence a nasty crash loop.

So you're right, in that this isn't the "real solution."  But devising
a safe, non-racy design for FIEMAP is not so simple, unless of course
you want to just hold the i_data_sem during the entire loop body of
ext4_ext_walk_space(), which would be pretty ugly.  Hence the
"band-aid" approach in my patch, which at least seems correct, if not
thorough.

Thanks,
Curt

>
> Thanks!
> -Lukas
>
>>
>> Signed-off-by: Curt Wohlgemuth <curtw@google.com>
>> ---
>> =A0fs/ext4/extents.c | =A0 =A04 +++-
>> =A01 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 57cf568..063a5b8 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -1395,7 +1395,9 @@ ext4_ext_next_allocated_block(struct ext4_ext_=
path *path)
>> =A0 =A0 =A0 while (depth >=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (depth =3D=3D path->p_depth) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* leaf */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (path[depth].p_ext !=3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* p_ext can be NULL */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (path[depth].p_ext &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path[depth=
].p_ext !=3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 EXT_LAST_EXTENT(path[depth].p_hdr))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return le32_to_cpu(p=
ath[depth].p_ext[1].ee_block);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
