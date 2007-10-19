From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] provide missing mode for open-create in check_mntent_file
Date: Fri, 19 Oct 2007 15:15:36 -0500
Message-ID: <47191068.2010609@redhat.com>
References: <46C4D18E.3080509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759329AbXJSUPj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Oct 2007 16:15:39 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id l9JKFb3L009561
	for <linux-ext4@vger.kernel.org>; Fri, 19 Oct 2007 16:15:37 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9JKFbCP006121
	for <linux-ext4@vger.kernel.org>; Fri, 19 Oct 2007 16:15:37 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9JKFa7N006464
	for <linux-ext4@vger.kernel.org>; Fri, 19 Oct 2007 16:15:36 -0400
In-Reply-To: <46C4D18E.3080509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> F8 is catching opens with O_CREAT flags and no mode now, and refusing
> to build them... 

Ping?  I don't see this in git yet.

Thanks,
-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Index: e2fsprogs-git/lib/ext2fs/ismounted.c
> ===================================================================
> --- e2fsprogs-git.orig/lib/ext2fs/ismounted.c
> +++ e2fsprogs-git/lib/ext2fs/ismounted.c
> @@ -147,7 +147,7 @@ static errcode_t check_mntent_file(const
>  is_root:
>  #define TEST_FILE "/.ismount-test-file"		
>  		*mount_flags |= EXT2_MF_ISROOT;
> -		fd = open(TEST_FILE, O_RDWR|O_CREAT);
> +		fd = open(TEST_FILE, O_RDWR|O_CREAT, 0644);
>  		if (fd < 0) {
>  			if (errno == EROFS)
>  				*mount_flags |= EXT2_MF_READONLY;
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
