From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 4/4] ext3: Implement delayed allocation on page_mkwrite time
Date: Tue, 3 May 2011 13:39:00 +0300
Message-ID: <BANLkTi=a8Ht0CbXicdAfJBy+tesY1jKX5A@mail.gmail.com>
References: <1304369816-14545-1-git-send-email-jack@suse.cz>
	<1304369816-14545-5-git-send-email-jack@suse.cz>
	<20110502141230.4a7640f9.akpm@linux-foundation.org>
	<20110502222020.GB14889@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62933 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1ECKjC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 May 2011 06:39:02 -0400
Received: by ewy4 with SMTP id 4so2016821ewy.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 May 2011 03:39:01 -0700 (PDT)
In-Reply-To: <20110502222020.GB14889@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 3, 2011 at 1:20 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 02-05-11 14:12:30, Andrew Morton wrote:
>> On Mon, =A02 May 2011 22:56:56 +0200
>> Jan Kara <jack@suse.cz> wrote:
>>
>> > So far, ext3 was allocating necessary blocks for mmapped writes wh=
en
>> > writepage() was called. There are several issues with this. The wo=
rst
>> > being that user is allowed to arbitrarily exceed disk quotas becau=
se
>> > writepage() is called from flusher thread context (which is root) =
and thus
>> > quota limits are ignored. Another bad consequence is that data is =
just lost
>> > if we find there's no space on the filesystem during ->writepage()=
 time.
>> >
>> > We solve these issues by implementing block reservation in page_mk=
write()
>> > callback. We don't want to really allocate blocks on page_mkwrite(=
) time
>> > because for random writes via mmap (as seen for example with appli=
cations using
>> > BerkeleyDB) it results in much more fragmented files and thus much=
 worse
>> > performance. So we allocate indirect blocks and reserve space for =
data block in
>> > page_mkwrite() and do the allocation of data block from writepage(=
).
>>
>> Yes, instantiating the metadata and accounting the data is a good
>> approach. =A0The file layout will be a bit suboptimal, but surely th=
at
>> will be a minor thing.
>>
>> But boy, it's a complicated patch! =A0Are we really sure that we wan=
t to
>> make changes this extensive to our antiquated old fs? =A0Or do we ju=
st
>> say "yeah, it's broken with quotas - use ext4"?
> =A0The patch isn't trivial, I agree (although it's mostly straightfor=
ward).
> Regarding telling users to switch to ext4 - it seems a bit harsh to m=
e
> to ask people to switch to ext4 as a response to a (possibly security=
)
> issue they uncover. Because for most admins switching to ext4 will re=
quire
> some non-trivial testing I presume. Of course, the counterweight is t=
he
> possibility of new bugs introduced to the code by my patch. But after=
 some
> considerations I've decided it's worth it and and fixed the bug...

Jan,

Maybe you can work out a simpler(=3Dsafer) patch, which uses much large=
r
reservation margins.

=46or example, by reserving on mmap call, the difference between i_size
and i_blocks
and storing that reservation in in-memory inode, protected by i_mutex.
If an in-memory inode RESERVATION flag is set, you can update i_reserve=
d_blocks
when updating i_blocks (alloc and free) and i_size (truncate).
global in-memory reservation counters can be updated at the same time.

This approach will avoid the need to introduce delayed allocation to ex=
t3,
since you got the reservation on mmap time, you can rest assure that
no dirty data will be dropped on the floor and no quota limits will be =
exceeded.

The trade off is that an application that want to mmap a very large spa=
rse file
to write just some blocks will not be able to do that on a near full
file system.
Do you know of any such real application?

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
