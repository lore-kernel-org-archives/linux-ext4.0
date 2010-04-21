From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Wed, 21 Apr 2010 17:47:27 -0400
Message-ID: <n2x87f94c371004211447w1e57ae43j4c988cf0205d7ec2@mail.gmail.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
	 <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com>
	 <4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com>
	 <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com>
	 <4BCF4C53.3010608@redhat.com>
	 <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>
	 <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>
	 <4BCF67A9.2040902@redhat.com> <4BCF6831.7080506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sandeen@redhat.com, Eric Sandeen <esandeen@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Mark Lord <kernel@teksavvy.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, Edward Shishkin <eshishki@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56076 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab0DUVr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Apr 2010 17:47:28 -0400
Received: by gwj19 with SMTP id 19so1603819gwj.19
        for <linux-ext4@vger.kernel.org>; Wed, 21 Apr 2010 14:47:28 -0700 (PDT)
In-Reply-To: <4BCF6831.7080506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adding James Bottomley because high-end scsi is entering the
discussion.  James, I have a couple scsi questions for you at the end.

On Wed, Apr 21, 2010 at 5:03 PM, Ric Wheeler <rwheeler@redhat.com> wrot=
e:
> On 04/21/2010 05:01 PM, Eric Sandeen wrote:
>>
>> On 04/21/2010 03:44 PM, Greg Freemyer wrote:
>>
>>
>>>
>>> Mark's benchmarks showed this as doable in seconds which seems like=
 a
>>> reasonable amount of time for a mount time operation.
>>>
>>
>> All the other things aside, mount-time is interesting, but it's an
>> infrequent operation, at least in my world. =A0I think we need somet=
hing
>> that can be done runtime.
>>
>> For anything with uptime, I don't think it's acceptable to wait unti=
l
>> the next mount to trim unused blocks.
>>
>> But as long as the mechanism can be called either at mount time and/=
or
>> kicked off runtime somehow, I'm happy.
>>
>> -Eric
>>
>
> That makes sense to me. =A0Most enterprise servers will go without re=
mounting
> a file system for (hopefully!) a very long time.
>
> It is really important to keep in mind that this is not just a laptop
> feature for laptop SSD's, this is also used by high end arrays and *c=
ould*
> be useful for virt IO, etc as well :-)
>
> ric

I'm not arguing that a runtime solution is not needed.

I'm arguing that at least for SSD backed filesystems Mark's userspace
implementation shows how the mount time initialization of the runtime
bitmap can be accomplished in a few seconds by leveraging the hardware
and using vector'ed trims as opposed to having to build an additional
on-disk structure.

At least for SSDs, the primary purpose of the proposed on-disk
structure seems to be to overcome the current lack of a vector'ed
discard implementation.

If it is too difficult to implement a fully functional vector'ed
discard in the block layer due to locking issues, possibly a special
purpose version could be written that is only used at mount time when
one can be assured no other i/o is occurring to the filesystem.

James,

The ATA-8 spec. supports vectored trims and requires a minimum of 255
sectors worth of range payload be supported.  That equates to a single
trim being able to trim thousands of ranges in one command.

Mark Lord has benchmarked in found a vectored trim to be drastically
faster than calling trim individually for each of those ranges.

Does scsi support vector'ed discard? (ie. write-same commands)

Or are high-end scsi arrays so fast they can process tens of thousands
of discard commands in a reasonable amount of time, unlike the SSDs
have so far proven to do.

It would be interesting to find out that a SSD can discard thousands
of ranges drastically faster than a high-end scsi device can.  But if
true, that might argue for the on-disk bitmap to track previously
discarded blocks/extents.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
