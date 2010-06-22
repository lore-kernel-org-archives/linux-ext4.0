From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH 4/8] e2fsprogs: Next3 snapshot control with chattr/lsattr
	-X
Date: Tue, 22 Jun 2010 11:56:24 +0300
Message-ID: <AANLkTilBJHoIUxbOI1RpBtBXLulcuv8VrSe6Vhwxegli@mail.gmail.com>
References: <1F7FAC7E-3FCF-4E32-922D-02E7A068CC50@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Amir Goldstein <amir73il@users.sf.net>,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <andreas.dilger@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48993 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab0FVI40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jun 2010 04:56:26 -0400
Received: by bwz7 with SMTP id 7so1290136bwz.19
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jun 2010 01:56:25 -0700 (PDT)
In-Reply-To: <1F7FAC7E-3FCF-4E32-922D-02E7A068CC50@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 21, 2010 at 9:17 PM, Andreas Dilger
<andreas.dilger@oracle.com> wrote:
>> +static struct flags_name snapshot_flags_array[] =3D {
>> + =A0 =A0 { NEXT3_SNAPFILE_LIST_FL, "S", "on_liSt" },
>> + =A0 =A0 { NEXT3_SNAPFILE_ENABLED_FL, "n", "eNabled" },
>> + =A0 =A0 { NEXT3_SNAPFILE_ACTIVE_FL, "a", "Active" },
>> + =A0 =A0 { NEXT3_SNAPFILE_INUSE_FL, "p", "inuse_by_Previous" },
>> + =A0 =A0 { NEXT3_SNAPFILE_DELETED_FL, "s", "Deleted" },
>> + =A0 =A0 { NEXT3_SNAPFILE_SHRUNK_FL, "h", "sHrunk" },
>> + =A0 =A0 { NEXT3_SNAPFILE_OPEN_FL, "o", "mOunted" },
>> + =A0 =A0 { NEXT3_SNAPFILE_TAGGED_FL, "t", "Tagged" },
>> =A0 =A0 =A0 { 0, NULL, NULL }
>> =A0};
>
> While clever, I don't think this necessarily makes for a good user in=
terface.
> In comparison, flags "l, e, a, i, d, s, m ,t" respectively make much =
easier to understand/remember name abbreviations.
>

I must show you the beauty of the 'S','n','a','p','s','h','o','t'
flags, because I grew very fond of them.
Here is a list of 4 snapshots for example:

Snapshots list:
id inode attributes disk-usage mtime filename
---------------------------------------------
44 277994 Snap--o- 7.3M Jun 14 16:50 /var/vol/2/.ctera/snapshots/4
43 277993 S--psh-- 12.0K Jun 14 16:50 /var/vol/2/.ctera/snapshots/3
42 277992 ----sh-- 0 Jun 14 16:50 /var/vol/2/.ctera/snapshots/2
41 277991 Sn----o- 1.2M Jun 14 16:50 /var/vol/2/.ctera/snapshots/1
=2E

The capital S is a graphical representation of the snapshots list chain=
s
(snapshot 2 was removed from the list after all its blocks were merged
into snapshot 1).

Both snapshots 2 and 3 were SHrunk, which is represented by the flag pa=
ir 'sh'
(the flag 's' alone represents a temporary transitional state before 's=
h').

Both snapshots files 1 and 4 have been Opened by losetup (i.e., mounted=
).
BTW, Ted has suggested to combine the 'n' and 'o' flags (i.e.,
auto-enable on open).

When the snapshot list is sorted by snapshot id, as the script command
'snapshot status' does,
the 'p' flags graphically points towards a previous enabled snapshot,
which is a dependency of this snapshot
(snapshot 4 and snapshot 3 blocks are accessed by mounted snapshot 1 re=
aders)

So far for lsattr -X flags.
As for chattr -X flags, I intend to eliminate those altogether.
As Ted suggested, controlling the 'n' flag, will no longer be needed,
once auto-enable is implemented.
Instead of controlling the 'S' flag for snapshot take/delete, 'take'
will be invoked automatically on create()
of file in a snapshots directory and 'delete' will be invoked on
attempt to unlink() a snapshot file.

See new API design at:
http://sourceforge.net/apps/mediawiki/next3/index.php?title=3DUser-kern=
el_API

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
