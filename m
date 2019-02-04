Return-Path: <SRS0=rNbD=QL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C8BC282C4
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Feb 2019 19:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC51920821
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Feb 2019 19:31:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="PZo2AlEt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbfBDTbr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Feb 2019 14:31:47 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39778 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfBDTbq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2019 14:31:46 -0500
Received: by mail-pl1-f194.google.com with SMTP id 101so391088pld.6
        for <linux-ext4@vger.kernel.org>; Mon, 04 Feb 2019 11:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=AhLc97Jv6QAdhtdoWraCNs3f3pafCeyrXV1LQqGCxZ8=;
        b=PZo2AlEt/gUHltBZ2UdHuXFp2g2EJNBMz1gnqjrvp6ie295WAN0dFKNCQLmCwv9zM+
         4sMQqyJRzGI/tCeF1znAUic8ZvKh5l+qqE8SADA9CXW34yxumD3HCe3jyR6GUnKfQiE7
         k87oex8pi5PcX5ALFtVgji7sfuD/Ne5r6JhIFLF9VCsSNpgP9Nt9tkZ2bpFXQyPA0Ci5
         xpldbvvz3m4K0uE9i9gbNRIS/X5hvcAjZ5pL5aryrmH8AXAEEbEBqKRCnxiMtVtrZIiZ
         0MJTmMrdJKPj9cmWstoPwbxw+acNlvIg1SR5hgMJzuQ2FIHn7qVuteceIUTh8A1V8Dgr
         1cWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=AhLc97Jv6QAdhtdoWraCNs3f3pafCeyrXV1LQqGCxZ8=;
        b=arlCdjjLM53ZJ4ZWAj/6YeQuTd1p0osvKSBBP3QVM4Vk9nUMDkAl9+H8TnHI/NJMll
         4fIyOHc+LyuXPKMvtprxbmC8J0uVjfJDTWe7bbheGzLwtrJ/BGnAB4h6nsXWDQxSEeVA
         +a70/5VqjItEw/q8XT5MlqM/oliaYCC6fhHGqWvK3l62VF5OBjmciI9uKV1z3Wz61Rbn
         P8PUgJXNCa8BSNknb/RzHmaOn4kAXDcH5PrwttDczZFSIPEUNaP9k3MCCCv8k5bKrQ7O
         Fbn3qIO0kTa/hU+WsU2DuzWTkFlWo1cnxKb2fUIq9QiTM6O1fZ+T776y0DxT733jmBur
         ftvA==
X-Gm-Message-State: AHQUAuYGpREyMS8R13+CRBKybXfBvaJcdNzpa1MTil+Lq+niKRjsIVDA
        tKC5HJDklQT9sKrmcwxVMYlz3A==
X-Google-Smtp-Source: AHgI3IZep4jwxUtNaoUeOHD0L7Hz2B3rA5I607DwyOITVlioQdVN0StpDGWqUXYg68OafZr5oyIETg==
X-Received: by 2002:a17:902:a40d:: with SMTP id p13mr999592plq.59.1549308705788;
        Mon, 04 Feb 2019 11:31:45 -0800 (PST)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id i5sm1097453pfg.34.2019.02.04.11.31.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 11:31:44 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <818181A2-66E3-42D3-A65E-64F950C48516@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_5D6FB81B-DA5D-4A8A-A593-F41BC084E941";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2] ext4: shrink directory when last block is empty
Date:   Mon, 4 Feb 2019 12:31:40 -0700
In-Reply-To: <20190201093813.122491-1-harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu, umka@cloudlinux.com
To:     harshadshirwadkar@gmail.com
References: <20190201093813.122491-1-harshadshirwadkar@gmail.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_5D6FB81B-DA5D-4A8A-A593-F41BC084E941
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Feb 1, 2019, at 2:38 AM, harshadshirwadkar@gmail.com wrote:
> 
> From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
> 
> This patch is the first step towards shrinking htree based directories
> when files are deleted. We truncate directory inode when a directory
> entry removal causes last directory block to be empty. In order to be
> backwards compatible, we don't remove empty last directory block if it
> results in one of the intermediate htree nodes to be empty.
> 
> Changes since v1:
> - not freeing the last block if it makes intermediate htree block empty
> - style fixes
> 
> Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

Some minor style nits below, but looks fine otherwise, you can add:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Have you run any kind of test (e.g. create 100k entries, ls -ld to get the
directory size, delete all entries, ls -ld to get the final "empty" size)
to see how much the directory shrinks from the maximum size?  Some info
about how well this works without further optimizations would be useful to
include into the commit comment.

It would also be good to run a loop with the above workload creating files
with different names (to change hash ordering), then unmount the filesystem
and run "e2fsck -f" on it to verify there are no errors introduced.

As the next step, it makes sense to implement checking if the previous leaf
block in the directory is also empty and free that as well.  Even before we
get to recursively freeing htree index blocks, being able to free all but
one leaf block per htree would give us a 509x reduction in space used by the
directory.

Cheers, Andreas

> +static inline bool is_empty_dirent_block(struct inode *dir,
> +					 struct buffer_head *bh)
> +{
> +	struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)bh->b_data;
> +
> +	return 	ext4_rec_len_from_disk(de->rec_len, dir->i_sb->s_blocksize)

(style) remove extra space after "return"

> +			== dir->i_sb->s_blocksize && de->inode == 0;
> +}

(style) "==" should go at the end of the previous line


Cheers, Andreas






--Apple-Mail=_5D6FB81B-DA5D-4A8A-A593-F41BC084E941
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxYkx0ACgkQcqXauRfM
H+Dj/Q/+NsNMo4mHuEVfEnb+avBwWaldYX/OzIX1zGkH/NvQSosKqb3tV7DAmrXa
NNY/z6E/86ODqdE5C3Z9E7dVRufhPyebAZfo98Pndj14ERr4OT8xN51SF5pNUHYi
1ls1S4s/DVzRcpHlHUte9Mgg0ilHSEg5+vafEeS3JazCzCCeRHRF66bQj2vnfCX7
tTkrQx0J5DbhBPhCOfa/29jivMj7k8hOYf/ZeO6XPHLAtFUN+I2RwJ8ZkMM6conf
WseYa1sp8NVQUoYnZFKT7UpU51BLzVX0PLORiUNSNOf3hBBE4bYg3jjf5CYTwXYr
Pfn40YjbvCVjiXNZCleGj5cf8LJEpp+xog+ARx6CnJ4FbgPzWJkV730G6JECnDEo
rrm5rvltKgcsy1IH3RU++1k6ipr3BWptNEwhQqaKVvgLu8qWdId5jVb6K84w7MW/
3P2JQpd0dnFY5yqkhIvMKq/bFG0NKBqRr3dDqE2fEKNPKahN2gZBTvq80d0THXOZ
+vIVDIqC/I/mYTF/U89UPVVWOBdcMDxNyyUzhkxoyPLse/RyAkDtHCuRB8FDsP6n
bFJjcodgIFQwMqZCfxTl0jtF9wn0nsxDoEX/YXGwWy9OiNF4Ksf6u+j4GY8KGboN
0xDuYLSqE79N2wsH38eRc8wxubLPHvyFLJRs1dfj4bX8Jpx3Ig4=
=RRX2
-----END PGP SIGNATURE-----

--Apple-Mail=_5D6FB81B-DA5D-4A8A-A593-F41BC084E941--
