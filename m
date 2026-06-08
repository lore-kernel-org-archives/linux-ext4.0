Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C463DA5AF
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 18:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780942822; cv=none; b=ad2LkAGFkcOn4CBRgR2Mmx8ymGran/GHYxsTDmCZgyBcnv4AUS1RW8k6F46jUBBPNMc3BjS4iJl3GyQV+r+VzqGri8kyMP+4hdIUfDWLMOYqVuYeEDhoPaWdxAGoDWGlzrOB41b6pQdnk41W4lWJhAojYcSBB346vtEYZTqLKWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780942822; c=relaxed/simple;
	bh=IFUxQePgQPWagX94LjUgPFEhbCxU/1dBN/zy8YE2k4Y=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=p8dTWD405Nb3JNyFem5rhK+CEZEmqlY3HOm/xDGuOUH4siV2zHrpWf/p7mDxrs8+9YZrVo3v2T/fMJDCg42UaUKjEVP0Kde1yxcFt+pB8oxjd2eF4SkHdxYFVorY0lBvOxfZksFHjmNmyi1J4jGpE6eB4XqoWHTshHOCX9YtCEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=y4CeyWJB; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="y4CeyWJB"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-36b9033d230so2432301a91.1
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jun 2026 11:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1780942820; x=1781547620; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQskHwaDxiAKCpvnt4doxj3gJ0rPMnrTgKnvTUd1hIY=;
        b=y4CeyWJBPe0mnqICl+nyXgGfuGxZE5XC/7hid3CLoRAvPNhaphVttxEw9Bx6CDQNjX
         jizopoLgd44hZFqYD1dApS3gxzFuLd/rTpoAPn7ZcunjmAK4BBMkWyMxCsgoTGMKGL++
         M90F3lUMuFz2chZIRdvdgexiizGJONGqxpKRksDDNwHUA0Uv0d4kgEYdmbv5sXesHSc1
         VVsVeAywZTm8TblMYkLmliTGZwf/67VtVHa7MaXJgEJjbLs01n8AZMahwANyniA8W3mc
         gn+1LBTvV1GLgtJYD9NB3LvyWCgbX9/kP9fqSEB/GcAHyv3BLiUN2JwMpf/lwr+dldEe
         xWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780942820; x=1781547620;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EQskHwaDxiAKCpvnt4doxj3gJ0rPMnrTgKnvTUd1hIY=;
        b=P4lbScyTwnnqJA8zBkM782lw+2L5f3pt9ZBtKNrF5DEjxt2x2Q6wnTZhAtIjRh2OhW
         VvMvy6JETRdBytmYG33NZ1U4CEYIG0KANEmKDTM+RSf1o7KOlGaMEgHKUSwGl4sIzjbq
         Yk21UQW3zOAnAnpjK80IDxWJFOwKEOaPJL3bUFcQWutUZ3lN1/g7mvhQHnCynS8yGKkD
         /M1qW4PPRwoZmIm+mauJvQutXnOeTM20BLctwOz8K5XjB6fJVboE0KD56aICTk3G46OG
         EEeYTaWDDTS3Tem2I7M8o7yJlK5qnlyLzDyVbj8iUDL8QMU4BRxwzsRNFVgeaWAoOoLc
         IpGg==
X-Forwarded-Encrypted: i=1; AFNElJ9/5lbNsT68adDu33wBwZe3ohBjpO415m3lRXcYEVSEoBKfLAFrvIZ9W4naQ0sDBgVEjROmy81BAcPj@vger.kernel.org
X-Gm-Message-State: AOJu0YyE+lCo2hPnC/wR5NIpfYhhAIfE9ZubTID9X15lTpS4wTXKVlfz
	ko758ccRqzzXRVVZM3EGh25+uoHpOLkqEiHQw7y7/+dwtQGJGv7NUhHvE8eFkWvSEag=
X-Gm-Gg: Acq92OHzSd5JjIP5yBLv0F2hHm0gcRkgJH85ewo/ESXAkGP20yxC4rNIUfBizI/9FIB
	g85QvHX0LyjlMs67YXp5cKCAWYUPtJas5eMgLuuOxXkXDUlCIQLJZiEjqxdaXVUtoW4LbYVlNhJ
	VD8BaGEJju0AiQylm0uiTJraRAlTd8N6mXSLGJArZR6nlXPUklsnFd9DgzpIn3vygE3/+Htf9Os
	eqM62i4S90Vl0oTOQCRKR9I68gAJ5Byap3NAPBZRjJf2XUot4/Btrw1q6RuJlholdk/zJSTVP+u
	ly6y4rvK06Pw7RCO6UHwFlz2qUiSYzCEoqzm2LPrFZDDdbGfttT/Ai1NtsjCW0+obVpsYyZIBQz
	9QmGMwExBlAf+bjE0EC4gd6HqJg20506+/x6w1+WLfKFQ3Nfz5ZXGQFjaKLErNqK5jofGu1g/eh
	8MdoCNR274C1EukwGNBwNnjRnoFZyYOkuq2JGJlpDLcfEVKDTi9OemUYcc//7byQcIRxrOA5odt
	avdiiDx+AarmemT
X-Received: by 2002:a17:90a:d003:b0:368:65d1:893 with SMTP id 98e67ed59e1d1-371306869a2mr13442994a91.5.1780942819936;
        Mon, 08 Jun 2026 11:20:19 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428235006dsm19410726b3a.13.2026.06.08.11.20.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jun 2026 11:20:19 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] ext4: validate donor file superblock early in
 EXT4_IOC_MOVE_EXT
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260608152521.1292656-1-yun.zhou@windriver.com>
Date: Mon, 8 Jun 2026 12:20:07 -0600
Cc: tytso@mit.edu,
 libaokun@linux.alibaba.com,
 jack@suse.cz,
 ojaswin@linux.ibm.com,
 ritesh.list@gmail.com,
 yi.zhang@huawei.com,
 dmonakhov@openvz.org,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5D214F11-047A-4414-B9BC-8ED669817145@dilger.ca>
References: <20260608152521.1292656-1-yun.zhou@windriver.com>
To: Yun Zhou <yun.zhou@windriver.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jun 8, 2026, at 09:25, Yun Zhou <yun.zhou@windriver.com> wrote:
>=20
> Reject the EXT4_IOC_MOVE_EXT ioctl early if the donor file does not
> belong to the same superblock as the original file.  Currently, this
> validation is performed inside ext4_move_extents() by
> mext_check_validity(), but only after lock_two_nondirectories() has
> already acquired the inode locks.  When the donor fd refers to a file
> on a different filesystem (e.g., overlayfs), this late validation
> creates a circular lock dependency:
>=20
>  CPU0 (overlayfs write)            CPU1 (ext4 ioctl)
>  ----                              ----
>  inode_lock(ovl_inode)
>                                    mnt_want_write_file(filp)
>                                      sb_start_write(ext4_sb)   =
[sb_writers]
>    backing_file_write_iter()
>      vfs_iter_write(real_file)
>        file_start_write(real_file)
>          sb_start_write(ext4_sb)   [blocked by freeze]
>                                    lock_two_nondirectories()
>                                      inode_lock(ovl_inode)     =
[blocked]
>=20
> With a concurrent freeze operation holding sb_writers write side, this
> forms a deadlock cycle: CPU0 waits for freeze to complete, freeze =
waits
> for CPU1's sb_writers reader to exit, CPU1 waits for CPU0's inode =
lock.
>=20
> Since EXT4_IOC_MOVE_EXT exchanges physical extents between two files,
> it fundamentally requires both files to reside on the same ext4
> filesystem.  Moving the superblock check before any lock acquisition
> is both semantically correct and eliminates the circular dependency
> by ensuring that cross-filesystem donor fds are rejected before
> sb_writers or inode locks are taken.
>=20
> Fixes: fcf6b1b729bc ("ext4: refactor ext4_move_extents code base")
> Reported-by: syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dad6118a7584b607c67f2
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

Thanks for the patch.  Looks good to me.

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> fs/ext4/ioctl.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 1d0c3d4bdf47..f7cd419a3218 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1650,6 +1650,9 @@ static long __ext4_ioctl(struct file *filp, =
unsigned int cmd,
>  	if (!(fd_file(donor)->f_mode & FMODE_WRITE))
>  		return -EBADF;
>=20
> +	if (file_inode(filp)->i_sb !=3D =
file_inode(fd_file(donor))->i_sb)
> +		return -EXDEV;
> +
>  	err =3D mnt_want_write_file(filp);
>  	if (err)
>  		return err;
> --=20
> 2.43.0
>=20


Cheers, Andreas





