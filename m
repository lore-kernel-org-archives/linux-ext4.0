From: Xi Wang <xi.wang@gmail.com>
Subject: Re: [PATCH] ext4: avoid oversized shift in ext4_fill_flex_info()
Date: Mon, 26 Dec 2011 21:26:22 -0500
Message-ID: <3C498AE4-D26A-41AD-A862-EE1C80290C7B@gmail.com>
References: <1324881404-3791-1-git-send-email-xi.wang@gmail.com> <C0DF217A-64C8-49E3-B979-652DB2C362C3@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36469 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab1L0C0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Dec 2011 21:26:25 -0500
Received: by iaeh11 with SMTP id h11so19660627iae.19
        for <linux-ext4@vger.kernel.org>; Mon, 26 Dec 2011 18:26:24 -0800 (PST)
In-Reply-To: <C0DF217A-64C8-49E3-B979-652DB2C362C3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 26, 2011, at 2:20 AM, Andreas Dilger wrote:
> While this is true in theory, it is not possible to have 2^32 groups per flex group. This would mean 2^32 block bitmaps and inode bitmaps in a single group, which is impossible. 

This patch is based on commit 503358ae "ext4: avoid divide by zero
when trying to mount a corrupted file system", as I quote: "If
s_log_groups_per_flex is greater than 31, then groups_per_flex will
will overflow and cause a divide by zero error."  The intent is to
avoid oversized shift in that commit, because the behavior is
undefined in C and may vary on different architectures.

My understanding is that sbi->s_es->s_log_groups_per_flex needs a
sanity check if it is read from a malicious or corrupted filesystem
in ext4_fill_flex_info(), which is called from ext4_fill_super().

Did I miss anything?

- xi