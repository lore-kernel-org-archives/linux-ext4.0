From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systems
Date: Mon, 5 May 2014 19:50:49 +0200
Message-ID: <20140505175049.GA29151@x2.net.home>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu>
 <1399295044-24489-2-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405051541080.2223@localhost.localdomain>
 <20140505140401.GD22287@thunk.org>
 <20140505142808.GF22287@thunk.org>
 <alpine.LFD.2.00.1405051629270.2223@localhost.localdomain>
 <20140505144423.GG22287@thunk.org>
 <alpine.LFD.2.00.1405051649050.2223@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405051649050.2223@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 05, 2014 at 04:51:25PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Mon, 5 May 2014, Theodore Ts'o wrote:
> > What we would need to do is file a feature request in the other fil=
e
> > systems to save this information, and then add proper support for t=
o
> > pass this information from the VFS layer into the struct
> > super_operations's mount function, which would be the proper, sane =
way
> > to provide this functionality.
> >=20
> > 						- Ted
>=20
> Which would be reasonable if there was a consumer of such
> information and it seemed to be useful. So I wonder what other
> people think about that.
>=20
> Karel, you had some suggestions about how to utilize that aside from
> the mkfs...

 It's really simple to add another NAME=3Dvalue to the low-level part o=
f
 the libblkid (used to feed udev db). The question is how usable will
 that, I can imagine:

   1) audit / logging purpose
   2) mount <device> --last-target
   3) automount (for example udisks and removable media)

 unfortunately 2) and 3) seem fragile as the filesystem superblocks
 have no clue about namespaces and the same filesystem is possible to
 mount in the same time to more places, etc.
=20
 BTW, the current trend is to use GPT partition types to identify
 purpose of the partition filesystem (for example extra GUID for
 /home). It's FS independent solution and it allows use the right
 filesystems for the right mountpoints. It's very attractive for
 example for virtual images where you don't have to setup fstab and
 identify FS, but you still have (for example) /home on the right
 place.

     Karel


--=20
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
