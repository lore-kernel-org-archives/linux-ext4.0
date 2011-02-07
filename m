From: Matt <jackdachef@gmail.com>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
Date: Mon, 7 Feb 2011 18:44:14 +0000
Message-ID: <AANLkTi=MPYjU4W4Zz=ajDeRAVoHCg+K68bNopgxf+DoE@mail.gmail.com>
References: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com>
	<20110207174552.GC3457@thunk.org>
	<4D503A06.3010403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D503A06.3010403@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Feb 7, 2011 at 6:29 PM, Milan Broz <mbroz@redhat.com> wrote:
> On 02/07/2011 06:45 PM, Ted Ts'o wrote:
>> On Fri, Feb 04, 2011 at 10:40:47PM +0000, Matt wrote:
>>>
>>> So that means that the file-corruption which existed until 2.6.37-r=
c6
>>> and got triggered (for me) more easily via "dm crypt: scale to
>>> multiple CPUs"
>>> is fixed now ?
>>
>> Well, a patch exists for it that will be merged into 2.6.38.
>>
>>> That should give ext4 a nice speedup for >=3D2.6.38 :)
>>
>> I'm not going to make it be the default for 2.6.38, since it's fairl=
y
>> late in the -rc features. =A0People who want it can explicitly enabl=
e it
>> using the mount option mblk_io_submit, though. =A0(And let me know y=
our
>> success stories! =A0:-) I will be enabling it as the default in
>> 2.6.39-rc1.
>
> So it was ext4 only bug in ext4_end_bio(),
> dm-crypt per-cpu code was just trigger here, right?
>
> Milan
>

Hi Milan,

Well, that was at least the experience that I made

ext4: after Ted had disabled support for multiple page-io submission

I observed no data-corruption anymore (it had only appeared on the
system-partition, /home - where ext4 also is used or on my backup
partitions there was also no problem as far as I can tell)

XFS: no corruption observed

reiserfs: I can't say for sure since I'm only using it on my /boot part=
ition :P

for other filesystems I can't say anything - I didn't use additional
ones at that time

Regards

Matt
