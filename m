From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [uml-devel] Issues with a rather unusual configured NFS server
Date: Fri, 30 Aug 2013 16:10:42 +0200
Message-ID: <5220A7E2.1070704@gmx.de>
References: <52075E01.7030506@gmx.de> <20130812143640.GF4596@quack.suse.cz> <20130813215313.GH17781@fieldses.org> <20130827180655.GE14809@fieldses.org> <521E318C.7040401@gmx.de> <CAFLxGvyK5+nB9TgW1uPho9KGwQrWQHx=wEpj+o-mZcN92bWAOg@mail.gmail.com> <20130829133010.GA14773@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: richard -rw- weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Linux NFS mailing list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org"
	<user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>,
	Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130829133010.GA14773-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 08/29/2013 03:30 PM, J. Bruce Fields wrote:
> On Thu, Aug 29, 2013 at 11:57:45AM +0200, richard -rw- weinberger wro=
te:
>> On Wed, Aug 28, 2013 at 7:21 PM, Toralf F=C3=B6rster <toralf.foerste=
r@gmx.de> wrote:
>>> On 08/27/2013 08:06 PM, J. Bruce Fields wrote:
>>>> On Tue, Aug 13, 2013 at 05:53:14PM -0400, bfields wrote:
>>>>> On Mon, Aug 12, 2013 at 04:36:40PM +0200, Jan Kara wrote:
>>>>>> On Sun 11-08-13 11:48:49, Toralf F=C3=B6rster wrote:
>>>>>>> so that the server either crashes (if it is a user mode linux i=
mage) or at least its reboot functionality got broken
>>>>>>> - if the NFS server is hammered with scary NFS calls using a fu=
zzy tool running at a remote NFS client under a non-privileged user id.
>>>>>>>
>>>>>>> It can re reproduced, if
>>>>>>>    - the NFS share is an EXT3 or EXT4 directory
>>>>>>>    - and it is created at file located at tempfs and mounted vi=
a loop device
>>>>>>>    - and the NFS server is forced to umount the NFS share
>>>>>>>    - and the server forced to restart the NSF service afterward=
s
>>>>>>>    - and trinity is used
>>>>>>>
>>>>>>> I could find a scenario for an automated bisect. 2 times it bro=
ught this commit
>>>>>>> commit 68a3396178e6688ad7367202cdf0af8ed03c8727
>>>>>>> Author: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>>>> Date:   Thu Mar 21 11:21:50 2013 -0400
>>>>>>>
>>>>>>>     nfsd4: shut down more of delegation earlier
>>>>>
>>>>> Thanks for the report.  I think I see the problem--after this com=
mit
>>>>> nfs4_set_delegation() failures result in nfs4_put_delegation bein=
g
>>>>> called, but nfs4_put_delegation doesn't free the nfs4_file that h=
as
>>>>> already been set by alloc_init_deleg().
>>>>>
>>>>> Let me think about how to fix that....
>>>>
>>>> Sorry for the slow response--can you check whether this fixes the
>>>> problem?
>>>>
>>> Yes.
>>>
>>> With the attached patch the problem can't be reproduced any longer =
with
>>> the prepared test case and current git kernels.
>>
>> BTW: Is nobody else fuzz testing NFS?
>=20
> I don't know.  Toralf's reports are the only ones I recall off the to=
p
> of my head, but I may have forgotten others.
>=20

well, 7255e71 and 3c50ba8 I'd say.

>> Or are these bugs just more likely to hit on UML?

This definitely not. I observed at a real system EXT4 corruptions/
issues but reported them to the EXT4 mailing list.
It just took me a longer time to figure out a reliable configuration
with 2 UML machiens to automatic bisect it.


> That's also possible.
>=20
>> This is not the first NFS issue found by Toralf using UML and Trinit=
y.
>=20
> Yep.  The testing is definitely appreciated.

Thx - in the mean while although my UML bisect scripts are working fine
and trinity is stable enough even in UML environments to be trust worth=
=2E

>=20
> --b.
>=20


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
