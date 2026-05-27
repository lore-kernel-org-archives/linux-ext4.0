Received: from sender-pp-o92.zoho.in (sender-pp-o92.zoho.in [103.117.158.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74D33BD657;
	Wed, 27 May 2026 10:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=103.117.158.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779879219; cv=pass; b=a9LNly43ij1E9pcJaNid5YroNsuvquqGhUDEkts20vzlU7y/5D76jxkkk6b1lCpN0MEhCIakCeigK8MbvpcQakhQKdL0N2cEfhRw+7MDOapB6Hn50HqYW/68rJiu/1kU4eJJMHq+ZU7Z1GRa5ftz/3VI1Zm28ST5LovFzlKIQpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779879219; c=relaxed/simple;
	bh=ZtlC7mxyLLYzshKxyTbPEnRyUrR+hDDk1ENdEMOtjgo=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=YTHFBcKFriK4QbYC/Xh/vHaTK9OHyWPpxC04MV+mlfZIplyquBiL8iuTEGWoD6QzAfLYbZPUj1Pf6IU3UUp2fkbuD3RKVa+bJB6uw+2jscc4QJ73H5OjF9A/v1I2ftPWjW/IDDqdOo5BlcuMYCOrouCYHPTsHi6XT/JPw7SAfZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.in; spf=pass smtp.mailfrom=zohomail.in; dkim=pass (1024-bit key) header.d=zohomail.in header.i=linuxuser509@zohomail.in header.b=PFIK0fPd; arc=pass smtp.client-ip=103.117.158.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.in header.i=linuxuser509@zohomail.in header.b="PFIK0fPd"
ARC-Seal: i=1; a=rsa-sha256; t=1779879198; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=RmlZm4Io5KXkSGCiS5QThu1Di8v1EpQ2S/jDEQalQbghVSMOexvXNjqgGfas5SPNrvB6HQKAhe4ta9b83doqBsHCYD5V+Vo4VnlrymhqPT9qoyKdWoRl9rzmcKmfyLx7jiZtREsMV8N+igg+UC6egNxkH/iUZo7aMx5G3U+EOq0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1779879198; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=HuMbpvsBlccwK0fIK83oay4plQdUUf+m1/8jmge2oy4=; 
	b=XAQY4LjzPQpo/m6coCIcI8oIWaggOLIWzKFifIKRPJzW5jmwBD+XoT33rzDuRI4eRRN3BBv00FOhdhy6WQ6jUk3in5YQltXLILSACbSbb+FJ1VSoy8Kdc3tIE5+QKmus1yGwia7rskY0nqEj/S4cGUsdwaMXjjJZH2prf/18Xp4=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=linuxuser509@zohomail.in;
	dmarc=pass header.from=<linuxuser509@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779879198;
	s=zoho; d=zohomail.in; i=linuxuser509@zohomail.in;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=HuMbpvsBlccwK0fIK83oay4plQdUUf+m1/8jmge2oy4=;
	b=PFIK0fPdsoh77Jbr0yRc5V7gi8kWd4gp3eRXfVPrC5Kb4Tj8fS/b6mI4uFCmmU4H
	s8od38ufYjOS4eB9uqMZtJaPvDJCqb3xU0rQUy4ge5RVLd70toUpQNAssAQ6ANkWXN+
	a5g8ZjIgKz8EhD1fADhH+KSGeBF+AKbLWoS9nsP4=
Received: from mail.zoho.in by mx.zoho.in
	with SMTP id 1779879191310723.8920771220262; Wed, 27 May 2026 16:23:11 +0530 (IST)
Received: from  [157.48.160.125] by mail.zoho.in
	with HTTP;Wed, 27 May 2026 16:23:11 +0530 (IST)
Date: Wed, 27 May 2026 16:23:11 +0530
From: Ashwin Gundarapu <linuxuser509@zohomail.in>
To: "Jan Kara" <jack@suse.cz>
Cc: "jack" <jack@suse.com>, "linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19e69112307.5dd566d616932.1244208289759522202@zohomail.in>
In-Reply-To: <fxaiddid432ivmkcsqmzeovemmnkyh37nfgwn4xurxb2wx5u5y@lhkjib3tmd7e>
References: <19e587e5143.434d5026117452.233431645221906532@zohomail.in> <fxaiddid432ivmkcsqmzeovemmnkyh37nfgwn4xurxb2wx5u5y@lhkjib3tmd7e>
Subject: Re: [PATCH v2] ext2: Remove deprecated DAX support
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Thanks for the review, Jan. All the style issues you mentioned have
been addressed in v3 and v4:

v3: https://lore.kernel.org/linux-ext4/19e595ac3d0.1a0dcfbe128078.1031782761444069401@zohomail.in/
v4: https://lore.kernel.org/linux-ext4/19e5aa07c9b.3a2e576d130187.5289857983023045470@zohomail.in/

v3 fixed the spaces-to-tabs indentation issues in inode.c, super.c,
and file.c. It also restored Opt_dax for a graceful mount error message.

v4 changed Opt_xip and Opt_dax from -EINVAL to break with a warning,
per Sashiko AI review, to avoid potential boot failures on systems
with these options in /etc/fstab.

The stray empty lines and tab indentation are all cleaned up in the
latest version (v4).

Thanks,
Ashwin


From: Jan Kara <jack@suse.cz>
To: "Ashwin Gundarapu"<linuxuser509@zohomail.in>
Cc: "jack"<jack@suse.com>, "linux-ext4"<linux-ext4@vger.kernel.org>, "linux-kernel"<linux-kernel@vger.kernel.org>
Date: Mon, 25 May 2026 22:00:40 +0530
Subject: Re: [PATCH v2] ext2: Remove deprecated DAX support

 > On Sun 24-05-26 11:08:53, Ashwin Gundarapu wrote: 
 > > 
 > > DAX support in ext2 was deprecated in commit d5a2693f93e4 
 > > ("ext2: Deprecate DAX") with a removal deadline of end of 2025. 
 > > Remove all DAX code from ext2 as scheduled. 
 > > 
 > > This removes the DAX mount option, IOMAP DAX support, DAX file 
 > > operations, DAX address_space_operations, and the DAX fault handler. 
 > > 
 > > Signed-off-by: Ashwin Gundarapu <linuxuser509@zohomail.in> 
 > > --- 
 > > v2: Removed unused sbi variable and fixed indentation as reported 
 > >     by kernel test robot. 
 >  
 > Thanks for the patch. Some style nits below. 
 >  
 > >  static ssize_t ext2_file_read_iter(struct kiocb *iocb, struct iov_iter *to) 
 > >  { 
 > > -#ifdef CONFIG_FS_DAX 
 > > -    if (IS_DAX(iocb->ki_filp->f_mapping->host)) 
 > > -        return ext2_dax_read_iter(iocb, to); 
 > > -#endif 
 > > + 
 >  
 > Stray empty line here. 
 >  
 > >      if (iocb->ki_flags & IOCB_DIRECT) 
 > >          return ext2_dio_read_iter(iocb, to); 
 > > 
 > > @@ -297,10 +188,7 @@ static ssize_t ext2_file_read_iter(struct kiocb *iocb, struct iov_iter *to) 
 > > 
 > >  static ssize_t ext2_file_write_iter(struct kiocb *iocb, struct iov_iter *from) 
 > >  { 
 > > -#ifdef CONFIG_FS_DAX 
 > > -    if (IS_DAX(iocb->ki_filp->f_mapping->host)) 
 > > -        return ext2_dax_write_iter(iocb, from); 
 > > -#endif 
 > > + 
 >  
 > ... and here. 
 >  
 > >      if (iocb->ki_flags & IOCB_DIRECT) 
 > >          return ext2_dio_write_iter(iocb, from); 
 > > 
 > > @@ -321,7 +209,7 @@ const struct file_operations ext2_file_operations = { 
 > >  #ifdef CONFIG_COMPAT 
 > >      .compat_ioctl    = ext2_compat_ioctl, 
 > >  #endif 
 > > -    .mmap_prepare    = ext2_file_mmap_prepare, 
 > > +    .mmap_prepare = generic_file_mmap_prepare, 
 >  
 > Please indent this with tab the same way as other methods. 
 >  
 > > @@ -841,10 +818,7 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length, 
 > > 
 > >      iomap->flags = 0; 
 > >      iomap->offset = (u64)first_block << blkbits; 
 > > -    if (flags & IOMAP_DAX) 
 > > -        iomap->dax_dev = sbi->s_daxdev; 
 > > -    else 
 > > -        iomap->bdev = inode->i_sb->s_bdev; 
 > > +        iomap->bdev = inode->i_sb->s_bdev; 
 >  
 > Indented with spaces instead of tabs. 
 >  
 > > @@ -1290,12 +1248,8 @@ static int ext2_setsize(struct inode *inode, loff_t newsize) 
 > > 
 > >      inode_dio_wait(inode); 
 > > 
 > > -    if (IS_DAX(inode)) 
 > > -        error = dax_truncate_page(inode, newsize, NULL, 
 > > -                      &ext2_iomap_ops); 
 > > -    else 
 > > -        error = block_truncate_page(inode->i_mapping, 
 > > -                newsize, ext2_get_block); 
 > > +        error = block_truncate_page(inode->i_mapping, 
 > > +                                newsize, ext2_get_block); 
 >  
 > Indented with spaces instead of tabs. 
 >  
 > >      if (error) 
 > >          return error; 
 > > 
 >  
 > ... 
 > > +        case Opt_xip: 
 > > +                ext2_msg_fc(fc, KERN_ERR, "DAX support has been removed. Please use ext4 instead."); 
 > > +                return -EINVAL; 
 >  
 > Indented with spaces instead of tabs. 
 >  
 > > @@ -992,16 +974,8 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc) 
 > >      } 
 > >      blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size); 
 > > 
 > > -    if (test_opt(sb, DAX)) { 
 > > -        if (!sbi->s_daxdev) { 
 > > -            ext2_msg(sb, KERN_ERR, 
 > > -                "DAX unsupported by block device. Turning off DAX."); 
 > > -            clear_opt(sbi->s_mount_opt, DAX); 
 > > -        } else if (blocksize != PAGE_SIZE) { 
 > > -            ext2_msg(sb, KERN_ERR, "unsupported blocksize for DAX\n"); 
 > > -            clear_opt(sbi->s_mount_opt, DAX); 
 > > -        } 
 > > -    } 
 > > + 
 > > + 
 >  
 > Stray empty lines. 
 >  
 >                                 Honza 
 > -- 
 > Jan Kara <jack@suse.com> 
 > SUSE Labs, CR 
 >  
 > 

