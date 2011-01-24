From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] radix_tree: radix_tree_gang_lookup_tag_slot may
	not return forever.
Date: Mon, 24 Jan 2011 15:27:39 +0100
Message-ID: <20110124142739.GA22410@atrey.karlin.mff.cuni.cz>
References: <20110121153431.acd113d8.toshi.okajima@jp.fujitsu.com> <20110121153154.1ca74dd2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Jan Kara <jack@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:43723 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751346Ab1AXO1n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Jan 2011 09:27:43 -0500
Content-Disposition: inline
In-Reply-To: <20110121153154.1ca74dd2.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Fri, 21 Jan 2011 15:34:31 +0900
> Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:
> 
> > Hi.
> > 
> > I executed fsstress and then found that the system hung up.
> > At that time, I took the crash dump. Here is the backtrace of the process
> > which causes this hangup.
> > 
> > [long description]
> >
> > --- a/lib/radix-tree.c
> > +++ b/lib/radix-tree.c
> > @@ -736,10 +736,11 @@ next:
> >  		}
> >  	}
> >  	/*
> > -	 * The iftag must have been set somewhere because otherwise
> > -	 * we would return immediated at the beginning of the function
> > +	 * We need not to tag the root tag if there is no tag which is set with
> > +	 * settag within the range from *first_indexp to last_index.
> >  	 */
> > -	root_tag_set(root, settag);
> > +	if (tagged > 0)
> > +		root_tag_set(root, settag);
> >  	*first_indexp = index;
> >  
> >  	return tagged;
> 
> Thanks.
> 
> It should be fairly simple to reproduce this hang with the userspace
> test harness (http://userweb.kernel.org/~akpm/stuff/rtth.tar.gz) and to
> then demonstrate that the fix fixes it.
> 
> If you have time, could you please do that and then send the rtth
> updates to me?
  Thanks for CCing me. The patch looks OK so feel free to add
Acked-by: Jan Kara <jack@suse.cz>
  But the changelog (~350 lines) was a bit too much for me ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
