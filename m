From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Mon, 17 Aug 2009 10:31:21 -0400
Message-ID: <4A8969B9.7000905@redhat.com>
References: <bug-13909-13602@http.bugzilla.kernel.org/> <200908151354.n7FDsmWp001652@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48195 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbZHQO3Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Aug 2009 10:29:16 -0400
In-Reply-To: <200908151354.n7FDsmWp001652@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/15/2009 09:54 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13909
>
>
>
>
>
> --- Comment #28 from Roland Kletzing<devzero@web.de>   2009-08-15 13:54:43 ---
> rus,any chance to try the attached patch and confirm if it is the real fix for
> the problem ?
>
>
>
> We're now able to duplicate this bug. Not sure why it only affects ext4.
>
> ima: kernel_read parm integer overflow bugfix
>
> Reading large files>2G causes process to loop.
> (http://bugzilla.kernel.org/show_bug.cgi?id=13909)
>
> Signed-off-by: Mimi Zohar<zohar@us.ibm.com>
>
> Index: security-testing-2.6/security/integrity/ima/ima_crypto.c
> ===================================================================
> --- security-testing-2.6.orig/security/integrity/ima/ima_crypto.c
> +++ security-testing-2.6/security/integrity/ima/ima_crypto.c
> @@ -47,7 +47,8 @@ int ima_calc_hash(struct file *file, cha
> struct scatterlist sg[1];
> loff_t i_size;
> char *rbuf;
> - int rc, offset = 0;
> + unsigned long offset = 0;
> + int rc;
>
> rc = init_desc(&desc);
> if (rc != 0)
>
>    

I suspect that you will need to use the official offset type to avoid 
overflow at 4GB - loff_t should be more consistent,

Ric


