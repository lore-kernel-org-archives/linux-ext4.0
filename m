From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH V2 2/2]QUOTA cleanup:Move EXPORT_SYMBOL immediatlely
	next to the functions/varibles
Date: Mon, 05 Jan 2009 20:31:30 -0800
Message-ID: <1231216290.9267.5.camel@mingming-laptop>
References: <1229114906.7646.30.camel@mingming-laptop>
	 <20081215125756.GB15464@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:60016 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZAFEbg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jan 2009 23:31:36 -0500
In-Reply-To: <20081215125756.GB15464@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-12-15=E4=B8=80=E7=9A=84 13:57 +0100=EF=BC=8CJan Kara=E5=86=
=99=E9=81=93=EF=BC=9A
> On Fri 12-12-08 12:48:26, Mingming Cao wrote:
> > quota: Move EXPORT_SYMBOL immediatlely next to the functions/varibl=
es
> > From: Mingming Cao <cmm@us.ibm.com>
> >=20
> > According to checkpatch: EXPORT_SYMBOL(foo); should immediately fol=
low its function/variable
> >=20
> > Updated with KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> com=
pile fix.
> >=20
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
>   This patch does not reflect the changes that are in linux-next (and=
 thus
> in -mm kernels) due to OCFS2. Please refresh the patch with them. Tha=
nks.
>=20

I didn't aware linux-next has quota related patches, I noticed now
2.6.28 should have the patch you are refering to and all the 64 bit
quota patches. I will update the patches to against latest mm tree.


Mingming
> 										Honza
> > ---
> >  fs/dquot.c |   69 ++++++++++++++++++++++++++++++------------------=
-------------
> >  1 file changed, 34 insertions(+), 35 deletions(-)
> >=20
> > Index: linux-2.6.28-rc2/fs/dquot.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.28-rc2.orig/fs/dquot.c	2008-12-12 12:21:49.000000000 =
-0800
> > +++ linux-2.6.28-rc2/fs/dquot.c	2008-12-12 12:35:36.000000000 -0800
> > @@ -127,6 +127,7 @@
> > =20
> >  static DEFINE_SPINLOCK(dq_list_lock);
> >  DEFINE_SPINLOCK(dq_data_lock);
> > +EXPORT_SYMBOL(dq_data_lock);
> > =20
> >  static char *quotatypes[] =3D INITQFNAMES;
> >  static struct quota_format_type *quota_formats;	/* List of registe=
red formats */
> > @@ -143,6 +144,7 @@ int register_quota_format(struct quota_f
> >  	spin_unlock(&dq_list_lock);
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL(register_quota_format);
> > =20
> >  void unregister_quota_format(struct quota_format_type *fmt)
> >  {
> > @@ -154,6 +156,7 @@ void unregister_quota_format(struct quot
> >  		*actqf =3D (*actqf)->qf_next;
> >  	spin_unlock(&dq_list_lock);
> >  }
> > +EXPORT_SYMBOL(unregister_quota_format);
> > =20
> >  static struct quota_format_type *find_quota_format(int id)
> >  {
> > @@ -210,6 +213,7 @@ static unsigned int dq_hash_bits, dq_has
> >  static struct hlist_head *dquot_hash;
> > =20
> >  struct dqstats dqstats;
> > +EXPORT_SYMBOL(dqstats);
> > =20
> >  static void dqput(struct dquot *dquot);
> > =20
> > @@ -306,6 +310,7 @@ int dquot_mark_dquot_dirty(struct dquot=20
> >  	spin_unlock(&dq_list_lock);
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL(dquot_mark_dquot_dirty);
> > =20
> >  /* This function needs dq_list_lock */
> >  static inline int clear_dquot_dirty(struct dquot *dquot)
> > @@ -357,6 +362,7 @@ out_iolock:
> >  	mutex_unlock(&dquot->dq_lock);
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(dquot_acquire);
> > =20
> >  /*
> >   *	Write dquot to disk
> > @@ -386,6 +392,7 @@ out_sem:
> >  	mutex_unlock(&dqopt->dqio_mutex);
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(dquot_commit);
> > =20
> >  /*
> >   *	Release dquot
> > @@ -414,6 +421,7 @@ out_dqlock:
> >  	mutex_unlock(&dquot->dq_lock);
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(dquot_release);
> > =20
> >  static void destroy_dquot(struct dquot *dquot)
> >  {
> > @@ -522,6 +530,7 @@ int vfs_quota_sync(struct super_block *s
> > =20
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL(vfs_quota_sync);
> > =20
> >  /* Free unused dquots from cache */
> >  static void prune_dqcache(int count)
> > @@ -1200,6 +1209,7 @@ out_err:
> >  	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(dquot_initialize);
> > =20
> >  /*
> >   * 	Release all quotas referenced by inode
> > @@ -1219,6 +1229,7 @@ int dquot_drop(struct inode *inode)
> >  	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL(dquot_drop);
> > =20
> >  /* Wrapper to remove references to quota structures from inode */
> >  void vfs_dq_drop(struct inode *inode)
> > @@ -1241,6 +1252,7 @@ void vfs_dq_drop(struct inode *inode)
> >  			inode->i_sb->dq_op->drop(inode);
> >  	}
> >  }
> > +EXPORT_SYMBOL(vfs_dq_drop);
> > =20
> >  /*
> >   * Following four functions update i_blocks+i_bytes fields and
> > @@ -1317,6 +1329,7 @@ out_unlock:
> >  out:
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(dquot_alloc_space);
> > =20
> >  int dquot_reserve_space(struct inode *inode, qsize_t number, int w=
arn)
> >  {
> > @@ -1335,6 +1348,7 @@ out_unlock:
> >  out:
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(dquot_reserve_space);
> > =20
> >  int dquot_claim_space(struct inode *inode, qsize_t number)
> >  {
> > @@ -1371,6 +1385,7 @@ int dquot_claim_space(struct inode *inod
> >  out:
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(dquot_claim_space);
> > =20
> >  /*
> >   * Release reserved quota space
> > @@ -1402,6 +1417,7 @@ out_unlock:
> >  out:
> >  	return;
> >  }
> > +EXPORT_SYMBOL(dquot_release_reserved_space);
> > =20
> >  /*
> >   * This operation can block, but only after everything is updated
> > @@ -1447,6 +1463,7 @@ warn_put_all:
> >  	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(dquot_alloc_inode);
> > =20
> >  /*
> >   * This operation can block, but only after everything is updated
> > @@ -1487,6 +1504,7 @@ out_sub:
> >  	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> >  	return QUOTA_OK;
> >  }
> > +EXPORT_SYMBOL(dquot_free_space);
> > =20
> >  /*
> >   * This operation can block, but only after everything is updated
> > @@ -1523,6 +1541,7 @@ int dquot_free_inode(const struct inode=20
> >  	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> >  	return QUOTA_OK;
> >  }
> > +EXPORT_SYMBOL(dquot_free_inode);
> > =20
> >  /*
> >   * Transfer the number of inode and blocks from one diskquota to a=
n other.
> > @@ -1640,6 +1659,7 @@ warn_put_all:
> >  	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(dquot_transfer);
> > =20
> >  /* Wrapper for transferring ownership of an inode */
> >  int vfs_dq_transfer(struct inode *inode, struct iattr *iattr)
> > @@ -1651,7 +1671,7 @@ int vfs_dq_transfer(struct inode *inode,
> >  	}
> >  	return 0;
> >  }
> > -
> > +EXPORT_SYMBOL(vfs_dq_transfer);
> > =20
> >  /*
> >   * Write info of quota file to disk
> > @@ -1666,6 +1686,7 @@ int dquot_commit_info(struct super_block
> >  	mutex_unlock(&dqopt->dqio_mutex);
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(dquot_commit_info);
> > =20
> >  /*
> >   * Definitions of diskquota operations.
> > @@ -1811,12 +1832,14 @@ put_inodes:
> >  		}
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(vfs_quota_disable);
> > =20
> >  int vfs_quota_off(struct super_block *sb, int type, int remount)
> >  {
> >  	return vfs_quota_disable(sb, type, remount ? DQUOT_SUSPENDED :
> >  				 (DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED));
> >  }
> > +EXPORT_SYMBOL(vfs_quota_off);
> > =20
> >  /*
> >   *	Turn quotas on on a device
> > @@ -1954,6 +1977,7 @@ static int vfs_quota_on_remount(struct s
> > =20
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(vfs_quota_on_remount);
> > =20
> >  int vfs_quota_on_path(struct super_block *sb, int type, int format=
_id,
> >  		      struct path *path)
> > @@ -1970,6 +1994,7 @@ int vfs_quota_on_path(struct super_block
> >  					     DQUOT_LIMITS_ENABLED);
> >  	return error;
> >  }
> > +EXPORT_SYMBOL(vfs_quota_on_path);
> > =20
> >  int vfs_quota_on(struct super_block *sb, int type, int format_id, =
char *name,
> >  		 int remount)
> > @@ -1987,6 +2012,7 @@ int vfs_quota_on(struct super_block *sb,
> >  	}
> >  	return error;
> >  }
> > +EXPORT_SYMBOL(vfs_quota_on);
> > =20
> >  /*
> >   * More powerful function for turning on quotas allowing setting
> > @@ -2031,6 +2057,7 @@ out_lock:
> >  load_quota:
> >  	return vfs_load_quota_inode(inode, type, format_id, flags);
> >  }
> > +EXPORT_SYMBOL(vfs_quota_enable);
> > =20
> >  /*
> >   * This function is used when filesystem needs to initialize quota=
s
> > @@ -2060,6 +2087,7 @@ out:
> >  	dput(dentry);
> >  	return error;
> >  }
> > +EXPORT_SYMBOL(vfs_quota_on_mount);
> > =20
> >  /* Wrapper to turn on quotas when remounting rw */
> >  int vfs_dq_quota_on_remount(struct super_block *sb)
> > @@ -2076,6 +2104,7 @@ int vfs_dq_quota_on_remount(struct super
> >  	}
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(vfs_dq_quota_on_remount);
> > =20
> >  static inline qsize_t qbtos(qsize_t blocks)
> >  {
> > @@ -2119,6 +2148,7 @@ int vfs_get_dqblk(struct super_block *sb
> >  	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL(vfs_get_dqblk);
> > =20
> >  /* Generic routine for setting common part of quota structure */
> >  static int do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
> > @@ -2202,6 +2232,7 @@ out:
> >  	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
> >  	return rc;
> >  }
> > +EXPORT_SYMBOL(vfs_set_dqblk);
> > =20
> >  /* Generic routine for getting common part of quota file informati=
on */
> >  int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqi=
nfo *ii)
> > @@ -2223,6 +2254,7 @@ int vfs_get_dqinfo(struct super_block *s
> >  	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL(vfs_get_dqinfo);
> > =20
> >  /* Generic routine for setting common part of quota file informati=
on */
> >  int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqi=
nfo *ii)
> > @@ -2251,6 +2283,7 @@ out:
> >  	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
> >  	return err;
> >  }
> > +EXPORT_SYMBOL(vfs_set_dqinfo);
> > =20
> >  struct quotactl_ops vfs_quotactl_ops =3D {
> >  	.quota_on	=3D vfs_quota_on,
> > @@ -2406,37 +2439,3 @@ static int __init dquot_init(void)
> >  	return 0;
> >  }
> >  module_init(dquot_init);
> > -
> > -EXPORT_SYMBOL(register_quota_format);
> > -EXPORT_SYMBOL(unregister_quota_format);
> > -EXPORT_SYMBOL(dqstats);
> > -EXPORT_SYMBOL(dq_data_lock);
> > -EXPORT_SYMBOL(vfs_quota_enable);
> > -EXPORT_SYMBOL(vfs_quota_on);
> > -EXPORT_SYMBOL(vfs_quota_on_path);
> > -EXPORT_SYMBOL(vfs_quota_on_mount);
> > -EXPORT_SYMBOL(vfs_quota_disable);
> > -EXPORT_SYMBOL(vfs_quota_off);
> > -EXPORT_SYMBOL(vfs_quota_sync);
> > -EXPORT_SYMBOL(vfs_get_dqinfo);
> > -EXPORT_SYMBOL(vfs_set_dqinfo);
> > -EXPORT_SYMBOL(vfs_get_dqblk);
> > -EXPORT_SYMBOL(vfs_set_dqblk);
> > -EXPORT_SYMBOL(dquot_commit);
> > -EXPORT_SYMBOL(dquot_commit_info);
> > -EXPORT_SYMBOL(dquot_acquire);
> > -EXPORT_SYMBOL(dquot_release);
> > -EXPORT_SYMBOL(dquot_mark_dquot_dirty);
> > -EXPORT_SYMBOL(dquot_initialize);
> > -EXPORT_SYMBOL(dquot_drop);
> > -EXPORT_SYMBOL(vfs_dq_drop);
> > -EXPORT_SYMBOL(dquot_alloc_space);
> > -EXPORT_SYMBOL(dquot_alloc_inode);
> > -EXPORT_SYMBOL(dquot_free_space);
> > -EXPORT_SYMBOL(dquot_free_inode);
> > -EXPORT_SYMBOL(dquot_reserve_space);
> > -EXPORT_SYMBOL(dquot_claim_space);
> > -EXPORT_SYMBOL(dquot_release_reserved_space);
> > -EXPORT_SYMBOL(dquot_transfer);
> > -EXPORT_SYMBOL(vfs_dq_transfer);
> > -EXPORT_SYMBOL(vfs_dq_quota_on_remount);
> >=20
> >=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
