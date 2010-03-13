From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsck doesn't repair broken ext4
Date: Fri, 12 Mar 2010 18:03:57 -0600
Message-ID: <4B9AD66D.1070802@redhat.com>
References: <20100312205435.GG32664@alea.gnuu.de> <4B9AC90D.6040904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932786Ab0CMAEJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Mar 2010 19:04:09 -0500
In-Reply-To: <4B9AC90D.6040904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> J=F6rg Sommer wrote:
>> Hi,
>>
>> after a system crash, I had a problem with ext4 that e2fsck didn't f=
ix. I
>> don't know if e2fsck or ext4 was wrong. In the end, I had to remove =
the
>> broken directory, which succeed and solved my problem.
>>
>> These are the steps I did:
>>
>> 01 % e2fsck -fy /dev/root
>> 02 % dumpe2fsck -x /dev/root
>> 03 % e2image -r /dev/root
>=20
> Great, thanks for gathering the images.
>=20
> What version of e2fsprogs were you using?

Ok never mind on that.  recent release has the same problem.

so this is 2.6.33-rc7 ...

you had:

[  347.673207] EXT4-fs error (device hda4): make_indexed_dir: invalid r=
ec_len for '..' in inode 425166
(wish we'd print out the actual bad rec_len there ...)

# mount -o loop 03-e2image-r  mount/
# find mount/ -inum 425166
# mount/usr/share/ri/1.8/system/String
# touch mount/usr/share/ri/1.8/system/String/foobar
touch: cannot touch `mount/usr/share/ri/1.8/system/String/foobar': Inpu=
t/output error
# dmesg | tail -n 1
EXT4-fs error (device loop0): make_indexed_dir: invalid rec_len for '..=
' in inode 425166
# debugfs 03-e2image-r

debugfs:  ls -l <425166>
 425166   40755 (2)      0      0    4096 11-Mar-2010 05:37 .
 424052   40755 (2)      0      0    4096  1-Feb-2010 16:53 ..
      0       0 (2)      0      0       0                   ..
      0       0 (2)      0      0       0                   .
 426379  100644 (1)      0      0    8494 10-Jan-2010 09:01 cdesc-Strin=
g.yaml
 426380  100644 (1)      0      0     293 10-Jan-2010 09:01 new-c.yaml
=2E..

Not sure what's going on with the duplicate 0-inode entries there yet.

-Eric

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
