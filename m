Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794742999;
	b=CYxzJSM8rv1eKw85/gZkIKgy+H1HPhuNT8tpx9E+gcSkyhMg+HSMY1DcGQHs9b0VvNdf
	 MfvFZPLW0tmZ3tZj0R39Yw27rpkPZ5qNRyoRb5ZyGzuywqmvCBrh+ZqOztjbm404GQfq6
	 OKN4wRElyx81sEZDBVAL1i7P735khm32cXCWFqpSmLC4nbw2jFSS6bdcjCm055lzz6Pyi
	 pD0ql8KjqF6tw2cIm9W1bpbNdApCCWa3Oo4EZbpAcPo/Pi5vjvO6Ju55fo/euZW8gyd6G
	 DS9+WDDgZJ8gkLSmfs/H7c6PUOooJo/BimKcPPA3Y6GufuR0yOhNKnqCigsgdx+QXfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794742999;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=qjPej5w11WbikcynHTF6kveEbA3S0oHjvCfUZQriRUU=;
	b=ytRlV//JLCCHbCPZB+cVIaHDUeFsTFCjOGdsOHVtjwaSkqhSk2Zks4pO54Z3rPRrpRIf
	 /7z4ckDvz+AjniRnozDLkKn9Rn6gbBczkQj+1XI9cav6DD0UUKeZfXNeE8Dp9gQ31yJ7m
	 osgKAEjODVorFkhExv9oNz5e/BkAGe3qR1gcaHI4fK+rbjlr5sBMQyVv7cGxMFnM98KPv
	 JP68na1yGoR3n2Fa3072z1N0iEHDVUTx2RyFP95698LwalqAU9MFEtQsrE+TDkiqej987
	 wjv5JSo6qpdNbKEKO2Xr46O85CDtjJLdtkmnnQZNbfJ7M49yDTZ/vIheeqWDiWyHZjw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NgMq15ZT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EB3606A31A
	for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 11:43:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0EB3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NgMq15ZT
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4cac7a7d3cso334556866b.3
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 03:43:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794742996; cv=none;
        d=google.com; s=arc-20260327;
        b=qcazXp/YBiM55AGwRRRic8NDO8svtqdYc0AZwdINurhf4SCjcXMNscQm8kn/cJ5vJs
         9/354iwomy0ksTStCvHm5aoYOQurDPx4sA2ZOS1J1LJq3aAeZkndzxC+LCREihsQWDpX
         hD3G2LUIepTA3Ad8DcdgzQ4ESVpYRuE2iwRoORDArhlpVGUVA/EigLeeqajGJPSczIXM
         YVRoso4zhMxe5RMOHLahch8X0B1t515zJt5fE9sa6TrcFJL48wW6l6kPne+59GEoaBTa
         LyEn2kFn25ZVrYkAqJsp5oI89gO6WWF0FLrL7kS+cSTuGjZj1LDdhYG2cIvWb3mbvW69
         Jp4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qjPej5w11WbikcynHTF6kveEbA3S0oHjvCfUZQriRUU=;
        fh=iO3OJoeeRt0DiAiHcLnuwZsTB0qWbOWcfR5htb6RnN0=;
        b=VMRvfMwHaQcZ7XOI/q/B9jYhj3hMBDKmvYDceZfBSh+xLDApLzephX6yU9Tr2ZT/ko
         AfGq3UHNJqPJhl2fPpQnvAVPwzSTynOBxhZIGJliQbgCcD3ZtaWOB2P5bN/M3m4pod7a
         LjtDwfToOfbieR9dhBJBwWl0rQ5KAuBIPnPdLLF9nyN4JE7DSHeClsmwHmDWNjdzf7/C
         oM3VPiae1tsbQjLT755mfwm9ORFvlhzKk7vApOGlZaTxVNYSbFwYmF3XnlqynOHYN1bR
         kJOAIuXyJk6aNd+gi/qVfIS+zOSPl2lrj62zxa0uGgjK5+YvkkDbuFHhdXAEVY9om3AV
         Enug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794742996; x=1795347796; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qjPej5w11WbikcynHTF6kveEbA3S0oHjvCfUZQriRUU=;
        b=NgMq15ZTWXW4+TO4lims5QvJ843nwsfQ1lMyAIl5Oxdu0N1VHHby8kgomJHx+RQYdw
         eXieXjUW1jyH4u2GK/nxeM784opwix3HC1Z9JhAawLtrUBs4Xnd9H88hiG5j0GQOZ0Fz
         E5wpEcw4UpqSiNVjEkqNROa+yPrLBc8afMvhqLlhtGN9IXklieU/8LjvdeZO8TrsWmQ4
         pUuFMnyIXm1u9iAXpOP2Wn8WpH+B0wC59byObJELDhndZAdKHQtRuR21fbPoji/shbs0
         /rf9Kc4xS6lmkXOVu9ffW15FwNhYvQx2THr5xGX/jujM0uE2NkhVH9+N8UM3cybYyqxI
         Lxhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794742996; x=1795347796;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qjPej5w11WbikcynHTF6kveEbA3S0oHjvCfUZQriRUU=;
        b=cBdwESEsCQjzDRHoeL47c08WbEWADRsmt71X50RGp947SUV9ZyjGvtz9If07lC1My5
         lDHAKQiYQC6QrADb+IRxcytVLRRTjP7YjNGz6j1zmrGVc28n+116QgMYo76BF28SB/im
         9yLq/4j/ghitrzxDUphzYoDzyKUuH+h/wKzK0fguqJzmfsdieUiTgu0BnuSt4qhplQd9
         nA8dB+hJ6sd7qAoPZT1U2Z+SBhRqYbYUeI4DQVHyGpPSwm2eJPMbYlhaFg4g+BIUiV0P
         UW6UaKQTVRVN/iCaQ09slc2ht/jX32m+iUtB51UonrcRPx3Dug5N27IIG9VFh5gQbYzB
         Ic9w==
X-Forwarded-Encrypted: i=1; AL+hErGDRntMy6lsnl8p7vRjGTsJ37J/AgK8WRPdwoMdA6dfsTLXbXdosa1sBWDen7Sb9/tqrh2N6dWUwZqE@vger.kernel.org
X-Gm-Message-State: APuU4Z/d+0FkfaT4i5DpqaurLwNN/TRgCdD1YE7xssbktY2m7q15zEuv
	bKTw1jRtVVYil+BkNfYf/G/rwqVXklcpaque2IHadWApH5/5Arjo31XgmEGKPhkaxGcyaYe4NK3
	aAgs+bTU/carckWItla2P+BpBg2Si9MY=
X-Gm-Gg: AYBFou0/aCLsPCipjxv9VRnVsU8XUcJ245UpUFOk9Kf7UUJu2nUGdTWgIWOVqhIm2Uy
	d0uaGAkbqzxqkJFqh6Jep0E7AuO+8TmEp+qxxog6NBTGM2ZruFHGlooN5nxc1mKzHTXUTBedSab
	3fLIrqXKf4oB1TNJbNzc5is62mpIMndWtKu7tdjEpyj/FKN+Sgj6N0qlGueq4qkxly9FG2KjrSC
	KpOZd9LKc6kaY02/qsfsC12apxICVXy0alK3BhknLZ56NgYdKPd+ii90UDZLSjo0a8l6zpSHWKg
	ms+M/8OWSF0uzWUjeOOVi8j5zNXObhL9Ed3CEbmrMb8gJN1Z1RzHGKvlZnStRF+a3xEV3kWII7p
	EyPF6ptgt74EsO5tTmooslMpSnHnCrPaWXBuASw==
X-Received: by 2002:a17:907:c13:b0:c42:e6c8:e494 with SMTP id
 a640c23a62f3a-c5096547278mr574061066b.37.1794742995902; Sun, 15 Nov 2026
 03:43:15 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021085635.3633692-1-r772577952@gmail.com>
In-Reply-To: <20261021085635.3633692-1-r772577952@gmail.com>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Sun, 15 Nov 2026 19:42:39 +0800
X-Gm-Features: AclHuK90wWzGoA4H29cy11pmb1JHH3C1yF5Eojyo_HIgeidC5_U6uD5eFeRWITg
Message-ID: <CANypQFYkEkoxA4vJzGd_TzoqV+_TA1nk6-ResYvG7PZ80221WQ@mail.gmail.com>
Subject: Re: [PATCH v2] ext4: clear in-inode xattr space before adding the
 first xattr
To: jack@suse.cz, linux-ext4@vger.kernel.org, tytso@mit.edu, 
	adilger.kernel@dilger.ca
Cc: libaokun@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, stable@vger.kernel.org, 
	yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jiaming Zhang <r772577952@gmail.com> =E4=BA=8E2026=E5=B9=B410=E6=9C=8821=E6=
=97=A5=E5=91=A8=E4=B8=89 16:56=E5=86=99=E9=81=93=EF=BC=9A
>
> An inode can hold extended attributes in the space that follows its extra
> fields, whose size is given by i_extra_isize.  When ext4 loads an inode,
> ext4_iget_extra_inode() validates that space only if it starts with the
> xattr magic, and only then sets EXT4_STATE_XATTR.  Without the magic, the
> space is treated as empty and is not checked.
>
> ext4_xattr_ibody_set() passes the space to ext4_xattr_set_entry() whether
> or not EXT4_STATE_XATTR is set.  ext4_xattr_set_entry() walks the entries
> there to find min_offs, the lowest value offset.  That offset decides
> whether the new value fits and where the value is copied:
>
>         free =3D min_offs - ((void *)last - s->base) - sizeof(__u32);
>         ...
>         void *val =3D s->base + min_offs - new_size;
>
> A crafted image can leave non-zero bytes in that space without the magic
> where ext4 looks for it, for example by shrinking i_extra_isize.  Those
> bytes are parsed as entries, and an entry that claims an in-inode value a=
t
> offset 0 sets min_offs to 0.  Because free is a size_t, the subtraction
> then wraps around to a huge value, and the free space check passes althou=
gh
> the value does not fit.  The value is copied new_size bytes before the
> start of the space, over the inode's own fields and, for a large value, t=
he
> memory in front of the inode.
>
> On a kernel without KASAN, the copy corrupts memory: it overwrites the
> inode's own fields and, for a large value, also the memory in front of th=
e
> inode.  The bytes and their length are decided by the setxattr() caller.
> Nothing is freed and reused here, so the use-after-free in the report onl=
y
> reflects where the write happened to land.
>
> Triggering this issue requires mounting a crafted image, which needs
> CAP_SYS_ADMIN or automounting of removable media; after that, any
> setxattr() on the file reaches this path.  The issue was found by fuzzing
> and has not been seen in production; a reproducer is available in the
> linked report.
>
> When EXT4_STATE_XATTR is not set, zero the first 32 bits of the space in
> ext4_xattr_ibody_set() before calling ext4_xattr_set_entry().  These are
> the bits IS_LAST_ENTRY() reads, so the space is treated as empty and the
> walk stops before reading any stale entry.
>
> Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
> Closes: https://lore.kernel.org/lkml/CANypQFZzxTAH=3D4QRRDoqH6VAw1daAq88N=
DWiQKoM7QTOnP40sg@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Assisted-by: Claude Code:claude-opus-5-5
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
> ---
> Changes in v2:
> - Zero only the first 32 bits space instead of the whole space.
> - Add a comment above the check.
> - v1: https://lore.kernel.org/lkml/20260916084723.877552-1-r772577952@gma=
il.com/
>
>  fs/ext4/xattr.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 5c310747b965..8e1fd26329d3 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2274,6 +2274,14 @@ int ext4_xattr_ibody_set(handle_t *handle, struct =
inode *inode,
>                 if (IS_ERR(ea_inode))
>                         return PTR_ERR(ea_inode);
>         }
> +
> +       /*
> +        * Make sure xattr space is properly initialized so that
> +        * IS_LAST_ENTRY() returns true for its first entry
> +        */
> +       if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
> +               *(__u32 *)s->first =3D 0;
> +
>         error =3D ext4_xattr_set_entry(i, s, handle, inode, ea_inode,
>                                      false /* is_block */);
>         if (error) {
> --
> 2.43.0
>

Friendly ping, please tell me if any further change is needed.
