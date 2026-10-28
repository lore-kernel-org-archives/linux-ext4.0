Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793201780;
	b=Ka2AvxsgUW7+zzyTJuJEGrnts2C+V21xpAS6gOmHOTGwEdQJeKswJpVF3l9wtaHm+OZu
	 CIl4txBO4fnIvOnfPwMq4Z9TGjN1WFHqpel3E9PkEW6QIMGen3ue8dtSTBZUtcI6XN6hH
	 5MmbczsWPClJ4cw7KFa9VWQD1OYgVBHh4KxeFXt8fKA2k0XXqgCAi8NK3dGuD4FNlH/om
	 zcJ0tWPYODswMHeYakyCpmj8gnCKj6YHqvNCWHq5HGeigKy24dPmSU2R5LNM0tPpy9bLJ
	 3F+n3Ef7pZ4QHFxwulAbodYCGaE05z5yhNoXqTSxFpK8sK0I5OHhX2uSObyij7boxmQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201780;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
	b=VtTDJrbT7/j9nMcUf/q4dkKLS1ZcwDrQ0mGstK6S3gebXLKUPAyGPq/ws8DZg29oBU8i
	 SbZtM5VB4Pe+KYjWdzp5QIMOOy8AGVtYNR7HSxxhbBloxjwWSvdUqA9Ga3FgUJt7BApza
	 w95WDAFgFvRRlAklK0ec8fHG4KNHj1Lipdom87bj3bqwUXds8SU9NAYhnoCfeyE+VPuaS
	 RIukbn47VHtQY2oCOrKNspAaFJ1NAxhuAC/SpR74vqLEMMDEMfJB1zbC3rqvbWFG+ygOn
	 KfFa8xRmNykcWcO6cBDoye8VrHHWxmvmvtqZDHVBSCOfk34QEeKtPWDv8oBYKfQsrFQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="o8+eS/kO";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D5E60A2620
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2026 15:36:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6D5E60A2620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=o8+eS/kO
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b1aa27963eso3449168a12.1
        for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2026 08:36:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793201778; cv=none;
        d=google.com; s=arc-20260327;
        b=BSJctetnsXe8wqyjbUwUp7TiZ7nT2jQI3qeyeEunJpeeD5gv4TIdpR4PqhjYzNbxhw
         C404TAVJfaYumDUU6cvW+amnRFiKiKHyxdfxJsXZx32fnQEGsEm24lnjh1ROkq4iYX2b
         iqIJROeXdkeZLxX2gzh7pGZgBPy4aAxkot0MH4dAQZYOYyAH7IGs5ixvJYpL3j++/Kgk
         FTNtrNy4y28Wm6DGWKNE8dKgvmVJYsEQwbGxNCHI1asZU3jT2994sr1Fm6DXBRxJJnn7
         pYfgGi3rHjCCYVGTg8SHc8Qe4E5RfNrBUzUh8Wuhg2aOMXKOGZ+1tsQLPMmXaPd39ie2
         6H5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
        fh=ysEhw9n5Bqu/WS3TuZ3pq+fDC3XcyMHA8zq77ARNno8=;
        b=f2qPxavKXcs9udbdm238iikbvwO14t/PqRIVyJRQ5umoVFGdXJlAxaLVDqrx+8vA8a
         2bLRTJOLhifLZDwmnqoBBBr073/qdnX9uhMP4O8sUan/V7WVRg6hoYIZt2Fq8pWG/9S+
         noWmXN8dHXWIevSvhNpEdnDY0BjFttdCGaMFRCtMBpgU+SAanUtjLek9ik8E2TFmXSBH
         mV4ssMs7vvTzcQOciGJl4MxaMIOpDNL6cqXKeq8nfqJaGsz4a/GPgi5enbTRAejF1/9Y
         W5/QUv74FKE6g5ZuirMTN5WjaJrU0UITV0x+0pw8U5uSwKaiciu2EtVzCm6SE6RphtJy
         8HLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793201778; x=1793806578; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
        b=o8+eS/kOJnmSQQuDmyzKcnpM8XIf62WHDcQTpfgGgAc33ST6Cpvb/Avm5gCEO3G83f
         mwT5WJaRXBMVxl81EO5AaJjNxHST8plT8azYXYCCF/zkFLzRRxL39DAnbyDEtc0izQ7z
         BXoAb+hBgpOG2MczfmPvBVDGk/iwK7R5wDwXpDgw00NJCrhcdpnLJlcQCfyX7fUAE/q3
         TuCIcIAJMA+UYbeKn4XOSAztm+6f2MAyPPJZPpKrZOIFxUTkZmyPclmqG21F1aEzhplB
         iTR/S6KCchmPfCqzmnzIC7zf+BT3HW7rmx33Rm1wtRiZPxIFwLBfca6G1MEP1JTTmXMW
         ehHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793201778; x=1793806578;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Bz0lN3WwW56lrjEyeicNzFHRzWGZupLlnq02xtOwZE=;
        b=2swwRq11EExJwv3fl9bFhT/fX2kz9TmQd5Y48wdCoLHjFxGgbC5/XuLL0oqqU+DYv1
         XZKDmUxh5YWV+qDGesFX9cZASKjwGgRnSMZ7+A+pDQpe15lvMZYOXcmVrgMysIfJGm80
         wtVCoPc6Kij7TkYI+EqFSrKQrgbORQ+Qgn8SU6KHEVcLx2nEy5d+Lpa15Q4b6mPiYlYI
         Ki98GogmVHjjK7antU/dkxbmqjzZTFxmnBDJba7GHVT5V89kVjjOFlByyDm4r0R1rvqb
         DQ0qkYvCUn8ooZ54/1S+BfvIc8FPxeKXxEZ/tZmie0b674zt/1114S0gIYoLy9gSs1qi
         ifzQ==
X-Forwarded-Encrypted: i=1; AKwUvBwgJtgI4/yr/AekWRxy3ihK4PbllOUQn4cFOR8ZTxYGcMFmaKNZtDE5yNZ6O6ANPFqxRv0mqOwmsUZP@vger.kernel.org
X-Gm-Message-State: AFq9FYLCGDGAbC2vTJDGLhtUSK6MxC/oqP60ujFDJNNc6M48GApaIkZB
	zPImYIDR+y/q3GFIHWR+SyKSuKZdy9GnwIF4Xvv0TMuOBHMOAM0bKYVDEVTzIYKbeDUeJgZ1OeI
	zSjs1NsBP3Mk/0cPS6IamKnclVE0ecfM=
X-Gm-Gg: AYBFou1GXKpwM7nLSAQ4d770ymZ1zZZ872bithjFRcWWIzz/DG8gIJkQLAWoGPww94R
	0S7NNok8zt2HrPa0BTX+fcAHQjB7MmvRVfPCu7pZZ9YqmL0tVOWloxrPXrjRd6E8R/Qy371q6vC
	IBwOouh6eBF7tHKmbzURh5YwYy+Jl3GEYVK/Pu3jwmHxcAdlnaVH8hn5lvWVwPlO6CNCEARrsNP
	2IzJJMZFBqMVt6Il3FvsClBlqAHTxhHhJFu6bvpYWeuRFxy2bIj6IO6bNtvTMRbtnJ2ylzYLdAp
	y26zpJhskOi556JWRTU9EUMBKbJzNFp46uekN83ZVtQOPLmFR667oXqkw7k6ez3RkqAOpqpHUkW
	k8n1HlaUb385kaVN3T98jr9g6P6EC9qi+U1BK7aOIgDzR+YNmycyh7DOnGUT196MWNb71rQ==
X-Received: by 2002:aa7:d955:0:b0:6b3:b0b2:6e7 with SMTP id
 4fb4d7f45d1cf-6b47bcde687mr3518808a12.18.1793201777944; Wed, 28 Oct 2026
 08:36:17 -0700 (PDT)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 28 Oct 2026 17:36:06 +0200
X-Gm-Features: AclHuK-uy9OcEc2oh0_9o59ea-Px6xRmZClAxF9aj0taY8198qZo83-6yRUk1Js
Message-ID: <CAOQ4uxjNWagHSXM0q+3q-SwX1RRun746iSsfyoR-4fLjcqH16A@mail.gmail.com>
Subject: Re: [PATCH 01/10] fs: add SB_I_OVL_USE_SYNC_FS
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>, 
	Carlos Maiolino <cem@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 11:09=E2=80=AFPM Josef Bacik <josef@toxicpanda.com>=
 wrote:
>
> sync_filesystem() writes every dirty inode of a filesystem and then calls
> ->sync_fs().  The data needs that.  Whether the metadata does depends on
> the filesystem.  ext2 copies an inode to its buffer in ->write_inode() an=
d
> nowhere else.  A filesystem which logs its metadata has recorded the
> change when it was made, and ->sync_fs() commits the log.
>
> overlayfs wants to sync what was changed through one overlay instead of
> the whole upper filesystem.  It knows which inodes it wrote data to.  It
> has a much harder time with all the inodes which the upper filesystem
> dirtied on its behalf, many of which it has no inode of its own for:
> whiteouts, index entries, work directories, the parents of all of them.
> With a filesystem which logs its metadata it doesn't have to know.
>
> Add SB_I_OVL_USE_SYNC_FS, by which a filesystem says that ->sync_fs() wit=
h
> wait set makes every change of metadata durable which was made before the
> call, whether ->write_inode() was called for the inode or not.  Timestamp=
s
> which lazytime holds back are not covered by that.  As an upper filesyste=
m
> of overlayfs it then gets ->sync_fs() instead of sync_filesystem().
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  include/linux/fs/super_types.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_type=
s.h
> index 72f4288e16c5..370b0d27815b 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -359,5 +359,6 @@ struct super_block {
>  #define SB_I_NOIDMAP   0x00002000      /* No idmapped mounts on this sup=
erblock */
>  #define SB_I_ALLOW_HSM 0x00004000      /* Allow HSM events on this super=
block */
>  #define SB_I_NO_DATA_INTEGRITY 0x00008000 /* fs cannot guarantee data pe=
rsistence on sync */
> +#define SB_I_OVL_USE_SYNC_FS   0x00010000 /* overlayfs: ->sync_fs() comm=
its all metadata */
>


I have some reservations about the flag name (how could I not).
Not easy, but can we try the flag to describe the contract?

I am interested to know if the same flag or maybe even a more
strict contract which is fulfilled by ext4/xfs/btrfs could be
used to help determine ovl_should_sync_metadata() -

In commit 7d6899fb69d25 ("ovl: fsync after metadata copy-up")
we added fsync on parent directories and metadata after copy up
to fix correctness on ubifs.

In commit 1f6ee9be92f8d ("ovl: make fsync after metadata copy-up
opt-in mount option") fsync=3Dstrict was created for opting-in to fsync
parent dirs on copy up, after a report on regression over ext4 when
due to the unconditional metadata fsync.

I am wondering whether fsync=3Dauto could decide regarding fsync of
metadata on copy up depending on the flag, so metadata would be
fsynced on ubifs and not fsynced on ext4.

The problem is that your flag speaks of the metadata ordering contract
of sync_fs(sb) and my interest is the metadata ordering contract of
fsync(inode).

To be more specific, in this sequence:
mkdir t1
chmod 700 t1
mv t1 A
mkdir t2
chmod 700 t2
mv t2 A/B
touch t3
chmod 600 t3
sync -d t3
mv t3 A/B/foo

When A/B/foo is observed after a crash, in xfs I know that because
all metadata writes are serialized in the single transaction, the mode
of parents is correct.

Not sure about btrfs and ext4 fast commit.

If you think that the answer is that they provide the same guaranty
then if the flag could be named something like
SB_I_ORDERED_METADATA or something and
the contract is documented, then perhaps it also fits the
sync_fs case, because what you really want to know is that
sync_fs persistent the metadata that the inode depends on.

Am I talking nonsense?

Thanks,
Amir.
