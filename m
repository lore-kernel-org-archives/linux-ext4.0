Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2071D130E;
	Thu, 28 May 2026 12:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779972684; cv=none; b=UlT44nLVb5E3HNPU0bS6RwptSHrlGwg3Tr9nMZswMHPM6ZJ8S5LCq+AHIAnocq121A/0w+i+aLVAJ8XSblceB9lUD4PQaJUVGPlzDZLShJK48dsJrIyfh/QeMcb/qQGIDl7uLmSNnkCZBWveScluW+kCMnFB4Son4+03A2ar+LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779972684; c=relaxed/simple;
	bh=l2WKjnkz7wL5YHQCQn0FPlauShdQUkMmXpFCsoMdnjE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=miqd483bH44JKzeJN9jh8VWThoXhcJSDKzjpm7sH9SPCtnxQG+4x+O7B1WYVenW4rkkZqOG+rTTx0VNaJUcWnNE4j5yy4sNbkIn8X1uhpNnZI34YhF9Y6tbSeo1E8LYfN8qwN08rWrBgKDEPPFpsU6hALpYN8zYlhof0sSRTjsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kf3IkGyc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kf3IkGyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C841F000E9;
	Thu, 28 May 2026 12:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779972683;
	bh=f2duLyTEyViEAsFKf2dWhkC4yuRPxnwNiVJ/FjoYBro=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=kf3IkGyc/a/9PWm0OUFMvziIu/91q4oL7/r6NJBf73rTDQexL1mmWzR4Fk5b1kRCo
	 zcIMX1Jyby3kP5y1jirwdArURCDE4EKgvq/kOkLfIDI9qD7AzLt0xGrjqFZUJo8nGn
	 CkXoD9Xl2UK9PXhvfzc5gxjnz3wrI1+WcLuBROIs4/1vZBirmzYlDpeoGyU63LvXNy
	 xupR+QWcBlEA5bPyCr0gM5ePA8oxN+aDxKYnOFZ4nRHz6CngczM1rtIzAuvj/icS/i
	 ppdGVyGJSlsM/+B7Oqu0M00ngUtAtkLTAk9PKxY4t0iqPlbv1cA/zWxmpSybuPCEYG
	 FBQt3Epc0bR0Q==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, 
 jack@suse.com, linux-ext4@vger.kernel.org, 
 Dai Junbing <daijunbing@vivo.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
In-Reply-To: <20260527064912.1038-1-daijunbing@vivo.com>
References: <20260527064912.1038-1-daijunbing@vivo.com>
Subject: Re: [PATCH 0/4] fs: mark selected blocking waits as freezable
Message-Id: <177997267385.1024700.10028396434477082299.b4-ty@b4>
Date: Thu, 28 May 2026 14:51:13 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1448; i=brauner@kernel.org;
 h=from:subject:message-id; bh=l2WKjnkz7wL5YHQCQn0FPlauShdQUkMmXpFCsoMdnjE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRJWHl+nvG96njs/html58zJIcEJXTYXjj8Zm7X2q2nF
 voe7I8J7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZgI1z2GfwZ+ExfrnFZnaszf
 eO1P0QG1/4wnwsKCnX8+42BemrLwxVZGhk+uSVEFYdG/RP22ssvWrPxa4pPvZOdlWRzwg3nqjCe
 ufAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Wed, 27 May 2026 14:49:08 +0800, Dai Junbing wrote:
> fs: mark selected blocking waits as freezable
> 
> Hi,
> 
> During suspend and resume, tasks blocked in some interruptible wait
> paths may be unnecessarily woken due to freezer state transitions. This
> can introduce avoidable activity in the suspend/resume path.
> 
> [...]

Applied to the vfs-7.2.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.misc

[1/4] eventpoll: mark ep_poll() sleep as freezable
      https://git.kernel.org/vfs/vfs/c/f5437433c37d
[2/4] jbd2: make kjournald2 commit wait freezable
      https://git.kernel.org/vfs/vfs/c/10c6b259fb56
[3/4] pipe: mark blocking pipe read and FIFO open sleeps as freezable
      https://git.kernel.org/vfs/vfs/c/6e5e03a76bee
[4/4] select: make select() and poll() waits freezable
      https://git.kernel.org/vfs/vfs/c/f837c1dbd121

