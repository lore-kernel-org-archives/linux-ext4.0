From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [oss-security] CVE Request - Linux kernel (multiple versions)
 ext2/ext3 filesystem DoS
Date: Thu, 31 Mar 2016 09:41:28 -0500
Message-ID: <56FD3718.2090502@redhat.com>
References: <f4df42b35dd9a6c8c6851eba66b2b3f1.squirrel@webmail-etu.univ-nantes.fr>
 <1459286067.2596.18.camel@debian.org>
 <57514A3C-DBAD-4E5E-98EA-23E490629C02@dilger.ca>
 <20160330204304.GD6207@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yves-Alexis Perez <corsac@debian.org>,
	oss-security@lists.openwall.com, Theodore Tso <tytso@google.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbcCaOlb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Mar 2016 10:41:31 -0400
In-Reply-To: <20160330204304.GD6207@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/30/16 3:43 PM, Theodore Ts'o wrote:
> On Tue, Mar 29, 2016 at 04:56:11PM -0600, Andreas Dilger wrote:
>> On Mar 29, 2016, at 3:14 PM, Yves-Alexis Perez <corsac@debian.org> w=
rote:
>>>
>>> [dropping MITRE from CC since it's not about the CVE]
>>> [adding ext and Theodore to CC]
>>>
>>> On mar., 2016-03-29 at 19:24 +0200, Hugues ANGUELKOV wrote:
>>>> Hello,
>>>>
>>>> The linux kernel is prone to a Denial of service when mounting spe=
cially
>>>> crafted ext2/ext3 (possibly ext4) filesystems. This occurs in the =
function
>>>> ext4_handle_error who call the panic function on precise circumsta=
nce.
>>>
>>> Did you contact the upstream maintainers about this? I'm adding the=
m just in
>>> case they're not already aware of that=E2=80=A6
>>>
>>>> This was tested on severals linux kernel version: 3.10, 3.18, 3.19=
, on
>>>> real hardware and Xen DomU PV & HVM (the crash report attached is =
from a
>>>> Fedora 3.18 PV DomU), from different distribution release: Ubuntu,=
 CentOS,
>>>> Fedora, Linux Mint, QubesOS.
>>>> This a low security impact bug, because generally only root can mo=
unt
>>>> image, however on Desktop (or possibly server?) system configured =
with
>>>> automount the bug is easily triggable (think of android smartphone=
? Haven't
>>>> test yet).
>>
>> It seems that the important point here is that the filesystem has
>> "s_errors=3DEXT4_ERRORS_PANIC" set in the superblock?  I don't think
>> the actual corruption that triggered the ext4_error() call is import=
ant,
>> since there are any number of other failure cases that could generat=
e
>> a similar error.
>>
>> It seems practical to change s_errors at mount time from EXT4_ERRORS=
_PANIC
>> to EXT4_ERRORS_RO for filesystems mounted by regular users.  The que=
stion
>> is whether there is a way for the ext4 code to know this at mount ti=
me?
>=20
> You can mount the file system with "mount -o errors=3Dcontinue" and t=
his
> will override the default behavior specified in the super block.
>=20
> I would argue that a Desktop or server system that had automount
> should either (a) mount with -o errors=3Dcontinue, or (b) force an fs=
ck
> on the file system before mounting it.
>=20
> So I think this is a particularly meaningless CVE, which is why I hav=
e
> zero respect for people who try to make any kind of conclusion based
> on CVE counts.   I certainly don't plan to do anything about this.
>=20
> You might as well complain that since the system ships with a reboot
> command that can be executed by a clueless root user, that this is a
> potential DOS attack scenario deserving of a CVE....

=46irst of all, yes, I have always been extremely skeptical of these
"crafted image" CVEs.  However, I'm not sure the "store errors=3Dpanic
in the superblock" was particularly well thought out either; it certain=
ly
does make for a tidy little timebomb.

While I really hate to give issues such as this a whole lot more
credibility, I wonder about a higher level control, such as a sysctl,
which could [dis]allow errors=3Dpanic at a system-wide level.  It could=
 default
to disallowing, and it's trivial to set it in sysctl.conf if you really
want it enabled by default.

In the end, errors=3Dpanic is really a debug option; a small hoop-jump =
to
use it doesn't sound too bad to me.

-Eric



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
