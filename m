From: Richard Weinberger <richard@nod.at>
Subject: Re: [uml-devel] Issues with a rather unusual configured NFS server
Date: Fri, 30 Aug 2013 16:36:23 +0200
Message-ID: <5220ADE7.1010502@nod.at>
References: <52075E01.7030506@gmx.de> <20130812143640.GF4596@quack.suse.cz> <20130813215313.GH17781@fieldses.org> <20130827180655.GE14809@fieldses.org> <521E318C.7040401@gmx.de> <CAFLxGvyK5+nB9TgW1uPho9KGwQrWQHx=wEpj+o-mZcN92bWAOg@mail.gmail.com> <20130829133010.GA14773@fieldses.org> <5220A7E2.1070704@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
	Linux NFS mailing list <linux-nfs@vger.kernel.org>,
	"J. Bruce Fields" <bfields@redhat.com>,
	"user-mode-linux-devel@lists.sourceforge.net"
	<user-mode-linux-devel@lists.sourceforge.net>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5220A7E2.1070704@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am 30.08.2013 16:10, schrieb Toralf F=C3=B6rster:
> On 08/29/2013 03:30 PM, J. Bruce Fields wrote:
>> On Thu, Aug 29, 2013 at 11:57:45AM +0200, richard -rw- weinberger wr=
ote:
>>> On Wed, Aug 28, 2013 at 7:21 PM, Toralf F=C3=B6rster <toralf.foerst=
er@gmx.de> wrote:
>>>> On 08/27/2013 08:06 PM, J. Bruce Fields wrote:
>>>>> On Tue, Aug 13, 2013 at 05:53:14PM -0400, bfields wrote:
>>>>>> On Mon, Aug 12, 2013 at 04:36:40PM +0200, Jan Kara wrote:
>>>>>>> On Sun 11-08-13 11:48:49, Toralf F=C3=B6rster wrote:
>>>>>>>> so that the server either crashes (if it is a user mode linux =
image) or at least its reboot functionality got broken
>>>>>>>> - if the NFS server is hammered with scary NFS calls using a f=
uzzy tool running at a remote NFS client under a non-privileged user id=
=2E
>>>>>>>>
>>>>>>>> It can re reproduced, if
>>>>>>>>    - the NFS share is an EXT3 or EXT4 directory
>>>>>>>>    - and it is created at file located at tempfs and mounted v=
ia loop device
>>>>>>>>    - and the NFS server is forced to umount the NFS share
>>>>>>>>    - and the server forced to restart the NSF service afterwar=
ds
>>>>>>>>    - and trinity is used
>>>>>>>>
>>>>>>>> I could find a scenario for an automated bisect. 2 times it br=
ought this commit
>>>>>>>> commit 68a3396178e6688ad7367202cdf0af8ed03c8727
>>>>>>>> Author: J. Bruce Fields <bfields@redhat.com>
>>>>>>>> Date:   Thu Mar 21 11:21:50 2013 -0400
>>>>>>>>
>>>>>>>>     nfsd4: shut down more of delegation earlier
>>>>>>
>>>>>> Thanks for the report.  I think I see the problem--after this co=
mmit
>>>>>> nfs4_set_delegation() failures result in nfs4_put_delegation bei=
ng
>>>>>> called, but nfs4_put_delegation doesn't free the nfs4_file that =
has
>>>>>> already been set by alloc_init_deleg().
>>>>>>
>>>>>> Let me think about how to fix that....
>>>>>
>>>>> Sorry for the slow response--can you check whether this fixes the
>>>>> problem?
>>>>>
>>>> Yes.
>>>>
>>>> With the attached patch the problem can't be reproduced any longer=
 with
>>>> the prepared test case and current git kernels.
>>>
>>> BTW: Is nobody else fuzz testing NFS?
>>
>> I don't know.  Toralf's reports are the only ones I recall off the t=
op
>> of my head, but I may have forgotten others.
>>
>=20
> well, 7255e71 and 3c50ba8 I'd say.
>=20
>>> Or are these bugs just more likely to hit on UML?
>=20
> This definitely not. I observed at a real system EXT4 corruptions/
> issues but reported them to the EXT4 mailing list.
> It just took me a longer time to figure out a reliable configuration
> with 2 UML machiens to automatic bisect it.
>=20
>=20
>> That's also possible.
>>
>>> This is not the first NFS issue found by Toralf using UML and Trini=
ty.
>>
>> Yep.  The testing is definitely appreciated.
>=20
> Thx - in the mean while although my UML bisect scripts are working fi=
ne
> and trinity is stable enough even in UML environments to be trust wor=
th.

That's good to know.
Thanks you and trinity we got rid of some nasty UML bugs.

Thanks,
//richard
