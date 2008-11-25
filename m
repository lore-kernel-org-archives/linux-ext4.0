From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [RESEND][PATCH 2/3 BUG,RFC] ext3: release block-device-mapping
 buffer_heads which have the filesystem private data for avoiding	oom-killer
Date: Tue, 25 Nov 2008 10:00:56 +0900
Message-ID: <492B4E48.3080000@jp.fujitsu.com>
References: <20081120093450.c87b39ef.toshi.okajima@jp.fujitsu.com> <20081124055133.GB20928@mit.edu>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, sct@redhat.com,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36968 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbYKYBBI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 20:01:08 -0500
In-Reply-To: <20081124055133.GB20928@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
Thanks for your comments.

 > Hi Toshijuki,
 >
 > My apologizes for not getting back to you sooner.  My travel schedule
Never mind.

 > has been a little crazy lately, including being in Japan last week
 > speaking at the Japan Linux Symposium.
 >
 > Your patch series looks good, but I have one comment, for the ext3 and
 > ext4 patches:
 >
 > > +	if (journal != NULL)
 > > +		return journal_try_to_free_buffers(journal, page, wait);
 > > +	else
 > > +		return try_to_free_buffers(page);
 >
 > According to the documentation for journal_try_to_free_buffers():
 >
 >  * This function returns non-zero if we wish try_to_free_buffers()
 >  * to be called. We do this if the page is releasable by try_to_free_buffers().
 >  * We also do it if the page has locked or dirty buffers and the caller wants
 >  * us to perform sync or async writeout.
I forgot reading it.

 >
 > So I think the last conditional in ext3_release_metadata() needs to be
 > changed to be like this:
 >
 > +	if ((journal != NULL) &&
 > +	    (journal_try_to_free_buffers(journal, page, wait) == 0))
 > +		return 0;
 > +	return try_to_free_buffers(page);
 >
 > A similar change should be made in the ext4 version of the patch.
 > Does that sound OK to you?
Yes.

I will make and repost a revised patch which reflects your comments later.

 >
 > Regards,
 >
 > 						- Ted

Thanks again,
Toshiyuki Okajima

