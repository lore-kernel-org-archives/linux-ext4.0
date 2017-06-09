From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: RE: Re: [PATCH v2] ext4: change sequential discard handling on
 commit complete phase into parallel manner
Date: Fri, 09 Jun 2017 06:42:12 +0000
Message-ID: <20170609064212epcms1p6678460b1844ca9b16cce0e06d8bf3b1e@epcms1p6>
References: <20170608081937.GA31632@quack2.suse.cz>
        <1496886288-6290-1-git-send-email-daeho.jeong@samsung.com>
        <CGME20170608014457epcas1p2c2f6af76eee8ab0c20f8f9d8fbcae563@epcms1p6>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: "jack@suse.com" <jack@suse.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>, Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53789 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdFIGmO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Jun 2017 02:42:14 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20170609064213epoutp02a9b002d056e766b1f7903a40fdcc9b11~GYPVYC21x1423114231epoutp02L
        for <linux-ext4@vger.kernel.org>; Fri,  9 Jun 2017 06:42:13 +0000 (GMT)
In-Reply-To: <20170608081937.GA31632@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Hmm, here you speak about 17s, in the above paragraph about half a minute

> so what was it? Just curious...



Oh, you're are right. 17.0s is true.

 

> Actually, I didn't give my 'Reviewed-by' tag yet... But the patch looks

> generally good, some smaller comments below.



Sorry, I don't know how to use the tag exactly.



> Use list_for_each_entry_safe() instead of explicit list_entry() call.

 

> Just find the right entry in the above loop and then use

> list_cut_position() to split the list as needed. That saves us having to

> remove and add each entry. Also you don't have to use _safe() list entry

> iteration in that case.



> efd_freed can never be true here - see my explanation at the end. So you

> can simplify the code by implementing something like:

 

> void ext4_try_merge_freed_extent(struct ext4_sb_info *sbi,

>                                  struct ext4_free_data *entry,

>                                  struct ext4_free_data *new_entry)

> {

>         if ((entry->efd_tid != new_entry->efd_tid) ||

>             (entry->efd_group != new_entry->efd_group))

>                 return;

>         if (entry->efd_start_cluster + entry->efd_count ==

>             new_entry->efd_start_cluster) {

>                 new_entry->efd_start_cluster = entry->efd_start_cluster;

>                 new_entry->efd_count += entry->efd_count;

>         } else if (new_entry->efd_start_cluster + new_entry->efd_count ==

>                    entry->efd_start_cluster) {

>                 new_entry->efd_count += entry->efd_count;

>         }

>         spin_lock(&sbi->s_md_lock);

>         list_del(&entry->efd_list);

>         spin_unlock(&sbi->s_md_lock);

>         rb_erase(entry->efd_node, &(db->bb_free_root));

>         kmem_cache_free(ext4_free_data_cachep, entry);

> }

 

> which should handle all that is needed in one place.

 

> Two comments here:

 

> a) 'bool' type in structures is discouraged in kernel as it can lead to

> strange alignment issues etc. Just use int or bitfields.

 

> b) efd_freed seems in fact unnecessary. You use it only in

> ext4_freed_data_try_del() which is called only if merge succeeded which

> means tids match and thus we currently have handle open against the

> transaction with that pid and so that transaction cannot commit... So all

> in all efd_freed can never be set in the places where you call

> ext4_freed_data_try_del().

 

> Thanks for working on this!

 

I like the modified version. It looks neat.

Thank you for your valuable comments.

 

 
