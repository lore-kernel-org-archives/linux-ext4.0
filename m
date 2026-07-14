Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E7441A906
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 18:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054687; cv=pass; b=p6jbFSrB7KfKdMl1YWNDi81KC0f+yBx5f8m0pXM26igfiI0lJ5tIcEgjWN/hmHXPwfrIVzG5HoERskyekWq29VRw8VDuyevcYJ/E9CXFQmtXRWSuq6V2vFQxAAzg8saNrWChMPAk3jZEQ+0AP12pmxLr4u2xNppLRvqIwuvEUkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054687; c=relaxed/simple;
	bh=wDtX0uTAETOs4RFh7pBYn/YS5v7ZLpBOXkdBgR2TXnw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MPR1qAVyNKMsESM3mJJLaZ/BB7TiUmIzbJEVc90unWdUM5aCEYI1otrPcNaJwd34uUzMOOCoks6O06RkkmuuxYEFOnx+vNsLEaZ96ctSdGYX/lke46KvBY5PUNJ0WQp8fXGL8tUFr4eoP+PMl/5njNZmJujeMMkKGIgILDVlyUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=AKyuYbdE; arc=pass smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="AKyuYbdE"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso13420375ad.2
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 11:44:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784054685; cv=none;
        d=google.com; s=arc-20260327;
        b=r8NzwcG55CGb5AC7rLytOETikQdrNcYTkNuxTKxL6tVVeTTSYdza0HnxE9f/iBXOxo
         Ygu2ma7PBZXNgNeJ7oOwJauTVXQ0VuIahCSIoHPTGdbXBDQXHwVwMkzPKdnCUDCwknZv
         FKEj9rfpfhJ1ajowOLIZvwYU/sfnQmdBGeqV7cxei9EbDqyL2OELOKoMbSvf6mbujJDX
         8sNDRalm1mdNWT0aZXqP+yop8TDfoBr9vZAu0u/oETskyGVZgroR33zhQ/x43e8TBLqn
         PH1XovycJksc6hHG8lK4ShGBjl89Vx7P+E9jnx+xLPZ+0me9a5Z5+q/udo8+Huc2rRLF
         GpDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eZVk8r2PkAVSJSjoSoX6628ugmlB5h3hiz2HXRn06QY=;
        fh=hdMDBuHOoUKBd+VAsvCnEagngz2/ku3gynzq0ga5o+U=;
        b=gV2/PwXOzqrmLaZ6BK/ndFldJXIAv/tOdAiU02hRLiygleUeEslAnvFM7DuKZCU2Yn
         7KWHOK/wsBKXp3CKcTtgIOETcS683g71MoBK/zRr6umADIiyO0EylwLqCLlAHUVLsEKw
         TiQ2kikWnKmP2k5bRmsCLgM8ACUJOoMNScr/chuLgPDxXuoZmJFVTTYW2Xp9xKzQeHMP
         Lrjih8eHIHfrLWgcVHg9HXd+rRDjpge4WPZkJzglA3KASNFpkThTZhlvaxCmvn/gi1D0
         s/wASjZurUBnewzNlszAsJw0hwD8cuD8CILzGfps6pXCan/umfcJALlDSA3mz8KwASq4
         +YTQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1784054685; x=1784659485; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eZVk8r2PkAVSJSjoSoX6628ugmlB5h3hiz2HXRn06QY=;
        b=AKyuYbdEYaY0gosppp65p9Hs8H0oWcLMf5u6k6YuMIWrZlNLLyjPKZoshmz1O8potG
         cvDkOz131t2ieIyrKnXfCjYBhn0QVuXItmHH8tp0WkyYDzTRFZ3FoAyonrUaUrhhbss4
         CuimKeeHjs/AS8T/N81czZvjCvXE7jG1sxPCdfgMk/kq99QlRTqpDTj3O75PD7UVIpuE
         /ezbK4H9SfHFW8na9seX2i8FXlwU6mx6a3t8TfDHCWC7wxsCBvOGNpSAjuBqJy4/GWJO
         DuFtlzcMqh2jjxnvo0tCQVRtPz8GxbeN4CVBCdAnnHojwkye9RwAdgHb1gDP7IQhYVyq
         S+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784054685; x=1784659485;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eZVk8r2PkAVSJSjoSoX6628ugmlB5h3hiz2HXRn06QY=;
        b=BTbgZ1Z+E8D7M+0y2n8FQ0CvR0THyV5Otigul7J7f7EqHfKEbLnHMM2kC2a5mDVSO0
         iX3crML+SHbdVkpxljMcTSTWfxM0TY/3ELDacm6vcwV6m1xrKU5oZhKwXIu0wzHr5E7K
         TTCkMYpgagUHcEIxnBmYa8ndkUlgAvpfeIcTLNu/V785JBs27UBUcuy4AJfzFsfCOTAy
         9bA4DAKhx6L0otd0g1HUWN92bxKOb9dlxqQ0ct4KHZ/iyGA3PFXtQOus7O+6rUm6HAt9
         3lHNTlb9e/GBgh2QQTFTsI4L63t0dkztB8QsltgdRkN2G11G8tVID+CIkuAEifUuNJDU
         /rpQ==
X-Forwarded-Encrypted: i=1; AHgh+RrAUE/cCLH4dDFL+i+T491yVRSGJzagQEW1uXD8ciQ4HpBxTHWbmI+ikxn37TSR2dAy54/I1M7FnTVh@vger.kernel.org
X-Gm-Message-State: AOJu0Yym53fyfkCWawN01lRZ6qakxDyLBpUYwnDpePaKHgwZls9cTyA2
	kbsxTBKyQY6aWOKJU2ey6+l519iAsOplMIKipMa3tnjdpSE7m9YIsYOxxTh5fUoEVg2zmzHL2hZ
	Yf5lsLrOAkccGO3TJivgSgB7MR2yz1bOu2FkOSBv3
X-Gm-Gg: AfdE7ckNhThagokOdgSc6NAXXkjl6yyphBtc9WHggiVjvKwR+UGXjIFdMvE23x4jIqE
	4Zq2ZcQgXVZZMjqj5J6P4jxDEGGS0IPHMICSPeLPCOYf4WXKAZEYBMG3L41Tk9UeMNBV+pJHUFd
	xBvSPcaRQUMFLfsj/il2pNK/XvESOrZKwEpBzUP1yFOTms35AlcGEe6QawU3BUGsrcRiIIppX4F
	TzRC5bGIqfXCzM7OHqkBVp+AUQyhXkL7tgriu5+wzqCMc7P4PAqTQ8x692guN8uvF6K88b4p3B0
	9bhBRzAFeJOWcQDVw470uwfv
X-Received: by 2002:a17:902:c405:b0:2c9:bd64:8c8b with SMTP id
 d9443c01a7336-2ce9ee1143amr149082385ad.31.1784054685280; Tue, 14 Jul 2026
 11:44:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709184101.441348-1-xmei5@asu.edu> <kokbbtjua37msovatv4ahnauqqof53ndzqooayk4l7qyamys6w@srqaissjlt3f>
In-Reply-To: <kokbbtjua37msovatv4ahnauqqof53ndzqooayk4l7qyamys6w@srqaissjlt3f>
From: Xiang Mei <xmei5@asu.edu>
Date: Tue, 14 Jul 2026 11:44:33 -0700
X-Gm-Features: AUfX_myjUPSjeQlJvFJBE21b89RuG4PRXuRl37fYiGpwuktvz-2Q_82OhrS55BI
Message-ID: <CAPpSM+TgX8MATQZeR=LqWpJp52KuQ1Nox1qHDQESbNZipORP5Q@mail.gmail.com>
Subject: Re: [PATCH] ext4: check dir entry fits before reading the hash
 trailer in ext4_search_dir()
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Daniel Rosenberg <drosen@google.com>, 
	Weiming Shi <bestswngs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2026 at 6:09=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Thu 09-07-26 11:41:01, Xiang Mei wrote:
> > For casefolded encrypted directories ext4 stores an 8-byte hash trailer
> > after the name (EXT4_DIRENT_HASHES()), at an offset derived from
> > de->name_len.  On the sb_no_casefold_compat_fallback() path ext4_match(=
)
> > reads that trailer, but ext4_search_dir()'s by-hand pre-check only test=
s
> > de->name + de->name_len <=3D dlimit, which proves the name fits, not th=
e
> > rounded trailer.  A crafted entry whose name ends at the block boundary
> > passes the check while EXT4_DIRENT_HASHES(de) lands past the block end,
> > so ext4_match() reads out of bounds on an ordinary lookup.  KASAN repor=
ts
> > it as a use-after-free when the page after the directory block holds a
> > freed object:
> >
> >   BUG: KASAN: use-after-free in ext4_match (fs/ext4/namei.c:1435)
> >   Read of size 4 at addr ffff888010458000 by task exploit
> >   Call Trace:
> >    ext4_match (fs/ext4/namei.c:1435)
> >    ext4_search_dir (fs/ext4/namei.c:1470)
> >    __ext4_find_entry (fs/ext4/namei.c:1268 fs/ext4/namei.c:1632)
> >    ext4_lookup (fs/ext4/namei.c:1703 fs/ext4/namei.c:1769)
> >    ...
> >    filename_lookup (fs/namei.c:2842)
> >    vfs_statx (fs/stat.c:353)
> >    __do_sys_newfstatat (fs/stat.c:538)
> >    do_syscall_64 (arch/x86/entry/syscall_64.c:94)
> >    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
> >
> > Require, for hash-in-dirent directories, that the whole entry including
> > the rounded trailer fits before calling ext4_match().  This is the same
> > bound ext4_check_dir_entry() already enforces via ext4_dir_rec_len(), s=
o
> > no well-formed entry is rejected.  The other caller, ext4_find_dest_de(=
),
> > runs ext4_check_dir_entry() first and is unaffected.
> >
> > Fixes: 471fbbea7ff7 ("ext4: handle casefolding with encryption")
> > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
>
> Looks good. Feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
>                                                                         H=
onza
>
Thanks for your review!

Xiang
> > ---
> >  fs/ext4/namei.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index cc49ae04a6f6..3b9740c1c16d 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -1467,6 +1467,8 @@ int ext4_search_dir(struct buffer_head *bh, char =
*search_buf, int buf_size,
> >               /* this code is executed quadratically often */
> >               /* do minimal checking `by hand' */
> >               if (de->name + de->name_len <=3D dlimit &&
> > +                 (!ext4_hash_in_dirent(dir) ||
> > +                  (char *)de + ext4_dir_rec_len(de->name_len, dir) <=
=3D dlimit) &&
> >                   ext4_match(dir, fname, de)) {
> >                       /* found a match - just to be sure, do
> >                        * a full check */
> > --
> > 2.43.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
