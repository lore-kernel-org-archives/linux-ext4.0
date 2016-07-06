From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] quota: fix coredump if projid file dose not exist
Date: Wed, 6 Jul 2016 11:44:45 +0200
Message-ID: <20160706094445.GF14067@quack2.suse.cz>
References: <1467702040-14764-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, sihara@ddn.com,
	lixi@ddn.com, Wang Shilong <wshilong@ddn.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbcGFKDo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jul 2016 06:03:44 -0400
Content-Disposition: inline
In-Reply-To: <1467702040-14764-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 05-07-16 16:00:40, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> if '/etc/projid' dose not exist,@project_file will
> be NULL pointer, fclose will cause coredump, add
> check in endprent().
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

Thanks. I've merged the patch.

							Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
