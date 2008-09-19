From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] [RFC] jbd2: Add buffer triggers
Date: Fri, 19 Sep 2008 15:46:25 -0600
Message-ID: <20080919214625.GK10950@webber.adilger.int>
References: <20080917232629.GB20752@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:46694 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbYISVqm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Sep 2008 17:46:42 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8JLkfIj004142
	for <linux-ext4@vger.kernel.org>; Fri, 19 Sep 2008 14:46:41 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7G00701PNJIV00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 19 Sep 2008 14:46:41 -0700 (PDT)
In-reply-to: <20080917232629.GB20752@mail.oracle.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 17, 2008  16:26 -0700, Joel Becker wrote:
> +	/* We have the actual buffer to go out, fire any commit trigger */
> +	/* XXX Checking trigger pointers here so as to skip kmap when
> +	 * empty */
> +	if (jh_in->b_triggers && jh_in->b_triggers->t_commit) {
> +		mapped_data = kmap_atomic(new_page, KM_USER0);
> +
> +		jbd2_buffer_commit_trigger(jh_in, mapped_data + new_offset);
> +		kunmap_atomic(mapped_data, KM_USER0);
> +	}

In many cases the kmap will not be needed (i.e. never for ext* because the
metadata buffers will always be allocated in low memory).

> index 8a62d1e..087a1c2 100644
> --- a/include/linux/journal-head.h
> +++ b/include/linux/journal-head.h
> @@ -87,6 +89,9 @@ struct journal_head {
>  	struct journal_head *b_cpnext, *b_cpprev;
> +
> +	/* Trigger type */
> +	struct jbd2_buffer_trigger_type *b_triggers;
>  };

The journal-head.h header is shared between jbd.h and jbd2.h, so it seems
a bit strange to have a jbd2_* struct here.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

