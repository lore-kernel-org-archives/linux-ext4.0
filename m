From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Porting Zfs features to ext2/3
Date: Tue, 29 Jul 2008 12:46:29 -0400
Message-ID: <488F4965.6080801@redhat.com>
References: <18674437.post@talk.nabble.com>	 <1217199281.6992.0.camel@telesto> <20080727233855.GB9378@mit.edu>	 <1217218559.28825.12.camel@telesto>  <20080728124055.GD9378@mit.edu> <1217303912.7887.20.camel@telesto>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, postrishi <postrishi@gmail.com>,
	linux-ext4@vger.kernel.org
To: Eric Anopolsky <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbYG2Qqj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2008 12:46:39 -0400
In-Reply-To: <1217303912.7887.20.camel@telesto>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Anopolsky wrote:
> Please let me know if I'm getting off topic for the ext4-devel list. =
My
> point is not to advocate ZFS over ext3/4 since ZFS still has its shar=
e
> of issues. No resizing raidz vdevs, for example, and performance in
> certain areas. My only point is to make it clear that ZFS on Linux is
> available (and not necessarily a bad choice) to people reading the
> ext4-devel mailing list looking for ZFS-like features like the origin=
al
> poster.
>
> On Mon, 2008-07-28 at 08:40 -0400, Theodore Tso wrote:
>  =20
>> On Sun, Jul 27, 2008 at 10:15:59PM -0600, Eric Anopolsky wrote:
>>    =20
>>> It's true that ZFS on FUSE performance isn't all it could be right =
now.
>>> However, ZFS on FUSE is currently not taking advantage of mechanism=
s
>>> FUSE provides to improve performance. For an example of what can be
>>> achieved, check out http://www.ntfs-3g.org/performance.html .
>>>      =20
>> Yes... and take a look at the metadata operations numbers.  FUSE can
>> do things to accellerate bulk read/write, but metadata-intensive
>> operations will (I suspect) always be slow. =20
>>    =20
>
> It doesn't seem too much worse than the other non-ext3 filesystems in
> the comparison. I'm sure everyone would prefer a non-FUSE implementat=
ion
> and the licensing issues aren't going to go away, but this post on Je=
ff
> Bonwick's blog gives some hope:
> http://blogs.sun.com/bonwick/entry/casablanca . Even so, not everyone
> needs a whole lot of speed in the metadata operations area.=20
>
>  =20
>> I also question whether
>> the FUSE implementation will have the safety that has always been th=
e
>> Raison d'=C3=AAtre of ZFS.  Have you or the ZFS/FUSE developers done=
 tests
>> where you are writing to the filesystem, and then someone pulls the
>> plug on the fileserver while ZFS is writing?  Does the filesystem
>> recovery cleanly from such a scenario?
>>    =20
>
> I haven't personally tried pulling the plug, but I've tried holding d=
own
> the power button on my laptop until it powers off. Everything works f=
ine
> and scrubs (the closest ZFS gets to fsck) don't report any checksum
> errors. The filesystem driver updates the on-disk filesystem atomical=
ly
> every five seconds (less time in special circumstances) so there's ne=
ver
> any point at which the filesystem would need recovery. The next time =
the
> filesystem is mounted the system sees the state the filesystem was in=
 up
> to five seconds before the power went out. The FUSEness of the
> filesystem driver doesn't seem to affect this.
>
> Cheers,
> Eric
>  =20
Does that mean you always lose the last 5 seconds of data before the=20
power outage?

We had an earlier thread where Chris had a good test for making a case=20
for the write barrier code being enabled by default. It would be neat t=
o=20
try that on ZFS ;-) The expected behaviour should be that any fsync()'e=
d=20
files should be there (regardless of the 5 seconds) and other=20
non-fsync'ed files might or might not be there, but that all file syste=
m=20
integrity is complete.

It would also be very interesting to try and do a drive hot pull.

Thanks!

Ric


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
