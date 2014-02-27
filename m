From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH] util-linux/fallocate: introduce an option -c to support FALLOC_FL_COLLAPSE_RANGE
Date: Thu, 27 Feb 2014 12:59:51 +0900
Message-ID: <CAKYAXd-ngheH2njza1Tq0umONrF+VBrmB+9SiVG1Q=DsM0PBBA@mail.gmail.com>
References: <alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
	<1393355305-12009-1-git-send-email-dongsu.park@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	Lukas Czerner <lczerner@redhat.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Dongsu Park <dongsu.park@profitbricks.com>,
	Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:58826 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaB0D7w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Feb 2014 22:59:52 -0500
In-Reply-To: <1393355305-12009-1-git-send-email-dongsu.park@profitbricks.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dongsu.
> As discussed in the thread "[PATCH RESEND 3/10] ext4: Add support
> FALLOC_FL_COLLAPSE_RANGE for fallocate", [3] this patch to util-linux
> will be useful for testing collapse-range inside xfstests.
As Dave pointed, this patch is needed for fsstress not xfstests.
>
> [1] https://lkml.org/lkml/2014/2/18/374
> [2] https://lkml.org/lkml/2014/2/20/318
> [3] https://lkml.org/lkml/2014/2/18/83
>
> @@ -51,6 +52,10 @@
>  # define FALLOC_FL_PUNCH_HOLE 2
>  #endif
>
> +#ifndef FALLOC_FL_COLLAPSE_RANGE
> +# define FALLOC_FL_COLLAPSE_RANGE 8
> +#endif
> +
>  #include "nls.h"
>  #include "strutils.h"
>  #include "c.h"
> @@ -66,12 +71,13 @@ static void __attribute__((__noreturn__)) usage(FILE
> *out)
>  	fprintf(out,
>  	      _(" %s [options] <filename>\n"), program_invocation_short_name);
>  	fputs(USAGE_OPTIONS, out);
> -	fputs(_(" -d, --dig-holes     detect and dig holes\n"), out);
> -	fputs(_(" -l, --length <num>  length of the (de)allocation, in bytes\n"),
> out);
> -	fputs(_(" -n, --keep-size     don't modify the length of the file\n"),
> out);
> -	fputs(_(" -o, --offset <num>  offset of the (de)allocation, in bytes\n"),
> out);
> -	fputs(_(" -p, --punch-hole    punch holes in the file\n"), out);
> -	fputs(_(" -v, --verbose       verbose mode\n"), out);
> +	fputs(_(" -c, --collapse-range collapse a hole in the file\n"), out);
I think that it is better to change like this => "collapse space in the file"
And I add util-liunx's maintainer in this mail loop.

Thanks.
