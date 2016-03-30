From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [oss-security] CVE Request - Linux kernel (multiple versions)
 ext2/ext3  filesystem DoS
Date: Wed, 30 Mar 2016 16:43:04 -0400
Message-ID: <20160330204304.GD6207@thunk.org>
References: <f4df42b35dd9a6c8c6851eba66b2b3f1.squirrel@webmail-etu.univ-nantes.fr>
 <1459286067.2596.18.camel@debian.org>
 <57514A3C-DBAD-4E5E-98EA-23E490629C02@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yves-Alexis Perez <corsac@debian.org>,
	oss-security@lists.openwall.com, Theodore Tso <tytso@google.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49206 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbcC3UnT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Mar 2016 16:43:19 -0400
Content-Disposition: inline
In-Reply-To: <57514A3C-DBAD-4E5E-98EA-23E490629C02@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 29, 2016 at 04:56:11PM -0600, Andreas Dilger wrote:
> On Mar 29, 2016, at 3:14 PM, Yves-Alexis Perez <corsac@debian.org> wr=
ote:
> >=20
> > [dropping MITRE from CC since it's not about the CVE]
> > [adding ext and Theodore to CC]
> >=20
> > On mar., 2016-03-29 at 19:24 +0200, Hugues ANGUELKOV wrote:
> >> Hello,
> >>=20
> >> The linux kernel is prone to a Denial of service when mounting spe=
cially
> >> crafted ext2/ext3 (possibly ext4) filesystems. This occurs in the =
function
> >> ext4_handle_error who call the panic function on precise circumsta=
nce.
> >=20
> > Did you contact the upstream maintainers about this? I'm adding the=
m just in
> > case they're not already aware of that=E2=80=A6
> >=20
> >> This was tested on severals linux kernel version: 3.10, 3.18, 3.19=
, on
> >> real hardware and Xen DomU PV & HVM (the crash report attached is =
from a
> >> Fedora 3.18 PV DomU), from different distribution release: Ubuntu,=
 CentOS,
> >> Fedora, Linux Mint, QubesOS.
> >> This a low security impact bug, because generally only root can mo=
unt
> >> image, however on Desktop (or possibly server?) system configured =
with
> >> automount the bug is easily triggable (think of android smartphone=
? Haven't
> >> test yet).
>=20
> It seems that the important point here is that the filesystem has
> "s_errors=3DEXT4_ERRORS_PANIC" set in the superblock?  I don't think
> the actual corruption that triggered the ext4_error() call is importa=
nt,
> since there are any number of other failure cases that could generate
> a similar error.
>=20
> It seems practical to change s_errors at mount time from EXT4_ERRORS_=
PANIC
> to EXT4_ERRORS_RO for filesystems mounted by regular users.  The ques=
tion
> is whether there is a way for the ext4 code to know this at mount tim=
e?

You can mount the file system with "mount -o errors=3Dcontinue" and thi=
s
will override the default behavior specified in the super block.

I would argue that a Desktop or server system that had automount
should either (a) mount with -o errors=3Dcontinue, or (b) force an fsck
on the file system before mounting it.

So I think this is a particularly meaningless CVE, which is why I have
zero respect for people who try to make any kind of conclusion based
on CVE counts.   I certainly don't plan to do anything about this.

You might as well complain that since the system ships with a reboot
command that can be executed by a clueless root user, that this is a
potential DOS attack scenario deserving of a CVE....

	      	     	      		   - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
