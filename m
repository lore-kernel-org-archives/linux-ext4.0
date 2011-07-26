From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Checks in ext4_ext_fiemap_cb() broken
Date: Tue, 26 Jul 2011 20:48:21 +0800
Message-ID: <CAGBYx2YV5-yNA9cRwU0ojmMnOqNsc_gLLGrc+jenDBk4uYbM8g@mail.gmail.com>
References: <20110725155836.GF6107@quack.suse.cz>
	<CAGBYx2ZsxvmEcC0akMRQTgDWUmkUHOp=D4Ff69_pSMb+bGH5Sg@mail.gmail.com>
	<20110726121225.GC20131@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>
To: Jan Kara <jack@suse.cz>,
	Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59143 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1GZMsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jul 2011 08:48:24 -0400
Received: by yia27 with SMTP id 27so197155yia.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Jul 2011 05:48:23 -0700 (PDT)
In-Reply-To: <20110726121225.GC20131@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 26, 2011 at 8:12 PM, Jan Kara <jack@suse.cz> wrote:
> =A0Hi Yongqiang,
>
> On Tue 26-07-11 09:20:28, Yongqiang Yang wrote:
>> I have been thinking if we can handle fiemap much simpler for a whil=
e.
>> =A0Current code is very ugly due to page cache look up. =A0I have a
>> thought on simplifying these code. =A0The reason leading us to looki=
ng
>> up page cache is that delayed extents are not in extents tree. =A0I
>> think we can add an in-memory delayed extents list in inode, and we
>> can delete entries in the list after we allocate blocks for them.
>> There is no limit on length of extents in the list, this way can an
>> entry contain as many blocks as they are contiguous logically.
>>
>> What's your opinion?
> =A0Yes, that should be doable and shouldn't have too big overhead. It=
's just
> stupid we'll do all this stuff only for fiemap call which is relative=
ly
> rare.

I guess there are other places where delayed extents should be handled
by looking up page cache.

SEEK_HOLE and SEEK_DATA also need to lookup page cache to handle
delayed extents.

Hi Allison,

If a delayed extents list added in the inode, could punch hole code be =
simpler?


Yongqiang.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
>
>> On Mon, Jul 25, 2011 at 11:58 PM, Jan Kara <jack@suse.cz> wrote:
>> > =A0Hello,
>> >
>> > =A0I just had a look at the code checking delayed allocated buffer=
s in
>> > ext4_ext_fiemap_cb(). I believe the checks there could use some el=
imiation
>> > of common patterns but that's just a minor thing. The main problem=
 is that
>> > the code can easily crash the kernel when it races with page recla=
im. You
>> > just cannot access most of the page contents (and for buffers it i=
s
>> > especially true) without locking the page. Getting a reference via
>> > find_get_pages_tag() guarantees you the structure cannot go away b=
ut mm is
>> > still free to detach the page from the mapping at any moment. So y=
ou must
>> > always lock a page and check that it still belongs to the desired =
mapping
>> > before you check 'page_has_buffers()'.
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
>> > --
>> > Jan Kara <jack@suse.cz>
>> > SUSE Labs, CR
>> >
>>
>>
>>
>> --
>> Best Wishes
>> Yongqiang Yang
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
