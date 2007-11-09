From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix check_mntent_file() to pass mode for open(O_CREAT)
Date: Thu, 08 Nov 2007 21:30:01 -0600
Message-ID: <4733D439.9020708@redhat.com>
References: <20071109012015.GA14612@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178AbXKIDaL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2007 22:30:11 -0500
In-Reply-To: <20071109012015.GA14612@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On my FC8 install, ismounted.c fails to build because open(O_CREAT) is
> used without passing a mode.  The following trivial patch fixes it.

You can add:

Acked-by: Eric Sandeen <sandeen@redhat.com>

'cause it's an awful lot like the patch I sent for the same issue back
on 8/16  ;-)  Guess I should have followed that up with a ping.  (though
your 0600 mode is probably better than my 0644 was)

Andreas, did you also run into trouble with struct_io_manager's ->open
calls triggering this test?

I sent a patch for that,

[PATCH] rename ->open and ->close ops in struct_io_manager

too... maybe the glibc #define tricks got smarter and don't trigger that
now?

-Eric

> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> 
> Index: e2fsprogs-1.40.2/lib/ext2fs/ismounted.c
> ===================================================================
> --- e2fsprogs-1.40.2.orig/lib/ext2fs/ismounted.c
> +++ e2fsprogs-1.40.2/lib/ext2fs/ismounted.c
> @@ -147,7 +147,7 @@ static errcode_t check_mntent_file(const
>  is_root:
>  #define TEST_FILE "/.ismount-test-file"		
>  		*mount_flags |= EXT2_MF_ISROOT;
> -		fd = open(TEST_FILE, O_RDWR|O_CREAT);
> +		fd = open(TEST_FILE, O_RDWR|O_CREAT, 0600);
>  		if (fd < 0) {
>  			if (errno == EROFS)
>  				*mount_flags |= EXT2_MF_READONLY;
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Software Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
