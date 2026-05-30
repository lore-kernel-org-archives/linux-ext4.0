Received: from send170.i.mail.ru (send170.i.mail.ru [95.163.59.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8BE1BD9D0;
	Sat, 30 May 2026 12:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.163.59.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780144880; cv=none; b=swQP2szAQWP/jHClLLudkj/uXho/DFwumL46Bw1UfS82Ou1NveAB4SVMW8sBjKl96qmeG9WyNE/X05cSptRJzMF2S3DuY3l35znJsDU08o0Z1mqaiHdrjAespwNmaBqe0JlYUa5S1cp61w3kprX7iZ9CFxYfdBJyeuz7831LCcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780144880; c=relaxed/simple;
	bh=FWr0rZyScC5DofjxBr2XDjNLgQhHrnhDLJ9KGntEe3U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rN5E5rSlN+wLl4iXO5K0GNA+sWxorlXvKZ9ztslwiyf/forR3u/l7Dw4gUrNMZPhZsdr1BruPO3cTSwGf31St/NZbZJXU2vqEqWczUV0+h0rEOou8mled7hnBOJd5jcYSqTcy2GQ/DzyZGFT/YZqa0FF1obx4gRA8ti86OonI2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mail.ru; spf=pass smtp.mailfrom=mail.ru; dkim=pass (2048-bit key) header.d=mail.ru header.i=@mail.ru header.b=nvgQsz9W; dkim=pass (2048-bit key) header.d=mail.ru header.i=@mail.ru header.b=RQeOLjea; arc=none smtp.client-ip=95.163.59.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mail.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mail.ru header.i=@mail.ru header.b="nvgQsz9W";
	dkim=pass (2048-bit key) header.d=mail.ru header.i=@mail.ru header.b="RQeOLjea"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru;
	s=mail4; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive:X-Cloud-Ids;
	bh=boN9FlMHOS7A0VBz9xfaYGtfcFtu7Iig44hJ4fPNM68=; t=1780144876; x=1780234876; 
	b=nvgQsz9WoEiHxCBIifefj7ZeqW7/+UpaJcqPcYLLgv9AuZ3h/MMuE4INvU9giUYQPVviIQKDhSr
	dpzPyrVyttToOiAutIf/re8DpoYFNm7ao6mDeWG9dzLWcsrXMVxZYD27/7dG/Tbe5VHI5mRh7jp3H
	+oMiNeM/3A+rOuIMT/91CEuqIn8GiqGLiCJl3nF71U/wQwwWg68K0haOLzvmCZNouipdXsCYqaC7E
	eTBps2y36J6D5YKAnW6fklsI1KS6Y7e1EM/qb3ZpGnnmpyCvz6XlannD1R0mbFpmjFQmJrIZEEQmY
	bOydE2YTalR1O+GIi9GXQsIiA7ILimUdtwuA==;
Received: from [10.113.207.124] (port=40884 helo=send104.i.mail.ru)
	by exim-fallback-554f498d9f-shwfg with esmtp (envelope-from <listdansp@mail.ru>)
	id 1wTIlQ-00000000AQm-2V27; Sat, 30 May 2026 15:26:04 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru;
	s=mail4; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:
	To:From:From:Sender:Reply-To:To:Cc:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
	X-Cloud-Ids:Disposition-Notification-To;
	bh=boN9FlMHOS7A0VBz9xfaYGtfcFtu7Iig44hJ4fPNM68=; t=1780143964; x=1780233964; 
	b=RQeOLjea7Q91ZF683P4i5Zqf36LkA72VT5BLHk5CNHvNX+OtNszyuZ8NNLr0eV1IRQ27sszVk8o
	GLCrA4OZOk6/e94W6fn1T2yI9A/fN+bsH+4W0fdIJeKl5c/AtmIJptfy48HAdwDlsVCvUUixlaDPU
	S35EL/Ovyw2zttJFXtkJBcfkUnSfGGMINyfaaRka0tQCkfDKZJO4adKYk23lzuOaZVzjyP9vvDxNL
	C2VPRBEUDlUbxsCwsOJvUHoJ0/VoskmsJ9tz1KPjUx6px/0mGbFBLYsmfiKtOs9C8HkEOR4H6Z69m
	Szfqzg/6J3lNnGsKQk1RJfDNb8UNQOlaQV+Q==;
Received: by exim-smtp-5b85998476-w27zp with esmtpa (envelope-from <listdansp@mail.ru>)
	id 1wTIlB-00000000SoT-3rNx; Sat, 30 May 2026 15:25:50 +0300
From: Danila Chernetsov <listdansp@mail.ru>
To: Jan Kara <jack@suse.com>
Cc: Danila Chernetsov <listdansp@mail.ru>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] ext2: fix ignored return value of generic_write_sync()
Date: Sat, 30 May 2026 12:23:11 +0000
Message-Id: <20260530122311.136803-1-listdansp@mail.ru>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mailru-Src: smtp
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9402BF17F4A9A44D6FD2958E3F641899897868DAB3B84C7AD00894C459B0CD1B9154A0D20C3ADCF50EDF1CDDB2C83CE565444DDD22516699A0E400E0F8EF59C83768ACFD3FE3A7A49
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7BF6699A3AA9BACA6EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637AC83A81C8FD4AD23D82A6BABE6F325AC2E85FA5F3EDFCBAA7353EFBB55337566A66E13412CE89A708C6F08E34A0D75EAB1646477B2F65CA93527CCD1FB45C0228EEF46B7454FC60B9742502CCDD46D0D6089696B24BB1D19F6B57BC7E64490618DEB871D839B73339E8FC8737B5C22498BFD6B1B042489ACCC7F00164DA146DAFE8445B8C89999729449624AB7ADAF37F6B57BC7E64490611E7FA7ABCAF51C92176DF2183F8FC7C084ED00A64A654CBE8941B15DA834481F9449624AB7ADAF37BA3038C0950A5D3613377AFFFEAFD269176DF2183F8FC7C044258A7565F9F4A67B076A6E789B0E97A8DF7F3B2552694AD5FFEEA1DED7F25D49FD398EE364050FB28585415E75ADA91AD9CA79AA6DBBDDB3661434B16C20ACC84D3B47A649675FE827F84554CEF5019E625A9149C048EE33AC447995A7AD182BEBFE083D3B9BA73A03B725D353964B0B7D0EA88DDEDAC722CA9DD8327EE4933F735096452955E3D2D576BCF940C736C4224003CC83647689D4C264860C145E
X-C1DE0DAB: 0D63561A33F958A5474C3882733BD6AA5002B1117B3ED6966E37C5B0E5DC00864A0A47EBA01A636A823CB91A9FED034534781492E4B8EEADABF80F987DAEDACBC79554A2A72441328621D336A7BC284946AD531847A6065AE478A468B35FE767BDAD6C7F3747799A
X-C8649E89: 1C3962B70DF3F0AD73CAD6646DEDE1918E10F71CB4DF9F9677DD89D51EBB774225B6776AC983F447FC0B9F89525902EE6F57B2FD27647F25E66C117BDB76D659E96292753A1AD15DF3CD14E582E209C0A504DFBD28CBF68F47C23E863CEECC40379325D192489D54B8341EE9D5BE9A0AEE1EDD53391CA287146F5835A63390395DA312BFC709E2619350E1BD188BD56E4C41F94D744909CE04437D853D7CD20871FE3B1D98EC473624A389F0E278DBF4
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu53w8ahmwBjZKM/YPHZyZHvz5uv+WouB9+ObcCpyrx6l7KImUglyhkEat/+ysWwi0gdhEs0JGjl6ggRWTy1haxBpVdbIX1nthFXMZebaIdHP2ghjoIc/363UZI6Kf1ptIMVYrk7BQKFwEt3owUH5JsNWNC6LQcN2QVxw==
X-Mailru-Sender: 4CE1109FD677D277A25EA9D9B320DF53171F9CFE4A62488EB951B70A5BD4BD8EFD681F25EFE76138DE369B216F14D11CC53BD13D3F6EEB2F3DDE9B364B0DF289C95E31D8FCF52BE1594FB4C9F0DBF4120D4ABDE8C577C2ED
X-Mras: Ok
X-Mailru-Src: fallback
X-7564579A: B8F34718100C35BD
X-77F55803: 6242723A09DB00B487EF4F2ACC83E26BB702F02B268DA64954F087923092041B049FFFDB7839CE9E335F9B817DF9F54FC491C621DAD3915D812EC7C28E23029A17336CD68B9FE82525169285964CA779
X-7FA49CB5: 0D63561A33F958A5167657256D5C097D5002B1117B3ED696E191CD16BEB3828C0CC8CF6E17EE77BC02ED4CEA229C1FA827C277FBC8AE2E8B54F520D093A0DF28
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu53w8ahmwBjZKM/YPHZyZHvz5uv+WouB9+OYcBso8Zm+oliTz8oZwnDrFsY77LZRcHyw5ht0smWrfSeTW5FiI8avd9v29gUBslpEZ9wIMwqVP4jLQVQ+dVm7x9BpDHadBV9RMjI809PraZxIqivjCN6Sn+NXixQxThcw==
X-Mailru-MI: 20000080020000000000000800
X-Mras: Ok

MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix ext2_dio_write_iter() to propagate the error returned by
generic_write_sync() instead of silently discarding it, which could
cause write(2) to return success to userspace on O_SYNC/O_DSYNC files
even when the sync failed.

The correct pattern, already used in ext2_dax_write_iter() in the same
file and in ext4, xfs, f2fs among others, is:
    if (ret > 0)
        ret = generic_write_sync(iocb, ret);

Found by Linux Verification Center (linuxtesting.org) with SVACE.
     
Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
---
 fs/ext2/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index d9b1eb34694a..855a62e96c38 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -272,7 +272,7 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 						 pos >> PAGE_SHIFT,
 						 endbyte >> PAGE_SHIFT);
 		if (ret > 0)
-			generic_write_sync(iocb, ret);
+			ret = generic_write_sync(iocb, ret);
 	}
 
 out_unlock:
-- 
2.25.1

