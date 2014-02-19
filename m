From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: Remove any occurrence of ext4dev and test_fs
Date: Wed, 19 Feb 2014 10:56:35 -0600
Message-ID: <5304E243.6050700@redhat.com>
References: <1392821835-12059-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693AbaBSQ4k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Feb 2014 11:56:40 -0500
In-Reply-To: <1392821835-12059-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/19/14, 8:57 AM, Lukas Czerner wrote:
> ext4dev is no longer supported by kernel so we really need to get rid of
> it entirely from e2fsprogs.
> 
> This patch removes any occurrence of ext4dev and test_fs flag from the
> e2fsprogs tools with one exception. Out of paranoia we can still leave
> the possibility to remove test_fs flag (EXT2_FLAGS_TEST_FILESYS) from
> the file system using e2fsck by specifying clear_test_fs_flag option in
> the e2fsck.config file.

Yes, I think this makes good sense.  While one could argue that
test_fs may be used for some other purpose in the future, we have
added a lot of fairly experimental code without making use of it,
so I'd argue that it has no practical use going forward.

Acked-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  e2fsck/Makefile.in   | 10 +++----
>  e2fsprogs.spec.in    |  4 ---
>  lib/blkid/probe.c    | 80 ++--------------------------------------------------
>  misc/Makefile.in     | 32 ++++++---------------
>  misc/fsck.c          |  7 ++---
>  misc/mke2fs.8.in     |  4 ---
>  misc/mke2fs.c        |  9 +-----
>  misc/mke2fs.conf.in  |  5 ----
>  misc/tune2fs.8.in    |  8 ------
>  misc/tune2fs.c       | 12 +-------
>  tests/mke2fs.conf.in |  5 ----
>  11 files changed, 20 insertions(+), 156 deletions(-)
> 
> diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
> index 8ca329b..441485b 100644
> --- a/e2fsck/Makefile.in
> +++ b/e2fsck/Makefile.in
> @@ -207,7 +207,7 @@ install: $(PROGS) $(MANPAGES) $(FMANPAGES) installdirs
>  		$(ES) "	INSTALL $(root_sbindir)/$$i"; \
>  		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(root_sbindir)/$$i; \
>  	done
> -	$(Q) for i in ext2 ext3 ext4 ext4dev; do \
> +	$(Q) for i in ext2 ext3 ext4; do \
>  		$(ES) "	LINK $(root_sbindir)/fsck.$$i"; \
>  		(cd $(DESTDIR)$(root_sbindir); \
>  			$(LN) $(LINK_INSTALL_FLAGS) e2fsck fsck.$$i); \
> @@ -226,7 +226,7 @@ install: $(PROGS) $(MANPAGES) $(FMANPAGES) installdirs
>  		$(ES) "	INSTALL_DATA $(man5dir)/$$i"; \
>  		$(INSTALL_DATA) $$i $(DESTDIR)$(man5dir)/$$i; \
>  	done
> -	$(Q) for i in ext2 ext3 ext4 ext4dev; do \
> +	$(Q) for i in ext2 ext3 ext4; do \
>  		$(ES) "	LINK $(man8dir)/fsck.$$i.8"; \
>  		(cd $(DESTDIR)$(man8dir); \
>  			$(LN) $(LINK_INSTALL_FLAGS) e2fsck.8 fsck.$$i.8); \
> @@ -244,8 +244,7 @@ uninstall:
>  	done
>  	$(RM) -f $(DESTDIR)$(root_sbindir)/fsck.ext2 \
>  		$(DESTDIR)$(root_sbindir)/fsck.ext3 \
> -		$(DESTDIR)$(root_sbindir)/fsck.ext4 \
> -		$(DESTDIR)$(root_sbindir)/fsck.ext4dev
> +		$(DESTDIR)$(root_sbindir)/fsck.ext4
>  	for i in $(MANPAGES); do \
>  		$(RM) -f $(DESTDIR)$(man8dir)/$$i; \
>  	done
> @@ -254,8 +253,7 @@ uninstall:
>  	done
>  	$(RM) -f $(DESTDIR)$(root_sbindir)/fsck.ext2 \
>  			$(DESTDIR)$(root_sbindir)/fsck.ext3 \
> -			$(DESTDIR)$(root_sbindir)/fsck.ext4 \
> -			$(DESTDIR)$(root_sbindir)/fsck.ext4dev
> +			$(DESTDIR)$(root_sbindir)/fsck.ext4
>  
>  clean:
>  	$(RM) -f $(PROGS) \#* *\# *.s *.o *.a *~ core e2fsck.static \
> diff --git a/e2fsprogs.spec.in b/e2fsprogs.spec.in
> index b188b75..c739e63 100644
> --- a/e2fsprogs.spec.in
> +++ b/e2fsprogs.spec.in
> @@ -122,14 +122,12 @@ exit 0
>  %{_root_sbindir}/fsck.ext2
>  %{_root_sbindir}/fsck.ext3
>  %{_root_sbindir}/fsck.ext4
> -%{_root_sbindir}/fsck.ext4dev
>  %{_root_sbindir}/logsave
>  %{_root_sbindir}/mke2fs
>  %{_root_etcdir}/mke2fs.conf
>  %{_root_sbindir}/mkfs.ext2
>  %{_root_sbindir}/mkfs.ext3
>  %{_root_sbindir}/mkfs.ext4
> -%{_root_sbindir}/mkfs.ext4dev
>  %{_root_sbindir}/resize2fs
>  %{_root_sbindir}/tune2fs
>  %{_sbindir}/filefrag
> @@ -164,7 +162,6 @@ exit 0
>  %{_mandir}/man8/fsck.ext2.8*
>  %{_mandir}/man8/fsck.ext3.8*
>  %{_mandir}/man8/fsck.ext4.8*
> -%{_mandir}/man8/fsck.ext4dev.8*
>  %{_mandir}/man8/e2image.8*
>  %{_mandir}/man8/e2label.8*
>  %{_mandir}/man8/e2undo.8*
> @@ -174,7 +171,6 @@ exit 0
>  %{_mandir}/man8/mkfs.ext2.8*
>  %{_mandir}/man8/mkfs.ext3.8*
>  %{_mandir}/man8/mkfs.ext4.8*
> -%{_mandir}/man8/mkfs.ext4dev.8*
>  %{_mandir}/man8/mklost+found.8*
>  %{_mandir}/man8/resize2fs.8*
>  %{_mandir}/man8/tune2fs.8*
> diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
> index 4b797ab..2877fdf 100644
> --- a/lib/blkid/probe.c
> +++ b/lib/blkid/probe.c
> @@ -305,64 +305,6 @@ static int system_supports_ext4(void)
>  	return ret;
>  }
>  
> -static int system_supports_ext4dev(void)
> -{
> -	static time_t	last_check = 0;
> -	static int	ret = -1;
> -	time_t		now = time(0);
> -
> -	if (ret != -1 || (now - last_check) < 5)
> -		return ret;
> -	last_check = now;
> -	ret = (fs_proc_check("ext4dev") || check_for_modules("ext4dev"));
> -	return ret;
> -}
> -
> -static int probe_ext4dev(struct blkid_probe *probe,
> -			 struct blkid_magic *id,
> -			 unsigned char *buf)
> -{
> -	struct ext2_super_block *es;
> -	es = (struct ext2_super_block *)buf;
> -
> -	/* Distinguish from jbd */
> -	if (blkid_le32(es->s_feature_incompat) &
> -	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)
> -		return -BLKID_ERR_PARAM;
> -
> -	/* 
> -	 * If the filesystem does not have a journal and ext2 and ext4
> -	 * is not present, then force this to be detected as an
> -	 * ext4dev filesystem.
> -	 */
> -	if (!(blkid_le32(es->s_feature_compat) &
> -	      EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
> -	    !system_supports_ext2() && !system_supports_ext4() &&
> -	    system_supports_ext4dev() &&
> -	    linux_version_code() >= EXT4_SUPPORTS_EXT2)
> -		goto force_ext4dev;
> -
> -	/*
> -	 * If the filesystem is marked as OK for use by in-development
> -	 * filesystem code, but ext4dev is not supported, and ext4 is,
> -	 * then don't call ourselves ext4dev, since we should be
> -	 * detected as ext4 in that case.
> -	 *
> -	 * If the filesystem is marked as in use by production
> -	 * filesystem, then it can only be used by ext4 and NOT by
> -	 * ext4dev, so always disclaim we are ext4dev in that case.
> -	 */
> -	if (blkid_le32(es->s_flags) & EXT2_FLAGS_TEST_FILESYS) {
> -		if (!system_supports_ext4dev() && system_supports_ext4())
> -			return -BLKID_ERR_PARAM;
> -	} else
> -		return -BLKID_ERR_PARAM;
> -
> -force_ext4dev:
> -    	get_ext2_info(probe->dev, id, buf);
> -	return 0;
> -}
> -
>  static int probe_ext4(struct blkid_probe *probe, struct blkid_magic *id,
>  		      unsigned char *buf)
>  {
> @@ -393,21 +335,7 @@ static int probe_ext4(struct blkid_probe *probe, struct blkid_magic *id,
>  		return -BLKID_ERR_PARAM;
>  
>  force_ext4:
> -	/*
> -	 * If the filesystem is a OK for use by in-development
> -	 * filesystem code, and ext4dev is supported or ext4 is not
> -	 * supported, then don't call ourselves ext4, so we can redo
> -	 * the detection and mark the filesystem as ext4dev.
> -	 *
> -	 * If the filesystem is marked as in use by production
> -	 * filesystem, then it can only be used by ext4 and NOT by
> -	 * ext4dev.
> -	 */
> -	if (blkid_le32(es->s_flags) & EXT2_FLAGS_TEST_FILESYS) {
> -		if (system_supports_ext4dev() || !system_supports_ext4())
> -			return -BLKID_ERR_PARAM;
> -	}
> -    	get_ext2_info(probe->dev, id, buf);
> +	get_ext2_info(probe->dev, id, buf);
>  	return 0;
>  }
>  
> @@ -453,11 +381,10 @@ static int probe_ext2(struct blkid_probe *probe, struct blkid_magic *id,
>  		return -BLKID_ERR_PARAM;
>  
>  	/* 
> -	 * If ext2 is not present, but ext4 or ext4dev are, then
> +	 * If ext2 is not present, but ext4 is, then
>  	 * disclaim we are ext2
>  	 */
> -	if (!system_supports_ext2() &&
> -	    (system_supports_ext4() || system_supports_ext4dev()) &&
> +	if (!system_supports_ext2() && system_supports_ext4() &&
>  	    linux_version_code() >= EXT4_SUPPORTS_EXT2)
>  		return -BLKID_ERR_PARAM;
>  
> @@ -1400,7 +1327,6 @@ static struct blkid_magic type_array[] = {
>    { "oracleasm", 0,	32,  8, "ORCLDISK",		probe_oracleasm },
>    { "ntfs",	 0,	 3,  8, "NTFS    ",		probe_ntfs },
>    { "jbd",	 1,   0x38,  2, "\123\357",		probe_jbd },
> -  { "ext4dev",	 1,   0x38,  2, "\123\357",		probe_ext4dev },
>    { "ext4",	 1,   0x38,  2, "\123\357",		probe_ext4 },
>    { "ext3",	 1,   0x38,  2, "\123\357",		probe_ext3 },
>    { "ext2",	 1,   0x38,  2, "\123\357",		probe_ext2 },
> diff --git a/misc/Makefile.in b/misc/Makefile.in
> index e8cfdb5..90986f6 100644
> --- a/misc/Makefile.in
> +++ b/misc/Makefile.in
> @@ -461,7 +461,7 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
>  		$(ES) "	INSTALL $(sbindir)/$$i"; \
>  		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(sbindir)/$$i; \
>  	done
> -	$(Q) for i in ext2 ext3 ext4 ext4dev; do \
> +	$(Q) for i in ext2 ext3 ext4; do \
>  		$(ES) "	LINK $(root_sbindir)/mkfs.$$i"; \
>  		(cd $(DESTDIR)$(root_sbindir); \
>  			$(LN) $(LINK_INSTALL_FLAGS) mke2fs mkfs.$$i); \
> @@ -490,7 +490,7 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
>  	done
>  	$(Q) $(RM) -f $(DESTDIR)$(man8dir)/mkfs.ext2.8.gz \
>  		$(DESTDIR)$(man8dir)/mkfs.ext3.8.gz
> -	$(Q) for i in ext2 ext3 ext4 ext4dev; do \
> +	$(Q) for i in ext2 ext3 ext4; do \
>  		$(ES) "	LINK mkfs.$$i.8"; \
>  		(cd $(DESTDIR)$(man8dir); \
>  			$(LN) $(LINK_INSTALL_FLAGS) mke2fs.8 mkfs.$$i.8); \
> @@ -519,22 +519,11 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
>  			mke2fs.conf; then \
>  			true; \
>  		else \
> -			if grep -q ext4dev $(DESTDIR)$(root_sysconfdir)/mke2fs.conf ; then \
> -				$(ES) "	INSTALL_DATA $(root_sysconfdir)/mke2fs.conf.e2fsprogs-new"; \
> -				$(INSTALL_DATA) mke2fs.conf \
> -					$(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-new; \
> -				echo "Warning: installing mke2fs.conf in $(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-new"; \
> -				echo "Check to see if you need to update your $(root_sysconfdir)/mke2fs.conf"; \
> -			else \
> -				$(ES) "	INSTALL_DATA $(root_sysconfdir)/mke2fs.conf"; \
> -				mv $(DESTDIR)$(root_sysconfdir)/mke2fs.conf \
> -				   $(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-old; \
> -				$(INSTALL_DATA) mke2fs.conf \
> -					$(DESTDIR)$(root_sysconfdir)/mke2fs.conf; \
> -				echo "Your mke2fs.conf is too old.  Backing up old version in"; \
> -				echo "$(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-old.  Please check to see"; \
> -				echo "if you have any local customizations that you wish to preserve."; \
> -			fi; \
> +			$(ES) "	INSTALL_DATA $(root_sysconfdir)/mke2fs.conf.e2fsprogs-new"; \
> +			$(INSTALL_DATA) mke2fs.conf \
> +				$(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-new; \
> +			echo "Warning: installing mke2fs.conf in $(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-new"; \
> +			echo "Check to see if you need to update your $(root_sysconfdir)/mke2fs.conf"; \
>  			echo " "; \
>  		fi; \
>  	else \
> @@ -565,8 +554,7 @@ uninstall:
>  	done
>  	$(RM) -f $(DESTDIR)$(root_sbindir)/mkfs.ext2 \
>  			$(DESTDIR)$(root_sbindir)/mkfs.ext3 \
> -			$(DESTDIR)$(root_sbindir)/mkfs.ext4 \
> -			$(DESTDIR)$(root_sbindir)/mkfs.ext4dev
> +			$(DESTDIR)$(root_sbindir)/mkfs.ext4
>  	for i in $(UPROGS); do \
>  		$(RM) -f $(DESTDIR)$(bindir)/$$i; \
>  	done
> @@ -576,11 +564,9 @@ uninstall:
>  	$(RM) -f $(DESTDIR)$(man8dir)/mkfs.ext2.8 \
>  		$(DESTDIR)$(man8dir)/mkfs.ext3.8 \
>  		$(DESTDIR)$(man8dir)/mkfs.ext4.8 \
> -		$(DESTDIR)$(man8dir)/mkfs.ext4dev.8 \
>  		$(DESTDIR)$(man8dir)/fsck.ext2.8 \
>  		$(DESTDIR)$(man8dir)/fsck.ext3.8 \
> -		$(DESTDIR)$(man8dir)/fsck.ext4.8 \
> -		$(DESTDIR)$(man8dir)/fsck.ext4dev.8
> +		$(DESTDIR)$(man8dir)/fsck.ext4.8
>  
>  	for i in $(UMANPAGES); do \
>  		$(RM) -f $(DESTDIR)$(man1dir)/$$i; \
> diff --git a/misc/fsck.c b/misc/fsck.c
> index 826aaeb..2df15cd 100644
> --- a/misc/fsck.c
> +++ b/misc/fsck.c
> @@ -84,7 +84,6 @@ static const char *really_wanted[] = {
>  	"ext2",
>  	"ext3",
>  	"ext4",
> -	"ext4dev",
>  	"jfs",
>  	"reiserfs",
>  	"xiafs",
> @@ -455,8 +454,7 @@ static int execute(const char *type, const char *device, const char *mntpt,
>  	if (progress) {
>  		if ((strcmp(type, "ext2") == 0) ||
>  		    (strcmp(type, "ext3") == 0) ||
> -		    (strcmp(type, "ext4") == 0) ||
> -		    (strcmp(type, "ext4dev") == 0)) {
> +		    (strcmp(type, "ext4") == 0)) {
>  			char tmp[80];
>  
>  			tmp[0] = 0;
> @@ -632,8 +630,7 @@ static struct fsck_instance *wait_one(int flags)
>  				continue;
>  			if (strcmp(inst2->type, "ext2") &&
>  			    strcmp(inst2->type, "ext3") &&
> -			    strcmp(inst2->type, "ext4") &&
> -			    strcmp(inst2->type, "ext4dev"))
> +			    strcmp(inst2->type, "ext4"))
>  				continue;
>  			/*
>  			 * If we've just started the fsck, wait a tiny
> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> index 9c38e20..9015770 100644
> --- a/misc/mke2fs.8.in
> +++ b/misc/mke2fs.8.in
> @@ -299,10 +299,6 @@ The \fBroot_owner=\fR option allows explicitly specifying these values,
>  and avoid side-effects for users that do not expect the contents of the
>  filesystem to change based on the user running \fBmke2fs\fR.
>  .TP
> -.B test_fs
> -Set a flag in the filesystem superblock indicating that it may be
> -mounted using experimental kernel code, such as the ext4dev filesystem.
> -.TP
>  .BI discard
>  Attempt to discard blocks at mkfs time (discarding blocks initially is useful
>  on solid state devices and sparse / thin-provisioned storage). When the device
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index facbe4c..44d1a60 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -952,8 +952,6 @@ static void parse_extended_opts(struct ext2_super_block *param,
>  
>  				param->s_reserved_gdt_blocks = rsv_gdb;
>  			}
> -		} else if (!strcmp(token, "test_fs")) {
> -			param->s_flags |= EXT2_FLAGS_TEST_FILESYS;
>  		} else if (!strcmp(token, "lazy_itable_init")) {
>  			if (arg)
>  				lazy_itable_init = strtoul(arg, &p, 0);
> @@ -1031,7 +1029,6 @@ static void parse_extended_opts(struct ext2_super_block *param,
>  			"\tlazy_journal_init=<0 to disable, 1 to enable>\n"
>  			"\troot_uid=<uid of root directory>\n"
>  			"\troot_gid=<gid of root directory>\n"
> -			"\ttest_fs\n"
>  			"\tdiscard\n"
>  			"\tnodiscard\n"
>  			"\tquotatype=<usr OR grp>\n\n"),
> @@ -1244,8 +1241,7 @@ static char **parse_fs_type(const char *fs_type,
>  	    strcmp(ext_type, "ext2")) {
>  		printf(_("\nYour mke2fs.conf file does not define the "
>  			 "%s filesystem type.\n"), ext_type);
> -		if (!strcmp(ext_type, "ext3") || !strcmp(ext_type, "ext4") ||
> -		    !strcmp(ext_type, "ext4dev")) {
> +		if (!strcmp(ext_type, "ext3") || !strcmp(ext_type, "ext4")) {
>  			printf("%s", _("You probably need to install an "
>  				       "updated mke2fs.conf file.\n\n"));
>  		}
> @@ -2670,9 +2666,6 @@ int main (int argc, char *argv[])
>  		io_channel_set_options(fs->io, opt_string);
>  	}
>  
> -	if (fs_param.s_flags & EXT2_FLAGS_TEST_FILESYS)
> -		fs->super->s_flags |= EXT2_FLAGS_TEST_FILESYS;
> -
>  	if ((fs_param.s_feature_incompat &
>  	     (EXT3_FEATURE_INCOMPAT_EXTENTS|EXT4_FEATURE_INCOMPAT_FLEX_BG)) ||
>  	    (fs_param.s_feature_ro_compat &
> diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
> index 178733f..980bf9c 100644
> --- a/misc/mke2fs.conf.in
> +++ b/misc/mke2fs.conf.in
> @@ -15,11 +15,6 @@
>  		auto_64-bit_support = 1
>  		inode_size = 256
>  	}
> -	ext4dev = {
> -		features = has_journal,extent,huge_file,flex_bg,metadata_csum,64bit,dir_nlink,extra_isize
> -		inode_size = 256
> -		options = test_fs=1
> -	}
>  	small = {
>  		blocksize = 1024
>  		inode_size = 128
> diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
> index 9455707..c1c64e7 100644
> --- a/misc/tune2fs.8.in
> +++ b/misc/tune2fs.8.in
> @@ -231,14 +231,6 @@ program.
>  .IP
>  This superblock setting is only honored in 2.6.35+ kernels;
>  and not at all by the ext2 and ext3 file system drivers.
> -.TP
> -.B test_fs
> -Set a flag in the filesystem superblock indicating that it may be
> -mounted using experimental kernel code, such as the ext4dev filesystem.
> -.TP
> -.B ^test_fs
> -Clear the test_fs flag, indicating the filesystem should only be mounted
> -using production-level filesystem code.
>  .RE
>  .TP
>  .B \-f
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 8ff47d2..5bc38cb 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -1735,14 +1735,6 @@ static int parse_extended_opts(ext2_filsys fs, const char *opts)
>  			       intv);
>  			fs->super->s_mmp_update_interval = intv;
>  			ext2fs_mark_super_dirty(fs);
> -		} else if (!strcmp(token, "test_fs")) {
> -			fs->super->s_flags |= EXT2_FLAGS_TEST_FILESYS;
> -			printf("Setting test filesystem flag\n");
> -			ext2fs_mark_super_dirty(fs);
> -		} else if (!strcmp(token, "^test_fs")) {
> -			fs->super->s_flags &= ~EXT2_FLAGS_TEST_FILESYS;
> -			printf("Clearing test filesystem flag\n");
> -			ext2fs_mark_super_dirty(fs);
>  		} else if (strcmp(token, "stride") == 0) {
>  			if (!arg) {
>  				r_usage++;
> @@ -1815,9 +1807,7 @@ static int parse_extended_opts(ext2_filsys fs, const char *opts)
>  			"\thash_alg=<hash algorithm>\n"
>  			"\tmount_opts=<extended default mount options>\n"
>  			"\tstride=<RAID per-disk chunk size in blocks>\n"
> -			"\tstripe_width=<RAID stride*data disks in blocks>\n"
> -			"\ttest_fs\n"
> -			"\t^test_fs\n"));
> +			"\tstripe_width=<RAID stride*data disks in blocks>\n"));
>  		free(buf);
>  		return 1;
>  	}
> diff --git a/tests/mke2fs.conf.in b/tests/mke2fs.conf.in
> index c06050d..ee246ba 100644
> --- a/tests/mke2fs.conf.in
> +++ b/tests/mke2fs.conf.in
> @@ -17,11 +17,6 @@
>  		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
>  		inode_size = 256
>  	}
> -	ext4dev = {
> -		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
> -		inode_size = 256
> -		options = test_fs=1
> -	}
>  	small = {
>  		blocksize = 1024
>  		inode_size = 128
> 

