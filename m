Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D8A4C9567
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jul 2026 19:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782934540; cv=pass; b=hq3Bj8O3Gyr9B37pz4MlOw+7VOqE9yLsf12oH0sDzbh1qllDR0j/vwmVVYUbMVDyu6/DNp2VadMAAgz6BxMZ+gYrPHtX+voymSNvCrpi7r1/unhVPayJ1jVnC1MuQMq64DSTJcXI0a59vFQSBOKccT8x2Ifbx54K9LOMPXQIQ+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782934540; c=relaxed/simple;
	bh=W6CJBvffePQ1xTgxagHeLlloRE/H6DklNbAaM7XMEes=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PZWXbR5XxpWJJa8wgPDWxxLVOBnkeZ1l1Ho7empknP3p05lRcU5GyAtZdEAwFaoe/gibCjUHg1CejVOSlpcqlnB1CumEtIWXMKe5ZGao6HKwQJFhE94bc1dn3ntGiqTjmDqdBPS5RGFtzlMBWF1qJBeHsPMRsdnXR9Y4f2CWy/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dkWeW4MO; arc=pass smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dkWeW4MO"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-474560436c3so959821f8f.0
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jul 2026 12:35:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782934537; cv=none;
        d=google.com; s=arc-20260327;
        b=Go0/0OhuADQdf7hTgBVz9GvIYp7GRMq3zinUH4nyVRJmmmaCA5QG2J8DUsPr6eisJA
         8SuJEzI82xc6CL64WqMoVXiiwgzdihHA7jXN56z0A1Xwpxvlcv6gpL5WZ1rxCSXhQgbb
         /UH/KOIe7fvjHO2j3XCypNSSHmrmnT9q9JbC1Qv6YdVG0VW6K3SC7cnB/kDbvYvbhbJC
         2qrhpA+b0UKzUVRdwTaqQPqHOp8rtp2CUizS5OTMkol9OXNrkQoIPpEQ00yvGwBp1zFo
         YzG5z/IkwD1CakWrurvqlFy5JULhBjmdrj0srzH1zqYTotE86f6JSkFSLH3AbEvKq2vJ
         d2OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pGGDxr3N3ZHTVGBYFBwUmfiD25X2IVkVBZj7x5VdJpQ=;
        fh=hTJ5KK0rZvYkHzfjgX3big2K2wQfY8HJTytdEh1m8Js=;
        b=mc5XaZpjmTlLx1EFI7kqfEK05Cym8IzmZ1wYXYmpE0rXbgQFkusHI6iG17W8j/lBj/
         4kLuOb8k7fG7ixn+Qedi8jKzWBwQPrI+YIWhCwDxQq1sh4aaLoZtAAzPeDYLGU49a+R2
         fH9srdycxbk2qNDfXQjTziWEyeEMMPRAymrpip25+1CoYgnDegXBTiIFcPj9myJKGJnc
         5mv9Sz1hiydAsdexmPSX6Rt2YsxhtxzrJEFTV2bktzxnQRUOH51bxTNfqTpa5WYBnuAb
         ptlSR5KkjFU1cegOksahqhn+yPb31kVcis2c7DG1mRIl5InvEfqFTqz1OMNPJyIYo+wP
         MPVQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782934537; x=1783539337; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pGGDxr3N3ZHTVGBYFBwUmfiD25X2IVkVBZj7x5VdJpQ=;
        b=dkWeW4MOYHjKBIGKBMixuDTcGthkx7tZXP9qzgxCHl0Bhnw7UPL730ubvrQwSAEbaw
         N1P6VfwhITJJgbnUb9K6TjMyMC5EMPXVByrQJSNCizIMoewbHJQxE9Boi2WHOZ2HoOtU
         8vsQigsZL8uiD07U8I1r8mMD5o2u+HH7JuIGZZ1biooJQwvQKXDMI3eMP+qF2HyZIqtu
         Er8v6T7q1EY5r/kHM9q+VWDlBnCeFjUFZYRTBD5dyqKKXbr/IZpfdMyqA+cSdk1+EvMl
         ZHrcGQWI7znAwTXcwS6VvN9n4vzlYri5UNI0P1Zd3pezzoouXNDwkzrg5x4ha3faPdn4
         hEag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782934537; x=1783539337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pGGDxr3N3ZHTVGBYFBwUmfiD25X2IVkVBZj7x5VdJpQ=;
        b=Km17iQTlYmZ6q6AY3cYGtBHAWUtG33X5n9cpn6YAk9b4wnNrFI2aEzKWCToyZZFDOg
         BoMes6rZXkrJMTdiWJ/ElzO019VZkkKlqVEknFNkf4QN+Wg/mWbNYBeuxoWwc0jTKvnC
         7quldK33qnJbj/cHuu+QEvmUri12NH3wdvaFFQkBPRbcgG1FHal6tci+19bl8zyiXqfX
         wkDUqwD+lm0ii9Aauop+GBz+U1dpN0kGjsxs8YB4S7wNgz4tJ3dgiArSwiiUMwBWzqMk
         plpCf+HgIcl3nvQ4SKiMMzRAPUTow1Ft7stNfi1Wfn9KysJ/N91QhBxcIjS/sYDBHitL
         jAnQ==
X-Forwarded-Encrypted: i=1; AHgh+Roufrelf0hpazCPWUBlkockkLDIlv7KKHP4LeHBQmIOnGnRZBHQz16qlaE78LGkY+NN+GIVtN6H6zOg@vger.kernel.org
X-Gm-Message-State: AOJu0YwqQy6biFWO/bA0eEhhMXBFXJ90jQs6WByYjK4eHajI+7+nb3Pl
	MJ3EnFzr6A9xFKiaswtvx5UYIIgw2eHpwxT80CCPjvd/Da9lDSmIeY7NZPv0Q1TJZxzKKlw5JER
	sfIsH+am1gYk5TcHF7mi/cSYq4sXY8HA=
X-Gm-Gg: AfdE7cmsl9pon0yaj4zGfLBX2TNQQOJq7wWK1BXb+/hUa8Gs0aSVKMWtnUQNuboSoJz
	PlXwOtJyd4Tjt2V8oPGP+sTbxWv/ABv8shRL496qfv98RIG8QBLhpQFM4KQp+UB/vdDuJ3xhBWw
	SrsBULhB4JpV5tggzmTLCBv9kGtirQ1cu+xhtnNYbL3OG/+CuwgYZVoGNAoLxAbRtQeDHqPCIQc
	LlmYCBl3xXi3B6pgNVcEWgZVQlnPZuEPTe76jQKz6InWBNH0W3JKJNdhjpcoymZkdc6bE56C/N/
	YC5zfK8mVAf4j6b/0gC3lZD4rqYE0+T2EIkbSDjuCNRrSfhOqhfq
X-Received: by 2002:a05:6000:4818:b0:474:9991:60d0 with SMTP id
 ffacd0b85a97d-477aeb5bef7mr3461724f8f.12.1782934536936; Wed, 01 Jul 2026
 12:35:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701033253.46420-1-changfengnan@bytedance.com>
 <20260701033253.46420-4-changfengnan@bytedance.com> <akT4tJzFSfrBxqdq@infradead.org>
In-Reply-To: <akT4tJzFSfrBxqdq@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 1 Jul 2026 12:35:24 -0700
X-Gm-Features: AVVi8CeXAJXVfUIyr35lv5pL20q_ALlPEdtXwqos7WTDEDHtloeaTCi_lAygHvs
Message-ID: <CAJnrk1Y3yPeXBeBNo+DjTt8eRN-mc2F9apBCUn+j=GV7GMzi4g@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] iomap: add simple dio path for small direct I/O
To: Christoph Hellwig <hch@infradead.org>
Cc: Fengnan Chang <changfengnan@bytedance.com>, brauner@kernel.org, djwong@kernel.org, 
	ojaswin@linux.ibm.com, dgc@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lidiangang@bytedance.com, 
	pankaj.raghav@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 1, 2026 at 4:23=E2=80=AFAM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> Looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> We'll need to sort out the interaction with the iomap_next work, though.
>
> Joanne, is it ok to get this in first and have Fengnan help your with
> the interactions due to the open coded iomap_begin/end calls?
>

That sounds good, I'll rebase the next version onto these changes.

I think it ends up being pretty simple to get it integrated since
->iomap_next already contains the logic to only begin the mapping at
the start and only finish the mapping when the iter has been fully
consumed, eg

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 3ef5e9adca87..e654ec135d54 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -1035,7 +1035,7 @@ iomap_dio_simple_supported(struct kiocb *iocb,
struct iov_iter *iter,
  */
 static ssize_t
 iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
-                const struct iomap_ops *ops, void *private,
+                iomap_next_fn iomap_next, void *private,
                 unsigned int dio_flags)
 {
        struct inode *inode =3D file_inode(iocb->ki_filp);
@@ -1062,11 +1062,11 @@ iomap_dio_simple(struct kiocb *iocb, struct
iov_iter *iter,

        inode_dio_begin(inode);

-       ret =3D ops->iomap_begin(inode, iomi.pos, count, iomi.flags,
-                              &iomi.iomap, &iomi.srcmap);
-       if (ret) {
+       ret =3D iomap_iter(&iomi, iomap_next);
+       if (ret <=3D 0) {
                inode_dio_end(inode);
-               return ret;
+               /* ret of 0 means no mapping, which should never happen */
+               return ret ? ret : -EFAULT;
        }

        if (iomi.iomap.type !=3D IOMAP_MAPPED ||
@@ -1125,14 +1125,17 @@ iomap_dio_simple(struct kiocb *iocb, struct
iov_iter *iter,
                WRITE_ONCE(iocb->private, bio);
        }

-       if (ops->iomap_end)
-               ops->iomap_end(inode, iomi.pos, count, count, iomi.flags,
-                              &iomi.iomap);
+       iomap_iter_advance(&iomi, count);
+       /*
+        * ends the mapping if the mapping needs to be ended. no new mappin=
gs
+        * are fetched since the entire range of the iter has been consumed
+        */
+       iomap_iter(&iomi, iomap_next);

        if (!wait_for_completion) {
                bio->bi_end_io =3D iomap_dio_simple_end_io;
                submit_bio(bio);
-               trace_iomap_dio_rw_queued(inode, iomi.pos, count);
+               trace_iomap_dio_rw_queued(inode, iocb->ki_pos, count);
                return -EIOCBQUEUED;
        }

@@ -1144,9 +1147,12 @@ iomap_dio_simple(struct kiocb *iocb, struct
iov_iter *iter,
 out_bio_put:
        bio_put(bio);
 out_iomap_end:
-       if (ops->iomap_end)
-               ops->iomap_end(inode, iomi.pos, count, 0, iomi.flags,
-                              &iomi.iomap);
+       /*
+        * on failure, iter was never advanced. ->iomap_next() will know th=
at 0
+        * bytes have been processed and the mapping will be ended with no =
next
+        * mapping fetched
+        */
+       iomap_iter(&iomi, iomap_next);
        inode_dio_end(inode);
        return ret;
 }

Thanks,
Joanne
