Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D33239A071
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 12:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777291341; cv=pass; b=DUNTzizzE6X36mMagrRX66Oce3b0QUIZRnjkwS2S3D9UF0+la0L4SR0SlH7BhSM3kjLtOCsuVlPQ7JYAAulx/JIfnRCVJtB9kbOshOU7DxNrhHBXwk2wYmduRz6b1axiBWbdfKh0pz9YBIOwRLsST8yvU1XrFwFWotEdVUyYPLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777291341; c=relaxed/simple;
	bh=f7oNU5FaDQl+Nkbi/6/Ivnlhsv7ogl5Ysmt1I3aNaRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eBCDJEAMBmEEag6ABr4SvCIdWH3oxxxb/lLHiH/UQg9WrDZFr02h8m4uy73EOtkkwN5LyqcZ7Nxwtrmphv7/nEk9rk5g8KHRZ2NWdkH8dcU4cYCU82mq7dUHDjIQIr1/QfE+waLj5250UdilXWR/kxE2rLYSmfN5fcdWC8V1TJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1Qji05Y; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1Qji05Y"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-671c24f23b1so14831414a12.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 05:02:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777291339; cv=none;
        d=google.com; s=arc-20240605;
        b=FSDQ3nZUEaMWBaqW5WFdSkdA2ejVyZbl9cWwY4/iJPLD+g6G1T73OisPzOOQEKDAHb
         sFmfgRsmeDqkThVbD6UzMH+Qy9lI7LnOhbDga2mUU4/EeOksNsevwXfHJ1G5cvCBn5e0
         6hSxwtbFea3k6h4UuGzx0BiKTY1cl1bTCQvxihwglji9Z8AZ/+NeJaCnaBTOomKAbLRY
         LcTljTf22ahWnhohMficuENJ2z3KmQAcYrM0M5yWMagi4ZUQL2OVmwoNMuISVJ2pZPEW
         JcyWtZ77r3IcFCMlAY1fsQUXQD0OSfLohNZ9e26XebiAc7okpoYEB0N6npRCdUUKW4jE
         jGeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bSw1aMO32TuHJYbNOmDfdqPOAHdqlsV6G0A1b+WUvMY=;
        fh=j/6lKImDOdfdBttr+wZqRc+2TkPYgXH6MBoCO4MbsB0=;
        b=gLpR2glIyohf+OlCJVKaT20uzVl0rq879Du+uGkb0fWIQGMhb8eLbqFed62dtxyZM0
         tI7YWCoa1gBSIKIcHlET0WwltbfdZQlcxqmpQ2/FEVEVK5165PvvHHlRlW2NERUbA3wR
         rxLUViXtjVdpuKuNPwaLtbdj4ANcwpZM7sjW5LCIP6uow/PSxWIPZ00hKqpPmhvj68gv
         REdCWNJi46CTImOYimq1vdtQ965PGZaK7qXEApwzyvTiUKoLmxQ/RCMDr29zFs+fRd9H
         yHVjAR8TaSnIci1GoDn1uFdx6FiAkfB1fqxc2a2H+QfpE4eIeDl9pZP4p0f1t37CdaQS
         1Dtw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777291339; x=1777896139; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bSw1aMO32TuHJYbNOmDfdqPOAHdqlsV6G0A1b+WUvMY=;
        b=L1Qji05YBSR2Px1RPMh0Qij8MMdumsVHV5YhEmf2miBD194l4h2f4Z7suJgFn1jtUi
         nzfd7Qh5/RECtOiX7nuAY1uhhuzoTTrXeMLpEZrhbXjht25kKCDiiIthtTp3DVHH5Nqx
         eMrNP697teAtC8Hv70hpPCgecgtZdpvh2VsT5utyY5amkOAKY+Yw0YFGZ/BKhJ1O6/Lw
         qfJ3koSwuyZNC3NIanPJvHA7FAEzxMODU8ZsjqoAInWEwJvYyPQ2vbfnqaO+SOYsAp7/
         a/kbMqdC5MiCHNxJE+BLEO8y0jN6NVDA5IEUYIDJmJJouMA+qdoOSNLNGUIDhH2IoA7V
         DMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777291339; x=1777896139;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSw1aMO32TuHJYbNOmDfdqPOAHdqlsV6G0A1b+WUvMY=;
        b=jS5+WL/sO1IY4p3tn6fkG6lHDaDR2BdvMDT8rc0RucAEgA/gYfcD+R3KIgX1CaxvSQ
         NB9NHnPiyRMoZPrmcOIb+oQQa36fIB1V7b+Kzc/NTjWqgrtEC4XfrbCzGFkLlHa8UXHN
         WhbhwrWtOEpFdRrvudj8U8pW4P3AZWYABlXTkf7uF/6IIahP3WJbKyAOUdUzZ04Nz/vA
         /bj8YHs6GYNy0sQMvXMDqPK5m4B35Z/hZx5XqX7cAv0OnBBNeyXSHre6tCRVdJiotGOD
         /eDXc8H45/Pi33/ZL3f9PMbRkksme/mrTDfZmkAA+JzxtX89qgndExR1KQXWSreWHuGw
         TU1g==
X-Forwarded-Encrypted: i=1; AFNElJ//WnTYK/j0hgulAQsWk9qlfmhpe2QZrK83qdPZQBYa3w6d/jTy9GTWYz9IzCmY642S0syTqKHmHlIc@vger.kernel.org
X-Gm-Message-State: AOJu0YwJx6HnW/9Mjy6K3RbPHsSqmIP2uTroQxFzJeBVVYgSNow+9iYM
	V3deETGfA817ACoRVNskd0gA7lFESPcG2iFyqCQ6EqYGgFFTG3IlW7dKKXy0nMQZ3mBVhK+wvus
	QTRUQUrJ965yM2pjeqRo27DxUqpJ/4mg=
X-Gm-Gg: AeBDiesIEXNzl8sdgVi6jsg2Sy64jZCdJATQ5A0/19cpULyJf18t+3Zut+ii/x3dnGD
	8Pt1pj47r23Ie2hlGq/OtHxd7cqT0Z9nK6E+pkZrqH2x8Pg0922AvislPRWvJKqJWldXIi/dY0J
	AJC1w5778yvnacH+PRMBU3OV3jnhDT3tx5cpZF/um+hkYJP55VI/3xOtOuZzgdGi98yMtrIN+Ta
	f4WZojmrC8ZU6bsdpzx23uy65+TsmYItEY4q1nt5AuMRehnA/Fgx5LdqG5UA08l3gS2I4vxILIQ
	PyWYnWgVdbwdOQyQG827z97cUrcO
X-Received: by 2002:a05:6402:c46:b0:670:d548:da79 with SMTP id
 4fb4d7f45d1cf-672bfd87175mr18491070a12.3.1777291337998; Mon, 27 Apr 2026
 05:02:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260424-case-sensitivity-v11-0-de5619beddaf@oracle.com>
 <20260424-case-sensitivity-v11-12-de5619beddaf@oracle.com> <isfgwmd5hxjfn7dj7p54yzlhumx2hrkt3zw7fscs2ywm57g3hu@co27drpx24lq>
In-Reply-To: <isfgwmd5hxjfn7dj7p54yzlhumx2hrkt3zw7fscs2ywm57g3hu@co27drpx24lq>
From: Lionel Cons <lionelcons1972@gmail.com>
Date: Mon, 27 Apr 2026 14:02:00 +0200
X-Gm-Features: AVHnY4JzeOH_kK3jDOjK2FxeQTqZ9zkWJjZAaa-9jIyvUG0bleb4vaJ230stvGc
Message-ID: <CAPJSo4WmRu_64TxBsaimWOqz3VAU0TZ1H-_hw36HSqzQULm39w@mail.gmail.com>
Subject: Re: [PATCH v11 12/15] isofs: Implement fileattr_get for case sensitivity
To: Jan Kara <jack@suse.cz>
Cc: Chuck Lever <cel@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	hirofumi@mail.parknet.co.jp, linkinjeon@kernel.org, sj1557.seo@samsung.com, 
	yuezhang.mo@sony.com, almaz.alexandrovich@paragon-software.com, 
	slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	trondmy@kernel.org, anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, 
	hansg@kernel.org, senozhatsky@chromium.org, 
	Chuck Lever <chuck.lever@oracle.com>, Roland Mainz <roland.mainz@nrubsig.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Apr 2026 at 12:47, Jan Kara <jack@suse.cz> wrote:
>
> On Fri 24-04-26 21:53:14, Chuck Lever wrote:
> > From: Chuck Lever <chuck.lever@oracle.com>
> >
> > Upper layers such as NFSD need a way to query whether a
> > filesystem handles filenames in a case-sensitive manner so
> > they can provide correct semantics to remote clients. Without
> > this information, NFS exports of ISO 9660 filesystems cannot
> > advertise their filename case behavior.
> >
> > Implement isofs_fileattr_get() to report ISO 9660 case handling
> > behavior via the FS_XFLAG_CASEFOLD flag. The 'check=r' (relaxed)
> > mount option enables case-insensitive lookups, and this setting
> > determines the value reported. By default, Joliet extensions
> > operate in relaxed mode while plain ISO 9660 uses strict
> > (case-sensitive) mode. All ISO 9660 variants are case-preserving,
> > meaning filenames are stored exactly as they appear on the disc.
> >
> > Case handling is a superblock-wide property, so the callback
> > must report the same value for every inode type. Regular files
> > previously had no inode_operations; introduce
> > isofs_file_inode_operations to carry the callback. Symlinks
> > previously shared page_symlink_inode_operations; introduce
> > isofs_symlink_inode_operations, which wires page_get_link
> > alongside the callback, so that fileattr queries on a symlink
> > reach the isofs implementation instead of returning
> > -ENOIOCTLCMD. The flag is set in both fa->fsx_xflags and
> > fa->flags so FS_IOC_FSGETXATTR and FS_IOC_GETFLAGS agree.
> >
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: Roland Mainz <roland.mainz@nrubsig.org>
> > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>
> ...
>
> > @@ -281,6 +293,18 @@ const struct file_operations isofs_dir_operations =
> >  const struct inode_operations isofs_dir_inode_operations =
> >  {
> >       .lookup = isofs_lookup,
> > +     .fileattr_get = isofs_fileattr_get,
> > +};
> > +
> > +const struct inode_operations isofs_file_inode_operations =
> > +{
> > +     .fileattr_get = isofs_fileattr_get,
> > +};
> > +
> > +const struct inode_operations isofs_symlink_inode_operations =
> > +{
> > +     .get_link = page_get_link,
> > +     .fileattr_get = isofs_fileattr_get,
> >  };
>
> Hum, I thought casefolding is a directory attribute. At least I don't see
> a big point in reporting it for regular files or symlinks (and then why not
> report it for device nodes or named pipes?). So why did you decide for this
> change?

Where do you see this being a per-directory attribute in
https://web.archive.org/web/20170404043745/http://www.ymi.com/ymi/sites/default/files/pdf/Rockridge.pdf

Lionel
