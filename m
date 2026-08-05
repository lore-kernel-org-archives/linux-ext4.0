Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E081A3029
	for <linux-ext4@vger.kernel.org>; Wed,  5 Aug 2026 20:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785961852; cv=pass; b=Njf/e2JcWl2qxT1yBZydQJDHDRSG2WexzW7sMqcX07f7qN4xkeqRZwtoctX4MS6i/K9CVTLoMCDFdzFrHl/AVRX6a+bhBn8h/8NozyduWmQPzKWrU/PomF3oDK7Z4ggiD2QU+aW6nq7nxTWLL/sefBC7E4crY/xIpVK3+1kuM7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785961852; c=relaxed/simple;
	bh=f8z1M1nzjLf68Sy9PkkSF+yweuJVjVDeAp0nHMvwWIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=avhMFiHERfhRae4+J7FBPC8J3OCLXswJx0DEAp/dmkZDLaGlJM7DXvScets63rle97gkDjR0a3OIfyiGLmr6p0ziHXGM/nfwhOphTOkz77rl1LhEePzQe36TgoUxuCvi8izLM3Rmvt/D4JjJBBndti8nK4cMVTHG/8ALLvldWdg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DbFdajYc; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DbFdajYc"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a144c8eea2so1835266a12.0
        for <linux-ext4@vger.kernel.org>; Wed, 05 Aug 2026 13:30:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785961849; cv=none;
        d=google.com; s=arc-20260327;
        b=eI2qJZhIymnWYp4Td2qRTLAqfNfJo18O3FaCRt+hMGJI+ezurkpp8P978iB44XVdQy
         lOOqbuQnRk5xJ9wF3bDau7iVR/qU33XizME8yiquiMixvDFti/X1FcIhYnrXdGl3w/b/
         vMomIVhxi+6/q48FvvGonl5/ee52+q9o6MBV5nS90QF3S+4dz62u9R9a5vfACbDXOy9A
         2YxLnykMgHBjvK8FQlZ1QuvGprXck2JQJ7j3Y3q2jkA6qcL2ToCBERnN7pwLBL0vnvmV
         3Dv0oGbVOon106DSgxXsyTyJMYY5AM0h663H9S4QiBLV0Thgn9NIQfeFsuNm5E31hXIz
         34Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ukL6w1a2HyKi8WGdg/EkyTugmN726KV6XvHTOGb21IA=;
        fh=Rt2YLd4C0nhV8o3wGaB8A2EUx0Tk1/UNBPlfsHx9yoc=;
        b=oa+mudRqed7VNA0HSlGe86CJSzPXcP96jdKxlcEEVInEkcRnlwEcHoAXDBKWv0Bi+w
         fPrPs29VJeuhIkOBsQQ1B4PGeD12cO/NR3dwK6LSepZPTEr3kufiPy9SMdU5+gBHpZhD
         3Tch0e2drRW3dVXDOSRQjUhFAZg7taJYfl46s7BQ6hFLQrY/YCt3f+7dNWRcwyL902sq
         CKfVgsYQiwUbv1u7nSg9s6E6CI328mz15nFyMnlgBsCvR7aPilVWmwtO0fcWzpWVhiKA
         dzD+UxpqStS2l2jW6IciTTUCdzvruvMymKJRpYM539A0mtlgJRL8ZroBWpS/PaVhDXPl
         AV8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785961849; x=1786566649; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ukL6w1a2HyKi8WGdg/EkyTugmN726KV6XvHTOGb21IA=;
        b=DbFdajYcz9us0AKHrN/i3PXNMS52lP/VVs1GkyxWRzl3fNVVcVB63Q6G42Thym6W44
         MGXtsCAVL8gJzN9rI5dHwpGkgOjrlBv+MQEvl19+yX4T9Tx4ob5afIluqyEjSeLxnNW1
         k0EVn9bEFp9WR+IWc6vsSvoHv3xPgiRNkK3nnn6Py0xcYw+mCuOktbrBXh4PV4xVu4uO
         MoZUEFvkzezFLwNvQmee7lleEQdzNuBxvnZcxGYWJw3Tsln1IAuz+v1DDh5+ATPx4Q3W
         5wVwcOjiAMBCAAuWUmFP7UQzUOt+JflTZZGuizjBPDbAClYFgE9zgHgtL8sLm8Vl79m2
         4xZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785961849; x=1786566649;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ukL6w1a2HyKi8WGdg/EkyTugmN726KV6XvHTOGb21IA=;
        b=kgd3sIrwsCghZR26YbfN3WaNPTFOaVVt+oGCL86XlAFhQo+gYuA1Fs9aQJXF7sXE/F
         dKfcpycv6tuTuZtawppNLh4i2KsX9SBxj4b2bBD/KkOllYNWbmCWFyXY9of+jQYEvPMo
         Z791wj9/Bx2+rTtZJVj+CpmPSCrBS5uglA26W/hUUh0/donfJKfMTrn5JUvImRYBcTd5
         P00DSodR+uKmtti7j4akewzoEdFbccO5oJIHIfsjbyl4XkRNl3qPSVVRp0Cx0B+2DH3/
         9iSjPQxAMngmV6tue8Xt1czBgbZ4uQeuQPs9zu2/x2YJHxxxukg8nP6lRmNQVwttY0VQ
         P+ig==
X-Forwarded-Encrypted: i=1; AHgh+RqTIb/MJf87CLZ+oVUANJa0Wl+a0TC28Tbdhnq56zjCYJTyOdVRCe1MMdKwVpXrbmSklYFooINnSPHO@vger.kernel.org
X-Gm-Message-State: AOJu0YwHyeAeGjx5GJF7AbRpfwZNzkKbNWubw4KGCJOQymZ3UCGT1Yki
	lfHG2nZkD1qOc4MHTSZEVQ3ihxhHc5Y+ICmk7K0lEZQnaM+alzWjcbNabvNJGSSYuHWGsXNpubE
	I6KtEIi4Zu/8rBjY9otvglMb+fPUZdF4=
X-Gm-Gg: AR+sD12dKJpieFPO9iF24lLVfpxFSBYjZztAvt2TJ8Y9WfJK6xZCGNAPZS9bN4egxCZ
	78RvFUfIJ9GCRjm62V/EYPxbHfm/mhErthrcQ2742n5s8JmhdkMXEJLNrDjXHYqVCyeogmFh+5r
	+f0735rUfflfD/falH0lLC9VMFWTdaYyXzXAefgXLxnaqVt92dKbCxSK8nwGSC2SEeYfZxtW5Y1
	ZKoNT00s5bQvj1yCdia+xnnMffGjp8bow+rq61HyV4ZQ/8tNYWuxfu75hCbMc8UeFU9c47gtitf
	2YTK9MNXvQM2HOUR/wzXmpWWxAJFsgTsftGYNa52uDVT
X-Received: by 2002:a05:6402:50ca:b0:698:3469:fa99 with SMTP id
 4fb4d7f45d1cf-6a14effe17bmr5079698a12.0.1785961849170; Wed, 05 Aug 2026
 13:30:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <bd2c982e7c91fcfdb8a326ae8166853351398aa2.1785621505.git.coshi036@gmail.com>
 <zr3we2xntqhn7ieev2khdkqvoi44vrkyd5hhgxjol2bggcllhr@g4wpvgfolwni>
In-Reply-To: <zr3we2xntqhn7ieev2khdkqvoi44vrkyd5hhgxjol2bggcllhr@g4wpvgfolwni>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 16:30:38 -0400
X-Gm-Features: AUfX_mw_SS8RGdpRx5YbwF50WJ1pFJNPD4n9XzsvkEDLkwiQIoG_VK4piD_G0XA
Message-ID: <CACd_6n0ZrHf+oGmZbvvAnMZHRDKhsV0DjHiLBPFGsuO0=Nd4Jg@mail.gmail.com>
Subject: Re: [PATCH 13/19] ocfs2: check for a metadata write error with buffer_write_io_error()
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, linux-ext4@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Agreed, and thanks for the tag.

ocfs2-devel and the ocfs2 maintainers are on Cc for v2, and the cover lette=
r
calls this out by name so it does not get lost in a 21 patch series.

To be concrete about what they are being asked to look at.
ocfs2_write_block() has never removed a block from the cluster uptodate
cache when its write failed, and the comment it carries today says why: the
buffer is not marked locally up-to-date, so the stale cache entry can do no
harm.  That reasoning stops holding at patch 20.  ocfs2_read_blocks()
decides whether to go to disk on the cluster cache alone, so it skips the
read either way; today it then fails the !buffer_uptodate(bh) test and
returns -EIO, but once the buffer stays up to date that read succeeds and
hands back the in-memory copy - the right data, but data that never reached
the disk, and another node reading the same block will not see it.

I do not have a cluster set up to test this on at the moment, so I would
rather ask than assume.  If it turns out to be a problem for ocfs2, I am
happy to fix it in the next version.

Best,
Chao

On Tue, Aug 4, 2026 at 4:49=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 01-08-26 18:00:57, Chao Shi wrote:
> > ocfs2_write_block() and ocfs2_write_super_or_backup() detect a failed w=
rite
> > by looking at BH_Uptodate afterwards.  That relies on the write complet=
ion
> > handler clearing BH_Uptodate on error, which this series removes: a buf=
fer
> > whose write failed still holds the data the filesystem asked to be writ=
ten,
> > so declaring it not up to date is wrong and makes callers re-read it.
> >
> > Test BH_Write_EIO instead.  Note that ocfs2_write_block()'s test is the
> > positive one, so the sense has to be inverted rather than the flag simp=
ly
> > swapped.
> >
> > The comment in ocfs2_write_block()'s error arm needs updating for the s=
ame
> > reason.  It said the clustered uptodate information did not have to be
> > removed because the buffer was not marked locally uptodate; after this
> > series it is, so the reason no longer holds.  Not advertising the block=
 to
> > the cluster is still the right thing to do - the data is in memory but =
not
> > on disk - so only the justification changes, not the behaviour.
> >
> > No behaviour change today - a failed write sets BH_Write_EIO and clears
> > BH_Uptodate together.  It stops being a no-op at the end of the series,
> > where the new test is the one that still works.
> >
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
>
> This looks ok to me so feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
> but it would be good to get a feedback from ocfs2 maintainers whether the
> logic change in ocfs2_write_block() where we now keep the cluster cache
> block uptodate after write IO error doesn't break some expectations of
> ocfs2.
>
>                                                                 Honza
>
> > ---
> >  fs/ocfs2/buffer_head_io.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> > index 7bfe377af2df..733ceda79ca1 100644
> > --- a/fs/ocfs2/buffer_head_io.c
> > +++ b/fs/ocfs2/buffer_head_io.c
> > @@ -66,12 +66,14 @@ int ocfs2_write_block(struct ocfs2_super *osb, stru=
ct buffer_head *bh,
> >
> >       wait_on_buffer(bh);
> >
> > -     if (buffer_uptodate(bh)) {
> > +     if (!buffer_write_io_error(bh)) {
> >               ocfs2_set_buffer_uptodate(ci, bh);
> >       } else {
> > -             /* We don't need to remove the clustered uptodate
> > -              * information for this bh as it's not marked locally
> > -              * uptodate. */
> > +             /*
> > +              * The buffer still holds what we tried to write, but it =
did
> > +              * not reach the disk, so don't advertise it to the clust=
er
> > +              * as up to date.
> > +              */
> >               ret =3D -EIO;
> >               mlog_errno(ret);
> >       }
> > @@ -446,7 +448,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super =
*osb,
> >
> >       wait_on_buffer(bh);
> >
> > -     if (!buffer_uptodate(bh)) {
> > +     if (buffer_write_io_error(bh)) {
> >               ret =3D -EIO;
> >               mlog_errno(ret);
> >       }
> > --
> > 2.43.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
