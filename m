From: Dan Carpenter <error27@gmail.com>
Subject: locking typo in ext4_mb_add_n_trim()
Date: Fri, 27 Mar 2009 13:27:04 +0300 (EAT)
Message-ID: <Pine.LNX.4.64.0903262204430.4167@usbsys.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:22029 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbZC0KaW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Mar 2009 06:30:22 -0400
Received: by fg-out-1718.google.com with SMTP id e12so350481fga.17
        for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2009 03:30:20 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Smatch (http://repo.or.cz/w/smatch.git/) complains about the locking in 
ext4_mb_add_n_trim() from fs/ext4/mballoc.c

I think it's meant to be spin_unlock(&tmp_pa->pa_lock); on line 4442.

  4438          list_for_each_entry_rcu(tmp_pa, &lg->lg_prealloc_list[order],
  4439                                                  pa_inode_list) {
  4440                  spin_lock(&tmp_pa->pa_lock);
  4441                  if (tmp_pa->pa_deleted) {
  4442                          spin_unlock(&pa->pa_lock);
  4443                          continue;
  4444                  }

I can send a patch if I'm right or you could just give me a:
Reported-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter
