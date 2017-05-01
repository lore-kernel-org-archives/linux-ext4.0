From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Add largedir feature
Date: Mon, 1 May 2017 17:39:41 -0600
Message-ID: <2C3E39F6-8143-415F-B9D5-F3363BDEBC45@dilger.ca>
References: <1489657877-34478-1-git-send-email-artem.blagodarenko@seagate.com>
 <20170430005953.m74yjettitj7mzr6@thunk.org>
 <20170501185824.GB30027@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_FBCD78D6-6280-406D-9A27-6EC18AB4C1C9";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Yang Sheng <yang.sheng@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: Eric Biggers <ebiggers3@gmail.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:32982 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbdEAXjt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 May 2017 19:39:49 -0400
Received: by mail-it0-f67.google.com with SMTP id z67so135372itb.0
        for <linux-ext4@vger.kernel.org>; Mon, 01 May 2017 16:39:48 -0700 (PDT)
In-Reply-To: <20170501185824.GB30027@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_FBCD78D6-6280-406D-9A27-6EC18AB4C1C9
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_D6647E66-0FEC-4CC5-96FD-DA0E836548EE"


--Apple-Mail=_D6647E66-0FEC-4CC5-96FD-DA0E836548EE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 1, 2017, at 12:58 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
>=20
> On Sat, Apr 29, 2017 at 08:59:53PM -0400, Theodore Ts'o wrote:
>> On Thu, Mar 16, 2017 at 05:51:17AM -0400, Artem Blagodarenko wrote:
>>> From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
>>>=20
>>> This INCOMPAT_LARGEDIR feature allows larger directories to be =
created
>>> in ldiskfs, both with directory sizes over 2GB and and a maximum =
htree
>>> depth of 3 instead of the current limit of 2. These features are =
needed
>>> in order to exceed the current limit of approximately 10M entries in =
a
>>> single directory.
>>>=20
>>> Signed-off-by: Yang Sheng <yang.sheng@intel.com>
>>> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>>=20
>> Thanks, applied.
>>=20
>> 					- Ted
>=20
> FYI, this patch is causing a problem when creating many files in a =
directory
> (without the largedir feature enabled).  I haven't looked into it but =
maybe it
> will ring a bell for someone.

Hmm, is this also a problem without the patch, when creating large =
numbers
of entries in a directory?

It looks like the directory index is clobbering the directory index =
block
checksum, which is stored in struct ext2_dx_tail at the end of each =
index
block.  One possibility is that the patch is miscalculating the maximum
number of entries in the index blocks when the metadata_csum feature is
enabled?  I don't think that feature is enabled by default with =
e2fsprogs
yet, so it is entirely possible that these two features aren't quite =
playing
nice together in the sandbox.

That said, I looked through the patch again with this in mind, and I =
don't
see anything related to the dx_limit.  The dx_node_limit() function =
correctly
takes the metadata_csum feature into account when calculating the limit =
of
the htree entries in interior index blocks, so it isn't clear where this
checksum error is coming from.

It might be useful to print out the checksum values, just in case e.g. =
this
is being checked on a block that was just zeroed out?

Alternately, it might be that we are not initializing the checksum =
properly
in the first place?  Looking at it from this angle, I see what could be =
a
problem.  Can you try out the following (untested) patch (also attached =
in
case of mangling)?  I'm not totally sure it is correct, since the change =
from
ext4_handle_dirty_metadata() to ext4_handle_dirty_dx_block() could =
potentially
be ext4_handle_dirty_dirent_block(), but I _think_ the current change is =
right.

There is also a separate question of whether we need to dirty ALL of the =
buffers
in this code, compared to the pre-patch changes which had fewer calls to =
dirty
buffers, but at least this patch should fix the checksum errors.

Cheers, Andreas
----
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index bd189c04..f0e8a6c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2309,21 +2309,23 @@ static int ext4_dx_add_entry(handle_t *handle,
 			dx_insert_block((frame - 1), hash2, newblock);
 			dxtrace(dx_show_index("node", frame->entries));
 			dxtrace(dx_show_index("node",
-				((struct dx_node *) =
bh2->b_data)->entries));
+				((struct dx_node =
*)bh2->b_data)->entries));
 			err =3D ext4_handle_dirty_dx_node(handle, dir, =
bh2);
 			if (err)
 				goto journal_error;
-			brelse (bh2);
-			ext4_handle_dirty_metadata(handle, dir,
-						   (frame - 1)->bh);
+			brelse(bh2);
+			err =3D ext4_handle_dirty_dx_node(handle, dir,
+							(frame - =
1)->bh);
+			if (err)
+				goto journal_error;
 			if (restart) {
-				ext4_handle_dirty_metadata(handle, dir,
-							   frame->bh);
-				goto cleanup;
+				err =3D =
ext4_handle_dirty_dirty_dx_node(handle,
+								dir, =
frame->bh);
+				goto journal_error;
 			}
-		} else {
+		} else /* add_level */ {
 			struct dx_root *dxroot;
-			memcpy((char *) entries2, (char *) entries,
+			memcpy((char *)entries2, (char *)entries,
 			       icount * sizeof(struct dx_entry));
 			dx_set_limit(entries2, dx_node_limit(dir));

@@ -2335,15 +2337,13 @@ static int ext4_dx_add_entry(handle_t *handle,
 			dxtrace(printk(KERN_DEBUG
 				       "Creating %d level index...\n",
 				       info->indirect_levels));
-			ext4_handle_dirty_metadata(handle, dir, =
frame->bh);
-			ext4_handle_dirty_metadata(handle, dir, bh2);
+			err =3D ext4_handle_dirty_dx_node(handle, dir, =
frame->bh);
+			if (err)
+				goto journal_error;
+			err =3D ext4_handle_dirty_dx_node(handle, dir, =
bh2);
 			brelse(bh2);
 			restart =3D 1;
-			goto cleanup;
-		}
-		if (err) {
-			ext4_std_error(inode->i_sb, err);
-			goto cleanup;
+			goto journal_error;
 		}
 	}
 	de =3D do_split(handle, dir, &bh, frame, &fname->hinfo);
@@ -2355,7 +2355,7 @@ static int ext4_dx_add_entry(handle_t *handle,
 	goto cleanup;

 journal_error:
-	ext4_std_error(dir->i_sb, err);
+	ext4_std_error(dir->i_sb, err); /* this is a no-op if err =3D=3D =
0 */
 cleanup:
 	brelse(bh);
 	dx_release(frames);


> seq -f "abcdefghijklmnopqrstuvwxyz012345%.0f" 100000 | xargs touch
>=20
> [   42.726480] EXT4-fs error (device vdc): dx_probe:840: inode #2: =
block 508: comm touch: Directory index failed checksum
> [   42.729472] EXT4-fs error (device vdc): dx_probe:840: inode #2: =
block 508: comm touch: Directory index failed checksum
> [   42.731689] EXT4-fs error (device vdc): dx_probe:840: inode #2: =
block 508: comm touch: Directory index failed checksum
> [   42.734303] EXT4-fs error (device vdc): dx_probe:840: inode #2: =
block 508: comm touch: Directory index failed checksum
> [   42.736383] EXT4-fs error (device vdc): dx_probe:840: inode #2: =
block 508: comm touch: Directory index failed checksum
> [   42.739133] EXT4-fs error (device vdc): dx_probe:840: inode #2: =
block 508: comm touch: Directory index failed checksum
> [   42.741307] EXT4-fs error (device vdc): dx_probe:840: inode #2: =
block 508: comm touch: Directory index failed checksum
> [   42.743963] EXT4-fs error (device vdc): dx_probe:840: inode #2: =
block 508: comm touch: Directory index failed checksum
> [   42.745998] EXT4-fs error (device vdc): dx_probe:840: inode #2: =
block 508: comm touch: Directory index failed checksum
> ...


Cheers, Andreas





--Apple-Mail=_D6647E66-0FEC-4CC5-96FD-DA0E836548EE
Content-Disposition: attachment;
	filename=0001-ext4-fix-large_dir-interaction-with-metadata_csum.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="0001-ext4-fix-large_dir-interaction-with-metadata_csum.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20103d130dfcdc05d9ba27a68e08325840ca877ffc=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Andreas=20Dilger=20<adilger@dilger.ca>=0ADate:=20=
Mon,=201=20May=202017=2017:28:55=20-0600=0ASubject:=20[PATCH]=20ext4:=20=
fix=20large_dir=20interaction=20with=20metadata_csum=0A=0AWhen=20=
dirtying=20htree=20directory=20index=20buffers,=20use=20the=20helper=20=
functions=0Afor=20metadata_csum=20so=20that=20the=20checksums=20are=20=
calculated=20correctly.=0A=0ASigned-off-by:=20Andreas=20Dilger=20=
<adilger@dilger.ca>=0A---=0A=20fs/ext4/namei.c=20|=2034=20=
+++++++++++++++++-----------------=0A=201=20file=20changed,=2017=20=
insertions(+),=2017=20deletions(-)=0A=0Adiff=20--git=20a/fs/ext4/namei.c=20=
b/fs/ext4/namei.c=0Aindex=20bd189c04..f0e8a6c=20100644=0A---=20=
a/fs/ext4/namei.c=0A+++=20b/fs/ext4/namei.c=0A@@=20-2309,21=20+2309,23=20=
@@=20static=20int=20ext4_dx_add_entry(handle_t=20*handle,=20struct=20=
ext4_filename=20*fname,=0A=20=09=09=09dx_insert_block((frame=20-=201),=20=
hash2,=20newblock);=0A=20=09=09=09dxtrace(dx_show_index("node",=20=
frame->entries));=0A=20=09=09=09dxtrace(dx_show_index("node",=0A-=09=09=09=
=20=20=20=20=20=20=20((struct=20dx_node=20*)=20bh2->b_data)->entries));=0A=
+=09=09=09=09=20=20=20=20=20((struct=20dx_node=20=
*)bh2->b_data)->entries));=0A=20=09=09=09err=20=3D=20=
ext4_handle_dirty_dx_node(handle,=20dir,=20bh2);=0A=20=09=09=09if=20=
(err)=0A=20=09=09=09=09goto=20journal_error;=0A-=09=09=09brelse=20(bh2);=0A=
-=09=09=09ext4_handle_dirty_metadata(handle,=20dir,=0A-=09=09=09=09=09=09=
=20=20=20(frame=20-=201)->bh);=0A+=09=09=09brelse(bh2);=0A+=09=09=09err=20=
=3D=20ext4_handle_dirty_dx_node(handle,=20dir,=0A+=09=09=09=09=09=09=09=
(frame=20-=201)->bh);=0A+=09=09=09if=20(err)=0A+=09=09=09=09goto=20=
journal_error;=0A=20=09=09=09if=20(restart)=20{=0A-=09=09=09=09=
ext4_handle_dirty_metadata(handle,=20dir,=0A-=09=09=09=09=09=09=09=20=20=20=
frame->bh);=0A-=09=09=09=09goto=20cleanup;=0A+=09=09=09=09err=20=3D=20=
ext4_handle_dirty_dirty_dx_node(handle,=0A+=09=09=09=09=09=09=09=09dir,=20=
frame->bh);=0A+=09=09=09=09goto=20journal_error;=0A=20=09=09=09}=0A-=09=09=
}=20else=20{=0A+=09=09}=20else=20/*=20add_level=20*/=20{=0A=20=09=09=09=
struct=20dx_root=20*dxroot;=0A-=09=09=09memcpy((char=20*)=20entries2,=20=
(char=20*)=20entries,=0A+=09=09=09memcpy((char=20*)entries2,=20(char=20=
*)entries,=0A=20=09=09=09=20=20=20=20=20=20=20icount=20*=20sizeof(struct=20=
dx_entry));=0A=20=09=09=09dx_set_limit(entries2,=20dx_node_limit(dir));=0A=
=20=0A@@=20-2335,15=20+2337,13=20@@=20static=20int=20=
ext4_dx_add_entry(handle_t=20*handle,=20struct=20ext4_filename=20*fname,=0A=
=20=09=09=09dxtrace(printk(KERN_DEBUG=0A=20=09=09=09=09=20=20=20=20=20=20=
=20"Creating=20%d=20level=20index...\n",=0A=20=09=09=09=09=20=20=20=20=20=
=20=20info->indirect_levels));=0A-=09=09=09=
ext4_handle_dirty_metadata(handle,=20dir,=20frame->bh);=0A-=09=09=09=
ext4_handle_dirty_metadata(handle,=20dir,=20bh2);=0A+=09=09=09err=20=3D=20=
ext4_handle_dirty_dx_node(handle,=20dir,=20frame->bh);=0A+=09=09=09if=20=
(err)=0A+=09=09=09=09goto=20journal_error;=0A+=09=09=09err=20=3D=20=
ext4_handle_dirty_dx_node(handle,=20dir,=20bh2);=0A=20=09=09=09=
brelse(bh2);=0A=20=09=09=09restart=20=3D=201;=0A-=09=09=09goto=20=
cleanup;=0A-=09=09}=0A-=09=09if=20(err)=20{=0A-=09=09=09=
ext4_std_error(inode->i_sb,=20err);=0A-=09=09=09goto=20cleanup;=0A+=09=09=
=09goto=20journal_error;=0A=20=09=09}=0A=20=09}=0A=20=09de=20=3D=20=
do_split(handle,=20dir,=20&bh,=20frame,=20&fname->hinfo);=0A@@=20-2355,7=20=
+2355,7=20@@=20static=20int=20ext4_dx_add_entry(handle_t=20*handle,=20=
struct=20ext4_filename=20*fname,=0A=20=09goto=20cleanup;=0A=20=0A=20=
journal_error:=0A-=09ext4_std_error(dir->i_sb,=20err);=0A+=09=
ext4_std_error(dir->i_sb,=20err);=09/*=20this=20is=20a=20no-op=20if=20=
err=20=3D=3D=200=20*/=0A=20cleanup:=0A=20=09brelse(bh);=0A=20=09=
dx_release(frames);=0A--=20=0A1.8.0=0A=0A=

--Apple-Mail=_D6647E66-0FEC-4CC5-96FD-DA0E836548EE--

--Apple-Mail=_FBCD78D6-6280-406D-9A27-6EC18AB4C1C9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZB8c/pIg59Q01vtYRAhFGAJ97ZZadxukSdI+T/k25YKseDTc5fQCfQ6CD
6u8lNw41C9/cAOhUU9c/5qw=
=Li9t
-----END PGP SIGNATURE-----

--Apple-Mail=_FBCD78D6-6280-406D-9A27-6EC18AB4C1C9--
