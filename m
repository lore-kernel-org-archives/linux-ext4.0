From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: [PATCH] mke2fs: Add support for lazy journal initialization
Date: Thu, 3 Feb 2011 13:36:45 -0700
Message-ID: <DFB0F581-2306-41A9-AD21-F6019C3AC3C5@dilger.ca>
References: <alpine.LFD.2.00.1102012025400.3559@dhcp-lab-213.englab.brq.redhat.com> <1296645377-18480-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: multipart/mixed; boundary=Apple-Mail-53-630626176
Cc: Lukas Czerner <lczerner@redhat.com>,
	ext4 List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:53916 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1BCUgr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Feb 2011 15:36:47 -0500
In-Reply-To: <1296645377-18480-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail-53-630626176
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

This patch adds the ability to skip zeroing the journal on disk.  This =
can
significantly speed up mke2fs with large journals.  At worst the =
uninitialized
journal is only a very short-term risk (if at all), because the journal =
will
be overwritten on any new filesystem as soon as any significant amount =
of data
is written to disk, unlike lazy_itable_init which can leave =
uninitialized
itable blocks indefinitely (in the absence of the kernel init thread).

Cheers, Andreas





--Apple-Mail-53-630626176
Content-Disposition: attachment;
	filename=0001-mke2fs-Add-lazy-journal-initialization-option.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="0001-mke2fs-Add-lazy-journal-initialization-option.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20a7f156b9078e2b121c4c7d509b55476804ae3f92=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Andreas=20Dilger=20<adilger@dilger.ca>=0ADate:=20=
Thu,=203=20Feb=202011=2013:04:15=20-0700=0ASubject:=20[PATCH]=20mke2fs:=20=
Add=20lazy=20journal=20initialization=20option=0A=0AThis=20patch=20adds=20=
the=20ability=20to=20skip=20zeroing=20the=20journal=20on=20disk.=20=20=
This=20can=0Asignificantly=20speed=20up=20mke2fs=20with=20large=20=
journals.=20=20At=20worst=20the=20uninitialized=0Ajournal=20is=20only=20=
a=20very=20short-term=20risk=20(if=20at=20all),=20because=20the=20=
journal=20will=0Abe=20overwritten=20on=20any=20new=20filesystem=20as=20=
soon=20as=20any=20significant=20amount=20of=20data=0Ais=20written=20to=20=
disk,=20unlike=20lazy_itable_init=20which=20can=20leave=20uninitialized=0A=
itable=20blocks=20indefinitely=20(in=20the=20absence=20of=20the=20kernel=20=
init=20thread).=0A=0ASigned-off-by:=20Andreas=20Dilger=20=
<adilger@dilger.ca>=0A---=0A=20lib/ext2fs/ext2fs.h=20=20=20=20|=20=20=20=20=
5=20++---=0A=20lib/ext2fs/mkjournal.c=20|=20=20=2022=20=
++++++++++++++++++----=0A=20lib/ext2fs/unix_io.c=20=20=20|=20=20=20=202=20=
++=0A=20misc/mke2fs.8.in=20=20=20=20=20=20=20|=20=20=2010=20+++++++++-=0A=
=20misc/mke2fs.c=20=20=20=20=20=20=20=20=20=20|=20=20=2019=20=
+++++++++++++++++--=0A=205=20files=20changed,=2048=20insertions(+),=2010=20=
deletions(-)=0A=0Adiff=20--git=20a/lib/ext2fs/ext2fs.h=20=
b/lib/ext2fs/ext2fs.h=0Aindex=20a204eb7..9fb77eb=20100644=0A---=20=
a/lib/ext2fs/ext2fs.h=0A+++=20b/lib/ext2fs/ext2fs.h=0A@@=20-193,10=20=
+193,9=20@@=20typedef=20struct=20ext2_file=20*ext2_file_t;=0A=20=0A=20/*=0A=
=20=20*=20Flags=20for=20mkjournal=0A-=20*=0A-=20*=20=
EXT2_MKJOURNAL_V1_SUPER=09Make=20a=20(deprecated)=20V1=20journal=20=
superblock=0A=20=20*/=0A-#define=20EXT2_MKJOURNAL_V1_SUPER=090x0000001=0A=
+#define=20EXT2_MKJOURNAL_V1_SUPER=090x0000001=20/*=20create=20V1=20=
superblock=20(deprecated)=20*/=0A+#define=20EXT2_MKJOURNAL_LAZYINIT=09=
0x0000002=20/*=20don't=20zero=20journal=20inode=20before=20use*/=0A=20=0A=
=20struct=20opaque_ext2_group_desc;=0A=20=0Adiff=20--git=20=
a/lib/ext2fs/mkjournal.c=20b/lib/ext2fs/mkjournal.c=0Aindex=20=
242c537..9ddd04c=20100644=0A---=20a/lib/ext2fs/mkjournal.c=0A+++=20=
b/lib/ext2fs/mkjournal.c=0A@@=20-103,7=20+103,7=20@@=20static=20=
errcode_t=20write_journal_file(ext2_filsys=20fs,=20char=20*filename,=0A=20=
=09/*=20Open=20the=20device=20or=20journal=20file=20*/=0A=20=09if=20((fd=20=
=3D=20open(filename,=20O_WRONLY))=20<=200)=20{=0A=20=09=09retval=20=3D=20=
errno;=0A-=09=09goto=20errout;=0A+=09=09goto=20errfree;=0A=20=09}=0A=20=0A=
=20=09/*=20Write=20the=20superblock=20out=20*/=0A@@=20-117,6=20+117,9=20=
@@=20static=20errcode_t=20write_journal_file(ext2_filsys=20fs,=20char=20=
*filename,=0A=20=09=09goto=20errout;=0A=20=09memset(buf,=200,=20=
fs->blocksize);=0A=20=0A+=09if=20(flags=20&=20EXT2_MKJOURNAL_LAZYINIT)=0A=
+=09=09goto=20success;=0A+=0A=20=09for=20(i=20=3D=201;=20i=20<=20size;=20=
i++)=20{=0A=20=09=09ret_size=20=3D=20write(fd,=20buf,=20fs->blocksize);=0A=
=20=09=09if=20(ret_size=20<=200)=20{=0A@@=20-126,10=20+129,12=20@@=20=
static=20errcode_t=20write_journal_file(ext2_filsys=20fs,=20char=20=
*filename,=0A=20=09=09if=20(ret_size=20!=3D=20(int)=20fs->blocksize)=0A=20=
=09=09=09goto=20errout;=0A=20=09}=0A-=09close(fd);=0A=20=0A+success:=0A=20=
=09retval=20=3D=200;=0A=20errout:=0A+=09close(fd);=0A+errfree:=0A=20=09=
ext2fs_free_mem(&buf);=0A=20=09return=20retval;=0A=20}=0A@@=20-213,6=20=
+218,7=20@@=20struct=20mkjournal_struct=20{=0A=20=09blk64_t=09=09goal;=0A=
=20=09blk64_t=09=09blk_to_zero;=0A=20=09int=09=09zero_count;=0A+=09int=09=
=09flags;=0A=20=09char=09=09*buf;=0A=20=09errcode_t=09err;=0A=20};=0A@@=20=
-242,9=20+248,9=20@@=20static=20int=20mkjournal_proc(ext2_filsys=09fs,=0A=
=20=0A=20=09es->newblocks++;=0A=20=09retval=20=3D=200;=0A-=09if=20=
(blockcnt=20<=3D=200)=0A+=09if=20(blockcnt=20<=3D=200)=20{=0A=20=09=09=
retval=20=3D=20io_channel_write_blk64(fs->io,=20new_blk,=201,=20=
es->buf);=0A-=09else=20{=0A+=09}=20else=20if=20(!(es->flags=20&=20=
EXT2_MKJOURNAL_LAZYINIT))=20{=0A=20=09=09if=20(es->zero_count)=20{=0A=20=09=
=09=09if=20((es->blk_to_zero=20+=20es->zero_count=20=3D=3D=20new_blk)=20=
&&=0A=20=09=09=09=20=20=20=20(es->zero_count=20<=201024))=0A@@=20-308,6=20=
+314,7=20@@=20static=20errcode_t=20write_journal_inode(ext2_filsys=20fs,=20=
ext2_ino_t=20journal_ino,=0A=20=09es.newblocks=20=3D=200;=0A=20=09es.buf=20=
=3D=20buf;=0A=20=09es.err=20=3D=200;=0A+=09es.flags=20=3D=20flags;=0A=20=09=
es.zero_count=20=3D=200;=0A=20=0A=20=09if=20=
(fs->super->s_feature_incompat=20&=20EXT3_FEATURE_INCOMPAT_EXTENTS)=20{=0A=
@@=20-504,6=20+511,13=20@@=20errcode_t=20=
ext2fs_add_journal_inode(ext2_filsys=20fs,=20blk_t=20size,=20int=20=
flags)=0A=20=09=09if=20((fd=20=3D=20open(jfile,=20O_CREAT|O_WRONLY,=20=
0600))=20<=200)=0A=20=09=09=09return=20errno;=0A=20=0A+=09=09/*=20Note=20=
that=20we=20can't=20do=20lazy=20journal=20initialization=20for=20mounted=0A=
+=09=09=20*=20filesystems,=20since=20the=20zero=20writing=20is=20also=20=
allocating=20the=0A+=09=09=20*=20journal=20blocks.=20=20We=20could=20use=20=
fallocate,=20but=20not=20all=20kernels=0A+=09=09=20*=20support=20that,=20=
and=20creating=20a=20journal=20on=20a=20mounted=20ext2=0A+=09=09=20*=20=
filesystems=20is=20extremely=20rare=20these=20days...=20=20Skip=20it=20=
for=20now.=20*/=0A+=09=09flags=20&=3D=20~EXT2_MKJOURNAL_LAZYINIT;=0A+=0A=20=
=09=09if=20((retval=20=3D=20write_journal_file(fs,=20jfile,=20size,=20=
flags)))=0A=20=09=09=09goto=20errout;=0A=20=0Adiff=20--git=20=
a/lib/ext2fs/unix_io.c=20b/lib/ext2fs/unix_io.c=0Aindex=20=
82e0fe4..73e5daf=20100644=0A---=20a/lib/ext2fs/unix_io.c=0A+++=20=
b/lib/ext2fs/unix_io.c=0A@@=20-472,8=20+472,10=20@@=20static=20errcode_t=20=
unix_open(const=20char=20*name,=20int=20flags,=20io_channel=20*channel)=0A=
=20=09open_flags=20=3D=20(flags=20&=20IO_FLAG_RW)=20?=20O_RDWR=20:=20=
O_RDONLY;=0A=20=09if=20(flags=20&=20IO_FLAG_EXCLUSIVE)=0A=20=09=09=
open_flags=20|=3D=20O_EXCL;=0A+#ifdef=20O_DIRECT=0A=20=09if=20(flags=20&=20=
IO_FLAG_DIRECT_IO)=0A=20=09=09open_flags=20|=3D=20O_DIRECT;=0A+#endif=0A=20=
=09data->flags=20=3D=20flags;=0A=20=0A=20#ifdef=20HAVE_OPEN64=0Adiff=20=
--git=20a/misc/mke2fs.8.in=20b/misc/mke2fs.8.in=0Aindex=20=
2eead17..b0f1e18=20100644=0A---=20a/misc/mke2fs.8.in=0A+++=20=
b/misc/mke2fs.8.in=0A@@=20-232,7=20+232,15=20@@=20This=20speeds=20up=20=
filesystem=0A=20initialization=20noticeably,=20but=20it=20requires=20the=20=
kernel=20to=20finish=0A=20initializing=20the=20filesystem=20in=20the=20=
background=20when=20the=20filesystem=20is=0A=20first=20mounted.=20=20If=20=
the=20option=20value=20is=20omitted,=20it=20defaults=20to=201=20to=0A=
-enable=20lazy=20inode=20table=20initialization.=0A+enable=20lazy=20=
inode=20table=20zeroing.=0A+.TP=0A+.B=20lazy_journal_init\fR[\fB=3D=20=
\fI{0=20to=20disable,=201=20to=20enable}\fR]=0A+If=20enabled,=20the=20=
journal=20inode=20will=20not=20be=20fully=20zeroed=20out=20by=0A+.BR=20=
mke2fs=20.=0A+This=20speeds=20up=20filesystem=20initialization=20=
noticeably,=20but=20carries=20some=0A+small=20risk=20if=20the=20system=20=
crashes=20before=20the=20journal=20has=20been=20overwritten=0A+entirely=20=
one=20time.=20=20If=20the=20option=20value=20is=20omitted,=20it=20=
defaults=20to=201=20to=0A+enable=20lazy=20journal=20inode=20zeroing.=0A=20=
.TP=0A=20.B=20test_fs=0A=20Set=20a=20flag=20in=20the=20filesystem=20=
superblock=20indicating=20that=20it=20may=20be=0Adiff=20--git=20=
a/misc/mke2fs.c=20b/misc/mke2fs.c=0Aindex=200ba4a4c..f45de47=20100644=0A=
---=20a/misc/mke2fs.c=0A+++=20b/misc/mke2fs.c=0A@@=20-501,6=20+501,10=20=
@@=20static=20void=20create_journal_dev(ext2_filsys=20fs)=0A=20=09=09=09=
_("while=20initializing=20journal=20superblock"));=0A=20=09=09exit(1);=0A=
=20=09}=0A+=0A+=09if=20(journal_flags=20&=20EXT2_MKJOURNAL_LAZYINIT)=0A+=09=
=09goto=20write_superblock;=0A+=0A=20=09ext2fs_numeric_progress_init(fs,=20=
&progress,=0A=20=09=09=09=09=20=20=20=20=20_("Zeroing=20journal=20=
device:=20"),=0A=20=09=09=09=09=20=20=20=20=20=
ext2fs_blocks_count(fs->super));=0A@@=20-525,6=20+529,8=20@@=20static=20=
void=20create_journal_dev(ext2_filsys=20fs)=0A=20=09}=0A=20=09=
ext2fs_zero_blocks2(0,=200,=200,=200,=200);=0A=20=0A+=09=
ext2fs_numeric_progress_close(fs,=20&progress,=20NULL);=0A=
+write_superblock:=0A=20=09retval=20=3D=20io_channel_write_blk64(fs->io,=0A=
=20=09=09=09=09=09fs->super->s_first_data_block+1,=0A=20=09=09=09=09=09=
1,=20buf);=0A@@=20-533,7=20+539,6=20@@=20static=20void=20=
create_journal_dev(ext2_filsys=20fs)=0A=20=09=09=09_("while=20writing=20=
journal=20superblock"));=0A=20=09=09exit(1);=0A=20=09}=0A-=09=
ext2fs_numeric_progress_close(fs,=20&progress,=20NULL);=0A=20}=0A=20=0A=20=
static=20void=20show_stats(ext2_filsys=20fs)=0A@@=20-744,6=20+749,12=20=
@@=20static=20void=20parse_extended_opts(struct=20ext2_super_block=20=
*param,=0A=20=09=09=09}=0A=20=09=09}=20else=20if=20(!strcmp(token,=20=
"test_fs"))=20{=0A=20=09=09=09param->s_flags=20|=3D=20=
EXT2_FLAGS_TEST_FILESYS;=0A+=09=09}=20else=20if=20(!strcmp(token,=20=
"lazy_journal_init"))=20{=0A+=09=09=09if=20(arg)=0A+=09=09=09=09=
journal_flags=20|=3D=20strtoul(arg,=20&p,=200)=20?=0A+=09=09=09=09=09=09=
EXT2_MKJOURNAL_LAZYINIT=20:=200;=0A+=09=09=09else=0A+=09=09=09=09=
journal_flags=20|=3D=20EXT2_MKJOURNAL_LAZYINIT;=0A=20=09=09}=20else=20if=20=
(!strcmp(token,=20"lazy_itable_init"))=20{=0A=20=09=09=09if=20(arg)=0A=20=
=09=09=09=09lazy_itable_init=20=3D=20strtoul(arg,=20&p,=200);=0A@@=20=
-767,7=20+778,8=20@@=20static=20void=20parse_extended_opts(struct=20=
ext2_super_block=20*param,=0A=20=09=09=09"\tstride=3D<RAID=20per-disk=20=
data=20chunk=20in=20blocks>\n"=0A=20=09=09=09"\tstripe-width=3D<RAID=20=
stride=20*=20data=20disks=20in=20blocks>\n"=0A=20=09=09=09=
"\tresize=3D<resize=20maximum=20size=20in=20blocks>\n"=0A-=09=09=09=
"\tlazy_itable_init=3D<0=20to=20disable,=201=20to=20enable>\n"=0A+=09=09=09=
"\tlazy_itable_init=3D{0=20to=20disable,=201=20to=20enable}\n"=0A+=09=09=09=
"\tlazy_journal_init=3D{0=20to=20disable,=201=20to=20enable}\n"=0A=20=09=09=
=09"\ttest_fs\n"=0A=20=09=09=09"\tdiscard\n"=0A=20=09=09=09=
"\tnodiscard\n\n"),=0A@@=20-1756,6=20+1768,9=20@@=20profile_error:=0A=20=09=
lazy_itable_init=20=3D=20get_bool_from_profile(fs_types,=0A=20=09=09=09=09=
=09=09=20"lazy_itable_init",=0A=20=09=09=09=09=09=09=20=
lazy_itable_init);=0A+=09journal_flags=20|=3D=20=
get_bool_from_profile(fs_types,=0A+=09=09=09=09=09=20=20=20=20=20=20=20=
"lazy_journal_init",=200)=20?=0A+=09=09=09=09=09=09=
EXT2_MKJOURNAL_LAZYINIT=20:=200;=0A=20=09discard=20=3D=20=
get_bool_from_profile(fs_types,=20"discard"=20,=20discard);=0A=20=0A=20=09=
/*=20Get=20options=20from=20profile=20*/=0A--=20=0A1.7.2=0A=0A=

--Apple-Mail-53-630626176--
