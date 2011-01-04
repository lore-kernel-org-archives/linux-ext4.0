From: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH resend] Update atime from future.
Date: Tue, 04 Jan 2011 10:02:29 +0100
Message-ID: <m2d3od11p6.fsf@whitebox.home>
References: <1294131418-3835-1-git-send-email-sickamd@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, adilger@dilger.ca,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	swhiteho@redhat.com, sickadm@gmail.com
To: yangsheng <sickamd@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:38434 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1ADJCe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Jan 2011 04:02:34 -0500
In-Reply-To: <1294131418-3835-1-git-send-email-sickamd@gmail.com> (yangsheng's
	message of "Tue, 4 Jan 2011 16:56:58 +0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

yangsheng <sickamd@gmail.com> writes:

> -	 * Is the previous atime value older than a day? If yes,
> +	 * Is the previous atime value old than a day? If yes,

Why did you change that comment?

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
