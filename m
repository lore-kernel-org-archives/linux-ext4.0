Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794807880;
	b=kpeGl2Lfo6qOJHycxTR1FWTpBWYPBujvYJdiCzRNPmRVuhOImM7zYh0+pMJYP4/U7Fac
	 A65Ioxuh5YymkPLqph27JgCtOWR76G3lgXhj9NAQCspw3ErwHjYSaFccR2th7cJd7JTWT
	 TYZNvB/RXxcXZh4CbqkqP40Awd1Hmm/bKbejMIOYQF/MhM/ZAGqJs5Uv+zL3eebiPfz4g
	 moaBrB42lcKaWmpQZHrgzI0mP1edZ40w68l/QQwaFwlIFJYLEacwwCde3leBnJ8jG5PSL
	 x211E5Vi2Nr5mP053NTbs1EFe8maeACIpUkTy2ya4Wf/eYSNQXypd0Po6zbROJr+Bkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794807880;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=YH442YWUNRpnQkaRImDBTqOX7zg5nlBfCdBGvA+8K7Y=;
	b=UJf63PkaT2u6EQzUPsPBbVehJvA0jmI2j/OgiznpsSLdMhxv3AeeDT2iTRrxZJoElwDr
	 68zrushbnhkz4660tYOuZC4jJDQCniDTOZwZXn9mEWgstozMgBFw68GlPV/l2ugirdG1d
	 6CFmAzAXdEkURwAlzB3NjYbJVUD5/aPAONLJuimviyfq/sgBWAAm9U+rY5GE3krmBpy/d
	 ytinx0//khsGGP4n1TSSEJhvSIv8yjKbWoGTTHuIC+gXXPk3gO6wpzti2nlM9SN01D55w
	 wRdFAYFj/okE6+thDRuoqvTQ1DKyN4UR9Q8RVeqHXb7Jh7fXwGvBnwWvyGvEBZXpoFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5B7606A33A
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 05:44:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D5B7606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4f8281066c4so3991766b6e.2
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 21:44:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794807879; x=1795412679;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YH442YWUNRpnQkaRImDBTqOX7zg5nlBfCdBGvA+8K7Y=;
        b=0IFjfq6NvyTkmpPXTTiCV2ZtLc2L1BBu6hysMrw8nueUurX8yLST5mSWPu7wGdjzdZ
         bzmyik0HkHbl3qqy/8uOLOcc7hCpf3OT592zBjTu7kMaUkljiSudvDT8Tci/gvgqhHYs
         E7NyF/vKPSlxCn18kW6hytcLx0IFiROzOUwN0t8nQgESzj/CYzW9y3hpbo0/hVQAb7za
         KwCftH3CiJE6Mv72U/JceRGsV3ErcGUGI+2Fx48HQexTyWtFalsFg3Pc9cEEzHamJONo
         V9Pj+xd6IuOY8JZie50SNOhusKiCENc+lCIiK11qxS2oOFSNn5AV8JVQHS+WeXohJHot
         RCrQ==
X-Forwarded-Encrypted: i=1; AL+hErFlTLAhR/hIYhqB2M+90HW0hCEAlgQtIyVmZVVjcX44j32s0O7boPQD7WRk998UC0pvUhwNYpkVCc6K@vger.kernel.org
X-Gm-Message-State: APuU4Z9zMYBkjHRvgEa8ht7/b490vcaFlM/sbIN5pmDNKsSpjUzYsxOt
	OU45SvZNh8g++b4yzcs1icO8YFjOmmVyykldmK6dZ6t+QqWrm9RhaHPW2mVcLY5drM2bEWb5qlo
	uhZw236yePWOgZMHmh7zbJpLSytNCl1p7T1uY4efoU4DvIvIjDhHFsW+feU0=
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6809:211:10b0:571:7f0f:924a with SMTP id
 5614622812f47-5717f10b319mr4111005b6e.35.1794807879376; Sun, 15 Nov 2026
 21:44:39 -0800 (PST)
Date: Sun, 15 Nov 2026 21:44:39 -0800
In-Reply-To: <20261116054424.62067-1-diasyzhang@tencent.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afa9847.b64ae673.1498f1.0dc5.GAE@google.com>
Subject: Re: [PATCH] ext4: attach jinode before inline data conversion in setattr
From: syzbot <syzbot+9c29b92a3b6500bb347d@syzkaller.appspotmail.com>
To: diasyzhangqing@gmail.com
Cc: adilger.kernel@dilger.ca, ahmadpsn95@gmail.com, diasyzhang@tencent.com, 
	diasyzhangqing@gmail.com, jack@suse.cz, kartikey406@gmail.com, 
	libaokun@linux.alibaba.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	stable@vger.kernel.org, tytso@mit.edu, yi.zhang@huawei.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> Commit ed9356a30e59 ("ext4: convert inline data to extents when
> truncate exceeds inline size") added inline data conversion to
> ext4_setattr(). Pathname-based truncate bypasses ext4_file_open(),
> so the inode may lack a jinode. In ordered mode, the conversion
> can pass this NULL jinode to jbd2_journal_file_inode(), causing a
> NULL pointer dereference.
>
> Attach the jinode before ext4_convert_inline_data() and propagate
> attachment errors. The attachment in ext4_truncate_up() occurs
> after the conversion and is too late.
>
> Fixes: ed9356a30e59 ("ext4: convert inline data to extents when truncate exceeds inline size")
> Reported-by: Ahmed Khan <ahmadpsn95@gmail.com>
> Link: https://lore.kernel.org/r/CAOaS1==g3mdoqmS2AjOC0_-woXJbA_X0LJQt7+M7d1=+gfyQqw@mail.gmail.com
> Reported-by: syzbot+9c29b92a3b6500bb347d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9c29b92a3b6500bb347d
> Cc: stable@vger.kernel.org
> Signed-off-by: Qing Zhang <diasyzhang@tencent.com>
> ---
>
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

Patch testing via #syz test is temporarily disabled.
See https://github.com/google/syzkaller/issues/8122 for details.

>  fs/ext4/inode.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 10cd85d4c721..1e31933ae98c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -7127,6 +7127,9 @@ int ext4_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  		 */
>  		if (ext4_has_inline_data(inode) &&
>  		    attr->ia_size > EXT4_I(inode)->i_inline_size) {
> +			error = ext4_inode_attach_jinode(inode);
> +			if (error)
> +				goto err_out;
>  			error = ext4_convert_inline_data(inode);
>  			if (error)
>  				goto err_out;
> -- 
> 2.43.7
>
