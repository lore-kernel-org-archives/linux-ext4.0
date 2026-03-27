Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BB13C661A
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 07:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.125.188.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774596426; cv=pass; b=emIDgMLBBAMU6OEbmb1A4RJD5iQYxRs2lFTuTtAPWYudU+t5p0m68IOiL5M+naBjVsesZW1jw21T7wc89uEoSaklJP4Su3jg5I0CbYHJi8C91tf/6U8EsibBxwmBmJCtMBNs7u+BNT1Uq3drzdECrcrnyy5oKNGnMXBQHF0eVSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774596426; c=relaxed/simple;
	bh=jGS6GqAbzhTwzxPv9nNCpB9bbOqvGVzvreAAFVgePZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HYiwpKO20tyAK5yHx0J23COT78+zvMlJM04A2ZAXsZvUXtt4w9YsNN+zycDImwENjX3e8Lk50jiP3AeEAK2QqUqvcvavx2+m0srOyg4i2V3aMliiwThWEo4TNzeztpIVIQQIGu2+Pe600+Pp/RX6BfNOOxKR54B+JW/uZfCDwcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=ArRwD/yx; arc=pass smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="ArRwD/yx"
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C70B13F675
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 07:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1774596410;
	bh=fGvKC6oA1d1MdWYMGoBXlxsXAqbx54ToRlN6blj+6jg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=ArRwD/yxY0fs/WpD/eZwUFiU70MFfqaFPo23QFJQhovAFLb/QmgCL5+YoYMEbk9oR
	 DpRO4EQt+sH7EpKO1vN68qfznUnUwAF483vLjdKQtweFaqbyI/I1COSIb8RLD3Wg9/
	 boL5rotCzfS2GRN+z9ChRtLzdGgfr8hp49fdFhKefz2npID0xLuxex2njDAHbmAMIq
	 VF25b3sQCXk4asNWsyFzniZc8WDnCM7lXUdLVkr9UpyisRJhHT9r+2korsd8QTI6Id
	 GaMZfGE6PNicHEVkZm1z+1kk+BqviV/hnUJ5Kadzlvjy+IJ9WAFTVFGBzPHtu6OBaC
	 +318UIjA1xWYfu745g+bdHbxZdJgX/r7dpkV4Y3cqHYPwZEcDNPdQLRw8DUSy+ji9o
	 9qOwynU2AZ/1JGbAiSyl3+5tpCQoB3JgNisfRNc0o9w06ZdJ0K9aCU6QR//u3GmIHP
	 O06mHiAwtLyrInIVVu0uYaYOveMe3IZr1b0oc5mwAISVVdRGKtsDJ7QntYN54cqDI1
	 /JZuMww/ku4S43nDTXG5LDBndhg6MZ0hOnraLMMYNjbkKIS+98g3vMofSBiLwAumrV
	 sjOBmXCtHIYPuzgFkdL/ZymdQJsaWRT1+8Jz2N/OWf5L9s14Dwilcit6A7LshAD6qP
	 LuBfyKeajoatMeEdjLMzUN04=
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5a143980c7aso953457e87.3
        for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 00:26:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774596410; cv=none;
        d=google.com; s=arc-20240605;
        b=NXZLvQYZSYVB/afSoSxykqVStQK3TuscjVT1MSRZH7E1kLXNKloxcu1pGfb0xK5thO
         U8BssGWuKtAf/Z7bQqF/tZg2wz9T3xCOIuLJQN9WvWcTIGM3UAma3SFSYqSly1aZMIRm
         IwK45gr0D/ccKbqOJGVD43Hx/z8NBIOwvfPvbqqHKi19AJ7U2y93nYVPfcf9uMjY4k6M
         6ukNjvNGxrGgAAuVDi9SXMctbm9QBNNJxvJwiVwQKiIjzAr7UwyehLFUwizkSwx18IZT
         pGNOgrQcffHlM4+VR9SV9GI86RZOP/NHPJ6QmaLObBjD8HoCSLsFV2g1GfImnxPZDgJT
         hn9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=fGvKC6oA1d1MdWYMGoBXlxsXAqbx54ToRlN6blj+6jg=;
        fh=6ss17h27LSsQadpLR4bwXEtd0ICjyoQWkzu7TVIWxpY=;
        b=WzqYIzQv2UNATRH53kBqaaCkIij/7Zd+H5PldNxJywuJq9PGYKkwzs2vLko5Sj+pVz
         KH96EBZqoaOajqS9TXk6seA79AjLhvXXbzphgkbDq2UOI9d4sigG7s080mZvDuS8yO9f
         02MNagZBSLr8MMp64PK5Fy869EeGhN9z53pTnpno/5Bev1V3cEPaLK1DkgjFYztUXOpY
         SxSP3cwl3gWUptAV/zEh+Mt6HpLFTLSkKHijNnakNsa3yJaeQjSbQByxBPzWBH415o/+
         UPhTvvzcsy+GWm6wkmOaR3dJgKndsQi51W6mwG6Ue/nDyBnpCYUzjg/1KTLs5UWmVby7
         p/gg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774596410; x=1775201210;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fGvKC6oA1d1MdWYMGoBXlxsXAqbx54ToRlN6blj+6jg=;
        b=mPjloKFPuQbVOu+UVSsoH+M5Rgby6eXvJ8MEchMMuKAszT/2WRGw2skPKE5InhGuRd
         rI4KonbTOsexHSSU+gZRIPPJ2MKWEzmTpZFLALziv/2YWMkMhpAAYx4/vuFA6aKnYaG2
         6yM2Yku5A99WbBOvzju2l2Sbolozd+4JUHnsrmTP9GgrTrUH8qqIFNYim8DkcFBWUI0h
         g2urxOxcDZHBd2jZWsgyG82aYj9XT6o7G13oG/okwyGfjfIRJnmhoeIGnGxK5BifiSlb
         ShUz7dkcsi7QFirs4UYiVIFn/zn/ucy6awYZWeXmlnQAQeKxGRXxe0V31B0XP1AmFJIZ
         6o6g==
X-Forwarded-Encrypted: i=1; AJvYcCVshFgW15ewNF9KaBPvHElfbo//Wvr6rbm0YnRRuF2teDxvU8Uav9emsVmunA9d6x2H5QUqGQJrRYVZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzxovbrTKCM5Z1uEGSgjYHpbEhT1YSzHMCGaAHO2dUJYv8l9gWr
	Npg4f3TwtE74M8sQyeTXq6NY9apMyAWiN7KYkcAtdCmxsC8pl/SW1cutRngX1AY5njJfAoL27Ie
	IfWjd1m+5aEtpdKu+0CF771e5Jh95Ar+/JED34QX2V9zl4kUA1DBgFIt3hhhtbBBv1hXIMJmMUo
	o2N/qvmJaD8AcL9B4Ozhr54odAeQ3LPj+Hoj6kNIMpyS/JcJg+uHvlSA==
X-Gm-Gg: ATEYQzz5Ut5e2o6BjsA4VDB9urXH+p0qYEVlSb+GfSrRUHLziwvY1pmyoU3x5us973e
	MnqO6tD3zwwQvEwIkJ+/4OEG7u4TXnvM9C/yD8Urmo8dLYJOFRgKkxYP4tXBDUK6/P0T0+UJGzt
	6UfnEzLlGnc5elde6Vv8pAA4t39HhFoDyEW8u8s/oFl3VnXwXYK4yD/MYoFTEH41fdYdUg5FWlB
	oRPWT0=
X-Received: by 2002:a05:6512:1383:b0:5a2:86a6:4adf with SMTP id 2adb3069b0e04-5a2ab7f038amr473432e87.7.1774596409987;
        Fri, 27 Mar 2026 00:26:49 -0700 (PDT)
X-Received: by 2002:a05:6512:1383:b0:5a2:86a6:4adf with SMTP id
 2adb3069b0e04-5a2ab7f038amr473420e87.7.1774596409531; Fri, 27 Mar 2026
 00:26:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260128074515.2028982-1-gerald.yang@canonical.com>
 <4u2l4huoj7zsfy2u37lgdzlmwwdntgqaer7wta7ud3kat7ox2n@oxhbcqryre3r>
 <CAMsNC+s1R-AUzhe80vjxYCSRu0X9Ybp33sSMHGHKpBL6=dG2_w@mail.gmail.com>
 <bycdopvwzfaskilhk3nsljuk3gkztvoa3is466a6utuj2lozmj@pxf44ulcnqup>
 <CAMsNC+ve3dRwT1xGWB0pvBJXqBpeksf7PgbEeihcnfs=AmwVRQ@mail.gmail.com>
 <gluj62pw5pu7ag2juf5ejwsr3ghvckag7wh4zunwyk57slcrmg@42of57gybigz>
 <tmtgzmvkfag4r6lbt4i2ej5ad3bfudezcm35l27ybit25r7l4d@5o2i4cuymh5j>
 <CAMsNC+svSX9AiZbs1dd4qigZqBuOjuCHOjpyXzgaO0sNLUHDYA@mail.gmail.com>
 <CAMsNC+vQceRaw9DkbQFo1p2piwcwDbTgohqt=Gtqj27n42kLTQ@mail.gmail.com> <si7uicc6vntron5s64lt5fzcubizryshxeafdeysqdid2xfmfx@mrjpfbddtdqk>
In-Reply-To: <si7uicc6vntron5s64lt5fzcubizryshxeafdeysqdid2xfmfx@mrjpfbddtdqk>
From: Gerald Yang <gerald.yang@canonical.com>
Date: Fri, 27 Mar 2026 15:26:38 +0800
X-Gm-Features: AQROBzB_FqDZzyy6_JFgxEEXSM9nQEZ8DhO8qU3I2DMZjmxY-3swjfr9rDM2xWA
Message-ID: <CAMsNC+u83HArYs1zjQ-YUHyADruros20LOB2m52=aeDXcpuJVQ@mail.gmail.com>
Subject: Re: [PATCH] ext4: Fix call trace when remounting to read only in
 data=journal mode
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	gerald.yang.tw@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Jan!

Hi Ted,

Would this be merged into the next merge window?
https://lore.kernel.org/linux-ext4/20260205092223.21287-2-jack@suse.cz/

Thanks,
Gerald

On Thu, Mar 26, 2026 at 4:54=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> Hi!
>
> On Thu 26-03-26 09:50:39, Gerald Yang wrote:
> > I'd like to ask when this will land in upstream kernel? Thanks.
>
> Well, this is more a question to Ted. He didn't pick up the patch [1] to
> his tree yet. I guess he'll pick it up for the next merge window which wi=
ll
> start in two weeks or so.
>
>                                                                 Honza
>
> [1] https://lore.kernel.org/linux-ext4/20260205092223.21287-2-jack@suse.c=
z/
>
> >
> > On Thu, Feb 5, 2026 at 8:59=E2=80=AFPM Gerald Yang <gerald.yang@canonic=
al.com> wrote:
> > >
> > > Thanks Jan for fixing this issue, I can confirm the patch works for m=
e too.
> > >
> > >
> > > On Thu, Feb 5, 2026 at 5:25=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> > > >
> > > > On Tue 03-02-26 15:50:43, Jan Kara wrote:
> > > > > Hello,
> > > > >
> > > > > On Fri 30-01-26 19:38:55, Gerald Yang wrote:
> > > > > > Thanks for sharing the findings, I'd also like to share some fi=
ndings:
> > > > > > I tried to figure out why the buffer is dirty after calling syn=
c_filesystem,
> > > > > > in mpage_prepare_extent_to_map, first I printed folio_test_dirt=
y(folio):
> > > > > >
> > > > > > while (index <=3D end)
> > > > > >     ...
> > > > > >     for (i =3D 0; i < nr_folios; i++) {
> > > > > >         ...
> > > > > >         (print if folio is dirty here)
> > > > > >
> > > > > > and actually all folios are clean:
> > > > > > if (!folio_test_dirty(folio) ||
> > > > > >     ...
> > > > > >     folio_unlock(folio);
> > > > > >     continue;       <=3D=3D=3D=3D continue here without writing=
 anything
> > > > > >
> > > > > > Because the call trace happens before going into the above whil=
e loop:
> > > > > >
> > > > > > if (ext4_should_journal_data(mpd->inode)) {
> > > > > >     handle =3D ext4_journal_start(mpd->inode, EXT4_HT_WRITE_PAG=
E,
> > > > > >
> > > > > > it checks if the file system is read only and dumps the call tr=
ace in
> > > > > > ext4_journal_check_start, but it doesn't check if there are any=
 real writes
> > > > > > that will happen later in the loop.
> > > > > >
> > > > > > To confirm this, first I added 2 more lines in the reproduce sc=
ript before
> > > > > > remounting read only:
> > > > > > sync      <=3D=3D=3D=3D it calls ext4_sync_fs to flush all dirt=
y data same as what's
> > > > > >                          called during remount read only
> > > > > > echo 1 > /proc/sys/vm/drop_caches       <=3D=3D=3D=3D drop clea=
n page cache
> > > > > > mount -o remount,ro ext4disk mnt
> > > > > >
> > > > > > Then I can no longer reproduce the call trace.
> > > > >
> > > > > OK, but ext4_do_writepages() has a check at the beginning:
> > > > >
> > > > >         if (!mapping->nrpages || !mapping_tagged(mapping, PAGECAC=
HE_TAG_DIRTY))
> > > > >                 goto out_writepages;
> > > > >
> > > > > So if there are no dirty pages, mapping_tagged(mapping, PAGECACHE=
_TAG_DIRTY)
> > > > > should be false and so we shouldn't go further?
> > > > >
> > > > > It all looks like some kind of a race because I'm not always able=
 to
> > > > > reproduce the problem... I'll try to look more into this.
> > > >
> > > > OK, the race is with checkpointing code writing the buffers while f=
lush
> > > > worker tries to writeback the pages. I've posted a patch which fixe=
s the
> > > > issue for me.
> > > >
> > > >                                                                 Hon=
za
> > > > --
> > > > Jan Kara <jack@suse.com>
> > > > SUSE Labs, CR
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
