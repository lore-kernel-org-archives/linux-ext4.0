From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RESEND][PATCH 2/3 BUG,RFC] ext3: release block-device-mapping
	buffer_heads which have the filesystem private data for avoiding
	oom-killer
Date: Mon, 24 Nov 2008 00:51:33 -0500
Message-ID: <20081124055133.GB20928@mit.edu>
References: <20081120093450.c87b39ef.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, sct@redhat.com,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081120093450.c87b39ef.toshi.okajima@jp.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Toshijuki,

My apologizes for not getting back to you sooner.  My travel schedule
has been a little crazy lately, including being in Japan last week
speaking at the Japan Linux Symposium.

Your patch series looks good, but I have one comment, for the ext3 and
ext4 patches:

> +	if (journal != NULL)
> +		return journal_try_to_free_buffers(journal, page, wait);
> +	else
> +		return try_to_free_buffers(page);

According to the documentation for journal_try_to_free_buffers():

 * This function returns non-zero if we wish try_to_free_buffers()
 * to be called. We do this if the page is releasable by try_to_free_buffers().
 * We also do it if the page has locked or dirty buffers and the caller wants
 * us to perform sync or async writeout.

So I think the last conditional in ext3_release_metadata() needs to be
changed to be like this:

+	if ((journal != NULL) && 
+	    (journal_try_to_free_buffers(journal, page, wait) == 0))
+		return 0;
+	return try_to_free_buffers(page);

A similar change should be made in the ext4 version of the patch.
Does that sound OK to you?

Regards,

						- Ted
