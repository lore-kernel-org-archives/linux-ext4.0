From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH] ext3: handle corrupted orphan list at mount
Date: Tue, 24 Jun 2008 18:16:21 +0100
Message-ID: <e9e943910806241016v743ce19s28bdf34177154799@mail.gmail.com>
References: <20080607121940.8ee6044a.akpm@linux-foundation.org>
	 <1214258200-16623-1-git-send-email-duaneg@dghda.com>
	 <20080624160810.GC22586@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	"Sami Liedes" <sliedes@cc.hut.fi>
To: "Jan Kara" <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.184]:1844 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718AbYFXRQX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jun 2008 13:16:23 -0400
Received: by rn-out-0910.google.com with SMTP id k40so572942rnd.17
        for <linux-ext4@vger.kernel.org>; Tue, 24 Jun 2008 10:16:21 -0700 (PDT)
In-Reply-To: <20080624160810.GC22586@atrey.karlin.mff.cuni.cz>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/6/24 Jan Kara <jack@suse.cz>:
>> +     /*
>> +      * If the orphans has i_nlinks > 0 then it should be able to be
>> +      * truncated, otherwise it won't be removed from the orphan list
>> +      * during processing and an infinite loop will result.
>> +      */
>> +     if (inode->i_nlink && !ext3_can_truncate(inode))
>> +             goto bad_orphan;
>> +
>  Maybe I miss something but shouldn't above rather be ||?

No, it is correct. If i_nlink == 0 the orphan will be deleted in the
cleanup loop by the iput. If i_nlink > 0 then ext3_truncate is called,
which usually calls ext3_orphan_del on the way out, thereby removing
the node from the orphan list. However, if it exits too early
(basically if the ext3_can_truncate check fails, although there are
other failure conditions such as OOM that can also cause it to exit
early) then it doesn't, hence we end up in the infinite loop. So the
check here says, if this node is not going to be deleted or truncated
then it is invalid.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
