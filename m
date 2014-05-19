From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: don't run quota test if quota is not enabled
Date: Mon, 19 May 2014 17:16:48 -0500
Message-ID: <537A82D0.8030702@redhat.com>
References: <537A6909.6060700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaESWQr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 May 2014 18:16:47 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4JMGkZB019677
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2014 18:16:47 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id s4JMGjhL017117
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2014 18:16:46 -0400
In-Reply-To: <537A6909.6060700@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/19/14, 3:26 PM, Eric Sandeen wrote:
> The default configuration still has quota disabled, but
> runs the f_quota test unconditionally, so we fail by
> default.
> 
> Fix that...

related to this, should quota be on by default now, or not?

also: my old fedora package (not built with --enable-quota) installed
a quota.pc and a /usr/include/quota dir.  But when I built today
with --enable-quota, those *didn't* show up.

TBH I get lost in the makefiles... should quota be on yet, or not?
Is libquota supposed to be installed if it's on?

Thanks,
-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/tests/f_quota/script b/tests/f_quota/script
> index bf25e07..d1c4b9e 100644
> --- a/tests/f_quota/script
> +++ b/tests/f_quota/script
> @@ -1,4 +1,11 @@
>  AFTER_CMD='$DEBUGFS -f $test_dir/debugfs-cmds $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $test_name.0.log'
>  PASS_ZERO=true
>  
> +$TUNE2FS -h 2>&1 | grep -q quota_options
> +if [ $? != 0 ] ; then
> +        rm -f $TMPFILE
> +        echo "$test_name: $test_description: skipped (quota not enabled)"
> +        return 0
> +fi
> +
>  . $cmd_dir/run_e2fsck
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

