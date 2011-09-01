From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: Use ext2fs_flush() only once
Date: Thu, 1 Sep 2011 10:38:30 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1109011038210.3665@dhcp-27-109.brq.redhat.com>
References: <1311941612-9108-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1108111657280.29009@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929Ab1IAIie (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Sep 2011 04:38:34 -0400
In-Reply-To: <alpine.LFD.2.00.1108111657280.29009@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 11 Aug 2011, Lukas Czerner wrote:

> On Fri, 29 Jul 2011, Lukas Czerner wrote:
> 
> > We are doing ext2fs_flush() twice right now at the end of the mke2fs.
> > First by directly calling ext2fs_flush() which is intended to write
> > superblock and fs accounting information. And then it is invoked again
> > when we are calling ext2fs_close(), only this time, because the fs is
> > not dirty, we are writing out only superblock.
> > 
> > I think it is bad to call it twice because even when writing only super
> > block it takes some time on bigger file systems and moreover
> > ext2fs_close() can fail without any reasonable explanation for the user.
> > Also ext2fs_flush() is printing out progress and it is confusing for the
> > users.
> > 
> > Fix all this by removing the ext2fs_flush() and leaving it all to
> > ext2fs_close(). However we need to introduce new variables to store
> > check interval and max mount count, because fs structure is freed on
> > ext2fs_close() and we really want to print those information as the last
> > info for the user.
> 
> Ping

Ping^2

> 
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  misc/mke2fs.c                   |   15 ++++++++-------
> >  misc/tune2fs.c                  |    3 ++-
> >  misc/util.c                     |    5 ++---
> >  misc/util.h                     |    2 +-
> >  tests/m_extent_journal/expect.1 |    2 +-
> >  tests/m_uninit/expect.1         |    2 +-
> >  6 files changed, 15 insertions(+), 14 deletions(-)
> > 
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index e062bda..481e550 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -2143,7 +2143,7 @@ int main (int argc, char *argv[])
> >  	ext2_filsys	fs;
> >  	badblocks_list	bb_list = 0;
> >  	unsigned int	journal_blocks;
> > -	unsigned int	i;
> > +	unsigned int	i, max_mnt_count, checkinterval;
> >  	int		val, hash_alg;
> >  	int		flags;
> >  	int		old_bitmaps;
> > @@ -2469,22 +2469,23 @@ no_journal:
> >  	if (!quiet)
> >  		printf(_("Writing superblocks and "
> >  		       "filesystem accounting information: "));
> > -	retval = ext2fs_flush(fs);
> > +	checkinterval = fs->super->s_checkinterval;
> > +	max_mnt_count = fs->super->s_max_mnt_count;
> > +	retval = ext2fs_close(fs);
> >  	if (retval) {
> >  		fprintf(stderr,
> >  			_("\nWarning, had trouble writing out superblocks."));
> > -	}
> > -	if (!quiet) {
> > +	} else if (!quiet) {
> >  		printf(_("done\n\n"));
> >  		if (!getenv("MKE2FS_SKIP_CHECK_MSG"))
> > -			print_check_message(fs);
> > +			print_check_message(max_mnt_count, checkinterval);
> >  	}
> > -	val = ext2fs_close(fs);
> > +
> >  	remove_error_table(&et_ext2_error_table);
> >  	remove_error_table(&et_prof_error_table);
> >  	profile_release(profile);
> >  	for (i=0; fs_types[i]; i++)
> >  		free(fs_types[i]);
> >  	free(fs_types);
> > -	return (retval || val) ? 1 : 0;
> > +	return retval;
> >  }
> > diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> > index 5bf5187..0e1e1cf 100644
> > --- a/misc/tune2fs.c
> > +++ b/misc/tune2fs.c
> > @@ -568,7 +568,8 @@ static void add_journal(ext2_filsys fs)
> >  		if ((mount_flags & EXT2_MF_MOUNTED) == 0)
> >  			fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
> >  	}
> > -	print_check_message(fs);
> > +	print_check_message(fs->super->s_max_mnt_count,
> > +			    fs->super->s_checkinterval);
> >  	return;
> >  
> >  err:
> > diff --git a/misc/util.c b/misc/util.c
> > index 51bdb60..18329ee 100644
> > --- a/misc/util.c
> > +++ b/misc/util.c
> > @@ -282,12 +282,11 @@ unsigned int figure_journal_size(int size, ext2_filsys fs)
> >  	return j_blocks;
> >  }
> >  
> > -void print_check_message(ext2_filsys fs)
> > +void print_check_message(unsigned int mnt, unsigned int check)
> >  {
> >  	printf(_("This filesystem will be automatically "
> >  		 "checked every %d mounts or\n"
> >  		 "%g days, whichever comes first.  "
> >  		 "Use tune2fs -c or -i to override.\n"),
> > -	       fs->super->s_max_mnt_count,
> > -	       (double)fs->super->s_checkinterval / (3600 * 24));
> > +		mnt, check / (3600 * 24));
> >  }
> > diff --git a/misc/util.h b/misc/util.h
> > index e0c99f6..d05f17e 100644
> > --- a/misc/util.h
> > +++ b/misc/util.h
> > @@ -23,4 +23,4 @@ extern void check_plausibility(const char *device);
> >  extern void parse_journal_opts(const char *opts);
> >  extern void check_mount(const char *device, int force, const char *type);
> >  extern unsigned int figure_journal_size(int size, ext2_filsys fs);
> > -extern void print_check_message(ext2_filsys fs);
> > +extern void print_check_message(unsigned int, unsigned int);
> > diff --git a/tests/m_extent_journal/expect.1 b/tests/m_extent_journal/expect.1
> > index 88ea2d9..a8c5b63 100644
> > --- a/tests/m_extent_journal/expect.1
> > +++ b/tests/m_extent_journal/expect.1
> > @@ -18,7 +18,7 @@ Writing inode tables: 0/81/82/83/84/85/86/87/8   done
> >  Creating journal (4096 blocks): done
> >  Writing superblocks and filesystem accounting information: 0/81/82/83/84/85/86/87/8   done
> >  
> > -0/81/82/83/84/85/86/87/8   Filesystem features: has_journal ext_attr resize_inode dir_index filetype extent sparse_super
> > +Filesystem features: has_journal ext_attr resize_inode dir_index filetype extent sparse_super
> >   
> >  Pass 1: Checking inodes, blocks, and sizes
> >  Pass 2: Checking directory structure
> > diff --git a/tests/m_uninit/expect.1 b/tests/m_uninit/expect.1
> > index 173c072..a3c059d 100644
> > --- a/tests/m_uninit/expect.1
> > +++ b/tests/m_uninit/expect.1
> > @@ -17,7 +17,7 @@ Allocating group tables:  0/16 1/16 2/16 3/16 4/16 5/16
> >  Writing inode tables:  0/16 1/16 2/16 3/16 4/16 5/16 6/16 7/16 8/16 9/1610/1611/1612/1613/1614/1615/16     done                            
> >  Writing superblocks and filesystem accounting information:  0/16 1/16 2/16 3/16 4/16 5/16 6/16 7/16 8/16 9/1610/1611/1612/1613/1614/1615/16     done
> >  
> > - 0/16 1/16 2/16 3/16 4/16 5/16 6/16 7/16 8/16 9/1610/1611/1612/1613/1614/1615/16     Filesystem features: ext_attr resize_inode dir_index filetype sparse_super uninit_bg
> > +Filesystem features: ext_attr resize_inode dir_index filetype sparse_super uninit_bg
> >   
> >  Pass 1: Checking inodes, blocks, and sizes
> >  Pass 2: Checking directory structure
> > 
> 
> 

-- 
