From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] debugfs: build read-only variant of debugfs
Date: Tue, 15 Nov 2011 09:41:57 -0600
Message-ID: <4EC28845.8000200@redhat.com>
References: <1321333509-4607-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102Ab1KOPmB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Nov 2011 10:42:01 -0500
In-Reply-To: <1321333509-4607-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/14/11 11:05 PM, Theodore Ts'o wrote:
> Create a version of debugfs which only supports read-only examination
> of the file system metadata (but not the data blocks).  The idea is
> that this version of debugfs might be suitable to be setuid root, and
> executable only by members of a particular group, or setgid disk, and
> globally executable, depending on the security/privacy policies in
> force at a particular site.

Just curious - what problem does this solve?

(Could the same policies simply make direct access to block devices
read-only for those users, and thus have an fs-independent solution
to whatever problem is at hand?)

- -Eric

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  debugfs/Makefile.in      |   20 ++++++++++-
>  debugfs/debugfs.c        |   53 ++++++++++++++++++++++++++---
>  debugfs/ro_debug_cmds.ct |   85 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 151 insertions(+), 7 deletions(-)
>  create mode 100644 debugfs/ro_debug_cmds.ct
> 
> diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
> index e314b91..4674ba6 100644
> --- a/debugfs/Makefile.in
> +++ b/debugfs/Makefile.in
> @@ -11,7 +11,7 @@ INSTALL = @INSTALL@
>  
>  @MCONFIG@
>  
> -PROGS=		debugfs
> +PROGS=		debugfs rdebugfs
>  MANPAGES=	debugfs.8
>  
>  MK_CMDS=	_SS_DIR_OVERRIDE=../lib/ss ../lib/ss/mk_cmds
> @@ -19,6 +19,9 @@ MK_CMDS=	_SS_DIR_OVERRIDE=../lib/ss ../lib/ss/mk_cmds
>  DEBUG_OBJS= debug_cmds.o debugfs.o util.o ncheck.o icheck.o ls.o \
>  	lsdel.o dump.o set_fields.o logdump.o htree.o unused.o
>  
> +RO_DEBUG_OBJS= ro_debug_cmds.o ro_debugfs.o util.o ncheck.o icheck.o ls.o \
> +	lsdel.o logdump.o htree.o
> +
>  SRCS= debug_cmds.c $(srcdir)/debugfs.c $(srcdir)/util.c $(srcdir)/ls.c \
>  	$(srcdir)/ncheck.c $(srcdir)/icheck.c $(srcdir)/lsdel.c \
>  	$(srcdir)/dump.c $(srcdir)/set_fields.c ${srcdir}/logdump.c \
> @@ -39,10 +42,22 @@ debugfs: $(DEBUG_OBJS) $(DEPLIBS)
>  	$(E) "	LD $@"
>  	$(Q) $(CC) $(ALL_LDFLAGS) -o debugfs $(DEBUG_OBJS) $(LIBS)
>  
> +rdebugfs: $(RO_DEBUG_OBJS) $(DEPLIBS)
> +	$(E) "	LD $@"
> +	$(Q) $(CC) $(ALL_LDFLAGS) -o rdebugfs $(RO_DEBUG_OBJS) $(LIBS)
> +
>  debug_cmds.c debug_cmds.h: debug_cmds.ct
>  	$(E) "	MK_CMDS $@"
>  	$(Q) $(MK_CMDS) $(srcdir)/debug_cmds.ct
>  
> +ro_debug_cmds.c ro_debug_cmds.h: ro_debug_cmds.ct
> +	$(E) "	MK_CMDS $@"
> +	$(Q) $(MK_CMDS) $(srcdir)/ro_debug_cmds.ct
> +
> +ro_debugfs.o: debugfs.c
> +	$(E) "	CC $@"
> +	$(Q) $(CC) -c $(ALL_CFLAGS) $< -DREAD_ONLY -o $@
> +
>  debugfs.8: $(DEP_SUBSTITUTE) $(srcdir)/debugfs.8.in
>  	$(E) "	SUBST $@"
>  	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/debugfs.8.in debugfs.8
> @@ -80,7 +95,8 @@ uninstall:
>  	done
>  
>  clean:
> -	$(RM) -f debugfs debugfs.8 \#* *.s *.o *.a *~ debug_cmds.c core
> +	$(RM) -f $(PROGS) debugfs.8 \#* *.s *.o *.a *~ debug_cmds.c \
> +		ro_debug_cmds.c core
>  
>  mostlyclean: clean
>  distclean: clean
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index 1fb8f44..fda8d92 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -140,7 +140,11 @@ void do_open_filesys(int argc, char **argv)
>  			open_flags |= EXT2_FLAG_IMAGE_FILE;
>  			break;
>  		case 'w':
> +#ifdef READ_ONLY
> +			goto print_usage;
> +#else
>  			open_flags |= EXT2_FLAG_RW;
> +#endif /* READ_ONLY */
>  			break;
>  		case 'f':
>  			open_flags |= EXT2_FLAG_FORCE;
> @@ -184,8 +188,11 @@ void do_open_filesys(int argc, char **argv)
>  	return;
>  
>  print_usage:
> -	fprintf(stderr, "%s: Usage: open [-s superblock] [-b blocksize] "
> -		"[-c] [-w] <device>\n", argv[0]);
> +	fprintf(stderr, "%s: Usage: open [-s superblock] [-b blocksize] [-c] "
> +#ifndef READ_ONLY
> +		"[-w] "
> +#endif
> +		"<device>\n", argv[0]);
>  }
>  
>  void do_lcd(int argc, char **argv)
> @@ -251,6 +258,7 @@ void do_close_filesys(int argc, char **argv)
>  	close_filesystem();
>  }
>  
> +#ifndef READ_ONLY
>  void do_init_filesys(int argc, char **argv)
>  {
>  	struct ext2_super_block param;
> @@ -276,6 +284,7 @@ void do_init_filesys(int argc, char **argv)
>  	root = cwd = EXT2_ROOT_INO;
>  	return;
>  }
> +#endif /* READ_ONLY */
>  
>  static void print_features(struct ext2_super_block * s, FILE *f)
>  {
> @@ -393,6 +402,7 @@ print_usage:
>  	fprintf(stderr, "%s: Usage: show_super [-h]\n", argv[0]);
>  }
>  
> +#ifndef READ_ONLY
>  void do_dirty_filesys(int argc EXT2FS_ATTR((unused)),
>  		      char **argv EXT2FS_ATTR((unused)))
>  {
> @@ -407,6 +417,7 @@ void do_dirty_filesys(int argc EXT2FS_ATTR((unused)),
>  		current_fs->super->s_state &= ~EXT2_VALID_FS;
>  	ext2fs_mark_super_dirty(current_fs);
>  }
> +#endif /* READ_ONLY */
>  
>  struct list_blocks_struct {
>  	FILE		*f;
> @@ -964,6 +975,7 @@ void do_chroot(int argc, char *argv[])
>  	root = inode;
>  }
>  
> +#ifndef READ_ONLY
>  void do_clri(int argc, char *argv[])
>  {
>  	ext2_ino_t inode;
> @@ -1006,6 +1018,7 @@ void do_seti(int argc, char *argv[])
>  	ext2fs_mark_inode_bitmap2(current_fs->inode_map,inode);
>  	ext2fs_mark_ib_dirty(current_fs);
>  }
> +#endif /* READ_ONLY */
>  
>  void do_testi(int argc, char *argv[])
>  {
> @@ -1020,6 +1033,7 @@ void do_testi(int argc, char *argv[])
>  		printf("Inode %u is not in use\n", inode);
>  }
>  
> +#ifndef READ_ONLY
>  void do_freeb(int argc, char *argv[])
>  {
>  	blk64_t block;
> @@ -1057,6 +1071,7 @@ void do_setb(int argc, char *argv[])
>  	}
>  	ext2fs_mark_bb_dirty(current_fs);
>  }
> +#endif /* READ_ONLY */
>  
>  void do_testb(int argc, char *argv[])
>  {
> @@ -1074,6 +1089,7 @@ void do_testb(int argc, char *argv[])
>  	}
>  }
>  
> +#ifndef READ_ONLY
>  static void modify_u8(char *com, const char *prompt,
>  		      const char *format, __u8 *val)
>  {
> @@ -1217,6 +1233,7 @@ void do_modify_inode(int argc, char *argv[])
>  	if (debugfs_write_inode(inode_num, &inode, argv[1]))
>  		return;
>  }
> +#endif /* READ_ONLY */
>  
>  void do_change_working_dir(int argc, char *argv[])
>  {
> @@ -1298,6 +1315,7 @@ static int ext2_file_type(unsigned int mode)
>  	return 0;
>  }
>  
> +#ifndef READ_ONLY
>  static void make_link(char *sourcename, char *destname)
>  {
>  	ext2_ino_t	ino;
> @@ -1445,6 +1463,7 @@ void do_unlink(int argc, char *argv[])
>  
>  	unlink_file_by_name(argv[1]);
>  }
> +#endif /* READ_ONLY */
>  
>  void do_find_free_block(int argc, char *argv[])
>  {
> @@ -1537,6 +1556,7 @@ void do_find_free_inode(int argc, char *argv[])
>  		printf("Free inode found: %u\n", free_inode);
>  }
>  
> +#ifndef READ_ONLY
>  static errcode_t copy_file(int fd, ext2_ino_t newfile)
>  {
>  	ext2_file_t	e2_file;
> @@ -1944,6 +1964,7 @@ void do_rmdir(int argc, char *argv[])
>  			return;
>  	}
>  }
> +#endif /* READ_ONLY */
>  
>  void do_show_debugfs_params(int argc EXT2FS_ATTR((unused)),
>  			    char *argv[] EXT2FS_ATTR((unused)))
> @@ -1957,6 +1978,7 @@ void do_show_debugfs_params(int argc EXT2FS_ATTR((unused)),
>  		current_fs ? current_fs->device_name : "--none--");
>  }
>  
> +#ifndef READ_ONLY
>  void do_expand_dir(int argc, char *argv[])
>  {
>  	ext2_ino_t inode;
> @@ -1990,6 +2012,7 @@ void do_features(int argc, char *argv[])
>  	}
>  	print_features(current_fs->super, stdout);
>  }
> +#endif /* READ_ONLY */
>  
>  void do_bmap(int argc, char *argv[])
>  {
> @@ -2047,6 +2070,7 @@ void do_imap(int argc, char *argv[])
>  
>  }
>  
> +#ifndef READ_ONLY
>  void do_set_current_time(int argc, char *argv[])
>  {
>  	time_t now;
> @@ -2066,6 +2090,7 @@ void do_set_current_time(int argc, char *argv[])
>  		current_fs->now = now;
>  	}
>  }
> +#endif /* READ_ONLY */
>  
>  static int find_supp_feature(__u32 *supp, int feature_type, char *name)
>  {
> @@ -2132,6 +2157,7 @@ void do_supported_features(int argc, char *argv[])
>  	}
>  }
>  
> +#ifndef READ_ONLY
>  void do_punch(int argc, char *argv[])
>  {
>  	ext2_ino_t	ino;
> @@ -2162,6 +2188,7 @@ void do_punch(int argc, char *argv[])
>  		return;
>  	}
>  }
> +#endif /* READ_ONLY */
>  
>  void do_dump_mmp(int argc, char *argv[])
>  {
> @@ -2256,7 +2283,13 @@ int main(int argc, char **argv)
>  {
>  	int		retval;
>  	int		sci_idx;
> -	const char	*usage = "Usage: %s [-b blocksize] [-s superblock] [-f cmd_file] [-R request] [-V] [[-w] [-c] device]";
> +	const char	*usage = 
> +		"Usage: %s [-b blocksize] [-s superblock] [-f cmd_file] "
> +		"[-R request] [-V] ["
> +#ifndef READ_ONLY
> +		"[-w] "
> +#endif
> +		"[-c] device]";
>  	int		c;
>  	int		open_flags = EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_64BITS;
>  	char		*request = 0;
> @@ -2266,15 +2299,23 @@ int main(int argc, char **argv)
>  	blk64_t		blocksize = 0;
>  	int		catastrophic = 0;
>  	char		*data_filename = 0;
> +#ifdef READ_ONLY
> +	const char	*opt_string = "iwcR:f:b:s:Vd:D";
> +#else
> +	const char	*opt_string = "icR:f:b:s:Vd:D";
> +#endif
>  
>  	if (debug_prog_name == 0)
> +#ifdef READ_ONLY
> +		debug_prog_name = "rdebugfs";
> +#else
>  		debug_prog_name = "debugfs";
> -
> +#endif
>  	add_error_table(&et_ext2_error_table);
>  	fprintf (stderr, "%s %s (%s)\n", debug_prog_name,
>  		 E2FSPROGS_VERSION, E2FSPROGS_DATE);
>  
> -	while ((c = getopt (argc, argv, "iwcR:f:b:s:Vd:D")) != EOF) {
> +	while ((c = getopt (argc, argv, opt_string)) != EOF) {
>  		switch (c) {
>  		case 'R':
>  			request = optarg;
> @@ -2288,9 +2329,11 @@ int main(int argc, char **argv)
>  		case 'i':
>  			open_flags |= EXT2_FLAG_IMAGE_FILE;
>  			break;
> +#ifndef READ_ONLY
>  		case 'w':
>  			open_flags |= EXT2_FLAG_RW;
>  			break;
> +#endif
>  		case 'D':
>  			open_flags |= EXT2_FLAG_DIRECT_IO;
>  			break;
> diff --git a/debugfs/ro_debug_cmds.ct b/debugfs/ro_debug_cmds.ct
> new file mode 100644
> index 0000000..4b16a67
> --- /dev/null
> +++ b/debugfs/ro_debug_cmds.ct
> @@ -0,0 +1,85 @@
> +#
> +# Restricted set of debugfs commands
> +#
> +# Copyright (C) 1993 Theodore Ts'o.  This file may be redistributed
> +# under the terms of the GNU Public License.
> +#
> +command_table debug_cmds;
> +
> +request do_show_debugfs_params, "Show debugfs parameters",
> +	show_debugfs_params, params;
> +
> +request do_open_filesys, "Open a filesystem",
> +	open_filesys, open;
> +
> +request do_close_filesys, "Close the filesystem",
> +	close_filesys, close;
> +
> +request do_show_super_stats, "Show superblock statistics",
> +	show_super_stats, stats;
> +
> +request do_ncheck, "Do inode->name translation",
> +	ncheck;
> +
> +request do_icheck, "Do block->inode translation",
> +	icheck;
> +
> +request do_chroot, "Change root directory",
> +	change_root_directory, chroot;
> +
> +request do_change_working_dir, "Change working directory",
> +	change_working_directory, cd;
> +
> +request do_list_dir, "List directory",
> +	list_directory, ls;
> +
> +request do_stat, "Show inode information ",
> +	show_inode_info, stat;
> +
> +request do_dump_extents, "Dump extents information ",
> +	dump_extents, extents, ex;
> +
> +request do_blocks, "Dump blocks used by an inode ",
> +	blocks;
> +
> +request do_testi, "Test an inode's in-use flag",
> +	testi;
> +
> +request do_find_free_block, "Find free block(s)",
> +	find_free_block, ffb;
> +
> +request do_find_free_inode, "Find free inode(s)",
> +	find_free_inode, ffi;
> +
> +request	do_print_working_directory, "Print current working directory",
> +	print_working_directory, pwd; 
> +
> +request do_lsdel, "List deleted inodes",
> +	list_deleted_inodes, lsdel;
> +
> +request do_logdump, "Dump the contents of the journal",
> +	logdump;
> +
> +request do_htree_dump, "Dump a hash-indexed directory",
> +	htree_dump, htree;
> +
> +request do_dx_hash, "Calculate the directory hash of a filename",
> +	dx_hash, hash;
> +
> +request do_dirsearch, "Search a directory for a particular filename",
> +	dirsearch;
> +
> +request do_bmap, "Calculate the logical->physical block mapping for an inode",
> +	bmap;
> +
> +request do_imap, "Calculate the location of an inode",
> +	imap;
> +
> +request do_supported_features, "Print features supported by this version of e2fsprogs",
> +	supported_features;
> +
> +request do_dump_mmp, "Dump MMP information",
> +	dump_mmp;
> +
> +end;
> +

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOwohEAAoJECCuFpLhPd7gzEUQAISFIzFo1U2Tx0xsIJWCLzuS
/mYVLTq2I4MvwQ87HQvMEl+cb6EdHCFm5VSVRGcMN2qd/jCvN8DW7XiwxA5JJvrv
nXmqcp4HMOCOe1fzmRl5Q+GMoJQpNAbgBcVne0l9QJJxO3xbteDBoPrR7jRyHq7V
38kfXa87/MVxm5Q3u6dldHeyU4xKJwIoyQ31bOcnKl8pdJP9sJvVyqvr4zJMkZb+
UnXYcXWAJEBoVChOYBmc8BlHOBvQwecS47XM05TVcY5TYh5VtPoxC2lZKbH8HCFV
k6AEExieGUisOZ5S5+OctS+5syFaoiZMVnbSN9EQd44WxhDGKh77cG+mTRc9kUBr
lbLZvGhnpdcinzT7SiCSGO5MPtnr3UNThZSR29rW2kIZOOJLJKLP/+FobCWhLJOt
LCa4T+OVaFxNk0QBFyK7/m1ARAWDBPs2kiC5sL07kSyqwIGqVy2hbot4OyRgVPzM
4FZIrOo0FGA7p5LXqrlGz88AavCFRo/VNWv8LPfP/VNDTgJlXIGc9g/rwRFhrQum
657OOriFP9V2bw4uG3/Mxl8GYQgCmlEnEn4LUEIO0nl9UU69xEbWaR5jlpr3IWyx
AfQWG1WEo5lRUTqFGlLQ8qEYZs6LoIyjR3987uWrI5W7A7PAKlik7d3V3YkK5gtY
njKXQkCkmA/ijW60FsED
=SVNC
-----END PGP SIGNATURE-----
