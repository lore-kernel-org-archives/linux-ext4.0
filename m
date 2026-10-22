Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792637632;
	b=hAnRv46i1TcXdg3g4wVal0079m3LPAFSRRGS0+DZ8zvxw9RhQ9VkFDRIgPK9tYmguKxf
	 UyviqALoB2l6MEIGzyYr4y+nxgSPw9TJsj93WN73m4Bp4Cm8hzJdN83doUeQnm9BopOoR
	 oqkFmrOvd5T7Dly2oHY2jMxBGM/Iom/8gWhLFKMjVWZleGOxUkslTaRI1lcYq83/LZbIT
	 LgKBdazF4c+a1GedzfDz77Al2S5vPtFZxMrY2evAXI3dI0DkQSj7ct9tz4oUDssisWUJ2
	 ocBrCWnvJuMGw4RugcgZDAXR7fdjYhk0nPO7yqVm30Q4BrfMF8FNPdokgGZaAyxgv/w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792637632;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=NnU6rs3hrQM9btLPDOKgfodkMRYa3+dqaWM6BzIydXs=;
	b=CleZKY8W2ELwZqtFgZTcFEUam/MvLCebNBqcsOjUqkIwQUuTW3fOE4kW8RflCoEQv5cD
	 r5/FqGh365BYTdLs3GusuHPHzFvv5+wLBFWkoqGnza0a6q6oQiF/ZSnbbmeUrWG/qwouN
	 9ge0vjl1Z9iB/2VWS+0WtUbcwH0/jJTyiUqB84J6UZcYcnzYxmWhh/KxhWRsJn+LXuu1Z
	 YzTBA9ACH38LWgGVNrlIlsfDU8toE9iIYYxzuTS9BqWajgcDR2d+I9QqCvFZ2sNnGwcBu
	 KfS3AkjoDe0Wwc2v4xXEpHCwz4IPP0VUqxZWwI98FLcV4kvfmK0k8cw+NBM3Y5hq45A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="DTOI/Pek";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F1E606A320
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 02:53:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78F1E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DTOI/Pek
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c43fbcb4393so173532366b.0
        for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2026 19:53:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792637631; cv=none;
        d=google.com; s=arc-20260327;
        b=iMTAyjEN++UNq6iburDxfHnX8uSHOtx5WMJPSe3r+CzM9/d/Vvtqh/XAsM5fS+P76P
         el8EhA+Q9HygPeKOyaZmdK+Rq4QFSkKXbh+fvZqCwLL42rmeKJQQR/OwbTsFNxo2EKj5
         hkkJOQ/RwmKU4c/gTU3QO7FJtapP6tJuinh6txc3oS57vU+dkM79nji39Cnszgp8ErdI
         GvxS/1n78u3e+/YvBxrYNYYXx+ohboJYPqD3CFmO1EgYM451j2ylC72qDlsq+6aEErv/
         7Bv77TQ5aAOhKvti2g3Cjaoke1zxxy5NpeZ2cz6dmyqLPGE+64N4wCAvVcFiq5QdcrmL
         ahAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NnU6rs3hrQM9btLPDOKgfodkMRYa3+dqaWM6BzIydXs=;
        fh=z7boC0Iu98zjAYwka8/ZdLCrunia2L+k9WdUb8FkDlA=;
        b=BVnAMLu8b5lu+mPKICvJr51Hp/ekVfdC+LMzumSASwmZd3FBpkB1HPNKzbibsI1C/T
         myZqlTCrFitSS/ro9MHokFTJUy0fVF/Rq1G17leVtsi0zfNBlQa6qUPcrK1UkSKTT6Qe
         bwH3SMF+9WtZaQv8pR+ppYsLmwejsaJep3bacFfmFULuknqpm73AyK677ALIv+yTK3w3
         hVHUV+isABK0ZrrT8Xy62g2ES8XJyeY5Ieqs79+hJik0eCopciJIBlNB9ZlWt4Gis9Vx
         YVLb6fxzVEIxnBq9lrjbaMDDxDd6wugRhh8DfPW3DOrlH4D52YwOTR4FKBBqe1icX04K
         BWwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792637631; x=1793242431; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NnU6rs3hrQM9btLPDOKgfodkMRYa3+dqaWM6BzIydXs=;
        b=DTOI/PekpHCFwbCxS6btLnjWQNCiYVc9jJXCEYwAmPekEK8t/PxBNEKZNgCm5yMo5O
         ZHRqWqq6Sa4prnp5961iu97eKvO2fCe1P/oDhQUuXQyhe3en4gFePLH+ndAycKrOkdLY
         ZBtVPzCtW837QZIUsvIlXqXaajHAOKuqlnaym36x90uyaZGBsQGk0lDoH47TKDdTDSv/
         +bNghojo2jLNQuKI4CGPrg7pLnnWdQfj43K8C91aQyr5qb1zEo8L/J/KSRypGRSRs42E
         gu3hUif099K3NIyvd05k0+GuTWcbFOAPWaSRNh9N1gfC8G9MuampVJBqQHApn7d+PZp0
         CiAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792637631; x=1793242431;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NnU6rs3hrQM9btLPDOKgfodkMRYa3+dqaWM6BzIydXs=;
        b=ZmUFz4PTEvsTYcaWDLbl7/VKnFn9BAscQyj7ienf8Wfnju33A0KEzIuYXNXc67Wxd2
         AptNHxqX/Rwz+aIHyoe94RfF3iwh6w3SK+sGoF0y/5+fauoqf/j8mtTm95mmljDOeD+0
         /GokvwJ1AFoeUn4R01H0fHA40rn4lKqB+WF1RsHvFmAgy7YZucNUyqceXg3dOMnjkVSU
         7gz/qUYO9lUZCjUVe2MnEO7gDzHRD+wEF3yuidTU0OCbHQcutMX9mkTkbPA1fDayUYXy
         5oNnD+90Ak3OK9SCsByOgd7UiH9lwpd8oQ3LHmMOt2EVYFGME95F2eL+UvQ764rdCeDO
         n1NA==
X-Forwarded-Encrypted: i=1; AKwUvBzXQnYiUrO5Xbh4L92MHc9mIPEZhQi2Yxyx0Y6K4CzMHaUhi4M0x0llCImHLdYmzbObBkv0LGfV02PX@vger.kernel.org
X-Gm-Message-State: AFq9FYKkYKiTjvppqgr5SxqKb9lyQw167NwH4gSiajfzzy4MT4mPhm2t
	YkdBFIdPidFEu1qqSX8NfigNYxr+SZmdudhoJCAZfTnwU91kz1be5siE/r5lhHCcmEKa8Y3CzmH
	B40+6GBfT0H7I3dOZMkXizehOJiIzk+4=
X-Gm-Gg: AYBFou1EIIF/xby5RN7UmltRl/6b46wzZef7BslaKZ7Q663yfZl7OD5FbxWYHLuuMTw
	4v5cnKOfOvVeAslYSq8EkolUTMj0hB2+qszgrFH6RB5zQRdtz065ZlhuTBfttuafomZanAx60/I
	V9UtgWjihnehsBdq3bl6XribDIhJB4aRoMfXTkwVicvzLuTK8A4QN5psGXky6R9Ezi4bBefUn0g
	sPOge8S0Cbk7Xr5iw6l+Kw/Vw3Z8G9fgtdjEU/iba2wDm7GxP7j3UekBEaA+5dsDhkGH7496qoD
	ozmj/MFE0DsAz5RKYqT6apdM6vsXed+4eE+wxFD3Q5cBKU6FoqRwJ+xbxj1kdApH09/iZk2wwQy
	iYj1307LC004rtSsafqPmDKe0Nv6L72DA0bRw9sk/vLTaWscbTsvmu8re9g==
X-Received: by 2002:a17:906:ba84:b0:c41:8e21:4d60 with SMTP id
 a640c23a62f3a-c46791326c1mr341731966b.1.1792637630664; Wed, 21 Oct 2026
 19:53:50 -0700 (PDT)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1792552161.git.jan.koester@tuxist.de> <f444dffc8e6bf98bf44c02456adc2de40e4ecd95.1792552161.git.jan.koester@tuxist.de>
 <fd20b840-350e-469c-9fd2-008fa0ded62a@slotpi15m67>
In-Reply-To: <fd20b840-350e-469c-9fd2-008fa0ded62a@slotpi15m67>
From: Takeshi Nishimura <takeshi.nishimura.linux@gmail.com>
Date: Thu, 22 Oct 2026 04:52:00 +0200
X-Gm-Features: AclHuK8zMCY_XzKvgZWVeEW29rK2WIKSmZA1a7YbTdfyZ3EtSnPZJ1CNUxd7pQ8
Message-ID: <CALWcw=FYKcDNXeArpsabHiQOAL+cWkF=L3stL6MB0OvVaHei1g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 40/41] nfsd, nfs: carry UUID and GUID owners as
 their text form
To: Chuck Lever <cel@kernel.org>
Cc: Jan Koester <jan.koester@tuxist.de>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>, Jan Kara <jack@suse.cz>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Paul Moore <paul@paul-moore.com>, Arnd Bergmann <arnd@arndb.de>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, netdev@vger.kernel.org, audit@vger.kernel.org, 
	keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 7:44=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
> On 10/20/26 11:16 PM, Jan Koester wrote:
> > Encode such an id as its text form -- "xxxxxxxx-xxxx-xxxx-xxxx-
> > xxxxxxxxxxxx" for a UUID, the same in braces for a GUID -- in both
> > directions on the server and the client, and take such a string (it
> > has no '@', so it can't be a user@domain name) as that id again.
>
> A bare UUID in an owner, owner_group, or ACE 'who' string is a new
> owner-string syntax for NFSv4, one that only Linux would recognize.
> Thus it isn't interoperable with other NFSv4 stacks as proposed
> here.
>
> RFC 8881 Section 5.9 says a string without an '@' that is not a
> decimal number means no translation was available and the receiver
> "should not use that string as a basis for translation into its
> own internal format." RFC 8000 Section 6.1 forbids bare numeric
> ids in multi-domain deployments because they collide; the same
> applies to bare UUIDs, and more so to GUIDs.
>
> If you are serious about pursuing this, you'll have to start by
> raising the proposed wire format on nfsv4@ietf.org before the
> Linux kernel's NFS stack commits to it.

I recall rumors of MS wanting to stick Windows SID in text form into
the NFSv4 protocol.

THIS proposal is even worse, in every imaginable way:
Stuff an unreadable 128bit blob everywhere. I am sure people having to
debug that in the kernel will LOVE the idea (compare blob a with blob
b as human,YAY!), and admins facing the 128bit hexdump will send
marriage proposals to the author, for making their lives even more
heartless and miserable.

NAK, -1, for the whole patch series.
--=20
Internationalization&localization dev / =E5=A4=A7=E9=98=AA=E5=A4=A7=E5=AD=
=A6
Takeshi Nishimura <takeshi.nishimura.linux@gmail.com>
