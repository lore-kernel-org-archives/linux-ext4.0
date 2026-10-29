Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=43.163.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793296558;
	b=z3bDFqR8YB3Ny9PbFJaFiQOMf0iO2V4rPlCWnryEzN+eALco36AOMmQHmljTNu6662Kj
	 udM2TxC/AHTtmGfufI1KD7/nx6sf9wYHJnyxtXNJm/NPIUEhZiEAxbdY/mxUvgncY2PMH
	 4Sfeg7dBQiunWpJX2LERHYPZQ7DUFV2MSDclK5omhtkd0j2Aaj4rs0DKT+QxSt2t0JjS3
	 7eB1/D1SVPE4a00uyk37Nj6krxOmH2LBTwPk7oU6/3iP/a9CZNhADuJyZh2dOzh+h9wD8
	 U8uxrVIE/l2ndN0UtV0ILwCh/HQM7cifzJZpA6qv2a9YJRCU5wUvDxvhj/XdBYZ9upw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793296558;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=9NRMu8PQ8MICPRBna3Q6ccaLnBShapmY0xbiXLML8iE=;
	b=YOD92ryVjZn8J7Qe2exl2/BhwpxeMJxXQjK24bFLqMX8wLHA0rabweS/5rh1x3HHVjsw
	 f8ZojMLrGe6jVmRsfNXmIpgD+5ehxZS6j83BfLcYtDfkUzaVAkTU0TlT0TwywdvS7VMlE
	 36QTnlybQhC1bRxcnQiVo7aHLoXLcT+V0zaW+zGQkckOSwMq5wF6tZDp1KIeXfn8crFGC
	 553lX533qu+AVDa2e7l/b/9kCzWuI6vHeesHyqiSD0DUunYbfZ3NmE+rGG5TL3aEWHqbg
	 IuOe7mNoJY4gVOZPRei94LfBulAH/vl35fs4V7zzWBO9WIMOKpS2Qx5h4YXpBndKOSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=Mx7Zll0M;
	arc=none smtp.remote-ip=43.163.128.43
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.43])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077F4606A31D;
	Thu, 29 Oct 2026 17:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 077F4606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=Mx7Zll0M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793296548; bh=9NRMu8PQ8MICPRBna3Q6ccaLnBShapmY0xbiXLML8iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mx7Zll0MS8Eyqqdc38ha+mInCElvFEnI0y2zfFUCZwANmF3B88kK/MWL/Azv0y2vw
	 qmH948HVD+iaO5ERAXYLH5ydrQYLRyFuGbR605uEn5sAEsPfedl2KbCu6sejoML6KK
	 uIu3urlOiTgEnE7UDwrxiYZwQY6WqaOgl6KkWlKE=
Received: from [172.18.4.77] ([111.31.227.58])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id DEE93E9D; Fri, 30 Oct 2026 01:55:46 +0800
X-QQ-mid: xmsmtpt1793296546tryicaagv
Message-ID: <tencent_5CEFAB1126275DD39A28299FC2A8E954F907@qq.com>
X-QQ-XMAILINFO: OTIbW6R4UQxK5CTEcKtwW9ljNNlgQ1vg9IOAgxZL26yXbGi8eT8fRK0YgCr1U2
	 4vAQ43LpZtgpbfUWSTdJ2FMHo7d6pTu6nJvdh5yR3kPOgaWzoZkLvYud2/WLt/doHUk6rY4d8ti6
	 v3zuUTx6W1Gj3yHM+wbv4UcEowNqdW/17hNETFYDaHvi2I5nOAHSFc4XXmKxBrnzjWQHLI4tHHcU
	 eLxefXRsMBsBe+BN44htlVNA3pbInEmrqWk2F26EV85wxvvRukacOUUlNYwwVkuWYZvqUmnvoJ9X
	 eoRXAqeWFmmVI2pkhgzW9G+OSTaB7uS+7vNiVr9wcnP4FSZee36wyWaCVd2JiAgOLknYTotYfbqP
	 wElhCAhrh9CC0GKOhHsdVKyyrq1aDDR1tIeYKoy4yg98/uAlJLUOQvoNznSJaIXzkD4gv9z+LOg+
	 +7a3FYtcQqtuFeTw0nb+tl7k3AqyZk62UXS1KIYPKmfBiYTAMlsKAlS6KHNRyJZfqmt1OY/4ybF3
	 O5tJx9ECu6YKZGyAOefpHdfjsVhaySK7VXIHp9ifnlwDnAUxxY3Ab2wti6hn8pmn/3/aS2GjwKbK
	 83gJJk+sAtFgYg/Z8KvfWPDuI7pwt2/OSD+tWkWVCstbW4P5QIZbUNyWXYKj5W97LeWlUpR2pZGN
	 rHX1wZlooJodT0W6XhuV/PdSHh9hRX/1p2HMV7Q9F0GUg1gX3PHIGx64E/b9qNFp3pQmKdBgwksa
	 1eOhuLSvIcHrBW/5v4EpzoiNPVz0ExMEDRvdvt3K0Qywm1BvEW2C3A4a33wiG2HY14m1aaKlv6to
	 jnG3Qaf7/NNFzgf0FGNfqCJjAMRYyzVVIgwjxylW9gEnDIl7NwR89BEb+gIllLMNEHEWDA0zu6/o
	 nMsHT92iU1T4HhUhHpVVft2E+pimH7LZiTCt8Mtnmm8Nx+bQ24jH3G/rl456qqL93YnGvFC5hGLA
	 WmdIiwKT7bbZNZDUsJm3LXvY8voX8a4u+ELJ4/a24rCdkRUnBzTLuzb0j5qKHb6XYOgGo/SMf5/Q
	 gnaz627XcZdDNJsLZx6mQq5HOw8SAvqiMD7N5AdaYLq2YWFZoq32ZhzhoOZ5k=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Guikun Yang <yangguikun19@qq.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ext4: unvalidated h_refcount on a shared xattr block ->
 double free, detected too late
Date: Fri, 30 Oct 2026 01:55:45 +0800
X-OQ-MSGID: <179329654579.60452.6108742348319878589@qq.com>
In-Reply-To: <tencent_B025D3B328709FF3A8B5D4B3EFED913C2707@qq.com>
References: <tencent_B025D3B328709FF3A8B5D4B3EFED913C2707@qq.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

From: Yang Guikun <yangguikun19@qq.com>
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ext4: unvalidated h_refcount on a shared xattr block -> double free, detected too late
In-Reply-To: <tencent_B025D3B328709FF3A8B5D4B3EFED913C2707@qq.com>
References: <tencent_B025D3B328709FF3A8B5D4B3EFED913C2707@qq.com>

Hi,

Friendly ping on this one - it has been quiet for a bit over two weeks, and I
wanted to add data rather than send a bare ping.

Update: the reproducer still fires on 7.3.0-rc7, 11/11 runs with a 64MB image
and a 5-thread hammer (the churn count raised from 8 to 64; 3 xattr-churn + 2
donor-churn threads). The earlier numbers stand too: 6/6 on 7.3.0-rc5 with the
8MB single-thread config. The release-path code in question is unchanged
between rc5, rc7 and current master, so this is not a regression and has not
been fixed in the meantime. The one race-dependent panic from the original
report has not recurred in the rc7 campaign; the deterministic double free is
the reproducible part.

The suggested direction from the original report stands: a
"freeing already freed block" error raised from the xattr release path means
a wrong free has already happened, so containing it (fs abort / remount-ro
rather than error + continue) looks like the sensible hardening point.

If it helps, a minimal containment would check the block bitmap bit right
before the ext4_free_blocks() call in ext4_xattr_release_block(): this call is
the one that clears the bit, so at that point it must still be set. If it is
already clear, the on-disk h_refcount was wrong and the block has had a
double lifetime since mount - the state that merits the ERRORS= policy:

--- cut ---
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1320,6 +1320,12 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		get_bh(bh);
 		unlock_buffer(bh);
 
+		if (!ext4_test_bit(EXT4_B2C(EXT4_SB(inode->i_sb),
+				   bh->b_blocknr -
+				   ext4_group_first_block_no(inode->i_sb,
+				   ext4_inode_to_group(inode))),
+				   bitmap_bh->b_data))
+			ext4_error(inode->i_sb,
+				   "releasing xattr block %lu which is already free; on-disk h_refcount is wrong",
+				   (unsigned long)bh->b_blocknr);
 		if (ext4_has_feature_ea_inode(inode->i_sb))
 			ext4_xattr_inode_dec_ref_all(handle, inode, bh,
--- cut ---

(That sketch glosses over fetching the group's bitmap_bh and the cluster
conversion; I will write it out properly and test it if you think the
approach is worth pursuing. Any containment shape that makes this state hit
ERRORS= instead of continuing silently works for me.)

Thanks,
Guikun Yang <yangguikun19@qq.com>

