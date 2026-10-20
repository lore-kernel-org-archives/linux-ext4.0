Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792456558;
	b=D4ZmwTJTf8tnlaL34L8omy25CRT3j5W5SOpXq6NJB80hW78EwJKzgCcYcJ2KdP3ZSAr6
	 ORo3YOW1+AMIpYnQaeaG4HZVYs642SACVOipdHb6bvo0EzY3AMdPEiyJh8WblCmIUTzj5
	 Iq4AMlLQvXX25d+j9yp0RKg4fOsbc0v+H1QK/eA2mqHjLQHtAR3ypS3B7LIjqp8LXPzco
	 QWEPXwKT3EaIfcOcYKHvoGzfMQlI/PWGr8oM7gGLrjls3dmJFSa3xGsZxyAAxp85b6dBg
	 ru9vEdY20S+niMC8so2LwKMFZfQoXrB3DzPR6js/SXekZZuxe8wl5uj8ibKKKUHwfkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792456558;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=NtUt4EBp1f75gVbnrDI7LLQPMBNwUZ1wb674GgkrAXQ=;
	b=J73Fmglqw1Hyfv6TMq6PHh0PQFDwYayLlHiyf47TAR8spoi+aRJvwi8oonrlshRBZp8a
	 VSG8DILCYakILnQdIs5sQklhDtlN5W7Am309gxuLNbuBsiVR5oAcGldj7oD/q3TUV72jK
	 Hqu5Eshh03Cxsqv3KCrG2TIJXhbm0zBjo7Y3tQy9PrdzFv8eIoAaEAGYAzIcQeXHVBhQk
	 lUwwANfRTu1QL0HFZBdELuHrBnYX1BPbRyKVqxnWyc6n1SKvkJmGWqCNzjhMrVYTKpcWJ
	 AH7dFpY9sxw5gvaFbrwkSYjP7L6YNp5FTg3QNwAyHbpKBwForh7OHoDAH1l2xNAxsxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fdolQjQh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA0C606A328
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2026 00:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fdolQjQh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180691F000CF
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2026 00:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792456553;
	bh=NtUt4EBp1f75gVbnrDI7LLQPMBNwUZ1wb674GgkrAXQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fdolQjQhkL0ujALk1waFv+Nz/s8AQ9DQO/nHMOTG4NsxuA5RKDI2NTHpnn0aFPhAU
	 jRV/jKSlDbi6c8ZYrYs4D2iJDluNi+ZSHo7FcjxbGOXxl6a0LMn8wJdjJVPDuaY8fz
	 KwpyrXuTyMjCKw9MGGwHhERv49qzjZYQveYO4OjHXO4hkNmG90EqqSVo027SpwY1YL
	 1WRm5iqVybI6Qkf5dkcFC7Gqd9fP80oT4nzy/RzbCWuTAk1p37hk08/o1qmfQD0+MM
	 LgOOUivAzl11PjhhxK9dLIGHOTlMERkGdsTs7uYo/nzPa+UWbN2YmCkU+I48qwvTLm
	 AmVDFgW4e0LTw==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93f1cf92c9eso273571185a.0
        for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 17:35:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxhopPZ6KehJCoKzacJ4qxrhdkPQI4r0QSXVolx7PER9a/rYgfRVbxsPL653RojzwoGJ3+PGHO1Q9dZ@vger.kernel.org
X-Gm-Message-State: AFq9FYIUCCRdOeHkjNKGvHlmw2WAyfWkghlUk4lxx4Ow6v+nHOKdTuY0
	PMoAz/V/MgKV5i/xn3g5gi3AtNkf8I1axJu7NroAB+w64sMDGAFfst1aGqBvODh26CfyJ23nFsI
	kslP9v5N0NSxsfWh0OJLzQsCqr5z5Mpg=
X-Received: by 2002:a05:620a:394c:b0:93e:5861:34df with SMTP id
 af79cd13be357-93f29d7be8dmr1558868285a.47.1792456552324; Mon, 19 Oct 2026
 17:35:52 -0700 (PDT)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <6ad67231.a20cb897.960b0.0042.GAE@google.com> <20261019164638.c33e70eaefbee802eefb4716@linux-foundation.org>
In-Reply-To: <20261019164638.c33e70eaefbee802eefb4716@linux-foundation.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 20 Oct 2026 08:35:40 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yjMP8Tq1mKWtV-1GK9NJ0HC581w0=x2V_QMOiDOm-cvw@mail.gmail.com>
X-Gm-Features: AclHuK-KfVTEMdx8AlHQkztAVoG4bf58LyyLDo_u5rI7H9Ara0G6VsLgl9a3zt8
Message-ID: <CAGsJ_4yjMP8Tq1mKWtV-1GK9NJ0HC581w0=x2V_QMOiDOm-cvw@mail.gmail.com>
Subject: Re: [syzbot] [mm?] WARNING in shrink_one
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com>, david@kernel.org, 
	gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, linux-ext4@vger.kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2026 at 7:46=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 19 Oct 2026 12:40:33 -0700 syzbot <syzbot+54f6a8926b40a171f2c8@sy=
zkaller.appspotmail.com> wrote:
>
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    a0ff06b3a7bd Merge tag 'firewire-fixes-7.3-final' of gi=
t:/..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D12cdb20d580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D44ac479246d=
4559b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D54f6a8926b40a=
171f2c8
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for=
 Debian) 2.44
> > userspace arch: i386
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/d900f083ada3/non_bootable_disk-a0ff06b3.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/3f4bcbceb92e/vmli=
nux-a0ff06b3.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/bf4df8252e54=
/bzImage-a0ff06b3.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+54f6a8926b40a171f2c8@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > current->flags & PF_MEMALLOC
> > WARNING: mm/page_alloc.c:4816 at __alloc_pages_slowpath mm/page_alloc.c=
:4816 [inline], CPU#3: syz-executor/5706
> > WARNING: mm/page_alloc.c:4816 at __alloc_frozen_pages_noprof+0x1eac/0x3=
300 mm/page_alloc.c:5449, CPU#3: syz-executor/5706
>
> Thanks.  The stack trace is missing important bits for some reason, but
> it appears to be ext4 disagreeing with page reclaim.
>
> __alloc_pages_slowpath():
>         if (unlikely(nofail)) {
>                 /*
>                  * We don't support __GFP_NOFAIL without __GFP_DIRECT_REC=
LAIM,
>                  * otherwise, we may result in lockup.
>                  */
>                 WARN_ON_ONCE(!can_direct_reclaim);
>                 /*
>                  * PF_MEMALLOC request from this context is rather bizarr=
e
>                  * because we cannot reclaim anything and only can loop w=
aiting
>                  * for somebody to do a work for us.
>                  */
> -->>            WARN_ON_ONCE(current->flags & PF_MEMALLOC);
>         }
>
> The electrical think machine said:
>
>
> filemap_fault()
>   -> direct reclaim
>      -> shrink_slab()
>         -> super_cache_scan()
>            -> prune_icache_sb()
>               -> evict()
>                  -> ext4_evict_inode()
>                     -> ext4_clear_inode()
>                        -> ext4_discard_preallocations()
>                           -> ext4_mb_load_buddy_gfp(
>                                GFP_NOFS | __GFP_NOFAIL)
>                              -> __filemap_get_folio()
>                                 -> page allocator
>                                    -> WARN_ON(PF_MEMALLOC)
>
>
> The task enters direct reclaim after a filemap allocation failure.
> Reclaim calls shrink_slab(), which evicts an ext4 inode via
> super_cache_scan() and prune_icache_sb().  The eviction path eventually
> calls ext4_discard_preallocations(), which explicitly does:
>
>     err =3D ext4_mb_load_buddy_gfp(sb, group, &e4b,
>                                  GFP_NOFS | __GFP_NOFAIL);
>
> If the buddy-cache folio isn't resident, ext4_mb_load_buddy_gfp()
> allocates one through __filemap_get_folio().  This reaches
> __alloc_pages_slowpath() with __GFP_NOFAIL while PF_MEMALLOC is set,
> triggering the warning.

Right. The problem is that ext4, while running under direct reclaim,
allocates memory with __GFP_NOFAIL, and that allocation can itself
re-enter direct reclaim.

>
> Simply removing __GFP_NOFAIL doesn't look safe.  The preallocations
> have already been detached from the inode's tree, and failure to load
> the buddy information can prevent their space from being released
> correctly.
>
> It seems that ext4 needs a way to complete this mandatory cleanup
> without performing a NOFAIL allocation from the slab-shrinker context.
> Perhaps the preallocation cleanup could be restructured so that it
> doesn't require allocating buddy-cache folios during reclaim?

Checking the code,


   2   5686  fs/ext4/mballoc.c <<ext4_discard_preallocations>>
             err =3D ext4_mb_load_buddy_gfp(sb, group, &e4b,


It does check if (err) there.

                err =3D ext4_mb_load_buddy_gfp(sb, group, &e4b,
                                             GFP_NOFS|__GFP_NOFAIL);
                if (err) {
                        ext4_error_err(sb, -err, "Error %d loading
buddy information for %u",
                                       err, group);
                        continue;
                }

So maybe it's safe to drop __GFP_NOFAIL.
In any case, we need the ext4 folks to look into this.

>
> The syzbot report is at:
> https://syzkaller.appspot.com/bug?extid=3D54f6a8926b40a171f2c8
>

Best Regards
Barry
