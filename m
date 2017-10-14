From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3] Fix typos in error messages and documentation.
Date: Sat, 14 Oct 2017 16:14:33 -0600
Message-ID: <648C10D0-5553-4969-ABA6-5482DFD27F62@dilger.ca>
References: <20171014184456.17602-1-sebras@gmail.com>
 <20171014184456.17602-2-sebras@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_68245B35-8943-44DA-92D1-E0F0CC0E9E0F";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Sebastian Rasmussen <sebras@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:51263 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751138AbdJNWOj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Oct 2017 18:14:39 -0400
Received: by mail-it0-f53.google.com with SMTP id o135so14263477itb.0
        for <linux-ext4@vger.kernel.org>; Sat, 14 Oct 2017 15:14:39 -0700 (PDT)
In-Reply-To: <20171014184456.17602-2-sebras@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_68245B35-8943-44DA-92D1-E0F0CC0E9E0F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 14, 2017, at 12:44 PM, Sebastian Rasmussen <sebras@gmail.com> =
wrote:
>=20
> Signed-off-by: Sebastian Rasmussen <sebras@gmail.com>

Thanks for the patch.  Documentation is the oft-overlooked corner of
software development, so it is nice when someone pays it some attention.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> contrib/android/perms.c         |  4 ++--
> debugfs/debugfs.8.in            |  2 +-
> debugfs/htree.c                 |  2 +-
> doc/libext2fs.texinfo           | 14 +++++++-------
> e2fsck/e2fsck.conf.5.in         |  8 ++++----
> e2fsck/revoke.c                 |  2 +-
> ext2ed/disk.c                   |  2 +-
> ext2ed/doc/ext2ed-design.sgml   | 12 ++++++------
> ext2ed/doc/ext2fs-overview.sgml |  8 ++++----
> ext2ed/doc/user-guide.sgml      |  6 +++---
> ext2ed/ext2.descriptors         |  2 +-
> ext2ed/general_com.c            |  4 ++--
> ext2ed/init.c                   |  6 +++---
> lib/blkid/libblkid.3.in         |  2 +-
> lib/e2p/e2p.pc.in               |  2 +-
> lib/et/com_err.texinfo          |  4 ++--
> lib/et/test_cases/heimdal2.c    |  2 +-
> lib/et/test_cases/heimdal2.et   |  2 +-
> lib/ext2fs/inline_data.c        |  6 +++---
> lib/uuid/uuid_compare.3.in      |  2 +-
> lib/uuid/uuid_generate.3.in     |  4 ++--
> misc/chattr.1.in                |  2 +-
> misc/mke2fs.8.in                |  2 +-
> misc/mke2fs.c                   |  2 +-
> misc/mke2fs.conf.5.in           |  2 +-
> resize/resize2fs.8.in           |  2 +-
> 26 files changed, 53 insertions(+), 53 deletions(-)
>=20
> diff --git a/contrib/android/perms.c b/contrib/android/perms.c
> index 08fb8614..b9b2463f 100644
> --- a/contrib/android/perms.c
> +++ b/contrib/android/perms.c
> @@ -116,7 +116,7 @@ static errcode_t set_perms_and_caps(ext2_filsys =
fs, ext2_ino_t ino,
> 		retval =3D ext2fs_write_inode(fs, ino, &inode);
> 		if (retval) {
> 			com_err(__func__, retval,
> -				_("while writting inode %u"), ino);
> +				_("while writing inode %u"), ino);
> 			return retval;
> 		}
> 	}
> @@ -167,7 +167,7 @@ static errcode_t set_timestamp(ext2_filsys fs, =
ext2_ino_t ino,
> 	retval =3D ext2fs_write_inode(fs, ino, &inode);
> 	if (retval) {
> 		com_err(__func__, retval,
> -			_("while writting inode %u"), ino);
> +			_("while writing inode %u"), ino);
> 		goto end;
> 	}
>=20
> diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
> index 87d487e7..55abd718 100644
> --- a/debugfs/debugfs.8.in
> +++ b/debugfs/debugfs.8.in
> @@ -226,7 +226,7 @@ Clear the contents of the inode
> .IR filespec .
> .TP
> .BI copy_inode " source_inode destination_inode"
> -Copy the conents of the inode structure in
> +Copy the contents of the inode structure in
> .I source_inode
> and use it to overwrite the inode structure at
> .IR destination_inode .
> diff --git a/debugfs/htree.c b/debugfs/htree.c
> index 8c18666d..cf7d78aa 100644
> --- a/debugfs/htree.c
> +++ b/debugfs/htree.c
> @@ -340,7 +340,7 @@ void do_dx_hash(int argc, char *argv[])
> 	err =3D ext2fs_dirhash(hash_version, argv[optind], =
strlen(argv[optind]),
> 			     hash_seed, &hash, &minor_hash);
> 	if (err) {
> -		com_err(argv[0], err, "while caclulating hash");
> +		com_err(argv[0], err, "while calculating hash");
> 		return;
> 	}
> 	printf("Hash of %s is 0x%0x (minor 0x%0x)\n", argv[optind],
> diff --git a/doc/libext2fs.texinfo b/doc/libext2fs.texinfo
> index 8f046510..c645d82a 100644
> --- a/doc/libext2fs.texinfo
> +++ b/doc/libext2fs.texinfo
> @@ -146,7 +146,7 @@ There are two functions which create a filesystem =
handle,
> @code{ext2fs_open} and @code{ext2fs_initialize}.
>=20
> The filesystem can also be closed using @code{ext2fs_close}, and any
> -changes to the superblock and group descripts can be written out to =
disk
> +changes to the superblock and group descriptors can be written out to =
disk
> using @code{ext2fs_flush}.
>=20
> @menu
> @@ -183,7 +183,7 @@ image.
>=20
> The @var{block_size} parameter specifies the block size used by the
> filesystem.  Normally this is determined automatically from the
> -filesystem uperblock.  If @var{block_size} is non-zero, it must match
> +filesystem superblock.  If @var{block_size} is non-zero, it must =
match
> the block size found in the superblock, or the error
> @code{EXT2_ET_UNEXPECTED_BLOCK_SIZE} will be returned.  The
> @var{block_size} parameter is also used to help fund the superblock =
when
> @@ -625,7 +625,7 @@ The @var{flags} parameter controls how the =
iterator will function:
> @table @samp
>=20
> @item BLOCK_FLAG_HOLE
> -This flag indiciates that the interator function should be called on
> +This flag indicates that the interator function should be called on
> blocks where the block number is zero (also known as ``holes''.)  It =
is
> also known as BLOCK_FLAG_APPEND, since it is also used by functions
> such as ext2fs_expand_dir() to add a new block to an inode.
> @@ -633,7 +633,7 @@ such as ext2fs_expand_dir() to add a new block to =
an inode.
> @item BLOCK_FLAG_DEPTH_TRAVERSE
> This flag indicates that the iterator function for the
> indirect, doubly indirect, etc. blocks should be called after all
> -of the blocks containined in the indirect blocks are processed.
> +of the blocks contained in the indirect blocks are processed.
> This is useful if you are going to be deallocating blocks from an
> inode.
>=20
> @@ -1175,7 +1175,7 @@ in block @var{blk}.
> @deftypefun errcode_t ext2fs_set_dir_block (ext2_dblist @var{dblist}, =
ext2_ino_t @var{ino}, blk_t @var{blk}, int @var{blockcnt})
>=20
> Change an entry in the dblist data structure; this changes the =
location
> -of block number @var{blockcnt} of directory indoe @var{ino} to be =
block
> +of block number @var{blockcnt} of directory inode @var{ino} to be =
block
> @var{blk}.
> @end deftypefun
>=20
> @@ -1208,12 +1208,12 @@ the inode is referenced according to the inode =
structure.
> This abstraction is designed to be extremely efficient for storing =
this
> sort of information, by taking advantage of the following properties =
of
> inode counts, namely (1) inode counts are very often zero (because
> -the inode is currrently not in use), and (2) many files have a inode
> +the inode is currently not in use), and (2) many files have a inode
> count of 1 (because they are a file which has no additional hard =
links).
>=20
> @deftypefun errcode_t ext2fs_create_icount2 (ext2_filsys @var{fs}, int =
@var{flags}, int @var{size}, ext2_icount_t @var{hint}, ext2_icount_t =
*@var{ret})
>=20
> -Creates an icount stucture for a filesystem @var{fs}, with initial =
space
> +Creates an icount structure for a filesystem @var{fs}, with initial =
space
> for @var{size} inodes whose count is greater than 1.  The @var{flags}
> parameter is either 0 or @code{EXT2_ICOUNT_OPT_INCREMENT}, which
> indicates that icount structure should be able to increment inode =
counts
> diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
> index d8205bcf..a727932b 100644
> --- a/e2fsck/e2fsck.conf.5.in
> +++ b/e2fsck/e2fsck.conf.5.in
> @@ -178,17 +178,17 @@ relation.
> This relation contains an alternate directory that will be used if the
> directory specified by
> .I log_dir
> -is not available or is not writeable.
> +is not available or is not writable.
> .TP
> .I log_dir_wait
> If this boolean relation is true, them if the directories specified by
> .I log_dir
> or
> .I log_dir_fallback
> -are not available or are not yet writeable, e2fsck will save the =
output
> +are not available or are not yet writable, e2fsck will save the =
output
> in a memory buffer, and a child process will periodically test to see =
if
> the log directory has become available after the boot sequence has
> -mounted the requiste file system for reading/writing.  This =
implements the
> +mounted the requested file system for reading/writing.  This =
implements the
> functionality provided by
> .BR logsave (8)
> for e2fsck log files.
> @@ -413,7 +413,7 @@ The name of the user running e2fsck.
> .B %U
> This percent expression does not expand to anything, but it signals =
that
> any following date or time expressions should be expressed in UTC time
> -instead of the local timzeone.
> +instead of the local timezone.
> .TP
> .B %y
> The last two digits of the current year (00..99)
> diff --git a/e2fsck/revoke.c b/e2fsck/revoke.c
> index 64b897a7..f7254713 100644
> --- a/e2fsck/revoke.c
> +++ b/e2fsck/revoke.c
> @@ -427,7 +427,7 @@ int journal_cancel_revoke(handle_t *handle, struct =
journal_head *jh)
> 	int did_revoke =3D 0;	/* akpm: debug */
> 	struct buffer_head *bh =3D jh2bh(jh);
>=20
> -	jbd_debug(4, "journal_head %p, cancelling revoke\n", jh);
> +	jbd_debug(4, "journal_head %p, canceling revoke\n", jh);
>=20
> 	/* Is the existing Revoke bit valid?  If so, we trust it, and
> 	 * only perform the full cancel if the revoke bit is set.  If
> diff --git a/ext2ed/disk.c b/ext2ed/disk.c
> index 5c243127..70ece943 100644
> --- a/ext2ed/disk.c
> +++ b/ext2ed/disk.c
> @@ -86,7 +86,7 @@ If logging is enabled, we log the change before =
writing it to the device.
> 	char temp [80];
>=20
> 	if (!write_access) {
> -		wprintw (command_win,"Error - Write access not aviable =
(use enablewrite)\n");
> +		wprintw (command_win,"Error - Write access not available =
(use enablewrite)\n");
> 		return (0);
> 	}
>=20
> diff --git a/ext2ed/doc/ext2ed-design.sgml =
b/ext2ed/doc/ext2ed-design.sgml
> index 7841358a..e8052a90 100644
> --- a/ext2ed/doc/ext2ed-design.sgml
> +++ b/ext2ed/doc/ext2ed-design.sgml
> @@ -83,7 +83,7 @@ subjects. I can think of two ways in which I could =
have made my project:
> <Para>
> 	The "Engineer" way
>=20
> -Learn the subject throughly before I get to the programming itself.
> +Learn the subject thoroughly before I get to the programming itself.
> Then, I could easily see the entire picture and select the best
> course of action, taking all the factors into account.
> </Para>
> @@ -94,7 +94,7 @@ course of action, taking all the factors into =
account.
> 	The "Explorer - Progressive" way.
>=20
> Jump immediately into the cold water - Start programming and
> -learning the material parallelly.
> +learning the material in parallel.
> </Para>
> </ListItem>
>=20
> @@ -418,7 +418,7 @@ superblock was set exactly to the above value.
> <Para>
> It seems that starting with the <Literal =
remap=3D"tt">superblock</Literal> was a good bet - Just from
> the list of variables, one can learn a lot. I didn't understand all of =
them
> -at the time, but it seemed that the following keywords were repeating =
themself
> +at the time, but it seemed that the following keywords were repeating =
themselves
> in various variables:
>=20
> <ItemizedList>
> @@ -710,8 +710,8 @@ int dispatch (char *command_line)
> <Title>Source files in EXT2ED</Title>
>=20
> <Para>
> -The project was getting large enough to be splitted into several =
source
> -files. I splitted the source as much as I could into self-contained
> +The project was getting large enough to be split into several source
> +files. I split the source as much as I could into self-contained
> source files. The source files consist of the following blocks:
>=20
> <ItemizedList>
> @@ -1156,7 +1156,7 @@ according to the source division outlined above, =
in inode_com.c) will
> store the necessary information about the inode in a specific =
structure
> of type struct_file_info which will be available for use by the =
file_com.c
> functions. Only then it will set the type to file. This is also the =
reason
> -that a direct asynchronic set of the object type to a file through a =
settype
> +that a direct asynchronous set of the object type to a file through a =
settype
> command will fail - The above data structure will not be initialized
> properly because the user never was at the inode of the file.
>=20
> diff --git a/ext2ed/doc/ext2fs-overview.sgml =
b/ext2ed/doc/ext2fs-overview.sgml
> index 900c3930..0d54f07c 100644
> --- a/ext2ed/doc/ext2fs-overview.sgml
> +++ b/ext2ed/doc/ext2fs-overview.sgml
> @@ -533,7 +533,7 @@ allocated blocks.
> </Para>
>=20
> <Para>
> -It was found experimently that many of the files in the filesystem =
are
> +It was found experimentally that many of the files in the filesystem =
are
> actually quite small. To take advantage of this effect, the kernel =
provides
> storage of up to 12 block numbers in the inode itself. Those blocks =
are
> called <Literal remap=3D"tt">direct blocks</Literal>. The advantage is =
that once the kernel has the
> @@ -692,7 +692,7 @@ options. They determine the type of the "file" to =
which the inode belongs:
> <Title>Time and date</Title>
>=20
> <Para>
> -Linux records the last time in which various operations occured with =
the
> +Linux records the last time in which various operations occurred with =
the
> file. The time and date are saved in the standard C library format - =
The
> number of seconds which passed since 00:00:00 GMT, January 1, 1970. =
The
> following times are recorded:
> @@ -1087,7 +1087,7 @@ the length of the file name.
> <Para>
> The variable <Literal remap=3D"tt">rec&lowbar;len</Literal> is =
provided because the directory entries are
> padded with zeroes so that the next entry will be in an offset which =
is
> -a multiplition of 4. The resulting directory entry size is stored in
> +a multiplication of 4. The resulting directory entry size is stored =
in
> <Literal remap=3D"tt">rec&lowbar;len</Literal>. If the directory entry =
is the last in the block, it is
> padded with zeroes till the end of the block, and rec&lowbar;len is =
updated
> accordingly.
> @@ -1402,7 +1402,7 @@ then zero s&lowbar;mnt&lowbar;count. <Literal =
remap=3D"tt">s&lowbar;max&lowbar;mnt
> E2fsck also records the last time in which the file system was checked =
in
> the <Literal remap=3D"tt">s&lowbar;lastcheck</Literal> variable. The =
user tunable parameter
> <Literal remap=3D"tt">s&lowbar;checkinterval</Literal> will contain =
the number of seconds which are allowed
> -to pass since <Literal remap=3D"tt">s&lowbar;lastcheck</Literal> =
until a check is reforced. A value of
> +to pass since <Literal remap=3D"tt">s&lowbar;lastcheck</Literal> =
until a check is forced. A value of
> <Literal remap=3D"tt">0</Literal> disables time-based check.
> </Para>
>=20
> diff --git a/ext2ed/doc/user-guide.sgml b/ext2ed/doc/user-guide.sgml
> index 42887eff..1e8f3cdf 100644
> --- a/ext2ed/doc/user-guide.sgml
> +++ b/ext2ed/doc/user-guide.sgml
> @@ -506,8 +506,8 @@ itself the direct blocks, indirect blocks, ..., =
while still preserving the
> actual view of the exact block usage of the file.
> </Screen>
>=20
> -The point is that the "tour" of the filesystem will now be synchronic =
rather
> -than asynchronic - Each object has the "links" to pass between =
connected
> +The point is that the "tour" of the filesystem will now be =
synchronous rather
> +than asynchronous - Each object has the "links" to pass between =
connected
> logical structures, and special fine-tuned functions to deal with it.
> </Para>
>=20
> @@ -855,7 +855,7 @@ The <Command>setdevice</Command> command is =
described at section <XRef LinkEnd=3D"
> Syntax: setoffset [block || type] [+|-]offset
> </Screen>
>=20
> -The <Command>setoffset</Command> command is used to move =
asynchronically inside the file
> +The <Command>setoffset</Command> command is used to move =
asynchronously inside the file
> system. It is considered a low level command, and usually should not =
be used
> when editing an ext2 filesystem, simply because movement is better
> utilized through the specific ext2 commands.
> diff --git a/ext2ed/ext2.descriptors b/ext2ed/ext2.descriptors
> index b1ac4c4b..e356f4cd 100644
> --- a/ext2ed/ext2.descriptors
> +++ b/ext2ed/ext2.descriptors
> @@ -5,7 +5,7 @@ Most of this file is just copied from the ext2 main =
include file.
> My parser is very primitive - It only searches for the struct =
keywords,
> and uses the variables in there. The rest of the file is just ignored.
>=20
> -You will find at the end a few additional types which are not aviable =
in
> +You will find at the end a few additional types which are not =
available in
> the original include file, such as the types "file" and "dir". They =
have
> no variables, but are necessary due to the way ext2ed binds C commands
> to specific types.
> diff --git a/ext2ed/general_com.c b/ext2ed/general_com.c
> index c9b2ffc4..aa274e33 100644
> --- a/ext2ed/general_com.c
> +++ b/ext2ed/general_com.c
> @@ -90,7 +90,7 @@ void help (char *command_line)
> 	wprintw (show_pad,"EXT2ED ver %s (%s)\n",E2FSPROGS_VERSION, =
E2FSPROGS_DATE);
> 	wprintw (show_pad,"Copyright (C) 1995 Gadi Oxman\n");
> 	wprintw (show_pad,"Reviewed 2001 Christian Bac\n");
> -	wprintw (show_pad,"Modified and enchanced by Theodore Ts'o, =
2002\n");
> +	wprintw (show_pad,"Modified and enhanced by Theodore Ts'o, =
2002\n");
> 	wprintw (show_pad,"EXT2ED is hereby placed under the terms of =
the GNU General Public License.\n\n");
> 	wprintw (show_pad,"EXT2ED was programmed as a student project in =
the software laboratory\n");
> 	wprintw (show_pad,"of the faculty of electrical engineering in =
the\n");
> @@ -140,7 +140,7 @@ void detailed_help (char *text)
> 		refresh_show_pad ();return;
> 	}
>=20
> -	wprintw (show_pad,"Error - Command %s not aviable now\n",text);
> +	wprintw (show_pad,"Error - Command %s not available =
now\n",text);
> 	refresh_show_pad ();return;
> }
>=20
> diff --git a/ext2ed/init.c b/ext2ed/init.c
> index 7d9b526f..718c0d08 100644
> --- a/ext2ed/init.c
> +++ b/ext2ed/init.c
> @@ -80,8 +80,8 @@ void add_general_commands (void)
> 	add_user_command (&general_commands,"help","EXT2ED help =
system",help);
> 	add_user_command (&general_commands,"set","Changes a variable in =
the current object",set);
> 	add_user_command (&general_commands,"setdevice","Selects the =
filesystem block device (e.g. /dev/hda1)",set_device);
> -	add_user_command (&general_commands,"setoffset","Moves =
asynchronicly in the filesystem",set_offset);
> -	add_user_command (&general_commands,"settype","Tells EXT2ED how =
to interpert the current object",set_type);
> +	add_user_command (&general_commands,"setoffset","Moves =
asynchronously in the filesystem",set_offset);
> +	add_user_command (&general_commands,"settype","Tells EXT2ED how =
to interpret the current object",set_type);
> 	add_user_command (&general_commands,"show","Displays the current =
object",show);
> 	add_user_command (&general_commands,"pgup","Scrolls data one =
page up",pgup);
> 	add_user_command (&general_commands,"pgdn","Scrolls data one =
page down",pgdn);
> @@ -316,7 +316,7 @@ Set specific type user commands.
> 	}
>=20
> 	if (strcmp ((ptr->name),"ext2_group_desc")=3D=3D0) {
> -		add_user_command (&ptr->type_commands,"next","Pass to =
the next block group decriptor",type_ext2_group_desc___next);
> +		add_user_command (&ptr->type_commands,"next","Pass to =
the next block group descriptor",type_ext2_group_desc___next);
> 		add_user_command (&ptr->type_commands,"prev","Pass to =
the previous group descriptor",type_ext2_group_desc___prev);
> 		add_user_command (&ptr->type_commands,"entry","Pass to a =
specific group descriptor",type_ext2_group_desc___entry);
> 		add_user_command (&ptr->type_commands,"show","Shows the =
current group descriptor",type_ext2_group_desc___show);
> diff --git a/lib/blkid/libblkid.3.in b/lib/blkid/libblkid.3.in
> index bd24cb1a..2fea3a9b 100644
> --- a/lib/blkid/libblkid.3.in
> +++ b/lib/blkid/libblkid.3.in
> @@ -47,7 +47,7 @@ so the use of the cache file is
> in this situation.
> .SH AUTHOR
> .B libblkid
> -was written by Andreas Dilger for the ext2 filesystem utilties, with =
input
> +was written by Andreas Dilger for the ext2 filesystem utilities, with =
input
> from Ted Ts'o.  The library was subsequently heavily modified by Ted =
Ts'o.
> .SH FILES
> .TP
> diff --git a/lib/e2p/e2p.pc.in b/lib/e2p/e2p.pc.in
> index c171ae67..150b089a 100644
> --- a/lib/e2p/e2p.pc.in
> +++ b/lib/e2p/e2p.pc.in
> @@ -4,7 +4,7 @@ libdir=3D@libdir@
> includedir=3D@includedir@
>=20
> Name: e2p
> -Description: Ext2fs userpace programs utility library
> +Description: Ext2fs userspace programs utility library
> Version: @E2FSPROGS_VERSION@
> Requires:
> Cflags: -I${includedir}/e2p -I${includedir}
> diff --git a/lib/et/com_err.texinfo b/lib/et/com_err.texinfo
> index c9d3fcaf..3e7ae32c 100644
> --- a/lib/et/com_err.texinfo
> +++ b/lib/et/com_err.texinfo
> @@ -394,7 +394,7 @@ any event, any invariant which the library assumes =
must be maintained.
> In general, it is not in the domain of non user-interface library
> routines to write error messages to the user's terminal, or halt the
> process.  Such forms of ``error handling'' should be reserved for
> -failures of internal invariants and consistancy checks only, as it
> +failures of internal invariants and consistency checks only, as it
> provides the user of the library no way to clean up for himself in the
> event of total failure.
>=20
> @@ -441,7 +441,7 @@ available, try again later,'' or it may try a =
different server.
>=20
> Cleanup which is typically necessary may include, but not be limited
> to, freeing allocated memory which will not be needed any more,
> -unlocking concurrancy locks, dropping reference counts, closing file
> +unlocking concurrency locks, dropping reference counts, closing file
> descriptors, or otherwise undoing anything which the procedure did up
> to this point.  When there are a lot of things which can go wrong, it
> is generally good to write one block of error-handling code which is
> diff --git a/lib/et/test_cases/heimdal2.c =
b/lib/et/test_cases/heimdal2.c
> index a8d4c111..d2ad5726 100644
> --- a/lib/et/test_cases/heimdal2.c
> +++ b/lib/et/test_cases/heimdal2.c
> @@ -14,7 +14,7 @@ static const char * const text[] =3D {
> 	N_("Bad key supplied"),
> 	N_("Can't encrypt data"),
> 	N_("Cannot encode/decode authentication info"),
> -	N_("Principal attemping change is in wrong realm"),
> +	N_("Principal attempting change is in wrong realm"),
> 	N_("Packet is too large"),
> 	N_("Version number is incorrect"),
> 	N_("Checksum does not match"),
> diff --git a/lib/et/test_cases/heimdal2.et =
b/lib/et/test_cases/heimdal2.et
> index 7a247c55..703600c5 100644
> --- a/lib/et/test_cases/heimdal2.et
> +++ b/lib/et/test_cases/heimdal2.et
> @@ -18,7 +18,7 @@ ec KADM_NO_CRED,	"Unable to fetch credentials"
> ec KADM_BAD_KEY,	"Bad key supplied"
> ec KADM_NO_ENCRYPT,	"Can't encrypt data"
> ec KADM_NO_AUTH,	"Cannot encode/decode authentication info"
> -ec KADM_WRONG_REALM,	"Principal attemping change is in wrong realm"
> +ec KADM_WRONG_REALM,	"Principal attempting change is in wrong realm"
> ec KADM_NO_ROOM,	"Packet is too large"
> ec KADM_BAD_VER,	"Version number is incorrect"
> ec KADM_BAD_CHK,	"Checksum does not match"
> diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> index 0c1eef6c..53016fdb 100644
> --- a/lib/ext2fs/inline_data.c
> +++ b/lib/ext2fs/inline_data.c
> @@ -603,7 +603,7 @@ static errcode_t file_test(ext2_filsys fs)
> 	/* create a new file */
> 	retval =3D ext2fs_new_inode(fs, 2, 010755, 0, &newfile);
> 	if (retval) {
> -		com_err("file_test", retval, "while allocaing a new =
inode");
> +		com_err("file_test", retval, "while allocating a new =
inode");
> 		return 1;
> 	}
>=20
> @@ -613,7 +613,7 @@ static errcode_t file_test(ext2_filsys fs)
> 	inode.i_mode =3D LINUX_S_IFREG;
> 	retval =3D ext2fs_write_new_inode(fs, newfile, &inode);
> 	if (retval) {
> -		com_err("file_test", retval, "while writting a new =
inode");
> +		com_err("file_test", retval, "while writing a new =
inode");
> 		return 1;
> 	}
>=20
> @@ -801,7 +801,7 @@ int main(int argc, char *argv[])
> 	retval =3D ext2fs_allocate_tables(fs);
> 	if (retval) {
> 		com_err("setup", retval,
> -			"while allocating tables for test filesysmte");
> +			"while allocating tables for test filesystem");
> 		exit(1);
> 	}
>=20
> diff --git a/lib/uuid/uuid_compare.3.in b/lib/uuid/uuid_compare.3.in
> index 4807f3a8..67bc9b9e 100644
> --- a/lib/uuid/uuid_compare.3.in
> +++ b/lib/uuid/uuid_compare.3.in
> @@ -47,7 +47,7 @@ to each other.
> .SH RETURN VALUE
> Returns an integer less than, equal to, or greater than zero if
> .I uu1
> -is found,  respectively, to be lexigraphically less than, equal, or
> +is found,  respectively, to be lexicographical less than, equal, or
> greater than
> .IR uu2 .
> .SH AUTHOR
> diff --git a/lib/uuid/uuid_generate.3.in b/lib/uuid/uuid_generate.3.in
> index f44900cd..e6be9685 100644
> --- a/lib/uuid/uuid_generate.3.in
> +++ b/lib/uuid/uuid_generate.3.in
> @@ -58,7 +58,7 @@ function forces the use of the all-random UUID =
format, even if
> a high-quality random number generator (i.e.,
> .IR /dev/urandom )
> is not available, in which case a pseudo-random
> -generator will be subsituted.  Note that the use of a pseudo-random
> +generator will be substituted.  Note that the use of a pseudo-random
> generator may compromise the uniqueness of UUID's
> generated in this fashion.
> .sp
> @@ -75,7 +75,7 @@ function only uses this algorithm if a high-quality =
source of
> randomness is not available.
> .sp
> The UUID is 16 bytes (128 bits) long, which gives approximately =
3.4x10^38
> -unique values (there are approximately 10^80 elemntary particles in
> +unique values (there are approximately 10^80 elementary particles in
> the universe according to Carl Sagan's
> .IR Cosmos ).
> The new UUID can reasonably be considered unique among all UUIDs =
created
> diff --git a/misc/chattr.1.in b/misc/chattr.1.in
> index 44ee3370..967b8088 100644
> --- a/misc/chattr.1.in
> +++ b/misc/chattr.1.in
> @@ -156,7 +156,7 @@ although it can be displayed by
> .PP
> A directory with the 'P' attribute set will enforce a hierarchical
> structure for project id's.  This means that files and directory =
created
> -in the directory will inhert the project id of the directory, rename
> +in the directory will inherit the project id of the directory, rename
> operations are constrained so when a file or directory is moved into
> another directory, that the project id's much match.  In addition, a
> hard link to file can only be created when the project id for the file
> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> index dc86e67f..766bf529 100644
> --- a/misc/mke2fs.8.in
> +++ b/misc/mke2fs.8.in
> @@ -433,7 +433,7 @@ be smaller than the blocksize of the filesystem, =
since in that case more
> inodes would be made than can ever be used.  Be warned that it is not
> possible to change this ratio on a filesystem after it is created, so =
be
> careful deciding the correct value for this parameter.  Note that =
resizing
> -a filesystem changes the numer of inodes to maintain this ratio.
> +a filesystem changes the number of inodes to maintain this ratio.
> .TP
> .BI \-I " inode-size"
> Specify the size of each inode in bytes.
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index d585a9e2..cfb10bc4 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2896,7 +2896,7 @@ int main (int argc, char *argv[])
> 	if (ext2fs_has_feature_csum_seed(fs->super) &&
> 	    !ext2fs_has_feature_metadata_csum(fs->super)) {
> 		printf("%s", _("The metadata_csum_seed feature "
> -			       "requres the metadata_csum feature.\n"));
> +			       "requires the metadata_csum =
feature.\n"));
> 		exit(1);
> 	}
>=20
> diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
> index a8517c39..21a0c882 100644
> --- a/misc/mke2fs.conf.5.in
> +++ b/misc/mke2fs.conf.5.in
> @@ -384,7 +384,7 @@ This relation indicates whether file systems with =
the
> feature enabled should be created with 0, 1, or 2 backup superblocks.
> .TP
> .I packed_meta_blocks
> -This boolean relation specifes whether the allocation bitmaps, inode
> +This boolean relation specifies whether the allocation bitmaps, inode
> table, and journal should be located at the beginning of the file =
system.
> .TP
> .I inode_ratio
> diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
> index 76434d74..3f0674ce 100644
> --- a/resize/resize2fs.8.in
> +++ b/resize/resize2fs.8.in
> @@ -143,7 +143,7 @@ operation during an offline resize, so that the =
user can keep track
> of what the program is doing.
> .TP
> .B \-P
> -Print an extimate of the number of file system blocks in the file =
system
> +Print an estimate of the number of file system blocks in the file =
system
> if it is shrunk using
> .BR resize2fs 's
> .B \-M
> --
> 2.14.2
>=20


Cheers, Andreas






--Apple-Mail=_68245B35-8943-44DA-92D1-E0F0CC0E9E0F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ4oxJpIg59Q01vtYRAlamAKCJiA5yrxE5PZ4+E3eENmb6IJaklACg1TGP
bnAgxS21bDvx9j8Aux8TJdo=
=BODQ
-----END PGP SIGNATURE-----

--Apple-Mail=_68245B35-8943-44DA-92D1-E0F0CC0E9E0F--
