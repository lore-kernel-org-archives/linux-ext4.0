Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.87
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794814545;
	b=PrtL1GMJGc5DGqBdSdPKUg7Jw4CGMp5E+/YgLH3xNM3f5xZXwvvN1Zy+9xFJ469U6pZK
	 OJzxMEqDChEhWY5j87Hof6tz9rnst9OzKZVXbnlsC+Ia7S2pO5qJrNMJ+Ks4DQj+lL/nu
	 gCFpbACU5Uw+nBg2pmkg+DOgWtoDX3cBxH2ZonpPlVcyKrOcJPICmIh81vgdRtz09s4LX
	 9IzeSRVxxzSrk+zLaWsgyvBff4v0Xyizkux2s+fFJOCU/V2Fc2BUPHYPp3UHN7HHfSjI6
	 g9aS0VLNbqvxQBA28CnHuFnHmGHGVZSbTzJj+kbJ/i1ck1+K8L95oPC6MgktEFaEb+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794814545;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=gPZTbZk8SoJNpUJDON4Ig3GkkPgAjMgPKV23C0DMgpU=;
	b=YMHuk8W5am2zo4BZYaNUHCg6y/1o/Fh0zt34BbnI/uVhqKpQbWhJr8AuOi014i0PohOR
	 Rv75Ut6esrdSUXLWvZYpz+3OeTjfVJTaSglTz+Mexiry3u3lEPdZEPbudL9PLFMOWAaEF
	 FVSXBe0NpWkvnc3K2fnsZdxiZq2x9KTUCto6it5Wi6E+eLd/lBS4aqTNO0OLL8c79mZlA
	 JDEeYXe/eIQHBwLGQgKAB+LBsAfTyr7r99wnXAj6ztztQtSZRQVRBlOphhS6Z5D64nkKn
	 p6OSXwvwDo6ys1Y+kPjSbwVOvBqonnweIBaF/k6kXK4GNRjNfH+aeS0T1g9iieBlzOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=m19tbZ5W;
	arc=none smtp.remote-ip=162.62.57.87
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358B9606A31C;
	Mon, 16 Nov 2026 07:35:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 358B9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=m19tbZ5W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794814532; bh=gPZTbZk8SoJNpUJDON4Ig3GkkPgAjMgPKV23C0DMgpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m19tbZ5WnGuKPYWjPPNwepbjA4QUPEQH4rUNG5Vyckd56/go7y0EXkFaC93h8h1dW
	 Xg6RyKFC9jgiVJDMqfX7Ah2ijCw6nTcoVgL5OnaarY+xQv5gRPSoP7pULeRmDP3zYv
	 Ca9okPL2DfIjsyB43xA4GjwXe639CUtXYFse3vQY=
Received: from ikun ([221.176.157.242])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 8D3BD429; Mon, 16 Nov 2026 15:35:19 +0800
X-QQ-mid: xmsmtpt1794814519tl5lnlj7n
Message-ID: <tencent_69B311F4356254E166A5EFDC981AA138D80A@qq.com>
X-QQ-XMAILINFO: MAUQIEZVArhLaRAHwoTiol5Eu17QC9JGLGD4PHcJuT6LN1zjNUHNcIM05oWU26
	 wyNGR9jWY5a/tzcgEoPwCEk8TwpkQTkplTdrFeP6TL4vi7dF1QeIlIru1AkXB7Q4HlFJO8KbRqIn
	 FQlN0HkIHbrZP0nQpzK/NEvjmaAoAqo87M4ogtRFNMuCFnitg8C7siVQh+Y05w3XoCGYvLzVOamj
	 trwcarLtqAY1FaPoOawK8mRzCnsBY8W2EG0jDS/GBK3z4M2xl1GbyV7XJXx0woh8Z3NPeCNiJy7m
	 pLOAJkt+6p/g+OZJ0EpHdQApBXxUw1em1hdv5j0TYo4U4EQ7Oibk5WPKDftKej/UiJRUdcJNVpYt
	 avDIv8MZL5gi1+TSM/ZMPAWr7+W6oX8Ntg1CHh8GxAQfapbAlyr11zREAmqwW9kUF4g6o4/fXite
	 w2Sv+fH2/6nbT9abLemPG/B3qETPc9rbUG+BuwtIBG8T4zAOOLcvH1s4yc2geR36re5ZefiQ4u/0
	 zHLyZKrcSq/Xo7cDJEowG2G10Ffm8Posz2Bwt9GvCdFt5LmMacE3b7sGHNo/JOKDPtXyKsIwPj/6
	 P6NzWXqXkIJuXJnwF+g4bqw8l4qCukIqb5DY4QBanYj+363PnX5x6s70dxuaNMsljzeHKw7NQd1o
	 HI2fseuS68VhoQgorkbdVWe8mlX+aemTsunomyJI1qV3SkN4SsLVBEMsEPMeaGI9j5hQllTAiBgo
	 7SzucFk97OCvBNrQqJ6pgy2ojTFV5MLG5Fol8Cl2wM/of0jbzA7nCZqsaXR+AkE5jaenVI8IUnEG
	 AOPUf9wvwevS/Pc/5ArXbWVxOKFQL08TxrZ3MbN00D8pnmzqW3VpFP4IhP7gI+fMXXy3/EYtSoDM
	 +uF1c5Cqx2E+U5zH4AqgbDnpmqCOh3hJFtfDWeoK8VudQw/E6e/+jj9n8bHt/1ree3cBlmVE+49o
	 4drTN6uA2uaW6xXpAfJ7XlBK8poZr7Ei5aNk82gbwz48UqzhqTQAyTjDwwbMrdUmhDjLGXrtrTXs
	 WJZQQlz6ag8l2/s8ZAE4RATyLQ4Zs=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Alan <3164729207@qq.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	harshadshirwadkar@gmail.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] ext4: reserve inode write access before unlinking entry
Date: Mon, 16 Nov 2026 15:35:19 +0800
X-OQ-MSGID: <20261116073519.21804-1-3164729207@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com>
References: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Ted, Jan and ext4 reviewers,

A gentle ping on this patch from October 27. Are there any comments on the
approach?

I have additional validation from November 2 using QEMU blkdebug to fail an
actual guest block READ. These results supplement the source-derived fault
injection described in the original mail.

On the unpatched Linux 6.12.1 test kernel, with errors=continue, the failed
read was at sector 2312, in the parent inode-table block (block 289, parent
inode 13). The kernel reported:

  I/O error, dev vda, sector 2312 op 0x0:(READ)
  ext4_get_inode_loc:4554: inode #13: block 289: unable to read itable block
  __ext4_unlink:3469: inode #13: mark_inode_dirty error

unlink returned EIO. After normal unmount, /p/file was absent, but raw
inode 2064 still had Links: 1. e2fsck -fn reported:

  Unattached inode 2064

In this case the inode-table read fails in ext4_get_inode_loc(), before the
journal write-access call. A separate run of the same block-read failure
traced JBD2 through unlink, sync and normal unmount:

  jbd2_journal_abort() probe hits: 0
  unlink handle at jbd2_journal_stop(): TID 7, T_RUNNING
  h_err=0, h_aborted=0, j_errno=0, journal JBD2_ABORT flag clear
  jbd2_journal_stop() return value: 0
  jbd2_start_commit: transaction 7
  jbd2_end_commit: transaction 7

The offline filesystem check still reported the unattached inode. This
demonstrates that this read-error path can commit the directory change
without a journal abort when mounted with errors=continue.

With the fix, the same clean input and block-read error failed before the
directory entry was removed. After normal unmount, /p/file remained present,
inode 2064 still had Links: 1, and e2fsck -fn completed without diagnostics.

Thanks,
Alan

