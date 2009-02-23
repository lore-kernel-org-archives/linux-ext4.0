From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] remove useless if-before-free tests
Date: Mon, 23 Feb 2009 18:07:50 +0100
Message-ID: <87y6vxcc9l.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:37443 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbZBWRIA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Feb 2009 12:08:00 -0500
Received: from smtp6-g21.free.fr (localhost [127.0.0.1])
	by smtp6-g21.free.fr (Postfix) with ESMTP id 8D7BEE080E9
	for <linux-ext4@vger.kernel.org>; Mon, 23 Feb 2009 18:07:52 +0100 (CET)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64])
	by smtp6-g21.free.fr (Postfix) with ESMTP id 8F074E0827E
	for <linux-ext4@vger.kernel.org>; Mon, 23 Feb 2009 18:07:50 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I noticed that the strdup-leak-fixing patch I just posted has a
prerequisite, otherwise it won't apply.  Apply the following patch first:
(if that's a problem, I can rework it)

In case you're wondering about whether this change is safe from a
portability standpoint, fear not.  This has been beaten to death
in other forums.  Here are a few threads:

  http://thread.gmane.org/gmane.comp.version-control.git/74187
  http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/12712
  http://thread.gmane.org/gmane.emacs.devel/98144
  http://thread.gmane.org/gmane.comp.lib.glibc.alpha/13092

There has been debate about whether it's a good idea from a
performance standpoint, too, but imho you'll have a hard time
finding an instance where this sort of change induces a
measurable performance penalty.  If you do, please let me know.

As for whether I made mistakes while making these changes, that
is always possible.  However, all but four hunks were changed
automatically by running this:

mkid; useless-if-before-free -l $(lid -knone free) \
  | xargs -0 perl -0x3b -pi -e \
's/\bif\s*\(\s*(\S+?)(?:\s*!=\s*NULL)?\s*\)\s+(free\s*\((?:\s*\([^)]+\))?\s*\1\s*\))/$2/s'

The remaining four were spotted by running this:

  git ls-files -z |xargs -0 useless-if-before-free

and then I manually made changes like this (all in nt_io.c):

-				if(NULL != io->name)
-				{
-					free(io->name);
-				}
-
+				free(io->name);

>From 532bf81f7a60a750ea22419f711e78f97ea91a11 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Mon, 23 Feb 2009 17:52:01 +0100
Subject: [PATCH] remove useless if-before-free tests

---
 debugfs/htree.c         |    3 +--
 debugfs/icheck.c        |    3 +--
 e2fsck/argv_parse.c     |    5 ++---
 e2fsck/dirinfo.c        |    3 +--
 e2fsck/profile.c        |    9 +++------
 e2fsck/rehash.c         |   12 ++++--------
 intl/bindtextdom.c      |    3 +--
 intl/loadmsgcat.c       |    6 ++----
 intl/localcharset.c     |    3 +--
 intl/printf-parse.c     |    6 ++----
 intl/vasnprintf.c       |    9 +++------
 lib/blkid/cache.c       |    3 +--
 lib/blkid/dev.c         |   15 +++++----------
 lib/blkid/devno.c       |    3 +--
 lib/blkid/probe.c       |    6 ++----
 lib/blkid/resolve.c     |    6 ++----
 lib/blkid/save.c        |    3 +--
 lib/blkid/tag.c         |    9 +++------
 lib/ext2fs/dosio.c      |   15 +++++----------
 lib/ext2fs/extent.c     |    3 +--
 lib/ext2fs/initialize.c |    3 +--
 lib/ext2fs/nt_io.c      |   25 ++++---------------------
 lib/ss/execute_cmd.c    |    3 +--
 misc/badblocks.c        |    3 +--
 misc/blkid.c            |    6 ++----
 misc/e2initrd_helper.c  |    3 +--
 misc/fsck.c             |   12 ++++--------
 misc/mke2fs.c           |   12 ++++--------
 misc/tune2fs.c          |    3 +--
 resize/resize2fs.c      |    3 +--
 util/subst.c            |    6 ++----
 31 files changed, 64 insertions(+), 140 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 4b8d7e9..62dba4a 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -275,8 +275,7 @@ void do_htree_dump(int argc, char *argv[])
 			    rootnode->indirect_levels);

 errout:
-	if (buf)
-		free(buf);
+	free(buf);
 	close_pager(pager);
 }

diff --git a/debugfs/icheck.c b/debugfs/icheck.c
index 2f880c0..4b090a9 100644
--- a/debugfs/icheck.c
+++ b/debugfs/icheck.c
@@ -161,8 +161,7 @@ void do_icheck(int argc, char **argv)

 error_out:
 	free(bw.barray);
-	if (block_buf)
-		free(block_buf);
+	free(block_buf);
 	if (scan)
 		ext2fs_close_inode_scan(scan);
 	return;
diff --git a/e2fsck/argv_parse.c b/e2fsck/argv_parse.c
index 09af765..c0c5bbe 100644
--- a/e2fsck/argv_parse.c
+++ b/e2fsck/argv_parse.c
@@ -66,7 +66,7 @@ int argv_parse(char *in_buf, int *ret_argc, char ***ret_argv)
 				new_argv = realloc(argv,
 						  (max_argc+1)*sizeof(char *));
 				if (!new_argv) {
-					if (argv) free(argv);
+					free(argv);
 					free(buf);
 					return -1;
 				}
@@ -126,8 +126,7 @@ int argv_parse(char *in_buf, int *ret_argc, char ***ret_argv)

 void argv_free(char **argv)
 {
-	if (*argv)
-		free(*argv);
+	free(*argv);
 	free(argv);
 }

diff --git a/e2fsck/dirinfo.c b/e2fsck/dirinfo.c
index f583c62..fb2887b 100644
--- a/e2fsck/dirinfo.c
+++ b/e2fsck/dirinfo.c
@@ -326,8 +326,7 @@ extern struct dir_info_iter *e2fsck_dir_info_iter_begin(e2fsck_t ctx)
 extern void e2fsck_dir_info_iter_end(e2fsck_t ctx EXT2FS_ATTR((unused)),
 				     struct dir_info_iter *iter)
 {
-	if (iter->tdb_iter.dptr)
-		free(iter->tdb_iter.dptr);
+	free(iter->tdb_iter.dptr);
 	ext2fs_free_mem(&iter);
 }

diff --git a/e2fsck/profile.c b/e2fsck/profile.c
index ef439f2..5e9dc53 100644
--- a/e2fsck/profile.c
+++ b/e2fsck/profile.c
@@ -603,8 +603,7 @@ void profile_free_file(prf_file_t prf)
 {
     if (prf->root)
 	profile_free_node(prf->root);
-    if (prf->filespec)
-	    free(prf->filespec);
+    free(prf->filespec);
     free(prf);
 }

@@ -1049,10 +1048,8 @@ void profile_free_node(struct profile_node *node)
 	if (node->magic != PROF_MAGIC_NODE)
 		return;

-	if (node->name)
-		free(node->name);
-	if (node->value)
-		free(node->value);
+	free(node->name);
+	free(node->value);

 	for (child=node->first_child; child; child = next) {
 		next = child->next;
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 6c24bdd..ff42a6e 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -247,10 +247,8 @@ static errcode_t alloc_size_dir(ext2_filsys fs, struct out_dir *outdir,

 static void free_out_dir(struct out_dir *outdir)
 {
-	if (outdir->buf)
-		free(outdir->buf);
-	if (outdir->hashes)
-		free(outdir->hashes);
+	free(outdir->buf);
+	free(outdir->hashes);
 	outdir->max = 0;
 	outdir->num =0;
 }
@@ -768,10 +766,8 @@ resort:
 		goto errout;

 errout:
-	if (dir_buf)
-		free(dir_buf);
-	if (fd.harray)
-		free(fd.harray);
+	free(dir_buf);
+	free(fd.harray);

 	free_out_dir(&outdir);
 	return retval;
diff --git a/intl/bindtextdom.c b/intl/bindtextdom.c
index dcdc400..8284226 100644
--- a/intl/bindtextdom.c
+++ b/intl/bindtextdom.c
@@ -197,8 +197,7 @@ set_binding_values (const char *domainname,

 		  if (__builtin_expect (result != NULL, 1))
 		    {
-		      if (binding->codeset != NULL)
-			free (binding->codeset);
+		      free (binding->codeset);

 		      binding->codeset = result;
 		      binding->codeset_cntr++;
diff --git a/intl/loadmsgcat.c b/intl/loadmsgcat.c
index c8fc46d..7fab71a 100644
--- a/intl/loadmsgcat.c
+++ b/intl/loadmsgcat.c
@@ -1372,8 +1372,7 @@ _nl_load_domain (struct loaded_l10nfile *domain_file,
       /* This is an invalid revision.  */
     invalid:
       /* This is an invalid .mo file.  */
-      if (domain->malloced)
-	free (domain->malloced);
+      free (domain->malloced);
 #ifdef HAVE_MMAP
       if (use_mmap)
 	munmap ((void *) data, size);
@@ -1405,8 +1404,7 @@ _nl_unload_domain (struct loaded_domain *domain)

   _nl_free_domain_conv (domain);

-  if (domain->malloced)
-    free (domain->malloced);
+  free (domain->malloced);

 # ifdef _POSIX_MAPPED_FILES
   if (domain->use_mmap)
diff --git a/intl/localcharset.c b/intl/localcharset.c
index 4865f10..a3e3a9b 100644
--- a/intl/localcharset.c
+++ b/intl/localcharset.c
@@ -199,8 +199,7 @@ get_charset_aliases ()
 	    }
 	}

-      if (file_name != NULL)
-	free (file_name);
+      free (file_name);

 #else

diff --git a/intl/printf-parse.c b/intl/printf-parse.c
index d19f903..416deda 100644
--- a/intl/printf-parse.c
+++ b/intl/printf-parse.c
@@ -524,10 +524,8 @@ PRINTF_PARSE (const CHAR_T *format, DIRECTIVES *d, arguments *a)
   return 0;

 error:
-  if (a->arg)
-    free (a->arg);
-  if (d->dir)
-    free (d->dir);
+  free (a->arg);
+  free (d->dir);
   return -1;
 }

diff --git a/intl/vasnprintf.c b/intl/vasnprintf.c
index 8a62282..61bfb9e 100644
--- a/intl/vasnprintf.c
+++ b/intl/vasnprintf.c
@@ -801,8 +801,7 @@ VASNPRINTF (CHAR_T *resultbuf, size_t *lengthp, const CHAR_T *format, va_list ar
 		      {
 			if (!(result == resultbuf || result == NULL))
 			  free (result);
-			if (buf_malloced != NULL)
-			  free (buf_malloced);
+			free (buf_malloced);
 			CLEANUP ();
 			errno = EINVAL;
 			return NULL;
@@ -860,8 +859,7 @@ VASNPRINTF (CHAR_T *resultbuf, size_t *lengthp, const CHAR_T *format, va_list ar
 	  result = memory;
       }

-    if (buf_malloced != NULL)
-      free (buf_malloced);
+    free (buf_malloced);
     CLEANUP ();
     *lengthp = length;
     return result;
@@ -869,8 +867,7 @@ VASNPRINTF (CHAR_T *resultbuf, size_t *lengthp, const CHAR_T *format, va_list ar
   out_of_memory:
     if (!(result == resultbuf || result == NULL))
       free (result);
-    if (buf_malloced != NULL)
-      free (buf_malloced);
+    free (buf_malloced);
   out_of_memory_1:
     CLEANUP ();
     errno = ENOMEM;
diff --git a/lib/blkid/cache.c b/lib/blkid/cache.c
index 7c95726..2b81886 100644
--- a/lib/blkid/cache.c
+++ b/lib/blkid/cache.c
@@ -146,8 +146,7 @@ void blkid_put_cache(blkid_cache cache)
 		}
 		blkid_free_tag(tag);
 	}
-	if (cache->bic_filename)
-		free(cache->bic_filename);
+	free(cache->bic_filename);

 	free(cache);
 }
diff --git a/lib/blkid/dev.c b/lib/blkid/dev.c
index fb8d852..128a869 100644
--- a/lib/blkid/dev.c
+++ b/lib/blkid/dev.c
@@ -45,8 +45,7 @@ void blkid_free_dev(blkid_dev dev)
 					   bit_tags);
 		blkid_free_tag(tag);
 	}
-	if (dev->bid_name)
-		free(dev->bid_name);
+	free(dev->bid_name);
 	free(dev);
 }

@@ -137,18 +136,14 @@ extern int blkid_dev_set_search(blkid_dev_iterate iter,
 	new_type = malloc(strlen(search_type)+1);
 	new_value = malloc(strlen(search_value)+1);
 	if (!new_type || !new_value) {
-		if (new_type)
-			free(new_type);
-		if (new_value)
-			free(new_value);
+		free(new_type);
+		free(new_value);
 		return -1;
 	}
 	strcpy(new_type, search_type);
 	strcpy(new_value, search_value);
-	if (iter->search_type)
-		free(iter->search_type);
-	if (iter->search_value)
-		free(iter->search_value);
+	free(iter->search_type);
+	free(iter->search_value);
 	iter->search_type = new_type;
 	iter->search_value = new_value;
 	return 0;
diff --git a/lib/blkid/devno.c b/lib/blkid/devno.c
index 0a16d9b..c9f5c92 100644
--- a/lib/blkid/devno.c
+++ b/lib/blkid/devno.c
@@ -222,8 +222,7 @@ int main(int argc, char** argv)
 	}
 	printf("Looking for device 0x%04llx\n", (long long)devno);
 	devname = blkid_devno_to_devname(devno);
-	if (devname)
-		free(devname);
+	free(devname);
 	return 0;
 }
 #endif
diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 1ed7d46..76763ae 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -1528,10 +1528,8 @@ found_type:
 			   dev->bid_name, (long long)st.st_rdev, type));
 	}

-	if (probe.sbbuf)
-		free(probe.sbbuf);
-	if (probe.buf)
-		free(probe.buf);
+	free(probe.sbbuf);
+	free(probe.buf);
 	if (probe.fd >= 0)
 		close(probe.fd);

diff --git a/lib/blkid/resolve.c b/lib/blkid/resolve.c
index 678f34e..6c2e268 100644
--- a/lib/blkid/resolve.c
+++ b/lib/blkid/resolve.c
@@ -97,10 +97,8 @@ char *blkid_get_devname(blkid_cache cache, const char *token,
 	ret = blkid_strdup(blkid_dev_devname(dev));

 out:
-	if (t)
-		free(t);
-	if (v)
-		free(v);
+	free(t);
+	free(v);
 	if (!cache) {
 		blkid_put_cache(c);
 	}
diff --git a/lib/blkid/save.c b/lib/blkid/save.c
index 656bb0b..6802e9d 100644
--- a/lib/blkid/save.c
+++ b/lib/blkid/save.c
@@ -153,8 +153,7 @@ int blkid_flush_cache(blkid_cache cache)
 	}

 errout:
-	if (tmp)
-		free(tmp);
+	free(tmp);
 	return ret;
 }

diff --git a/lib/blkid/tag.c b/lib/blkid/tag.c
index b305ab4..639ef89 100644
--- a/lib/blkid/tag.c
+++ b/lib/blkid/tag.c
@@ -54,10 +54,8 @@ void blkid_free_tag(blkid_tag tag)
 	list_del(&tag->bit_tags);	/* list of tags for this device */
 	list_del(&tag->bit_names);	/* list of tags with this type */

-	if (tag->bit_name)
-		free(tag->bit_name);
-	if (tag->bit_val)
-		free(tag->bit_val);
+	free(tag->bit_name);
+	free(tag->bit_val);

 	free(tag);
 }
@@ -206,8 +204,7 @@ int blkid_set_tag(blkid_dev dev, const char *name,
 errout:
 	if (t)
 		blkid_free_tag(t);
-	else if (val)
-		free(val);
+	else free(val);
 	if (head)
 		blkid_free_tag(head);
 	return -BLKID_ERR_MEM;
diff --git a/lib/ext2fs/dosio.c b/lib/ext2fs/dosio.c
index d93cc6a..97ceef5 100644
--- a/lib/ext2fs/dosio.c
+++ b/lib/ext2fs/dosio.c
@@ -278,8 +278,7 @@ static errcode_t dos_open(const char *dev, int flags, io_channel *channel)
   if(!HW_OK())
   {
     _dio_error = ERR_HARDWARE;
-    if (part)
-	    free(part);
+    free(part);
     return EFAULT;
   }

@@ -298,8 +297,7 @@ static errcode_t dos_open(const char *dev, int flags, io_channel *channel)
   if(!HW_OK())
   {
     _dio_error = ERR_HARDWARE;
-    if (part)
-	    free(part);
+    free(part);
     return EFAULT;
   }

@@ -310,8 +308,7 @@ static errcode_t dos_open(const char *dev, int flags, io_channel *channel)
   {
     _dio_error = part->pno == 0xFE ? ERR_EMPTYPART :
                  part->pno == 0xFD ? ERR_LINUXSWAP : ERR_NOTEXT2FS;
-    if (part)
-	    free(part);
+    free(part);
     return ENODEV;
   }

@@ -352,10 +349,8 @@ static errcode_t dos_open(const char *dev, int flags, io_channel *channel)

 static errcode_t dos_close(io_channel channel)
 {
-	if (channel->name)
-		free(channel->name);
-	if (channel)
-		free(channel);
+	free(channel->name);
+	free(channel);

 	return 0;
 }
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 929e5cd..55e2313 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1005,8 +1005,7 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
 done:
 	if (newpath)
 		ext2fs_free_mem(&newpath);
-	if (block_buf)
-		free(block_buf);
+	free(block_buf);

 	return retval;
 }
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 22d1899..21fc293 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -437,8 +437,7 @@ ipg_retry:
 	*ret_fs = fs;
 	return 0;
 cleanup:
-	if (buf)
-		free(buf);
+	free(buf);
 	ext2fs_free(fs);
 	return retval;
 }
diff --git a/lib/ext2fs/nt_io.c b/lib/ext2fs/nt_io.c
index c39127c..efd2a09 100644
--- a/lib/ext2fs/nt_io.c
+++ b/lib/ext2fs/nt_io.c
@@ -1191,11 +1191,7 @@ nt_open(const char *name, int flags, io_channel *channel)

 			if (NULL != io)
 			{
-				if(NULL != io->name)
-				{
-					free(io->name);
-				}
-
+				free(io->name);
 				free(io);
 			}

@@ -1207,11 +1203,7 @@ nt_open(const char *name, int flags, io_channel *channel)
 					_CloseDisk(NtData->Handle);
 				}

-				if(NULL != NtData->Buffer)
-				{
-					free(NtData->Buffer);
-				}
-
+				free(NtData->Buffer);
 				free(NtData);
 			}
 		}
@@ -1245,12 +1237,7 @@ nt_close(io_channel channel)
 		return 0;
 	}

-	if(NULL != channel->name)
-	{
-		free(channel->name);
-	}
-
-
+	free(channel->name);
 	free(channel);

 	if (NULL != NtData)
@@ -1262,11 +1249,7 @@ nt_close(io_channel channel)
 			_CloseDisk(NtData->Handle);
 		}

-		if(NULL != NtData->Buffer)
-		{
-			free(NtData->Buffer);
-		}
-
+		free(NtData->Buffer);
 		free(NtData);
 	}

diff --git a/lib/ss/execute_cmd.c b/lib/ss/execute_cmd.c
index b9f2a4e..e9c65f6 100644
--- a/lib/ss/execute_cmd.c
+++ b/lib/ss/execute_cmd.c
@@ -221,8 +221,7 @@ int ss_execute_line (sci_idx, line_ptr)
     /* parse it */
     argv = ss_parse(sci_idx, line_ptr, &argc);
     if (argc == 0) {
-	if (argv)
-	    free(argv);
+	free(argv);
         return 0;
     }

diff --git a/misc/badblocks.c b/misc/badblocks.c
index f7d67a7..528bc22 100644
--- a/misc/badblocks.c
+++ b/misc/badblocks.c
@@ -1237,8 +1237,7 @@ int main (int argc, char ** argv)
 	close (dev);
 	if (out != stdout)
 		fclose (out);
-	if (t_patts)
-		free(t_patts);
+	free(t_patts);
 	return 0;
 }

diff --git a/misc/blkid.c b/misc/blkid.c
index 4bbf9fb..0c34d61 100644
--- a/misc/blkid.c
+++ b/misc/blkid.c
@@ -420,10 +420,8 @@ int main(int argc, char **argv)
 	}

 exit:
-	if (search_type)
-		free(search_type);
-	if (search_value)
-		free(search_value);
+	free(search_type);
+	free(search_value);
 	blkid_put_cache(cache);
 	return err;
 }
diff --git a/misc/e2initrd_helper.c b/misc/e2initrd_helper.c
index c4e2e46..eaf9ce6 100644
--- a/misc/e2initrd_helper.c
+++ b/misc/e2initrd_helper.c
@@ -274,8 +274,7 @@ static int parse_fstab_line(char *line, struct fs_info *fs)
 	fs->flags = 0;
 	fs->next = NULL;

-	if (dev)
-		free(dev);
+	free(dev);

 	return 0;
 }
diff --git a/misc/fsck.c b/misc/fsck.c
index ea8f0e2..fe9426e 100644
--- a/misc/fsck.c
+++ b/misc/fsck.c
@@ -233,12 +233,9 @@ static void parse_escape(char *word)

 static void free_instance(struct fsck_instance *i)
 {
-	if (i->prog)
-		free(i->prog);
-	if (i->device)
-		free(i->device);
-	if (i->base_device)
-		free(i->base_device);
+	free(i->prog);
+	free(i->device);
+	free(i->base_device);
 	free(i);
 	return;
 }
@@ -310,8 +307,7 @@ static int parse_fstab_line(char *line, struct fs_info **ret_fs)
 	fs = create_fs_device(device, mntpnt, type ? type : "auto", opts,
 			      freq ? atoi(freq) : -1,
 			      passno ? atoi(passno) : -1);
-	if (dev)
-		free(dev);
+	free(dev);

 	if (!fs)
 		return -1;
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 3d830fc..3a55282 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1021,8 +1021,7 @@ static char **parse_fs_type(const char *fs_type,
 		}
 	}
 	free(parse_str);
-	if (profile_type)
-		free(profile_type);
+	free(profile_type);
 	if (is_hurd)
 		push_string(&list, "hurd");
 	return (list.list);
@@ -1499,16 +1498,14 @@ static void PRS(int argc, char *argv[])
 					   "features", "", &tmp);
 			if (tmp && *tmp)
 				edit_feature(tmp, &fs_param.s_feature_compat);
-			if (tmp)
-				free(tmp);
+			free(tmp);
 		}
 		tmp = get_string_from_profile(fs_types, "default_features",
 					      "");
 	}
 	edit_feature(fs_features ? fs_features : tmp,
 		     &fs_param.s_feature_compat);
-	if (tmp)
-		free(tmp);
+	free(tmp);

 	if (fs_param.s_feature_incompat & EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
 		fs_types[0] = strdup("journal");
@@ -1622,8 +1619,7 @@ static void PRS(int argc, char *argv[])
 		profile_get_string(profile, "fs_types", *cpp, "options", "", &tmp);
 			if (tmp && *tmp)
 				parse_extended_opts(&fs_param, tmp);
-			if (tmp)
-				free(tmp);
+			free(tmp);
 	}

 	if (extended_opts)
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index e72518a..deb72bb 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -529,8 +529,7 @@ static void add_journal(ext2_filsys fs)
 	return;

 err:
-	if (journal_device)
-		free(journal_device);
+	free(journal_device);
 	exit(1);
 }

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index abe05f5..470c804 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1359,8 +1359,7 @@ errout:
 		ext2fs_close_inode_scan(scan);
 	if (block_buf)
 		ext2fs_free_mem(&block_buf);
-	if (inode)
-		free(inode);
+	free(inode);
 	return retval;
 }

diff --git a/util/subst.c b/util/subst.c
index 0015a9c..b55f54b 100644
--- a/util/subst.c
+++ b/util/subst.c
@@ -54,10 +54,8 @@ static int add_subst(char *name, char *value)
 	return 0;
 fail:
 	if (ent) {
-		if (ent->name)
-			free(ent->name);
-		if (ent->value)
-			free(ent->value);
+		free(ent->name);
+		free(ent->value);
 		free(ent);
 	}
 	return retval;
--
1.6.2.rc1.266.g4bdf
