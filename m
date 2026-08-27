Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E74F3FBB4D
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 08:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787820665; cv=none; b=MMi0wxk6hV7swIYqZBgko3NEuOZS5CSwxCHiF3eLs8rOxbda353QuFmsCK7iCEMLXesDpO71YMl0vXDTGjJCM9nMy9e22tPsqaCLq+irjmR9Sy18C3BRSKAq8s8nkci0xOAEBV9cVENuv5sGsTswo2MVUZp5NJZYQ20p7BQ094Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787820665; c=relaxed/simple;
	bh=V7f3mO3z8lJ4TwwIBXW3L3UKZCx34uNnG/3o1Yvd7bc=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qJ9dnM5AMIeJdDmUcWHqHnufQo/nxxs+9Rb5ZZ0IqA+do1O7XcbvJGbPYQYF5LcBzEVKuTpg+csCcHKTU8IWqE8a2uGwJ+6WAM+xmyguxuK2UpIDVxmXZm5OWeo5wgCx+KEeCLQVaV5K1SsxHTgeQN1Gjy38TfMbhm4ZPyru2fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=JAihs0Ak; arc=none smtp.client-ip=162.62.57.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="JAihs0Ak"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787820656; bh=MkVAz+nziKZdCTn6HmvN/NomSd/COxgGaSRyDjl50UA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JAihs0AkYXHVUWlVxhG89wNjalEeGvHFGgfceVWgC5bRNSRDoBQ55GebIh+QHgwLx
	 9rg5QtjZ/HxBKxr6Ta/GEMbo+7EUeaFw8tYpmOqQK1jsZ/a+amuKcHHQ2t02Nb2m+6
	 robKvqOrMEQzcpDFtceCjB53vsx4AnB1/LWiay4w=
Received: from DESKTOP-AT5F202.localdomain ([183.242.244.64])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id CB527A6F; Thu, 27 Aug 2026 16:50:53 +0800
X-QQ-mid: xmsmtpt1787820653tenvsk5pw
Message-ID: <tencent_DBADB12BBC6D88300488F16E75A384FAE505@qq.com>
X-QQ-XMAILINFO: ODafEzNm5ExjyRyvYuhEnPZXoeEln5e2S2zBV2pNntpeSDN8DTevB9gCk1ENw7
	 SjIz5UT8CQkf/6UKM1Vl1MDaTpaxqlMJ08xPhbaZu/e344rxtcy+v9elLQxseJTr0Dvj5+6A5zew
	 wNDQmSk0mKfktzrG0QoEgvZpcRiVADtWR2LdBBShLvYCI4j2y5pfTptTuN0EX5bF4mElCcEqbZxF
	 fFaHOcsmBP5j0XCDSee5f4rRRCPwEGXdLdTtTyO/lfpDvXDBRngFt9J67xaxPf5I205Ax0zzp6jJ
	 i5WhvLSOmMHqGt3qBen1ybCQdGV60WLYinDYBoo89X2SMceAIP1YJFqFsmsVDS753SnoxPIA03+3
	 9BOHqlouKL4JN6oHdTTsDhOpl2cndZoA/KK984r0+6fPOEzD18tjtq/e9qzbZIi3261JnR+JDZBt
	 9XQaUHzRW2B2YqvYNKEjOkx6sJVccm7uulCpJVFUPxBVkcbJ0lVi5Nhj46L4qFfWdAIGLAn13wwH
	 rYU/dLxfcp6Twrw0csjEzVk13j6bU5hjrG5yC2z6/oLo6wu3uU2cGK751qn2OATaNndwFgFlM5ae
	 2Gzcnj0ijJeqG4JUSqzGEWMpqy1BwxXCFZPEy5qjd3jknfsjL7uGlb3iHQVXskULSkD1EYegM0y6
	 HH5iE5FC8Dj2cHWS734WxU3hVW9V3IOJsrfOKYOYzZpUeJeV7dEShztsQ4abr5Om4bkJbEsywB1i
	 G/cz7cCzXxTZ0Xty1RfAxetbL4THRWZrTPLoWvzsiAgRwQtZXwaRtdDiCoLWFfTAeXjVRlr2RLfx
	 rDVf1+pOgDThfgbdsqJV9scM6n7vsHiKRwSspHvA+PQiBgZIJAiDeLMhK9oPdcgEX+zdy1HniSyB
	 oLznFPVoqaLrJEYjOJk0aVk+P5Z0Rr7NlzaZ+asVUrwC3G4SWFGRfK3FIS0gGUXl+NVCfM2N351V
	 wIgBrqEJt97wPWioyAc2/MhgHLMZoFgDaZT4qD/hAW4FrbIngF9B+qHo68+U2XZ4xsUV55z+Pgwp
	 aHKNZhzU6rsIwtpQ4WcR5Dh5oQb+JeSbcq7Yw1oxopr7WbmFyK
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
Date: Thu, 27 Aug 2026 16:50:52 +0800
From: shuo chen <1289151713@qq.com>
To: sashiko-reviews@lists.linux.dev
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: [PATCH V3] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
X-OQ-MSGID: <ao_6bP7yWpEHM8Bs@DESKTOP-AT5F202.localdomain>
References: <aoJ4bJZNgNAt4pLD@mit.edu>
 <tencent_5FCFA1D9100C4691D5AA92A597B846A8F007@qq.com>
 <20260822164543.96A9F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260822164543.96A9F1F00A3A@smtp.kernel.org>

On Sat, Aug 22, 2026 at 04:45:43PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 7 potential issue(s) to consider:
> - [Critical] Misordered metadata update causes corrupt directory `i_size` on disk.
> - [Critical] Unconditional BUG_ON() crash in `ext4_free_blocks()` on error paths for allocations > 1 block.
> - [High] Permanent block leak when `ext4_ext_insert_extent` fails with an error other than EDQUOT or ENOSPC.
> - [High] Concurrent inode metadata changes are overwritten during error recovery.
> - [High] Permanent space leak due to hardcoded extent length of 1 block.
> - [High] Missing `i_blocks` accounting for newly allocated physical blocks.
> - [Medium] The commit message describes a completely different change.
> --
> 
> --- Patch [1]: [PATCH V3] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir ---
> commit 1cb52ec17c1b86718dd26a2d224b02e260c85e40
> Author: pipishuo <1289151713@qq.com>
> Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
> 
> The commit message describes adding a state check in ext4_readdir, but the
> patch refactors ext4_convert_inline_data_nolock and introduces a new block
> allocation mechanism for inline data conversion.
> 
> >     Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
> >     
> >     Resend as v3 because I forgot to add the version number
> 
> [Severity: Medium]
> Is the commit message mismatched with the actual code changes? The subject
> and message describe adding a state check in ext4_readdir, but the patch
> entirely refactors ext4_convert_inline_data_nolock and introduces a new
> block allocation mechanism for inline data conversion without mentioning it.
Got it
> 
> > --- a/fs/ext4/inline.c
> > +++ b/fs/ext4/inline.c
> [ ... ]
> > @@ -1079,21 +1080,115 @@ static int ext4_update_inline_dir(handle_t *handle, struct inode *dir,
> >  	return 0;
> >  }
> >  
> > -static void ext4_restore_inline_data(handle_t *handle, struct inode *inode,
> > -				     struct ext4_iloc *iloc,
> > -				     void *buf, int inline_size)
> > +static int ext4_set_inline_data_block(handle_t *handle, struct inode *inode, ext4_fsblk_t block,
> > +					unsigned int len, struct buffer_head *bh)
> >  {
> [ ... ]
> > +		struct ext4_extent newex;
> > +
> > +		newex.ee_block = cpu_to_le32(0);
> > +		newex.ee_len = cpu_to_le16(1);
> 
> [Severity: High]
> Does this permanently leak physical blocks if the allocator returns more
> than 1 block? When ext4_mb_new_blocks() returns a larger allocation
> (e.g., due to cluster normalization on bigalloc filesystems), hardcoding
> the extent length to 1 abandons the extra blocks. Should this use the
> allocated length (len parameter) instead?
The excess blocks will be stored in i_prealloc_node, so setting the length
to 1 is fine.
> 
> > +		ext4_ext_store_pblock(&newex, block);
> > +		path = ext4_ext_insert_extent(handle, inode, path, &newex, 0);
> 
> [Severity: High]
> Does this miss accounting for the newly allocated physical blocks?
> Manually inserting the extent bypasses the normal ext4_map_blocks()
> pipeline, meaning ext4_inode_add_physical_space() is never called to
> increment inode->i_blocks. Could this lead to stat() inconsistencies and
> fsck failures?
I don't have a deep understanding of the i_blocks update mechanism, 
but I still believe that i_blocks should not be updated here.
> 
> > +		if (IS_ERR(path)) {
> > +			error = PTR_ERR(path);
> > +			if (error == -EDQUOT || error == -ENOSPC) {
> > +				goto recovery;
> > +			} else {
> > +				ext4_forget(handle, 0, inode, bh, block);
> > +				goto nofree;
> > +			}
> > +		} else {
> > +			ext4_free_ext_path(path);
> > +		}
> > +	} else {
> > +		EXT4_I(inode)->i_data[0] = cpu_to_le32(block);
> > +	}
> > +	error = ext4_xattr_ibody_find(inode, &i, &is);
> > +	if (error)
> > +		goto recovery;
> > +	if (!is.s.not_found)
> > +		error = ext4_xattr_ibody_set(handle, inode, &i, &is);
> > +recovery:
> > +	if (error) {
> > +		ext4_discard_preallocations(inode);
> > +		ext4_free_blocks(handle, inode, bh, block, len, EXT4_FREE_BLOCKS_FORGET);
> 
> [Severity: Critical]
> Can this trigger a BUG_ON() crash in ext4_free_blocks() on bigalloc
> filesystems? If the length (len) is greater than 1, calling
> ext4_free_blocks() with both a valid buffer_head (bh) and the
> EXT4_FREE_BLOCKS_FORGET flag will unconditionally hit the
> BUG_ON(count > 1) check inside ext4_free_blocks().
Got it
> 
> > +nofree:
> 
> [Severity: High]
> Does the jump to the nofree label earlier permanently leak the allocated
> blocks if the extent insertion fails with an error other than -EDQUOT or
> -ENOSPC? Jumping here bypasses the ext4_free_blocks() call during error
> recovery. Because ext4_forget() only removes the buffer from the journal
> without freeing the physical blocks in the buddy bitmap, the blocks appear
> to be permanently leaked.
Got it
> 
> > +		memcpy((void *)raw_inode, inode_buf, inode_size);
> 
> [Severity: High]
> Could this non-atomic memcpy() overwrite concurrent metadata updates?
> The i_data_sem protects the block mapping, but background flushers or
> other operations might have updated the inode's timestamps or extended
> attributes in the raw_inode while we were allocating blocks. Blindly
> copying back the old inode_buf could silently discard those changes.
Got it
> 
> > +		memcpy(ei->i_data, raw_inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
> > +		ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
> > +	} else {
> > +		ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
> > +		get_bh(is.iloc.bh);
> > +		error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
> > +		EXT4_I(inode)->i_inline_off = 0;
> > +		EXT4_I(inode)->i_inline_size = 0;
> > +		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
> > +		if (S_ISDIR(inode->i_mode)) {
> > +			i_size_write(inode, inode->i_sb->s_blocksize);
> > +			EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
> > +		}
> 
> [Severity: Critical]
> Does this permanently save a stale directory size to disk?
> The raw metadata buffer is marked dirty via ext4_mark_iloc_dirty()
> before the VFS inode size and i_disksize are updated. Since this patch
> removed the later ext4_mark_inode_dirty() call, is there a risk the
> updated size fields never make it to the on-disk raw_inode?
Got it
> 
> > +		brelse(bh);
> > +	}
> [ ... ]
> > @@ -1168,24 +1263,28 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
> >  						   inode, data_bh);
> >  	} else {
> >  		unlock_buffer(data_bh);
> > -		inode->i_size = inode->i_sb->s_blocksize;
> > -		i_size_write(inode, inode->i_sb->s_blocksize);
> > -		EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
> > -
> >  		error = ext4_init_dirblock(handle, inode, data_bh,
> >  			  le32_to_cpu(((struct ext4_dir_entry_2 *)buf)->inode),
> >  			  buf + EXT4_INLINE_DOTDOT_SIZE,
> >  			  inline_size - EXT4_INLINE_DOTDOT_SIZE);
> > -		if (!error)
> > -			error = ext4_mark_inode_dirty(handle, inode);
> >  	}
> > +out_bh:
> > +	if (error) {
> > +		int flags = 0;
> >  
> > -out_restore:
> > -	if (error)
> > -		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);
> > +		if (data_bh)
> > +			flags |= EXT4_FREE_BLOCKS_FORGET;
> > +		struct ext4_inode_info *ei = EXT4_I(inode);
> >  
> > +		down_write(&ei->i_data_sem);
> > +		ext4_discard_preallocations(inode);
> > +		ext4_free_blocks(handle, inode, data_bh, newblock, allocated_block, flags);
> 
> [Severity: Critical]
> Similarly, could this also trigger the BUG_ON(count > 1) in
> ext4_free_blocks() on failure? If allocated_block is greater than 1
> (e.g., bigalloc) and data_bh is valid, flags will include
> EXT4_FREE_BLOCKS_FORGET, which crashes when freeing multiple blocks
> with a provided buffer_head.
Got it
I'll fix these issues and send V4.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/tencent_5FCFA1D9100C4691D5AA92A597B846A8F007@qq.com?part=1

