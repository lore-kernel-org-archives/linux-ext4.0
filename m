From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH e2fsprogs] subst: use 0644 perms
Date: Fri, 18 Sep 2015 10:52:28 -0600
Message-ID: <E093072B-F995-496D-BE3D-B14EB5A1C27A@dilger.ca>
References: <1442562858-862-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33282 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbbIRQwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2015 12:52:31 -0400
Received: by pacex6 with SMTP id ex6so55896099pac.0
        for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2015 09:52:30 -0700 (PDT)
In-Reply-To: <1442562858-862-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 18, 2015, at 01:54, Mike Frysinger <vapier@gentoo.org> wrote:
> 
> When running on NFS, opening files with 0444 perms for writing can
> sometimes fail.  Since there's no real reason for these files to be
> read-only, give the owner write permission.

Actually, there IS a reason for subst to make these files read-only. They are auto-generated and any edits to these files can be overwritten and lost if their origin files are modified. 

I'd lost edits to these auto generated files many time because they are the ones that "tags" or "cscope" will jump to when searching for symbols. 

There really isn't any reason for them to be writable, so the fact that you are getting an error trying to open them for writing is a hint that you are doing, or going to do, the wrong thing and the read-only nature of the file is preventing you from going down the wrong path. 

Cheers, Andreas

> URL: https://bugs.gentoo.org/550986
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> util/subst.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/util/subst.c b/util/subst.c
> index f36adb4..e4004c9 100644
> --- a/util/subst.c
> +++ b/util/subst.c
> @@ -370,7 +370,7 @@ int main(int argc, char **argv)
>        }
>        strcpy(newfn, outfn);
>        strcat(newfn, ".new");
> -        fd = open(newfn, O_CREAT|O_TRUNC|O_RDWR, 0444);
> +        fd = open(newfn, O_CREAT|O_TRUNC|O_RDWR, 0644);
>        if (fd < 0) {
>            perror(newfn);
>            exit(1);
> -- 
> 2.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
