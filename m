From: Joe Perches <joe@perches.com>
Subject: Re: [RFC PATCH] mm: introduce kv[mz]alloc helpers
Date: Tue, 13 Dec 2016 14:07:33 -0800
Message-ID: <1481666853.29291.33.camel@perches.com>
References: <20161208103300.23217-1-mhocko@kernel.org>
	 <20161213101451.GB10492@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
 <vbabka@suse.cz>,  David Rientjes <rientjes@google.com>, Mel Gorman
 <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,  Anatoly Stepanov
 <astepanov@cloudlinux.com>, LKML <linux-kernel@vger.kernel.org>, Paolo
 Bonzini <pbonzini@redhat.com>,  Mike Snitzer <snitzer@redhat.com>,
 dm-devel@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, Theodore Ts'o
 <tytso@mit.edu>, kvm@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net,
 linux-security-module@vger.kernel.org,  Dave Chinner <david@fromorbit.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Mikulas Patocka <mpatocka@redhat.com>
To: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20161213101451.GB10492@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2016-12-13 at 11:14 +0100, Michal Hocko wrote:
> Are there any more comments or objections to this patch? Is this a good
> start or kv[mz]alloc has to provide a way to cover GFP_NOFS users as
> well in the initial version.

Did Andrew Morton ever comment on this?
I believe he was the primary objector in the past.

Last I recollect was over a year ago:

https://lkml.org/lkml/2015/7/7/1050


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
