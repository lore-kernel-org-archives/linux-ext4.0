From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext4: remove ext4_handle_release_buffer()
Date: Wed, 31 Oct 2012 10:27:12 -0200
Message-ID: <20121031122712.GA26151@andromeda.usersys.redhat.com>
References: <509008C6.3070700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab2JaM1Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Oct 2012 08:27:16 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9VCRGAC025250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 31 Oct 2012 08:27:16 -0400
Content-Disposition: inline
In-Reply-To: <509008C6.3070700@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 30, 2012 at 12:05:10PM -0500, Eric Sandeen wrote:
> ext4_handle_release_buffer() was intended to remove journal
> write access from a buffer, but it doesn't actually do anything
> at all other than add a BUFFER_TRACE point, but it's not reliably
> used for that either.  Remove all the associated dead code.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> If this flies, I can do the same for ext3.
> 
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 56d258c..7177f9b 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -254,13 +254,6 @@ static inline void ext4_handle_sync(handle_t *handle)
>  		handle->h_sync = 1;
>  }
>  

Particularly, I like code clean up, and the patch looks good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
--Carlos
