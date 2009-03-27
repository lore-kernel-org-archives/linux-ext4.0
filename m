From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: locking typo in ext4_mb_add_n_trim()
Date: Fri, 27 Mar 2009 09:16:59 -0500
Message-ID: <49CCDFDB.9000109@redhat.com>
References: <Pine.LNX.4.64.0903262204430.4167@usbsys.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34005 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbZC0ORI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 10:17:08 -0400
In-Reply-To: <Pine.LNX.4.64.0903262204430.4167@usbsys.site>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dan Carpenter wrote:
> Smatch (http://repo.or.cz/w/smatch.git/) complains about the locking in 
> ext4_mb_add_n_trim() from fs/ext4/mballoc.c
> 
> I think it's meant to be spin_unlock(&tmp_pa->pa_lock); on line 4442.
> 
>   4438          list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
>   4439                                                  pa_inode_list) {
>   4440                  spin_lock(&tmp_pa->pa_lock);
>   4441                  if (tmp_pa->pa_deleted) {
>   4442                          spin_unlock(&pa->pa_lock);
>   4443                          continue;
>   4444                  }
> 
> I can send a patch if I'm right or you could just give me a:
> Reported-by: Dan Carpenter <error27@gmail.com>

Seems right to me,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

although I wonder why we don't trip over this in spinlock debugging
(seems like it'd lead to a double unlock at times)  I wonder if we can
tie this to any other bugs we've seen.

Thanks,
-Eric
