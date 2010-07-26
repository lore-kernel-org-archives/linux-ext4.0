From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH 4/8] e2fsprogs: Next3 snapshot control with chattr/lsattr
	-X
Date: Mon, 26 Jul 2010 11:01:52 +0300
Message-ID: <AANLkTi=oMJE1RYmgwPxo8s7mZH7zwUtOAUyF1O3kaemP@mail.gmail.com>
References: <1F7FAC7E-3FCF-4E32-922D-02E7A068CC50@oracle.com>
	<AANLkTilBJHoIUxbOI1RpBtBXLulcuv8VrSe6Vhwxegli@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <andreas.dilger@oracle.com>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35148 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0GZIBz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jul 2010 04:01:55 -0400
Received: by bwz1 with SMTP id 1so2620669bwz.19
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2010 01:01:53 -0700 (PDT)
In-Reply-To: <AANLkTilBJHoIUxbOI1RpBtBXLulcuv8VrSe6Vhwxegli@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 22, 2010 at 11:56 AM, Amir G.
<amir73il@users.sourceforge.net> wrote:
> On Mon, Jun 21, 2010 at 9:17 PM, Andreas Dilger
> <andreas.dilger@oracle.com> wrote:
>>> +static struct flags_name snapshot_flags_array[] =3D {
>>> + =A0 =A0 { NEXT3_SNAPFILE_LIST_FL, "S", "on_liSt" },
>>> + =A0 =A0 { NEXT3_SNAPFILE_ENABLED_FL, "n", "eNabled" },
>>> + =A0 =A0 { NEXT3_SNAPFILE_ACTIVE_FL, "a", "Active" },
>>> + =A0 =A0 { NEXT3_SNAPFILE_INUSE_FL, "p", "inuse_by_Previous" },
>>> + =A0 =A0 { NEXT3_SNAPFILE_DELETED_FL, "s", "Deleted" },
>>> + =A0 =A0 { NEXT3_SNAPFILE_SHRUNK_FL, "h", "sHrunk" },
>>> + =A0 =A0 { NEXT3_SNAPFILE_OPEN_FL, "o", "mOunted" },
>>> + =A0 =A0 { NEXT3_SNAPFILE_TAGGED_FL, "t", "Tagged" },
>>> =A0 =A0 =A0 { 0, NULL, NULL }
>>> =A0};
>>
>> While clever, I don't think this necessarily makes for a good user i=
nterface.
>> In comparison, flags "l, e, a, i, d, s, m ,t" respectively make much=
 easier to understand/remember name abbreviations.
>>
>

=46YI, I've just resent the snapshot control patch.
The 'leaidsmt' flags where added to Andreas's request.
Those are the default flags when lssnap/chsnap (symlinks to
lsattr/chattr) are invoked.
The 'Snapshot' flags are still supported when lssnap/chsnap -X (or
lsattr/chattr -X) are invoked.

here is the usage of chsnap:
# chsnap
Usage: ./misc/chsnap [-+=3Dlet] snapshot files...
Usage: ./misc/chsnap -X [-+=3DSnt] snapshot files...


>
> As for chattr -X flags, I intend to eliminate those altogether.
> As Ted suggested, controlling the 'n' flag, will no longer be needed,
> once auto-enable is implemented.
> Instead of controlling the 'S' flag for snapshot take/delete, 'take'
> will be invoked automatically on create()
> of file in a snapshots directory and 'delete' will be invoked on
> attempt to unlink() a snapshot file.
>
> See new API design at:
> http://sourceforge.net/apps/mediawiki/next3/index.php?title=3DUser-ke=
rnel_API
>

I still didn't get around to implementing the new API,
so for now lssnap/chsnap are still using unused bits in the
GETFLAGS/SETFLAGS ioctl
to control/view snapshot status flags.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
