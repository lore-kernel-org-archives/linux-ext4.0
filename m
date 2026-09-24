Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F27049E5DA
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 15:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790262964; cv=none; b=p+G7vtHR86XktktKJvhjZcoUcwXtN4L8uG2xib958b1y/iKcnLgQsj42JdlKIRMw4ULDjF8Pk8PPAYBt2oR0W0wvIkfmBAflhZI8qDElO6MZ0d2e+3hhZT8+jiiqlTRyLT/lr/g8BgRQ6FeVJbA6MEiUNvBCsOlK4bX33MphyXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790262964; c=relaxed/simple;
	bh=qyPoVSR50bd9pnnpnUgmjAX3bTxJsz9pjKorGAHMsa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dsv/Dydl+OMGw97D/ozkYcsj+vKQOAeo+ZZJcAtjUD8N82sIVATgMW7Ocb4MBcjjX7gMRV2RmR0xYwB0YjAGLwFjVkzAAs6/9drxysTNlwYF9MLi9cCey1Du0B4nJ/ZBFMin85xyU0B6tRa7Cl5PlT41sGYHhr3ZDU/CKE5NHjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=TrACtS4t; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="TrACtS4t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	From:Reply-To; bh=yuaRWDcPf1ShwyOsEF37tu+L9LFp6Tb/2ylCi1CWR04=; b=TrACtS4tAWk
	GS5F+yGvVnzwrTrs/H8D6Ty+1cuCKBdvVKffyG/lP/iVF3fel8yJgq+6yIZHUzbUVQoRb/dXgXU1S
	1HGFT9EZGBtWKnlotV7bYNiwragqt/b7mLMwP3rGKsptr7X41B0vJskZyzrI7lkjvWUHmu3nK8flj
	XZMtkRCfAMz+ctOf94Xhd053eRvzVcnsngG4EHpK7U98jaez8xth65dv0UPKK6Ei4QXd7CRCDD1XQ
	qodxVQQNZJKf3qBuf+Gz+QNuEwv9YP8xCOG73Unglq2N9fCeu00SJ6zy2YSlXAwvAEiyDz/7F619b
	yypzwMB9PaQ7QrZ0Z2gFCCg==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x9lAZ-006i0A-RH; Thu, 24 Sep 2026 17:15:31 +0200
Received: from gate.service.igalia.com ([192.168.21.52])
	by mail.igalia.com with esmtp (Exim)
	id 1x9lAY-00A6EK-Pd; Thu, 24 Sep 2026 17:15:31 +0200
Received: from berto by gate.service.igalia.com with local (Exim 4.96)
	(envelope-from <berto@igalia.com>)
	id 1x9lAY-005E4r-20;
	Thu, 24 Sep 2026 15:15:30 +0000
Date: Thu, 24 Sep 2026 17:15:30 +0200
From: Alberto Garcia <berto@igalia.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Baokun Li <libaokun@linux.alibaba.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
Message-ID: <arU-kvN-75AEmNQw@igalia.com>
References: <arO0KE9_Jf8rNRwN@igalia.com>
 <38d9a34b-0547-45f0-b8b3-64da1f913058@linux.alibaba.com>
 <arPIrtWTXUTwqxFC@igalia.com>
 <cbbfa461-c770-457d-bfc6-317d744f1dcd@linux.alibaba.com>
 <20260923180119.GA1506901@google.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923180119.GA1506901@google.com>
X-Spam-Report: NO, Score=-2.1, Tests=ALL_TRUSTED=-3,BAYES_50=0.8,KAM_DMARC_NONE=0.125,KAM_DMARC_STATUS=0.005
X-Spam-Score: -20
X-Spam-Bar: --

On Wed, Sep 23, 2026 at 06:01:19PM +0000, Eric Biggers wrote:
> The proposed patch looks good

As I said, I think we need an additional check to detect if encryption
is set on a mounted filesystem that has blocksize > pagesize.

Such a filesystem cannot be mounted (ext4_check_large_folio refuses),
but if you do it after the fs is mounted you can crash the kernel
using the same method.

# mkfs.ext4 -b 16384 /dev/vdb 
# mount /dev/vdb /mnt/
# fscrypt setup /mnt
# tune2fs -O encrypt /dev/vdb 
# mkdir /mnt/foo
# fscrypt encrypt /mnt/foo/

The other patch alone does not prevent this.

With this additional change, FS_IOC_SET_ENCRYPTION_POLICY returns
-EOPNOTSUPP, so tune2fs succeeds, but 'fscrypt encrypt' fails:

   [ERROR] fscrypt encrypt: encryption not enabled on filesystem /mnt (/dev/vdb).

--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -156,6 +156,9 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	if (ext4_test_inode_flag(inode, EXT4_INODE_DAX))
 		return -EOPNOTSUPP;
 
+	if (inode->i_sb->s_blocksize > PAGE_SIZE)
+		return -EOPNOTSUPP;
+
 	res = ext4_convert_inline_data(inode);
 	if (res)
 		return res;

That prevents the crash, but the filesystem cannot be remounted:

   kernel: EXT4-fs (vdb): bs(16384) > ps(4096) unsupported for encrypt

Would this be enough or is there anything else to take into account?

Regards,

Berto
