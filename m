Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362927;
	b=ACjbYE2xZpF5JihqLjOFcd9whfiZxeddSL8v/R1Qbg4h3PiBI+v8iWFxmWJsWx4FsuNe
	 jsfkBP1l2Q1KAnakwBOmzZVSNI2j9KmRAZPgHusLWxHdkGoHm2HdKK1JGVvZOh3z5qg34
	 zAo3b5KcmvcFFabas15zF7Tsg6GafTx1cHkU3j5I4oJQykDChGfqp0/dPOQRCmCIjlOln
	 L5MnaoeagQIdSCvuEGU79HCA+GLhm8oCG+BWRhK4O3P905Iu+ktCdqrPFbviGqYJtFazD
	 V0AknE0AAB1xjZisuM2y0VkvMLrTj2APfstwnA6WwG8UwYVRmdHoxqtIeSKtOYdcbSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362927;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=2SmqxFZ5ET5ovU99WYg5B4lOpoiUsLlbPO9Yq3mG7AI=;
	b=IiQkyrpiIlmfqZtkt4SZg9VyEugzUjsf8d3S2+k8x/0AebTtn4zuhDfnK95zRMkLrUw4
	 EQa+5TtsEfZB/yIHt6k8Y6NyezVxUjSBOqbmpfGxrrYzIl5cUI99Ev82rf812hX4hFOSQ
	 6z1uLRHP8cYs5GOpeVlAQFW33EQh9B6oM5pOY1k5K0cH1ueUJlfs67mxkaS9SKbM/t7to
	 Vjc2KzIjJ7wE99GCyEQ+ZQpIirKmy/nx1VlzrWnz8M0JaA4xj9Vt8Nbth9zHqMbb5p6vD
	 mX9VcBFLT0uVUJcOe+xsaEBGF0sN3zKaBPwMGJhXdzDriAAQyKbAphWLIIe6ga3U98g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OLGWxTsx;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C593C606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 12:22:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C593C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OLGWxTsx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793362926; x=1824898926;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6+HvW8OjTbumzlb3yAn0aXCox2G3PG2m36nXQ8+AkII=;
  b=OLGWxTsxOimcMHcL+2k2VzkRdXe3SZzhsIAWR4ZKPHa7DNks3SQ31hgl
   nJ0vjLwPdoELTchf/CX9723aqWWmOB725o+C4IlbQxtDIh6dnxagOQUzT
   KOAbSfBGucQKO6H4kYNAL4tRxuDIkUVkGFm9HgGldqUZjyawVwm5zyt5m
   curgq79zObhNDyaShdygczpixQNCYHOPFBB6giu63O8ChSnIjqcKuxJOp
   FZNRKU/MJPUkWfUR3ebkk8YYYLN3gjJay2IUgHzSOxz3f9i951mubD9qz
   zgGRAkB6hBd1s/l9SFldz6kBIH+TSWI5l+PuWHcz4ChiaTE0oILEEmuss
   Q==;
X-CSE-ConnectionGUID: d1KO6tjpRQKg2noPPKVmKQ==
X-CSE-MsgGUID: 2ed0LZd5RAOpv1hOsIUR3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2216701"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2216701"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 05:22:06 -0700
X-CSE-ConnectionGUID: iZm8YhY4SaiiOrr35PE90w==
X-CSE-MsgGUID: UgM56x6nTbKzWnv7pBM+pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5322022"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 30 Oct 2026 05:22:03 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMlcO-00000000biO-2ubz;
	Fri, 30 Oct 2026 12:22:00 +0000
Date: Fri, 30 Oct 2026 20:21:59 +0800
From: kernel test robot <lkp@intel.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	linux-ext4@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, tytso@mit.edu, jack@suse.cz,
	adilger.kernel@dilger.ca, ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v13 11/11] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting
 LUFID on directory entries
Message-ID: <202610302057.dZ9WDGS4-lkp@intel.com>
References: <20261029122413.230409-12-ablagodarenko@thelustrecollective.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029122413.230409-12-ablagodarenko@thelustrecollective.com>

Hi Artem,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8c4f6e3376348fc3162eed86a05b933921c8f9ed]

url:    https://github.com/intel-lab-lkp/linux/commits/Artem-Blagodarenko/ext4-validate-count-against-limit-in-ext4_dx_csum_verify-_set/20261029-122400
base:   8c4f6e3376348fc3162eed86a05b933921c8f9ed
patch link:    https://lore.kernel.org/r/20261029122413.230409-12-ablagodarenko%40thelustrecollective.com
patch subject: [PATCH v13 11/11] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory entries
config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20261030/202610302057.dZ9WDGS4-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261030/202610302057.dZ9WDGS4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610302057.dZ9WDGS4-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/ext4/namei.c: In function 'ext4_dirdata_set_lufid':
>> fs/ext4/namei.c:5097:1: warning: the frame size of 1344 bytes is larger than 1280 bytes [-Wframe-larger-than=]
    5097 | }
         | ^


vim +5097 fs/ext4/namei.c

  4838	
  4839	/*
  4840	 * ext4_dirdata_set_lufid() - Set LUFID data on an existing directory entry
  4841	 * @dir:        parent directory inode
  4842	 * @filename:   name of the file in the directory
  4843	 * @namelen:    length of filename
  4844	 * @edp:        pointer to initialized dentry param with LUFID data
  4845	 *
  4846	 * This function finds an existing directory entry, deletes it, and re-creates it
  4847	 * with LUFID data attached. Used by the EXT4_IOC_SET_LUFID ioctl.
  4848	 *
  4849	 * Returns 0 on success, negative error code on failure.
  4850	 */
  4851	int ext4_dirdata_set_lufid(struct mnt_idmap *idmap, struct inode *dir,
  4852				    const char *filename, int namelen,
  4853				    struct ext4_dentry_param *edp)
  4854	{
  4855		struct super_block *sb = dir->i_sb;
  4856		 /* zero-init: safe to free on any path */
  4857		struct ext4_filename fname = {};
  4858		struct ext4_dir_entry_2 *de = NULL;
  4859		struct buffer_head *bh = NULL;
  4860		struct inode *inode = NULL;
  4861		handle_t *handle = NULL;
  4862		struct ext4_lufid_snap old_snap = {};
  4863		struct qstr d_name;
  4864		/* on-disk name snapshot for non-encrypted casefolded directories: the
  4865		 * on-disk case may differ from what the caller supplied. */
  4866		char ondisk_name[EXT4_NAME_LEN];
  4867		struct qstr real_name = {};
  4868		/* name to pass to ext4_add_entry() for the re-add and rollback */
  4869		const struct qstr *add_name;
  4870		__u32 ino = 0;
  4871		bool child_locked = false;
  4872		int err = 0;
  4873	
  4874		if (!ext4_has_feature_dirdata(sb))
  4875			return -EOPNOTSUPP;
  4876	
  4877		if (namelen > EXT4_NAME_LEN)
  4878			return -ENAMETOOLONG;
  4879		if (namelen != strnlen(filename, namelen + 1))
  4880			return -EINVAL;
  4881	
  4882		d_name.name = filename;
  4883		d_name.len = namelen;
  4884	
  4885		err = ext4_fname_setup_filename(dir, &d_name, 0, &fname);
  4886		if (err)
  4887			goto out_free;
  4888	
  4889		/* Lock dir with the VFS parent-mutation subclass.  The lookup and any
  4890		 * mutation must be inside this lock to prevent TOCTOU races. */
  4891		inode_lock_nested(dir, I_MUTEX_PARENT);
  4892	
  4893		/* Phase 1: look up the entry without holding a journal handle to
  4894		 * obtain the child inode reference before taking the child lock.
  4895		 * VFS locking order requires all inode locks to be acquired before
  4896		 * starting a jbd2 transaction; starting the journal while already
  4897		 * holding the child lock would invert that order and risk deadlock
  4898		 * if jbd2 blocks waiting for a commit that the child lock holder
  4899		 * prevents from finishing. */
  4900		bh = ext4_find_entry(dir, &d_name, &de, NULL);
  4901		if (IS_ERR(bh)) {
  4902			err = PTR_ERR(bh);
  4903			bh = NULL;
  4904			goto out_unlock_dir;
  4905		}
  4906		if (!bh) {
  4907			err = -ENOENT;
  4908			goto out_unlock_dir;
  4909		}
  4910		ino = le32_to_cpu(de->inode);
  4911		brelse(bh);
  4912		bh = NULL;
  4913		de = NULL;
  4914	
  4915		inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
  4916		if (IS_ERR(inode)) {
  4917			err = PTR_ERR(inode);
  4918			inode = NULL;
  4919			goto out_unlock_dir;
  4920		}
  4921	
  4922		/* Enforce sticky-bit restriction: on a sticky directory only the
  4923		 * directory owner, the file owner, or a privileged process may
  4924		 * modify entries.  inode_permission(MAY_WRITE) alone does not cover
  4925		 * this, so check it explicitly here as may_delete() does. */
  4926		err = check_sticky(idmap, dir, inode);
  4927		if (err)
  4928			goto out_iput;
  4929	
  4930		/* The ioctl calls ext4_delete_entry() on the parent directory, which
  4931		 * bypasses the VFS may_delete() path.  inode_permission(MAY_WRITE)
  4932		 * above blocks IS_IMMUTABLE(dir) but does NOT block IS_APPEND(dir):
  4933		 * append-only directories allow new entries but forbid deletion, and
  4934		 * that restriction lives only in may_delete(), not in
  4935		 * inode_permission().  Enforce it explicitly here. */
  4936		if (IS_APPEND(dir)) {
  4937			err = -EPERM;
  4938			goto out_iput;
  4939		}
  4940	
  4941		/* The ioctl deletes and re-creates the directory entry, which
  4942		 * effectively modifies the target file's namespace presence.
  4943		 * Refuse if the target itself is immutable or append-only. */
  4944		if (IS_IMMUTABLE(inode) || IS_APPEND(inode)) {
  4945			err = -EPERM;
  4946			goto out_iput;
  4947		}
  4948	
  4949		/* Lock the target inode BEFORE starting the journal (dir-then-child,
  4950		 * VFS-locks-before-journal ordering).  Use I_MUTEX_CHILD for directory
  4951		 * inodes (consistent with VFS rename/rmdir) and I_MUTEX_NONDIR2 for
  4952		 * all others; mixing subclasses on the same inode triggers lockdep
  4953		 * cycles with concurrent rename. */
  4954		if (inode != dir) {
  4955			if (S_ISDIR(inode->i_mode))
  4956				inode_lock_nested(inode, I_MUTEX_CHILD);
  4957			else
  4958				inode_lock_nested(inode, I_MUTEX_NONDIR2);
  4959			child_locked = true;
  4960		}
  4961	
  4962		handle = ext4_journal_start(dir, EXT4_HT_DIR,
  4963					    3 * EXT4_DATA_TRANS_BLOCKS(sb) +
  4964					    2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS);
  4965		if (IS_ERR(handle)) {
  4966			err = PTR_ERR(handle);
  4967			handle = NULL;
  4968			goto out_unlock;
  4969		}
  4970	
  4971		/* Phase 2: re-look up the entry inside the journal to obtain a stable
  4972		 * de pointer.  Verify it still refers to the same inode (TOCTOU
  4973		 * guard: a concurrent unlink+create between phase 1 and here would
  4974		 * change the inode number). */
  4975		bh = ext4_find_entry(dir, &d_name, &de, NULL);
  4976		if (IS_ERR(bh)) {
  4977			err = PTR_ERR(bh);
  4978			bh = NULL;
  4979			goto out_journal;
  4980		}
  4981		if (!bh) {
  4982			err = -ENOENT;
  4983			goto out_journal;
  4984		}
  4985		if (le32_to_cpu(de->inode) != ino) {
  4986			err = -ENOENT;
  4987			goto out_brelse;
  4988		}
  4989	
  4990		/* Choose the name to use for re-adding the entry after deletion.
  4991		 *
  4992		 * For non-encrypted casefolded directories ext4_find_entry() matches
  4993		 * case-insensitively, so de->name may differ in case from the
  4994		 * caller-supplied filename.  Re-adding with the caller's case would
  4995		 * silently rename the entry, so preserve the on-disk bytes.
  4996		 *
  4997		 * For encrypted directories (with or without casefold) de->name holds
  4998		 * the raw ciphertext.  ext4_fname_setup_filename() deterministically
  4999		 * re-encrypts d_name (the plaintext) to the identical ciphertext, so
  5000		 * using d_name for the re-add is correct.  Passing the raw ciphertext
  5001		 * bytes would cause double-encryption and make the entry unreachable. */
  5002		if (IS_CASEFOLDED(dir) && !IS_ENCRYPTED(dir)) {
  5003			memcpy(ondisk_name, de->name, de->name_len);
  5004			real_name.name = ondisk_name;
  5005			real_name.len = de->name_len;
  5006			add_name = &real_name;
  5007		} else {
  5008			add_name = &d_name;
  5009		}
  5010	
  5011		/* Snapshot the old LUFID before deleting so we can restore it if the
  5012		 * re-add fails.  Without this the rollback path re-adds the entry
  5013		 * without any LUFID, silently orphaning the old FID-to-path mapping. */
  5014		err = ext4_lufid_snapshot(de, sb->s_blocksize, &old_snap);
  5015		if (err)
  5016			goto out_brelse;
  5017	
  5018		err = ext4_delete_entry(handle, dir, de, bh);
  5019		if (err)
  5020			goto out_brelse;
  5021	
  5022		brelse(bh);
  5023		bh = NULL;
  5024	
  5025		/* Re-add with LUFID via dentry->d_fsdata.  ext4_add_entry() resolves
  5026		 * dfid from d_fsdata into fname.dfid and passes it through to
  5027		 * add_dirent_to_buf() without touching the shared i_dirdata field,
  5028		 * eliminating the race with concurrent link() calls. */
  5029		{
  5030			struct dentry parent_dentry = { .d_inode = dir };
  5031			struct dentry new_dentry = {
  5032				.d_name = *add_name,
  5033				.d_parent = &parent_dentry,
  5034				.d_inode = inode,
  5035				.d_fsdata = edp,
  5036			};
  5037			err = ext4_add_entry(handle, &new_dentry, inode);
  5038		}
  5039	
  5040		if (err) {
  5041			/* Delete succeeded but re-add failed; try to restore so the
  5042			 * inode is not left without a directory entry.  Restore the
  5043			 * original LUFID too: without it the entry is re-added clean
  5044			 * and the old FID-to-path mapping is silently lost. */
  5045			struct dentry parent_dentry = { .d_inode = dir };
  5046			struct dentry orig_dentry = {
  5047				.d_name = *add_name,
  5048				.d_parent = &parent_dentry,
  5049				.d_inode = inode,
  5050			};
  5051			int rollback_err;
  5052	
  5053			if (old_snap.fid) {
  5054				unsigned int fid_size = old_snap.fid->df_header.ddh_length;
  5055				struct ext4_dentry_param *old_edp =
  5056					kmalloc(sizeof(*old_edp) + fid_size, GFP_NOFS);
  5057	
  5058				if (old_edp) {
  5059					old_edp->edp_magic = EXT4_LUFID_MAGIC;
  5060					memcpy(old_edp->edp_dfid, old_snap.fid, fid_size);
  5061					orig_dentry.d_fsdata = old_edp;
  5062				}
  5063			}
  5064	
  5065			rollback_err = ext4_add_entry(handle, &orig_dentry, inode);
  5066			kfree(orig_dentry.d_fsdata);
  5067	
  5068			if (rollback_err)
  5069				EXT4_ERROR_INODE(dir,
  5070					"Failed to set LUFID on '%.*s' (err=%d) and failed to restore the original directory entry (err=%d); inode %llu may be orphaned",
  5071					namelen, filename, err, rollback_err,
  5072					(unsigned long long)inode->i_ino);
  5073			goto out_journal;
  5074		}
  5075	
  5076		inode_set_ctime_current(dir);
  5077		inode_inc_iversion(dir);
  5078		ext4_mark_inode_dirty(handle, dir);
  5079	
  5080	out_brelse:
  5081		brelse(bh);
  5082	out_journal:
  5083		ext4_lufid_snap_release(&old_snap);
  5084		if (handle)
  5085			ext4_journal_stop(handle);
  5086	out_unlock:
  5087		if (child_locked)
  5088			inode_unlock(inode);
  5089	out_iput:
  5090		iput(inode);
  5091	out_unlock_dir:
  5092		inode_unlock(dir);
  5093	out_free:
  5094		ext4_fname_free_filename(&fname);
  5095	
  5096		return err;
> 5097	}
  5098	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
