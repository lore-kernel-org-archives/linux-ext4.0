From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: ll_ver_fs data verification failure - 96TB fs
Date: Thu, 06 Aug 2009 18:54:32 -0400
Message-ID: <19332.1249599272@alphaville.usa.hp.com>
References: <28623.1249307676@gamaville.dokosmarshall.org> <20090806200400.GC1800@shell> <18249.1249591034@alphaville.usa.hp.com> <20090806205002.GH3340@webber.adilger.int> <18690.1249594088@alphaville.usa.hp.com> <18822.1249594980@alphaville.usa.hp.com>  <18945.1249596064@alphaville.usa.hp.com>
Reply-To: nicholas.dokos@hp.com
Cc: Valerie Aurora <vaurora@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:47969 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbZHFWy3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2009 18:54:29 -0400
Cc: nicholas.dokos@hp.com
In-Reply-To: Message from Nick Dokos <nicholas.dokos@hp.com>
   of "Thu, 06 Aug 2009 18:01:04 EDT." <18945.1249596064@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> ... 
> The code should  perhaps read something like this:
> 
>  		if ((nread = read(fd, chunk_buf, chunksize)) < 0) {
>  			fprintf(stderr, "\n%s: read %s+%llu failed: %s\n",
>  				progname, file, offset, strerror(errno));
>  			return 1;
>  		}
>                 if (nread < chunksize) {
>                         fprintf(stderr, "short read etc");
>                         /* or force the next read() to check for errors? */
>                         return 1;
>                 }
>  		if (verify_chunk(chunk_buf, chunksize, offset, time_st,
>  				 inode_st, file) != 0)
>  			return 1;
> 

... except that the write() side also does not deal with short writes,
and for a full run, the last file of the last directory will probably be
short even if no errors occur. In that case, the short read is not an
error.

Thanks,
Nick
