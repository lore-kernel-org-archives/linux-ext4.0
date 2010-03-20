From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_discard_preallocations
Date: Sat, 20 Mar 2010 22:05:13 +0800
Message-ID: <ac8f92701003200705u2bb6b65p4adce7b79f250705@mail.gmail.com>
References: <ac8f92701003180539h7228040bm82a0c69d678ec93b@mail.gmail.com>
	 <20100318174629.GK8256@thunk.org>
	 <ac8f92701003190717u19334b4ei58e4829e4651db22@mail.gmail.com>
	 <67790F0F-9921-4A98-8DC6-DA1C00CE6CA9@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu, linux-ext4 <linux-ext4@vger.kernel.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56514 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0CTOFP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Mar 2010 10:05:15 -0400
Received: by gwaa18 with SMTP id a18so237398gwa.19
        for <linux-ext4@vger.kernel.org>; Sat, 20 Mar 2010 07:05:14 -0700 (PDT)
In-Reply-To: <67790F0F-9921-4A98-8DC6-DA1C00CE6CA9@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/3/20, Andreas Dilger <adilger@sun.com>:
> On 2010-03-19, at 08:17, jing zhang wrote:
>>>> 		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
>>>> @@ -3811,6 +3813,12 @@ repeat:
>>>> 		list_del(&pa->u.pa_tmp_list);
>>>> 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
>>>> 	}
>>>> +	if (! list_empty(&list)) {
>>>> +		if (occurs++ < 2)
>>>> +			goto best_efforts;
>>>> +		else
>>>> +			BUG();
>>>> +	}
>>>> 	if (ac)
>>>> 		kmem_cache_free(ext4_ac_cachep, ac);
>>>> }
>>>
>>> Hmm, I'm not sure that BUG() is appropriate here.  If there is an
>>> I/O error reading the block bitmap, #1, retrying isn't going to help,
>>> and #2, bringing down the entire system just because of an I/O error
>>> in reading the block bitmap doesn't seem right.
>>
>> But disk hardware error is not rare,
>
> Exactly, which is the reason why it should not cause the system to
> hang.  The filesystem should handle such errors gracefully if this is
> possible, return an error to the application, and/or marking the
> filesystem in error so that it will be checked on next boot, or similar.
>
>>> Right now, if there is a problem, we just end up leaving the
>>> preallocated list on the inode.  Does that cause problems later on
>>> down the line which you have observed?
>>>
>>> 					- Ted
>>
>> and is there still chance to call the
>>       call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
>> function again later on? (I am not sure yet the chance does exist.)
>>
>> If no chance, how about the kmem_cache subsystem then?
>> After reboot, the file system is still reliable, or just with a few
>> lost blocks?
>>
>> Thus it is necessary, at least for me, to make sure whether the
>> chance exists.
>>                                      - zj
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-
>> ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.

Evening,

Thanks Andreas and Ted for your good explanations to deal error in
gentle way, and I got it that the chance may exist since the pa is not
deleted from its group_list yet.

And it also seems that there is work deserved.
       - zj

---

--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ fs/mballoc.c	2010-03-20 21:40:04.000000000 +0800
@@ -3788,14 +3788,14 @@ repeat:
 		err = ext4_mb_load_buddy(sb, group, &e4b);
 		if (err) {
 			ext4_error(sb, __func__, "Error in loading buddy "
-					"information for %u", group);
+			"information for group %u inode %lu", group, inode->i_ino);
 			continue;
 		}

 		bitmap_bh = ext4_read_block_bitmap(sb, group);
 		if (bitmap_bh == NULL) {
 			ext4_error(sb, __func__, "Error in reading block "
-					"bitmap for %u", group);
+			"bitmap for group %u inode %lu", group, inode->i_ino);
 			ext4_mb_release_desc(&e4b);
 			continue;
 		}
@@ -3811,6 +3811,14 @@ repeat:
 		list_del(&pa->u.pa_tmp_list);
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}
+	if (! list_empty(&list)) {
+		/*
+		 * we have to do something for the check in
+		 * the function, ext4_mb_discard_group_preallocations()
+		 */
+		list_for_each_entry(pa, &list, u.pa_tmp_list)
+			pa->pa_deleted = 0;
+	}
 	if (ac)
 		kmem_cache_free(ext4_ac_cachep, ac);
 }
