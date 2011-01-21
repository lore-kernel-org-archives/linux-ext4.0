From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] radix_tree: radix_tree_gang_lookup_tag_slot may
 not return forever.
Date: Fri, 21 Jan 2011 15:31:54 -0800
Message-ID: <20110121153154.1ca74dd2.akpm@linux-foundation.org>
References: <20110121153431.acd113d8.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Jan Kara <jack@ucw.cz>
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754220Ab1AUXcT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 18:32:19 -0500
In-Reply-To: <20110121153431.acd113d8.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 21 Jan 2011 15:34:31 +0900
Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:

> Hi.
> 
> I executed fsstress and then found that the system hung up.
> At that time, I took the crash dump. Here is the backtrace of the process
> which causes this hangup.
> 
> [long description]
>
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -736,10 +736,11 @@ next:
>  		}
>  	}
>  	/*
> -	 * The iftag must have been set somewhere because otherwise
> -	 * we would return immediated at the beginning of the function
> +	 * We need not to tag the root tag if there is no tag which is set with
> +	 * settag within the range from *first_indexp to last_index.
>  	 */
> -	root_tag_set(root, settag);
> +	if (tagged > 0)
> +		root_tag_set(root, settag);
>  	*first_indexp = index;
>  
>  	return tagged;

Thanks.

It should be fairly simple to reproduce this hang with the userspace
test harness (http://userweb.kernel.org/~akpm/stuff/rtth.tar.gz) and to
then demonstrate that the fix fixes it.

If you have time, could you please do that and then send the rtth
updates to me?

