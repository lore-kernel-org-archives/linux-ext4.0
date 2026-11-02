Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600225;
	b=HlsLzCF1YeiXeak7NdtzigsqbK2/0O54YiDtEu4Y3UG7Vs1/03k0T1QAPjBRS5xmJpeG
	 ly0/ofbvNNyg34EjITWVyNk/WVTuZWszYpWPPTy7dpLVnbafLxgDCUP27wBjcIDLJn3zV
	 x5BGEjlTfIOhSYEwNvDefj07nsAuFamu4vehIeu9B8qikV/rPAUPby8Wov0gsB54J4Q/A
	 B5yS2GE6Bth31aoLqusDvjn9SC+STyDNu+OQx6C6qYa12s+zEuMFIHDwUXL/Qqz+DqvPK
	 gfeKv7a5urvclyq0UXD1RhagYshlu5q4o7dfMcHdo9YnPPwWlONN2oAXUCeCS2eIHLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600225;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JIuVYhzDr7tBsDpbhyh1CCeaiWBRpMDlHv7fDLl13QY=;
	b=pcgx+A3ut0ppvXuH3QZ0zqjixVvTo8k+lza2G6Yz57vn0CeeYxz8Q0Sk3FgWEdVDpZiT
	 4imqgX1/GB5RIjI7TLuF0mQF27p4ZtmXk+6YtZ7epuvawL6xzkuYU9tilF2y/1BEJzTvZ
	 sAs/2ykgCYF0k6BU9ATK2+qwmCo0CXut2GrUSG4mDSkEGdsO+SN+zyfPDg6Dywdiw3Vu3
	 uIn4sOPTA3ZBNV6M2Q+MQGEvcARLtOxiVmu+qypVCVSDcrQg9a298A0+d085tOTLyRv1d
	 DLDKS0o7S7rMKpjJZnGrWonh7u/uPiYk7mzvOgmBQRWkLJr22tWVo9GJsxsgG6/RrCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mAr9hJBE;
	arc=none smtp.remote-ip=74.125.229.8
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03A3606A329
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 06:17:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A03A3606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mAr9hJBE
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-369fd8abd71so2907800eec.1
        for <linux-ext4@vger.kernel.org>; Sun, 01 Nov 2026 22:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793600224; x=1794205024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JIuVYhzDr7tBsDpbhyh1CCeaiWBRpMDlHv7fDLl13QY=;
        b=mAr9hJBEtrch/cLsG+l8iSEMx4rie4Rq4wlLYZk8IblWD+idnG+d8AlYE8h1J/sL3d
         /LjNBZa6flPW/Y6ma7ooi8LTW7ZzlIICfQYKXRnuVi7zPSQwFYRkFdwvRZIjKI9BzuGn
         Wt/shzDTFefyt/XpNgduVodd2GE4fL86Jmbsz+eOod0tKtp0YIqLY77loE/asc9gimx2
         bIqcYL3qmBQM8E+30KuNspN3diiprMKamCjuXBneBj5zDNedznko9Cbv60tQNuFAYRKH
         rXsW2ZPccAGZp6LU0u6lr7T+YMmtWyyYUsLBHF/BUUtDL2cdqONMsY9rw2F9KLfK9hr6
         SQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793600224; x=1794205024;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JIuVYhzDr7tBsDpbhyh1CCeaiWBRpMDlHv7fDLl13QY=;
        b=hwP1a/VtFh4vdt9vOCVjW4v+/BSz9tujMHRMbGPyt5JlZdb3I7o/F8DpRQyrvTG0Tq
         KPaiCj0JRr7KaNInZteCy7PuCnzi9/cAjIlBGFSHHfGOyNsdQqG4Xk7E9zzc+ltlmHUn
         F2gLl0DoGU4C15wPNjVHNRTJZTdGn91Z+jbMFcL99ALXC5j6kHE6KQzLIRbtt6jBzJJh
         DCiMWZzd8+3C3vSpEAizTxrZW5tXFsDAwyMdw1MSjRERT8vdjb+GyRRUcmF31W227uFP
         /VJtNlDa8Hn/BivyFtuI/SMcts2qZxxfSvQdWG7QbNH4EUFtyd8yZpcjX6F7eBRaIma+
         gBdg==
X-Forwarded-Encrypted: i=1; AKwUvBzxvACBMLb+/jSKdV+6LJ40yH7rOQ4m9f4Fm+at/k7I5y63TU0E+lqz59LlTXzmsGob6JeAkaq/5LeL@vger.kernel.org
X-Gm-Message-State: APuU4Z/P144fI2BrS5iqFhoaiyi76cgvGkX29u/mPk8Am9Lzx/jfNTwu
	CzCinvTgXwThXAMeY1JHQ0WE2jv+ct+nP2jyniSpG9btcJz+eVthaagC
X-Gm-Gg: AYBFou1SulRS6T9B0PYKbLknhbtID5sjUTGsvwHwxlNb9SxkPKxIruRbPHmYesa2+yH
	SCZg/Hhdd+AeLn41ERa6ZttJTZw7zB6Nb3o16rEube9Q123nGIejKBdPhQNeKRoq81/I4wLg8Ji
	Sr4Jalc2WAMOjtO+/rSPwo5diRNi1NsECMfgFIlQ/F3ce9Id+hlRSvVuRRmkxC9zMcGfJks1QrS
	m8QisqrudsK/VfwIJtJTEMA7UorrcUb0rP/wcVh8om8ENgaOdCF0zQBshz6olxFzRNYH7q5VNy6
	hlG4OVuTW48Q22PJt1vUzsP1vWptEpLrhz5O0LMZomJ7EGBkItOpoELIH3ey9/EA+GPIhQqarXf
	5xqYjzyQBuJJIRdUPpJ6vyVq3/yPzJ3A3brZ2XlsF+L2LYXsG916vfnAHtZPeamiT7LFAA86Dzi
	HKHxii8T6HCTHjdLn2uFco9jBdg8voP7Ca2pEQI89w3ZZ8p6LcMpUGEbOvHgKs6Sv/8EC2pPX9C
	8OSE/TuxEsfF0ocURJpErqzEMaPV2fYKWyRJw+C2gu9YXuExGfFbG0Vax+JR4aOskY4l9gXIiRj
	RqCm42qODqD+DiZp7hmBS4Nsk2E8Ju6d4JkKzQ/RYJ8LlNeu1f5fRQ1s
X-Received: by 2002:a05:7300:4353:b0:369:fc93:eda5 with SMTP id 5a478bee46e88-36a42434630mr21125404eec.39.1793600222582;
        Sun, 01 Nov 2026 22:17:02 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42a6f7f9sm39820872eec.25.2026.11.01.22.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:17:02 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: Jan Kara <jack@suse.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH] ext2: preserve completed DIO bytes when buffered fallback fails
Date: Mon,  2 Nov 2026 06:15:55 +0000
Message-ID: <20261102061555.55183-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext2_dio_write_iter() can complete part of a direct write before
falling back to buffered I/O for a hole inside i_size. If
generic_perform_write() then fails, its error overwrites the completed
direct-I/O byte count.

For example, on a full filesystem, an 8 KiB write to a file with an
allocated 4 KiB prefix and a 4 KiB hole overwrites the prefix but returns
ENOSPC and leaves the file position unchanged. GNU dd with oflag=direct
consequently reports zero bytes written.

Preserve a positive direct-I/O result and return the buffered error
when no bytes were direct-written. This restores the fallback policy of
generic_file_write_iter(), which ext2 used before its iomap conversion.

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 fs/ext2/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 67fe423c3828..8ddc149d4884 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -145,7 +145,8 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		pos = iocb->ki_pos;
 		status = generic_perform_write(iocb, from);
 		if (unlikely(status < 0)) {
-			ret = status;
+			if (!ret)
+				ret = status;
 			goto out_unlock;
 		}
 
-- 
2.43.0

