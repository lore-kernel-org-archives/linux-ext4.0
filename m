From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Fri, 28 Aug 2009 14:44:23 -0700
Message-ID: <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com>
References: <1248211771.20743.2.camel@bobble.smo.corp.google.com>
	 <1248304214.14463.17.camel@bobble.smo.corp.google.com>
	 <4A67D36D.20708@redhat.com>
	 <1248366422.27509.1.camel@bobble.smo.corp.google.com>
	 <4A689723.7000805@redhat.com>
	 <1248372301.31323.2.camel@bobble.smo.corp.google.com>
	 <20090723215614.GF4231@webber.adilger.int>
	 <1248389165.17459.3.camel@bobble.smo.corp.google.com>
	 <5df78e1d0908281142r683b902ube65288df858695d@mail.gmail.com>
	 <20090828194051.GM4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Frank Mayhar <fmayhar@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:48643 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZH1Vo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2009 17:44:26 -0400
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com [172.24.198.65])
	by smtp-out.google.com with ESMTP id n7SLiQI2017669
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 22:44:26 +0100
Received: from qyk11 (qyk11.prod.google.com [10.241.83.139])
	by wpaz1.hot.corp.google.com with ESMTP id n7SLiN9Z023199
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 14:44:24 -0700
Received: by qyk11 with SMTP id 11so1743966qyk.1
        for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 14:44:23 -0700 (PDT)
In-Reply-To: <20090828194051.GM4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 28, 2009 at 12:40 PM, Andreas Dilger<adilger@sun.com> wrote=
:
> On Aug 28, 2009 =A011:42 -0700, Jiaying Zhang wrote:
>> Sorry for joining the conversation late. Frank and I had a discussio=
n on this
>> problem this morning. We wonder whether we can just add the checking
>> on whether i_blocks is consistent with i_size during truncate. Here =
is the
>> patch I tried and it seems to have solved the problem. I.e., the spa=
ce
>> reserved in fallocate(KEEP_SIZE) is now freed in the next truncate.
>>
>> --- git-linux/fs/attr.c =A0 =A0 =A0 2009-05-20 18:05:55.000000000 -0=
700
>> +++ linux-2.6.30.5/fs/attr.c =A02009-08-27 14:34:48.000000000 -0700
>> @@ -68,7 +68,8 @@ int inode_setattr(struct inode * inode,
>> =A0 =A0 =A0 unsigned int ia_valid =3D attr->ia_valid;
>>
>> =A0 =A0 =A0 if (ia_valid & ATTR_SIZE &&
>> - =A0 =A0 =A0 =A0 attr->ia_size !=3D i_size_read(inode)) {
>> + =A0 =A0 =A0 =A0 (attr->ia_size !=3D i_size_read(inode) ||
>> + =A0 =A0 =A0 =A0 =A0 =A0attr->ia_size >> 9 < inode->i_blocks - 1)) =
{
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int error =3D vmtruncate(inode, attr->ia=
_size);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return error;
>
> This isn't really correct, however, because i_blocks also contains
> non-data blocks (indirect/index, EA, etc) blocks, so even with small
> files with ACLs i_blocks may always be larger than ia_size >> 9, and
> for ext2/3 at least this will ALWAYS be true for files > 48kB in size=
=2E

I see. I guess we need to use a special flag then. Or is there any
other suggestions? I also have another question related to this
problem. Why those fallocated blocks are not marked as preallocated
blocks that will then be automatically freed in ext4_release_file?

Jiaying

>
>> On Thu, Jul 23, 2009 at 3:46 PM, Frank Mayhar<fmayhar@google.com> wr=
ote:
>> > On Thu, 2009-07-23 at 15:56 -0600, Andreas Dilger wrote:
>> >> On Jul 23, 2009 =A011:05 -0700, Frank Mayhar wrote:
>> >> > On Thu, 2009-07-23 at 12:00 -0500, Eric Sandeen wrote:
>> >> > > Sorry I skimmed to fast, skipped over the fsck part. =A0But:
>> >> > >
>> >> > > # touch /mnt/test/testfile
>> >> > > # /root/fallocate -n -l 16m /mnt/test/testfile
>> >> > > # ls -l /mnt/test/testfile
>> >> > > -rw-r--r-- 1 root root 0 Jul 23 12:13 /mnt/test/testfile
>> >> > > # du -h /mnt/test/testfile
>> >> > > 16M =A0 =A0 =A0 /mnt/test/testfile
>> >> > >
>> >> > > there doesn't seem to be a problem in fsck w/ block past EOF,=
 or am I
>> >> > > missing something else?
>> >> >
>> >> > I was taking Andreas' word for it but now that you mention it, =
I see the
>> >> > same thing. =A0Andreas, did you have a specific case in mind?
>> >>
>> >> Ted and I had discussed this in the past, maybe he fixed e2fsck t=
o not
>> >> change the file size when there are blocks allocated beyond EOF. =
=A0Having
>> >> a flag wouldn't be a terrible idea, IMHO, so that e2fsck can make=
 a
>> >> better decision on whether the size or the blocks count are more =
correct.
>> >> I'm not dead set on it.
>> >
>> > For the moment I'm going to table the e2fsck change and make the f=
lag
>> > memory-only. =A0It'll be easy enough to change this if and when yo=
u guys
>> > come to an agreement about what is right.
>> >
>> > As for the flag itself, I'll pick a bit that doesn't conflict with
>> > anything else and leave reconciling the already-conflicting bits t=
o you
>> > guys.
>> > --
>> > Frank Mayhar <fmayhar@google.com>
>> > Google, Inc.
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ex=
t4" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> >
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
