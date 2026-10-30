Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793389710;
	b=B70w1CikyMWxBqj3W0HYQboV14dxBG0mvF6+fZHGkzx1gC8+DeThAExw+fDkR49+toX0
	 LmlRrMlm/0iviWHxO0riE5NgeVOs9KFCP+/HIV/xKj75UO1fwRUFR2+q6x38T3Klue84k
	 IXjGvPg7CulqVtSTA7wezu/FuwDEb7GAbXWurtsF7FKUEuexky6pLPcAViDbxEiC+wJj/
	 BAU/HChvF3dfzwNjpVO4yHbZCwTEQkVAUtRFRAptIXUz9L5hK++PfY2iaCajuifDMPpmL
	 slECJ9kSYHoVa2T7hPupPhtEksFHETgOpS70ZcqH5hKOAwHMikeriswtnFI6E5559Aw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793389710;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=B3QeQKv83CCubBRhLwLfDBWq4r5yqUeetrN4Gz6lflQ=;
	b=1V3RHZnKxFIvw6rZLUNabOhwN0mlxR5elbYX185B4IKAcproPkXbwFBVfGLa7JZzfzfh
	 C3iesZar07FTf4yfRXpbPe6qnMs4+edP3D6khEzsqpbqmitXmysunVdijhRIUzLayXIWY
	 YZcaQ7sMzyDKtXtQGPA21FKUiQsK9a0OAhPVTpZWXpX+QgJeap1E6NLaX1Ma6MNLHZI0/
	 xk20GZ1GSMCnibJICyJB3WKUfYHPhWN9aRGrU+7Eo83c5yhLDdtB0Z7TkeEgLAyDzBuJf
	 5vLrErRtbAViPI0+0cGANoxboONFnEeLU+2vHoygzeX8HGTubsPllHXLRo+/7db3axw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="wyv/v7L8";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01A4606A31D
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 19:48:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D01A4606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wyv/v7L8
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48afcd7ba9bso786822f8f.3
        for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 12:48:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793389708; cv=none;
        d=google.com; s=arc-20260327;
        b=XS7/B9j/x/LPoS/JkQOe0nW4MdXBD4Z1XjbHCELVXwe5Bj/oIPyOvX0HfHhrdCcH6R
         dhbOVo3PQtWchdmDYFnaK3zZv7S4s8yxAPMl0WBd9zIXIBFFiw0EtfeDqQE7hE8JWioX
         RI2a0VgnUIRqjdcvNLdjwWEpVe1/PbcTddth5WJ8p30+q8d05mVF4GlMsPNwGwt2d2CD
         KMyYxwpls6cGp3C/hngcfInldd3DIVTgi5hBWMSRbIO9V5tIbKT5C9JpkCo1vqwbPUaY
         UEMqTYsm9BtIaJsbG5tkwC274jWbdfpRf3aLmaAK1rdUsa5dhtCnF99MDPc6X0Q77Bmw
         4VIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B3QeQKv83CCubBRhLwLfDBWq4r5yqUeetrN4Gz6lflQ=;
        fh=kMPcOCmros43hPYQn60ALmgvQp/r9MZAfBBP8529x7c=;
        b=r/NPVRmZEgyufLgse1ifgInbXgFdz+HrNHS/e/5E5ElWEtus3L2dPoi8RSJ7SDnwG7
         7AU+xlla3Fq4S5tW1RPHV1Xf7cB2T0stjIKYCm6nUPQK5b+PHr9gXHh5EhHklM6tHXG5
         jCumdSsOvZZgPSt49KiXTww+HB+fLAIVHKs/XLFtS5Y+9oOIrfvXvI5nuGyvw7GLlbUI
         SJvFeAkSEsyPBAQ/QdcQu8FMuVnFj4f/ufsAamX227qRu5I5pISsaYf8oSuBw+zprbsR
         VZXEJ2OAOEp6Epeoj2zHA6WnUaHneXeE/32cY1YLQcNOBZ1Ddo5MAWQ94kmX5lrHi/e6
         77WA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793389708; x=1793994508; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B3QeQKv83CCubBRhLwLfDBWq4r5yqUeetrN4Gz6lflQ=;
        b=wyv/v7L8ZjnHsyc20OjjJOPmD/d8wZkqutlwDLWfoawPlVGaLkb+9+1Q4rDqm0kyyr
         lbSR15f762gdfiaSH5Q7eEU9n6kF6PrrymY/LNTU9ZS2K3cEw4P7hxyB3qy3qk2K3HX2
         9EACw1yTy6dG+Th59oeBPohq82am5cg3DuP5ilBO2nTZwcaEXu/Qokyz/TBYdnp8BIec
         9WJho9V8nkW9owQOoX+dF9K+f+xSf4u195/2QTDbn5vRjTcZjNCpDHIMZM1Dd5YXUJWX
         VvuQq7SrYbYvRUp5v66RyLaybHGnVGnuRLAkTqvqY0/1OiP7Wkf58D4Sf0ROqP8yLS2I
         GfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793389708; x=1793994508;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B3QeQKv83CCubBRhLwLfDBWq4r5yqUeetrN4Gz6lflQ=;
        b=EzblYT47zH9eu+kzEfmvS6DTcKPn578WhnSQRktPnUX0HWTnv3XxocW+vRR+1ju3vG
         vjF2v961KJP1wzqqEufc0eXdSTWoqTAr5rIwBYZ6V5E9SwDn5z3t6cHL24T7krK/fY+6
         uWDg2YUZZnND2m3NgK9bUIW4JSbBhsz4RTZDNidlaK+1o3ZF2JNkI0O2i1fu71lkOfYo
         N/tY2rqLpMhSpLJWIK+6Fihzby7zJ2lliv0k4fAZX/qWifesdguBYDMI4Yd+LGCim9lD
         uIYnmTqqtbWrppjN/FXPI7EI0igE6Xjl1tWntbqxQ1cnccWg3OhJHIpZarKb6XRav6is
         HQTg==
X-Forwarded-Encrypted: i=1; AKwUvByFbsmfPfATqv+Z2ow/KuT2cEH7KsvXYgcF/DUj+LcQeig67Q7kWeoG7Mmk1plmCJ0HuZXzT861UlXQ@vger.kernel.org
X-Gm-Message-State: AFq9FYJVTP6xwM8OCRYQ2qVvZR6dyJSxjm77UWPGCZdlFaWQijtURw88
	pNrGKKajizf9+qpQCFJdk76uQL6MBAl/ZnGbMsxrcBU+02ZMYyUIKrBqg9n7FBEM/F2avXcihob
	FJvjHkVWbNsTrjCDtnDh0GKt1bcYMn1M=
X-Gm-Gg: AYBFou04ToZpGxIsYWzLFWjS4mn6zPuLkvYDLZDmA9kuBKJtCzkcIBPS3gYVM8teCfJ
	L1aPVBOpoaiR9pHw91rqt+NEM0RlzSwEUtKqJl1LMlwe/zh7bfT4SfboPkguNfdURs/KcwynV39
	vmRu++XNbM8SabcaJySN/cTKks/kgH6vS+tGFHfaAaNX78LsQcr2GwDs+0ktxNMvN4YQ4yPFLzS
	zFuiuEH+DTJjuU5yv+H5wei/+fi0CZ/n1D4s505HvNwQ2RUlQGCZNhyun9CYKnIrL32d5UVqeZv
	rBDZYzVJttBENmb3iA5UnfvOsHJSfzAu3wLjOis4ZY1iQyvrvkbHKAQT76vJN7ZHJuEXVFvUbJ7
	8cX/Y1vjwDACMyskzvGwxxEzcbk2lIwToEj4YUEIreJvesss7kLBbifejZNZ4GAYToj7FR/Gpdp
	bwJaXBzhcww+mwAaPNng==
X-Received: by 2002:a05:6000:40ca:b0:48c:5304:5e50 with SMTP id
 ffacd0b85a97d-48e6e2620d8mr8708785f8f.0.1793389707952; Fri, 30 Oct 2026
 12:48:27 -0700 (PDT)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
In-Reply-To: <20261027215326.2693300-1-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 30 Oct 2026 12:48:15 -0700
X-Gm-Features: AclHuK9oCK5VP76Wbek63tch4M8ewVUH28c6PHPAdmsJkgtv-kMhmrFiNwyHte4
Message-ID: <CAJnrk1bqPCy8ryVjCsUWR2+4jkNE8rJJU2bUFsO3Q7nznsF7xA@mail.gmail.com>
Subject: Re: [PATCH 0/5] iomap: remaining patches for iomap_iter_next conversion
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	"Darrick J . Wong" <djwong@kernel.org>, changfengnan@bytedance.com, kbusch@kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com, bfoster@redhat.com, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	linux-nilfs@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Zhang Yi <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 2:58=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> These patches are being sent out now in case anyone wants to look at the
> preparatory patches or patch 4. This series applies cleanly to both curre=
nt
> mainline and next-20261027. If anything conflicts by the time you pick it=
 up
> at the end of the merge window, I'll rebase and resend.
>

I pulled in Linus's latest tree (commit abf8c33470f7) and the series
still applies cleanly with no conflicts. It also applies cleanly on
top of next-20261030, which includes the remaining btrfs, ntfs, exfat,
ext2, and gfs2 changes that haven't been merged yet. There shouldn't
be any conflicts between this series and anything else going in this
window.

Thanks,
Joanne
