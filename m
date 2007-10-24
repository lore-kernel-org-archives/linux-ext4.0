From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Enable delalloc and mballoc by default.
Date: Wed, 24 Oct 2007 16:15:36 -0500
Message-ID: <471FB5F8.1090805@redhat.com>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <471F7F41.6080800@redhat.com> <20071024210639.GC26078@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbXJXVQD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Oct 2007 17:16:03 -0400
In-Reply-To: <20071024210639.GC26078@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Oct 24, 2007  12:22 -0500, Eric Sandeen wrote:
>> Aneesh Kumar K.V wrote:
>>> @@ -1279,6 +1280,9 @@ clear_qf_name:
>>>  		case Opt_delalloc:
>>>  			set_opt (sbi->s_mount_opt, DELALLOC);
>>>  			break;
>> If delalloc, mballoc, extents are the new defaults, is there a reason to
>> keep them as options?  When would you need to specify -o extents, now,
>> for example?  (though my brain is fuzzy today, maybe I'm missing
>> something)  If this were not a filesystem ending in "dev" I could see
>> keeping it for compatibility with existing fstabs....
> 
> It is useful to be able to mount w/o extents/delalloc/mballoc for perf
> testing and functional testing of the block-mapped file path in ext4.
> Also, some users might want the ability to use features of ext4 w/o
> the incompatibility of extents.

Right, I understand the reason for noextents, nodelalloc, nomballoc.
Above, I ask what is the point of having the *defaults* (extents,
delalloc, mballoc) as mount options?

-Eric
