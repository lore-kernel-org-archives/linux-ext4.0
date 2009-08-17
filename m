From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Mon, 17 Aug 2009 14:29:24 GMT
Message-ID: <200908171429.n7HETO5M004352@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59569 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbZHQO3X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Aug 2009 10:29:23 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7HETOiG004353
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2009 14:29:24 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909





--- Comment #30 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-08-17 14:29:19 ---
Reply-To: rwheeler@redhat.com

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

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
