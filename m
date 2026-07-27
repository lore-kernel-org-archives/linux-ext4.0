Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA45374A1D;
	Mon, 27 Jul 2026 14:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785162120; cv=none; b=HsV5P60LpJ3Cf6B5Rcg3XC5gJjbLoFmjsYWlXBMFOwVWaZNLdGIg+vMWd3cLb1JH3P2m4SXxxrKdHaJjy8E1HA2L1L5xG4ZOwtA73hxdr6+ZPLzPzlQCtVVaWrh3wWSRAvnYlwaMZq9MRLsvCXYH3UMM+mjjr8nISNJTL4QooDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785162120; c=relaxed/simple;
	bh=XzSWIVxHmwUGWh7S3nrQa395bSNuJa5GquC/vqGghhc=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=S42DcjS3cU4SIeFCJPRw+kNAQVPK1PGZwjDVTbMrQgFj744ZoCpM7PRn9kdIP0LRnXHV6cipgrNAATFvpUNtklFbwY9D1E/G25dtphwBYQhUwjSJt49fkoIYEgHt9PREbR+9XLpBQx1c2NqlJkbXOM3P46EQtpvqTR3g5iAVACI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zn5uW0tF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zn5uW0tF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467351F000E9;
	Mon, 27 Jul 2026 14:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785162118;
	bh=sNvr1pSnqcxSG1kVvzMqbAjGO1NYWTVir99tzaDjoOA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Zn5uW0tFYoY1K78qjzixa58AMMm0k39v+NnOSrUrkWRsq15W97a3x0KWA+xr5Laro
	 8wrXA3HTtV+ItyyJcshCsrgoGMY4e/ObHCDa4+kfj72fTlL0mMkW6aN8p/ZYBzqJZ2
	 UVEEuOi8p6dSvTSJBU7ll/a+VLolJ/1MbDqa59wMzDvocyXEjFXWOBrhZO36BhkNUo
	 4p4+wKb/zaaiSrRv2QuBbO1KBHIe5TwMwYy01pITxzlpEQf4nYq6ehLSApfMRba4Yn
	 fLqWvycxb0Olg3rVr4MWYLtrxe80ncB243a/gCCrFx/bLhBeXq5RNNKrms49QGUUWH
	 nKYsE2OKEZ1xQ==
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 0/21] fs: Fix missed inode write during fsync
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 aivazian.tigran@gmail.com, Ted Tso <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
In-Reply-To: <pvgt7vemge5pwcs4bvlzg32fz3tzdnctni7zsai6uchtmtyx3y@sv7zv4ipg4ci>
References: <20260716145359.28639-1-jack@suse.cz>
 <20260724-einmieten-beatmen-glossar-63c4b3962e07@brauner>
 <pvgt7vemge5pwcs4bvlzg32fz3tzdnctni7zsai6uchtmtyx3y@sv7zv4ipg4ci>
Date: Mon, 27 Jul 2026 16:21:55 +0200
Message-Id: <20260727-flugverbindung-hufeisen-teufel-5592f536407a@brauner>
X-Mailer: b4 0.16-dev-09492
X-Developer-Signature: v=1; a=openpgp-sha256; l=1143; i=brauner@kernel.org;
 h=from:subject:message-id; bh=XzSWIVxHmwUGWh7S3nrQa395bSNuJa5GquC/vqGghhc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSlZ7b8cj++0ohpdsNDj537f7yuYOk5sjJnSrrCruR/C
 k+UElwUOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZSeYORYdODuJTJ5lbSry3E
 RWb9TGaNXsN6Y8X33Pj3+Z8s3rQsWcvwV+7b8tt7Yo9tuLW6vyxuJ5OgEVe9cnT3+bCbiyX1/x9
 n5QUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-07-27 12:21 +0200, Jan Kara wrote:
> On Fri 24-07-26 11:52:31, Christian Brauner wrote:
> > On Thu, 16 Jul 2026 16:55:22 +0200, Jan Kara wrote:
> > > fs: Fix missed inode write during fsync
> > > 
> > > Hello,
> > > 
> > > here is v4 of the patch series which fixes the possibly missing inode write
> > > during fsync(2) for filesystems using generic metadata bh tracking. This
> > > revision contains mostly small fixes and improvements since v3, neither
> > > Sashiko nor Christian found fundamental issues with this approach.
> > > 
> > > [...]
> > 
> > I think there's some outstanding sashiko reviews for this one. Feel free
> > to just send follow-up fixes if the changes are small enough! Thanks,
> > Jan!
> 
> Thanks! Yes, there were still three bugs Sashiko rightfully pointed out. I
> already did some fixups before I went for vacation last week. Testing has
> finished while I was on vacation so I'll post a new revision of the series
> today (sorry, I didn't keep the fixes as separate patches and bfs
> compilation failure would be annoying in git history anyway).

No problem, I'll just drop v4.

