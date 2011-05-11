From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 0/3] Reduce impact to overall system of SLUB using
 high-order allocations
Date: Wed, 11 May 2011 15:28:49 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1105111527490.24003@chino.kir.corp.google.com>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de> <1305149960.2606.53.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Colin King <colin.king@canonical.com>,
	Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
	Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1305149960.2606.53.camel@mulgrave.site>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 11 May 2011, James Bottomley wrote:

> OK, I confirm that I can't seem to break this one.  No hangs visible,
> even when loading up the system with firefox, evolution, the usual
> massive untar, X and even a distribution upgrade.
> 
> You can add my tested-by
> 

Your system still hangs with patches 1 and 2 only?
