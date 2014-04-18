From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] ext4: fallocate_zero_range, check if is regular file
Date: Fri, 18 Apr 2014 13:20:14 +0530
Message-ID: <CAOiN93=1BBvgUg3Zk9xC1WkBa87UDhR0C_=gsLOM1SSq9BhR0Q@mail.gmail.com>
References: <CAGW2f1GoMPwcO3o4Q=As-DkiT2WPN7BiEkq1=RYfX6rnpExipA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:49983 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaDRHuO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Apr 2014 03:50:14 -0400
Received: by mail-qa0-f54.google.com with SMTP id w8so1319440qac.27
        for <linux-ext4@vger.kernel.org>; Fri, 18 Apr 2014 00:50:14 -0700 (PDT)
In-Reply-To: <CAGW2f1GoMPwcO3o4Q=As-DkiT2WPN7BiEkq1=RYfX6rnpExipA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 17, 2014 at 9:52 AM, jon ernst <jonernst07@gmail.com> wrote:
> fallocate_zero_range, check if inode is regular file.
>
> Signed-off-by: Jon Ernst <jonernst07@gmail.com>
> ---
>  fs/ext4/extents.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 1bb3e4b..756a3b9 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4742,6 +4742,8 @@ static long ext4_zero_range(struct file *file,
> loff_t offset,
>
>     trace_ext4_zero_range(inode, offset, len, mode);
>
> +   if (!S_ISREG(inode->i_mode))
> +       return -EOPNOTSUPP;
IMO returning -EINVAL is better suited in this situation.
And the same error value has to be updated for collapse_range too. (as
mentioned by Michael in other mail thread regarding manpage patch of
collapse range)
>     /*
>      * Write out all dirty pages to avoid race conditions
>      * Then release them.
> --
> 1.8.1.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
