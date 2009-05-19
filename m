From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Documentation/filesystems/ext3.txt
Date: Tue, 19 May 2009 09:35:16 -0500
Message-ID: <4A12C3A4.90202@redhat.com>
References: <20090518212209.17c46cee@digital-domain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andrew Clayton <andrew@digital-domain.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40777 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbZESOfS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 May 2009 10:35:18 -0400
In-Reply-To: <20090518212209.17c46cee@digital-domain.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Clayton wrote:
> Update the ext3 document with the fact that data=writeback is now the
> default journaling mode.
> 
> 
> Signed-off-by: Andrew Clayton <andrew@digital-domain.net>
> 
> --- linux-2.6/Documentation/filesystems/ext3.txt.orig	2009-05-18 20:48:27.084220753 +0100
> +++ linux-2.6/Documentation/filesystems/ext3.txt	2009-05-18 20:49:01.023225288 +0100
> @@ -39,11 +39,11 @@
>  data=journal		All data are committed into the journal prior to being
>  			written into the main file system.
>  
> -data=ordered	(*)	All data are forced directly out to the main file
> +data=ordered		All data are forced directly out to the main file
>  			system prior to its metadata being committed to the
>  			journal.
>  
> -data=writeback		Data ordering is not preserved, data may be written
> +data=writeback	(*)	Data ordering is not preserved, data may be written
>  			into the main file system after its metadata has been
>  			committed to the journal.

If we're updating this documentation, while we're at it we should add
that the default is actually controlled by a new kernel config option,
and also something along the lines of "this mode will produce file
corruption on a power loss or unclean shutdown, and may lead to
unintentional information disclosure."

-Eric
