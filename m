Return-Path: <SRS0=G5ay=OI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49832 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbeK2VRF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Nov 2018 16:17:05 -0500
Subject: Re: [PATCH 2/2] fs: Don't open-code lru_to_page
To: Michal Hocko <mhocko@kernel.org>,
        Nikolay Borisov <nborisov@suse.com>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Steve French <sfrench@samba.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Matthew Wilcox <willy@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Shakeel Butt <shakeelb@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, devel@lists.orangefs.org,
        linux-mm@kvack.org
References: <20181129075301.29087-1-nborisov@suse.com>
 <20181129075301.29087-2-nborisov@suse.com>
 <20181129081826.GO6923@dhcp22.suse.cz>
From: David Hildenbrand <david@redhat.com>
Message-ID: <38bdc5f7-63b5-7276-921f-258ee876c45b@redhat.com>
Date: Thu, 29 Nov 2018 11:12:07 +0100
MIME-Version: 1.0
In-Reply-To: <20181129081826.GO6923@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 29.11.18 09:18, Michal Hocko wrote:
> On Thu 29-11-18 09:52:57, Nikolay Borisov wrote:
>> There are a bunch of filesystems which essentially open-code lru_to_page
>> helper. Change them to using the helper. No functional changes.
> 
> I would just squash the two into a single patch. It makes the first one
> more obvious. Or is there any reason to have them separate?
> 
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

mm_inline.h is 99.9% about lru and there is barely anything about lru in
mm.h. However this simple macro seems to differ from the other inlined
functions.

So to the squashed patch

Reviewed-by: David Hildenbrand <david@redhat.com>


-- 

Thanks,

David / dhildenb
