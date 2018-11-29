Return-Path: <SRS0=G5ay=OI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39078 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726565AbeK2UJf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Nov 2018 15:09:35 -0500
Date: Thu, 29 Nov 2018 10:04:50 +0100
From: Michal Hocko <mhocko@kernel.org>
To: Nikolay Borisov <nborisov@suse.com>
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
Subject: Re: [PATCH 2/2] fs: Don't open-code lru_to_page
Message-ID: <20181129090450.GR6923@dhcp22.suse.cz>
References: <20181129075301.29087-1-nborisov@suse.com>
 <20181129075301.29087-2-nborisov@suse.com>
 <20181129081826.GO6923@dhcp22.suse.cz>
 <0921bc8f-b899-4925-51f2-a9f45d4c906a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0921bc8f-b899-4925-51f2-a9f45d4c906a@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 29-11-18 10:50:08, Nikolay Borisov wrote:
> 
> 
> On 29.11.18 г. 10:18 ч., Michal Hocko wrote:
> > On Thu 29-11-18 09:52:57, Nikolay Borisov wrote:
> >> There are a bunch of filesystems which essentially open-code lru_to_page
> >> helper. Change them to using the helper. No functional changes.
> > 
> > I would just squash the two into a single patch. It makes the first one
> > more obvious. Or is there any reason to have them separate?
> 
> No reason, just didn't know how people would react so that's why I chose
> to send as two separate.

This is a matter of taste I guess. But I usually prefer to have callers
along with a new helper in a single patch. This is not a new helper
per-se but doing it the same way seems reasonable to me. Not that I
would insist of course. You can use my ack for both patch in case you
decide to leave it as is.

> If I squash them who would be the best person to take them ?

Sounds like a mmotm material to me.
-- 
Michal Hocko
SUSE Labs
