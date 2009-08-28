From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Fri, 28 Aug 2009 11:42:59 -0700
Message-ID: <5df78e1d0908281142r683b902ube65288df858695d@mail.gmail.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
	 <1248211771.20743.2.camel@bobble.smo.corp.google.com>
	 <20090721215421.GM4231@webber.adilger.int>
	 <1248304214.14463.17.camel@bobble.smo.corp.google.com>
	 <4A67D36D.20708@redhat.com>
	 <1248366422.27509.1.camel@bobble.smo.corp.google.com>
	 <4A689723.7000805@redhat.com>
	 <1248372301.31323.2.camel@bobble.smo.corp.google.com>
	 <20090723215614.GF4231@webber.adilger.int>
	 <1248389165.17459.3.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:23479 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZH1SnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2009 14:43:13 -0400
Received: from spaceape13.eur.corp.google.com (spaceape13.eur.corp.google.com [172.28.16.147])
	by smtp-out.google.com with ESMTP id n7SIhCsR017680
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 19:43:12 +0100
Received: from qyk34 (qyk34.prod.google.com [10.241.83.162])
	by spaceape13.eur.corp.google.com with ESMTP id n7SIh9tO013390
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 11:43:10 -0700
Received: by qyk34 with SMTP id 34so1338989qyk.12
        for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 11:43:09 -0700 (PDT)
In-Reply-To: <1248389165.17459.3.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry for joining the conversation late. Frank and I had a discussion o=
n this
problem this morning. We wonder whether we can just add the checking
on whether i_blocks is consistent with i_size during truncate. Here is =
the
patch I tried and it seems to have solved the problem. I.e., the space =
reserved
in fallocate(KEEP_SIZE) is now freed in the next truncate.

--- git-linux/fs/attr.c	2009-05-20 18:05:55.000000000 -0700
+++ linux-2.6.30.5/fs/attr.c	2009-08-27 14:34:48.000000000 -0700
@@ -68,7 +68,8 @@ int inode_setattr(struct inode * inode,
 	unsigned int ia_valid =3D attr->ia_valid;

 	if (ia_valid & ATTR_SIZE &&
-	    attr->ia_size !=3D i_size_read(inode)) {
+	    (attr->ia_size !=3D i_size_read(inode) ||
+            attr->ia_size >> 9 < inode->i_blocks - 1)) {
 		int error =3D vmtruncate(inode, attr->ia_size);
 		if (error)
 			return error;

One thing I am not sure is whether adding this check in inode_setattr m=
ay
cause any problem in other cases. I saw inode_setattr is called at many
places as well as during ftruncate. Any opinions on this proposed solut=
ion?

Jiaying

On Thu, Jul 23, 2009 at 3:46 PM, Frank Mayhar<fmayhar@google.com> wrote=
:
> On Thu, 2009-07-23 at 15:56 -0600, Andreas Dilger wrote:
>> On Jul 23, 2009 =A011:05 -0700, Frank Mayhar wrote:
>> > On Thu, 2009-07-23 at 12:00 -0500, Eric Sandeen wrote:
>> > > Sorry I skimmed to fast, skipped over the fsck part. =A0But:
>> > >
>> > > # touch /mnt/test/testfile
>> > > # /root/fallocate -n -l 16m /mnt/test/testfile
>> > > # ls -l /mnt/test/testfile
>> > > -rw-r--r-- 1 root root 0 Jul 23 12:13 /mnt/test/testfile
>> > > # du -h /mnt/test/testfile
>> > > 16M =A0 =A0 =A0 /mnt/test/testfile
>> > >
>> > > there doesn't seem to be a problem in fsck w/ block past EOF, or=
 am I
>> > > missing something else?
>> >
>> > I was taking Andreas' word for it but now that you mention it, I s=
ee the
>> > same thing. =A0Andreas, did you have a specific case in mind?
>>
>> Ted and I had discussed this in the past, maybe he fixed e2fsck to n=
ot
>> change the file size when there are blocks allocated beyond EOF. =A0=
Having
>> a flag wouldn't be a terrible idea, IMHO, so that e2fsck can make a
>> better decision on whether the size or the blocks count are more cor=
rect.
>> I'm not dead set on it.
>
> For the moment I'm going to table the e2fsck change and make the flag
> memory-only. =A0It'll be easy enough to change this if and when you g=
uys
> come to an agreement about what is right.
>
> As for the flag itself, I'll pick a bit that doesn't conflict with
> anything else and leave reconciling the already-conflicting bits to y=
ou
> guys.
> --
> Frank Mayhar <fmayhar@google.com>
> Google, Inc.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
