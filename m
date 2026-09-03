Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACFD3B0AD8
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 19:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788462104; cv=pass; b=rFLfCVnJvemZE7w/TPvSsjWS5EkyIrYqHwyFZO3jFQTd5bsi1I3nAg75n9Gsd3+2l5wtNaOY9ZLfhuSdjvWQk59Y8mAyJGU7hhb2v3oNeujvAsZQV0ETmLwsM0rzHzTWTdSkepCMZ/6s+Z2nqNJ0xNHyIaEf26kWnYuvxLczR40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788462104; c=relaxed/simple;
	bh=nO7P5MOWf5n75hGIclRBq3mBx37PZnx6Ncqnx419+RY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nx7eRA2+N0E5T00JPkV17WuYtBcHbfz6nNL6iALub1Mz8TgU/11wuUHBLsHDOMfoObUEcf/tilqPj9Atx/vRGgYC/BefNhh4DIbcN+aLgn3DA7M9WkZnbwV5o+iL4JNAIMDaUlIvYWOGflw371fM9O7G4YoZvUisyB+4J98Ygew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hy3qmigA; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hy3qmigA"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4843e397f74so232426f8f.1
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 12:01:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788462095; cv=none;
        d=google.com; s=arc-20260327;
        b=eKHkbumZ/rm/vuj61VVGd2SrK8dAnyakjF0H8/PbOs32Ka3hkSCWtuw48i8z/le2kS
         L0aU0Yup7th5lSNSHenkfew5+fNbFwfYVDftvtvM4c973eFh3Dp8cBYyO6nkcy2QoDrg
         kMzoce0lJSFxMUuYn+lFg5APFHfDfk9CbRFSEpPsAGd69IKF2A/n8omGQxdF774MRoT6
         XS5eNroCntYMm6TzUFWVZ1sv7IGK7j2/JU2BdKkXMkEy84/1IRGIO5wJQ4jy8OTvyszs
         802heuHdj0CNuf/R6c7Oez+JY9XwvTgsyecA4Q3jdmHCwHIHD5+q8kNmhHf2VSymzkso
         VUeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4k6051qYGqcOE0IbvTlu78LucmjSeHvrRypj52NEgg0=;
        fh=oaUK8eCwKYLO8MFyAtPzulw9IIVVZLVHd3lTi47W6ug=;
        b=JPHxADm9D8SZeX3I/wLEOc+6HPvIhn6lg+Lxt/emmnXP+Q/uuqwiNsu+aDNExIT2Qo
         XtlUwjoccv2jJQV+gkURNCWkOVGgTHLyIixHCETvsHDB9LAqmBtGu6X7DN5DDp6KQvBn
         npfXx5ofq1hnODvlM4TEMf4UmqR30SHAm8XVsR7M4YxDOTIAxSS+hw0yRpX1QHjd6Ws3
         OCjS5/I7NAdlNbxt8mv3IAqUCIoRhc9Ad3Fy22QCvMrzpKmFm3HvMC0Ss61vsQLyAEhA
         C2LD+O3oDz3YPQAOFd6x6MCt7/QoEo0xsqXhd5WbaDxxsV6hMicuUtITl4B0MurYhRcf
         8GpA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788462095; x=1789066895; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4k6051qYGqcOE0IbvTlu78LucmjSeHvrRypj52NEgg0=;
        b=Hy3qmigAP91kBmiZ/NcBxXvBu7TS3L4LREM6KRRtk6Snv9xEbXxpfSuEFEexsr8Jle
         afvGYmxuSE9zWLO36hBTtOHj96fB9f8Nz5dBWxm1LScuIiHm22IJmhsTilYuVM1KXaqg
         xMg2S4c1UlvEpF7B2MvUplvmVE5ma7ovkcmX61jNW+23pZWPYAGgJ0TX4VWYoGNl5BqX
         nSzAPApuErPNTAza8ZQdRkRmaXq/SZqcSaKbjF/8oF5Q1DbdPi6DjdqMjBKaVe7t5IO5
         Ld5VHCx8zFskyH36vkz1qMDoYK2zMXX1WLsQMD/nvgVJh05Qxd5bpkBjDNY/jHhQmNms
         uWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788462095; x=1789066895;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4k6051qYGqcOE0IbvTlu78LucmjSeHvrRypj52NEgg0=;
        b=WtS85iuusV++fJA0oV7M4Ggn/e7+iAA8La1dVvC7lkYH+tLJOreOj/6ohwsLO5LaPq
         LcMYibBJ0c9e2jN0nKqeelnQpN6xaWnzTEyhmx5xkRXE0FoQwVfV2Lg8oWC2xEGmL+Pk
         t+ZexgsfeeyprYWmM4+TkQDbxKnlRPfl7E68nUczOvyvpFDt41++k3LdBNzaywmH0goO
         nKOLgmdZ4Z9I/fK/2NpRltwQcHB2ORweq7z5pNaI4DUFLg8MBMNhoZV8m3Q+M83QyrZu
         z6BdImX3+7H29jEcNlk24RGG+6CD6GFjHjQiMhEal3byk4qUF6rBXg8z2iseywsRWs5q
         SD8w==
X-Forwarded-Encrypted: i=1; AKwUvBwDMewRF0J6OGxl0lmOzZvSxYJNrrdlPUzT34quNqwOLef6rK+7ZxLgSpKfKw9ul0vJWyA+umduJuX9@vger.kernel.org
X-Gm-Message-State: AFuF++nsLGpfjUZ19cO67IgvTkpOz6qEyS7IKRBInshgErYEl68nWAij
	6fImJ5xG551Gq8lMMuFbtBUTK70FmgcnbhjL1lK4x8NpQK2PiucvS6M1TRo5nqyfZ0lTce0m+2S
	p4I83wUg48Sev270Hjk4HA/ptrsalzeG+V7NMXHE=
X-Gm-Gg: AYBFou0AuoproUTeIIfgOSTnMivIOzbFkabRqegjAt7lrzw14srGl0GXHMa4Ba3Vt/l
	DUSxRcK7l7xJycloYtv4T7CPDFX7EY6y9xHMI//O5vY/TCOJ0w2lw0yuAQIvubBojZBQNBrfrKl
	eYbPqyQI+MRVENV41KGAPIqO/UwooKcckl2blU3IdPcedrutd2jJIj89xDagyrmFHSenFKkn5ll
	HgBcBgP6m2E6YNMhc15ohrCHM/M068g7s+YG37ibfPqZpdNsE8uVdF7SSWmpIAHZr18mv6cQYVl
	ytY46fymdRhfgvs/L0lEXKnCCQAbsgZ9MrEda0M/EoWO8ln87pqV2licvs7SMc6Y0ztR3bVqjay
	sdJ5vG2QbOa9/R75zDE/YuB2uVW8=
X-Received: by 2002:a5d:64c4:0:b0:485:7d6d:e0e0 with SMTP id
 ffacd0b85a97d-48582315f07mr6561895f8f.3.1788462094628; Thu, 03 Sep 2026
 12:01:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
In-Reply-To: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 3 Sep 2026 12:01:22 -0700
X-Gm-Features: AcwNN1Xq1z0FxsQ9zPWn4QO4ZTMRixlUUwLEJLuKQWt5XQuIf6s3hWHxYB2ovjw
Message-ID: <CAJnrk1ZLzNQxrSLQx7TsLK89QC_=9cDfoDcyKNBNde0CiDGoNg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in truncate_inode_partial_folio()
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com, 
	willy@infradead.org, jack@suse.cz, ziy@nvidia.com, bfoster@redhat.com, 
	djwong@kernel.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, 
	yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 5:01=E2=80=AFAM Zhang Yi <yi.zhang@huaweicloud.com> =
wrote:
>
> From: Zhang Yi <yi.zhang@huawei.com>
>
> truncate_inode_partial_folio() splits a large folio so that the caller's
> truncate loop can drop the in-range sub-folios while keeping the
> out-of-range tail. The first split at the punch start edge is
> non-uniform, which leaves the sub-folio at the truncation end edge as
> large as possible, this means it may still straddle the range, holding
> both zeroed in-range and valid out-of-range data. The function then
> attempts a second split at offset + length to isolate that tail.
>
> If the second split fails the straddling sub-folio stays merged. The
> function returned true unconditionally on all exit paths of the success
> block, telling the caller it was fully handled. The caller kept its
> default end and the truncate loop truncated every sub-folio below it,
> including the merged straddler, discarding the valid out-of-range tail.
>
> For example, a 4-page order-2 folio punched from offset 0 to the middle
> of the last page:
>
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()      # same_folio =3D=3D true
>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>       folio2 =3D p2-3 # straddles: p2 zeroed, p3 tail valid
>       2nd split of folio2 fails / cannot lock
>       return true                       # BUG: caller keeps default end
>     end =3D 3
>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
>
> This became reachable after commit 7460b470a131 ("mm/truncate: use
> folio_split() in truncate operation") replaced the atomic split_folio()
> with folio_split(), whose non-uniform split can partially split a folio
> and leave the end edge merged.
>
> It has gone unnoticed because a dirty large folio normally carries the
> filesystem's private data, for example buffer_head, so
> filemap_release_folio() -> iomap_release_folio() returns false on a
> dirty folio and folio_split() aborts with -EBUSY before any split,
> leaving the straddler safely unsplit. The bug is only reachable on paths
> that produce dirty large folios without filesystem private data, and it
> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
> attached.
>
> Rework the contract so the caller is told where to stop instead of
> silently truncating the straddler:
>
>   - Return true only when a split occurred, false otherwise. This
>     clarifies the existing confusing return value semantics.
>
>   - Add an optional out-parameter pgoff_t *end, set to the index of the
>     folio that contains @lend and must be kept by the caller's loop. It
>     is only written when the folio actually straddles @lend. On the
>     success path it defaults to the page index of the end edge and is
>     refined to folio2->index when the second split fails to isolate the
>     tail.
>
>   - Rename the byte-range parameters start/end to lstart/lend to avoid
>     clashing with the new @end output and to separate byte offsets from
>     folio indices.
>
> Callers in truncate_inode_pages_range() and shmem_undo_range() pass &end
> only when the folio straddles lend. After all, no caller discards a
> straddling folio anymore, the in-range cleanly-split sub-folios below it
> are still dropped.
>
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operatio=
n")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  mm/internal.h |  4 ++--
>  mm/shmem.c    | 12 +++++------
>  mm/truncate.c | 57 ++++++++++++++++++++++++++++++---------------------
>  3 files changed, 41 insertions(+), 32 deletions(-)
>
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..2ebb00f6c379 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -206,15 +206,18 @@ static int folio_split_or_unmap(struct folio *folio=
, struct page *split_at,
>  /*
>   * Handle partial folios.  The folio may be entirely within the
>   * range if a split has raced with us.  If not, we zero the part of the
> - * folio that's within the [start, end] range, and then split the folio =
if
> + * folio that's within the [lstart, lend] range, and then split the foli=
o if
>   * it's large.  split_page_range() will discard pages which now lie beyo=
nd
>   * i_size, and we rely on the caller to discard pages which lie within a
>   * newly created hole.
>   *
> - * Returns false if splitting failed so the caller can avoid
> - * discarding the entire folio which is stubbornly unsplit.
> + * When @end non-NULL, set to the index of the folio that contains @lend
> + * and must be kept by the caller's truncate loop.  Return %true if the
> + * folio was split, %false otherwise, in which case the folio is dropped=
 or
> + * may still straddle the range, so the caller must not discard it.
>   */
> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start, lof=
f_t end)
> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
> +                                 loff_t lend, pgoff_t *end)
>  {
>         loff_t pos =3D folio_pos(folio);
>         size_t size =3D folio_size(folio);
> @@ -222,19 +225,22 @@ bool truncate_inode_partial_folio(struct folio *fol=
io, loff_t start, loff_t end)
>         struct page *split_at, *split_at2;
>         unsigned int min_order;
>
> -       if (pos < start)
> -               offset =3D start - pos;
> +       if (end && pos + size > (u64)lend)
> +               *end =3D folio->index;
> +
> +       if (pos < lstart)
> +               offset =3D lstart - pos;
>         else
>                 offset =3D 0;
> -       if (pos + size <=3D (u64)end)
> +       if (pos + size <=3D (u64)lend)
>                 length =3D size - offset;
>         else
> -               length =3D end + 1 - pos - offset;
> +               length =3D lend + 1 - pos - offset;
>
>         folio_wait_writeback(folio);
>         if (length =3D=3D size) {
>                 truncate_inode_folio(folio->mapping, folio);
> -               return true;
> +               return false;
>         }
>
>         /*
> @@ -248,7 +254,7 @@ bool truncate_inode_partial_folio(struct folio *folio=
, loff_t start, loff_t end)
>         if (folio_needs_release(folio))
>                 folio_invalidate(folio, offset, length);
>         if (!folio_test_large(folio))
> -               return true;
> +               return false;
>
>         min_order =3D mapping_min_folio_order(folio->mapping);
>         split_at =3D folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZ=
E);
> @@ -259,6 +265,10 @@ bool truncate_inode_partial_folio(struct folio *foli=
o, loff_t start, loff_t end)
>                  * for shmem truncate
>                  */
>                 struct folio *folio2;
> +               bool tail_isolated =3D true;
> +
> +               if (end)
> +                       *end =3D (pos + offset + length) >> PAGE_SHIFT;

If I'm understanding it correctly, based on how
truncate_inode_pages_range() uses the end value (eg the "while (index
< end)" loop condition and the find_get_entries(..., end - 1, ...)),
end needs to point to the start of the folio if the tail folio from
the split is a large folio, in order to exclude that folio from then
being truncated. But with the (pos + offset + length) >> PAGE_SHIFT
calculation here, does that result in some cases in it pointing to the
middle of a large folio? Maybe some logic is needed to make sure that
it points to the start?

Thanks,
Joanne
