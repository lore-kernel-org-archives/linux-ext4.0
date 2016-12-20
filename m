From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm: introduce kv[mz]alloc helpers
Date: Tue, 20 Dec 2016 14:13:41 -0800
Message-ID: <20161220141341.de8b22fd66ea9bc6c4fcf962@linux-foundation.org>
References: <20161208103300.23217-1-mhocko@kernel.org>
	<20161213101451.GB10492@dhcp22.suse.cz>
	<1481666853.29291.33.camel@perches.com>
	<20161214085916.GB25573@dhcp22.suse.cz>
	<20161220135016.GH3769@dhcp22.suse.cz>
	<1482255502.1984.21.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Vlastimil Babka
 <vbabka@suse.cz>, David Rientjes <rientjes@google.com>, Mel Gorman
 <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, Anatoly Stepanov
 <astepanov@cloudlinux.com>, LKML <linux-kernel@vger.kernel.org>, Paolo
 Bonzini <pbonzini@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 dm-devel@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>, "Theodore Ts'o"
 <tytso@mit.edu>, kvm@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net,
 linux-security-module@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Mikulas Patocka <mpatocka@redhat.com>
To: Joe Perches <joe@perches.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1482255502.1984.21.camel@perches.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 20 Dec 2016 09:38:22 -0800 Joe Perches <joe@perches.com> wrote:

> > So what are we going to do about this patch?
> 
> Well if Andrew doesn't object again, it should probably be applied.
> Unless his silence here acts like a pocket-veto.
> 
> Andrew?  Anything to add?

I guess we should give in to reality and do this, or something like it.
But Al said he was going to dig out some patches for us to consider?


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
