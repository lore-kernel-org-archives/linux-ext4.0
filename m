Return-Path: <SRS0=QItb=SB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05896C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 17:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4373217F5
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 17:50:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="QCa3yDb+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbfC3Rt7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 30 Mar 2019 13:49:59 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43620 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730526AbfC3Rt7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Mar 2019 13:49:59 -0400
Received: by mail-pl1-f193.google.com with SMTP id m10so2480478plt.10
        for <linux-ext4@vger.kernel.org>; Sat, 30 Mar 2019 10:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=8E+hSaYs/8++lmDMWklBVfbX6BTWou/pcJgdoUvO0os=;
        b=QCa3yDb+iNw0osJacHzYOCRkgFfmkqDBKYlIfuVbgbhf7fHFe5p2uEu7aEuMtfHYqI
         JzmcN1DE6BSXUaPSL1X76c4g8W1wy7gP2Bkc176G3tEQd64lOfEGKCZmtb4jK2/CUerI
         UzrVw709m+w3SYVnKzS3hxH+wdWrnWPGESfJlfSeOqGmUU+Lc+urwnvvLOPqSQa3/r/r
         KPXpuUFsCR7zoAgIUIk2nPCp0dqpK4L6+PfVYMlNPCiSr3iJAPABR/de4LV2IdIEfxJa
         kZtIhzVYEg6PPU9aVbZ82MCleTRKmsxFhPGg58Jb7tDRPPQQNlDefpXRjivEK/E8nD4G
         ZNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=8E+hSaYs/8++lmDMWklBVfbX6BTWou/pcJgdoUvO0os=;
        b=F2v96tqq5FRGcZ1ujiKYN7MAkq0ortp/SGtrHiYoy+jbxtvGruAnsYfqjbYi4Bdw5Q
         70MGXeYRU6ap93t5aw76os4V0ii9wEZbh5hsYX9gMd0gqJrnL51pK9QMiGGUQFUg6YZr
         ZPKtFRpgZRsoTwm4CawfAIG3MFuC7YxUjwVxKgBQeIKTg3Kv05Hict3+XEm75w85Ts4w
         L9Mdmi2SB/sqHtXVbJtYGX87NVPlsjoRFbX5Y/L/30vImdGAhrIriapYplIXkHEY3x74
         mQIJ9WwNB4iccsCO3A0k/DucSvQfNYSNxBLMF+Cx7P7NaIUMgvnOWBe5fLVNMXUzWI5C
         Z5gg==
X-Gm-Message-State: APjAAAU4Z7hGBL6ceBeqEl+5H6ky4gYdZNhxkX95ePNjKn931H9mNKCa
        TjeWLDkQYrSU0xZcfy44d90LRg==
X-Google-Smtp-Source: APXvYqyoY7MgnueM5G4NMe7D1uz7wvFm+hVIKps1KQcenUgtwd/kD9ffpLauBkb0p2QhpPpNhlvz0w==
X-Received: by 2002:a17:902:4681:: with SMTP id p1mr53635525pld.42.1553968198379;
        Sat, 30 Mar 2019 10:49:58 -0700 (PDT)
Received: from cabot.adilger.ext (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id z8sm8346133pgz.3.2019.03.30.10.49.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 Mar 2019 10:49:57 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <4B0B5E8B-3B30-4CF6-AA9D-D1294542D65D@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_65735BA2-2B7A-4927-B12D-267E456AC8C8";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v3 7/7] fs/ext4,jbd2: add support for passing write-hint
 with journal
Date:   Sat, 30 Mar 2019 11:49:54 -0600
In-Reply-To: <1553846032-4451-8-git-send-email-joshi.k@samsung.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, axboe@fb.com, prakash.v@samsung.com,
        anshul@samsung.com, joshiiitr@gmail.com
To:     Kanchan Joshi <joshi.k@samsung.com>
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
 <CGME20190329075800epcas2p4731f10eabf7d70dc7096117d161b05a3@epcas2p4.samsung.com>
 <1553846032-4451-8-git-send-email-joshi.k@samsung.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_65735BA2-2B7A-4927-B12D-267E456AC8C8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 29, 2019, at 1:53 AM, Kanchan Joshi <joshi.k@samsung.com> wrote:
>=20
> For NAND based SSDs, mixing of data with different life-time reduces
> efficiency of internal garbage-collection. During FS operations, =
series
> of journal updates will follow/precede series of data/meta updates, =
causing
> intermixing inside SSD. By passing a write-hint with journal, its =
write
> can be isolated from other data/meta writes, leading to =
endurance/performance
> benefit on SSD.
>=20
> This patch introduces "j_writehint" member in JBD2 journal, using =
which
> Ext4 specifies write-hint (as SHORT) for journal

The comment here says the "WRITE_LIFE_SHORT" hint is used for the =
journal,
but the code uses WRITE_LIFE_KERN_MIN.  However, it seems that "MIN" =
will
be mapped to "NONE" if it exceeds the number of streams available in the
underlying device.  It would be better to use "SHORT" if there are not
enough streams available.

It should call blk_queue_stream_limits() to see if there are extra =
stream
IDs available, and fall back to WRITE_LIFE_SHORT if not.

Cheers, Andreas

> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
> fs/ext4/ext4_jbd2.h  |  1 +
> fs/ext4/super.c      |  2 ++
> fs/jbd2/commit.c     | 11 +++++++----
> fs/jbd2/journal.c    |  3 ++-
> fs/jbd2/revoke.c     |  3 ++-
> include/linux/jbd2.h |  8 ++++++++
> 6 files changed, 22 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 15b6dd7..b589ca4 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -16,6 +16,7 @@
> #include <linux/jbd2.h>
> #include "ext4.h"
>=20
> +#define EXT4_JOURNAL_WRITE_HINT (WRITE_LIFE_KERN_MIN)
> #define EXT4_JOURNAL(inode)	(EXT4_SB((inode)->i_sb)->s_journal)
>=20
> /* Define the number of blocks we need to account to a transaction to
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index fb12d3c..9c2c73e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4289,6 +4289,8 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>=20
> 	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
>=20
> +	sbi->s_journal->j_writehint =3D EXT4_JOURNAL_WRITE_HINT;
> +
> 	sbi->s_journal->j_commit_callback =3D =
ext4_journal_commit_callback;
>=20
> no_journal:
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 2eb55c3..6da4c28 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -153,10 +153,12 @@ static int =
journal_submit_commit_record(journal_t *journal,
>=20
> 	if (journal->j_flags & JBD2_BARRIER &&
> 	    !jbd2_has_feature_async_commit(journal))
> -		ret =3D submit_bh(REQ_OP_WRITE,
> -			REQ_SYNC | REQ_PREFLUSH | REQ_FUA, bh);
> +		ret =3D submit_bh_write_hint(REQ_OP_WRITE,
> +			REQ_SYNC | REQ_PREFLUSH | REQ_FUA, bh,
> +			journal->j_writehint);
> 	else
> -		ret =3D submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
> +		ret =3D submit_bh_write_hint(REQ_OP_WRITE, REQ_SYNC, bh,
> +			journal->j_writehint);
>=20
> 	*cbh =3D bh;
> 	return ret;
> @@ -711,7 +713,8 @@ void jbd2_journal_commit_transaction(journal_t =
*journal)
> 				clear_buffer_dirty(bh);
> 				set_buffer_uptodate(bh);
> 				bh->b_end_io =3D =
journal_end_buffer_io_sync;
> -				submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
> +				submit_bh_write_hint(REQ_OP_WRITE, =
REQ_SYNC,
> +						bh, =
journal->j_writehint);
> 			}
> 			cond_resched();
> 			stats.run.rs_blocks_logged +=3D bufs;
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 8ef6b6d..804dc2c 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1384,7 +1384,8 @@ static int jbd2_write_superblock(journal_t =
*journal, int write_flags)
> 	jbd2_superblock_csum_set(journal, sb);
> 	get_bh(bh);
> 	bh->b_end_io =3D end_buffer_write_sync;
> -	ret =3D submit_bh(REQ_OP_WRITE, write_flags, bh);
> +	ret =3D submit_bh_write_hint(REQ_OP_WRITE, write_flags, bh,
> +				journal->j_writehint);
> 	wait_on_buffer(bh);
> 	if (buffer_write_io_error(bh)) {
> 		clear_buffer_write_io_error(bh);
> diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
> index a1143e5..376b1d8 100644
> --- a/fs/jbd2/revoke.c
> +++ b/fs/jbd2/revoke.c
> @@ -642,7 +642,8 @@ static void flush_descriptor(journal_t *journal,
> 	set_buffer_jwrite(descriptor);
> 	BUFFER_TRACE(descriptor, "write");
> 	set_buffer_dirty(descriptor);
> -	write_dirty_buffer(descriptor, REQ_SYNC);
> +	write_dirty_buffer_with_hint(descriptor, REQ_SYNC,
> +				journal->j_writehint);
> }
> #endif
>=20
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 0f919d5..918f21e 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1139,6 +1139,14 @@ struct journal_s
> 	 */
> 	__u32 j_csum_seed;
>=20
> +	/**
> +	 * @j_writehint:
> +	 *
> +	 * write-hint for journal (set by FS).
> +	 */
> +	enum rw_hint	j_writehint;
> +
> +
> #ifdef CONFIG_DEBUG_LOCK_ALLOC
> 	/**
> 	 * @j_trans_commit_map:
> --
> 2.7.4
>=20


Cheers, Andreas






--Apple-Mail=_65735BA2-2B7A-4927-B12D-267E456AC8C8
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlyfrEMACgkQcqXauRfM
H+Awog//R0q+wZ7sWDziORQpf4h0sVTnHqSOZIqEoU/iIdGKX4u7Pj4VoBTnc8o/
Jd+MS8J0dioOzU6Pg3yU0vX7Ic38VBLGV4ORpRg5xOqG3EDHU2hzO73VEQokSUPK
vphNY7J6EJJWRWb8oD2inEWh2RZQ93y/MCjhZS3K2PVW5EqfrN7USfomzNE1LPnv
L3sStO3rCafsAwW8N46BJF4gscgW2Xk2K885XV2Uy4MPIcM6MjbVrn7xd5VDTfxx
T+XwHLGtEz1UOe5/U/+YkxbvjDpj7r3xqZ9OpEnsL0ozlIR5B21L12qCVdxCJwWn
L+yKsECM68yWDFKN8+s8YEnGjNUx+A5wQSDJL5Zcxa3ahFIL/RX5ivUEgq10f5JU
1QOyeFd/fyBbhjFTwzsvKh78dcNpAKPZ5IpQJ66sMNJXeG1rXjaqW0i3nRbJYzYi
CypU0e0pAPzFzJ+a2g881zPXPtIvmqL0nlp2FPdYXtfqkVADyqlW67R7TJuh3+oZ
vNND3y0AlmvDKA8B+G4Z8PSPhcFX14pVKGocvSKwk8BIR0EPaHdqLiLAmSiqlnN0
lXrRSNjn2QUqpWhcKDYjErkgo7GLB1nRnYzrGGTQ+zg8KACmqlbDunjubyDAPkO+
y0byklIvIi6UdV6BI4WnpC2k6RSR3EZcGR5EmZBGjueLFWK/sqM=
=+O2I
-----END PGP SIGNATURE-----

--Apple-Mail=_65735BA2-2B7A-4927-B12D-267E456AC8C8--
