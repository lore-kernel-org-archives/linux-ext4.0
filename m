From: "gnehzuil.liu" <gnehzuil.liu@gmail.com>
Subject: Re: EXT4 corruption on Linus latest tree.
Date: Thu, 28 Feb 2013 01:07:10 +0800
Message-ID: <3F9FDA73-A142-43FB-BFF2-35C200355736@gmail.com>
References: <20130227154311.GA12450@redhat.com> <20130227155539.GA2638@pd.tnic> <20130227160446.GA4792@redhat.com> <20130227164417.GF5609@thunk.org> <20130227165621.GA8834@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, Borislav Petkov <bp@alien8.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Dave Jones <davej@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130227165621.GA8834@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

=D4=DA 2013-2-28=A3=AC=C9=CF=CE=E712:56=A3=ACDave Jones <davej@redhat.c=
om> =D0=B4=B5=C0=A3=BA

> On Wed, Feb 27, 2013 at 11:44:17AM -0500, Theodore Ts'o wrote:
>> On Wed, Feb 27, 2013 at 11:04:46AM -0500, Dave Jones wrote:
>>>>> EXT4-fs error (device sdb1): htree_dirblock_to_tree:919: inode #1=
72235804: block 152052301: comm ls: bad entry in directory: rec_len is =
smaller than minimal - offset=3D0(0), inode=3D0, rec_len=3D0, name_len=3D=
0
>>>=20
>>> Yeah, looks similar.  The missing files/dirs reappeared when I
>>> booted an older kernel, so it looks like the corruption doesn't
>>> hit the disk.  Fsck (1.42.5) didn't find anything either.
>>=20
>> I suspect I see the problem...   can you send me the results of=20
>>=20
>>  debugfs -R "stat <172235804>" /dev/sdb1
>>=20
>> to confirm?
>=20
> debugfs 1.42.5 (29-Jul-2012)
> Inode: 172235804   Type: directory    Mode:  0775   Flags: 0x80000
> Generation: 1174354732    Version: 0x00000000:00000055
> User:  1000   Group:  1000   Size: 4096
> File ACL: 0    Directory ACL: 0
> Links: 24   Blockcount: 8
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x512d0fdc:71fe3000 -- Tue Feb 26 14:41:16 2013
> atime: 0x512d106e:5a143300 -- Tue Feb 26 14:43:42 2013
> mtime: 0x512d0fdc:71fe3000 -- Tue Feb 26 14:41:16 2013
> crtime: 0x50e76c35:1d69aad8 -- Fri Jan  4 18:56:37 2013
> Size of extra inode fields: 28
> Extended attributes stored in inode body:=20
>  selinux =3D "unconfined_u:object_r:file_t:s0\000" (32)
> EXTENTS:
> (0):688923213
>=20
>=20
> That took about 2 minutes to run btw, expected ?

Hi Dave and Ted,

Thanks for the report.  From the result, I think extent status tree is =
root cause because of wrong logical-to-physical block mapping.  I am ve=
ry sorry about that.  I will try to fix the bug ASAP.

Ted, I am not sure whether we need to revert the patch or give me somet=
imes to fix it.

Thanks!!
                                                - Zheng--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
