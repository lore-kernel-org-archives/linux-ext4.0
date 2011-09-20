From: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 3/4] mm: filemap: pass __GFP_WRITE from grab_cache_page_write_begin()
Date: Tue, 20 Sep 2011 14:40:39 -0400
Message-ID: <4E78DE27.1030906@redhat.com>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com> <1316526315-16801-4-git-send-email-jweiner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Johannes Weiner <jweiner@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1316526315-16801-4-git-send-email-jweiner@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On 09/20/2011 09:45 AM, Johannes Weiner wrote:
> Tell the page allocator that pages allocated through
> grab_cache_page_write_begin() are expected to become dirty soon.
>
> Signed-off-by: Johannes Weiner<jweiner@redhat.com>

Reviewed-by: Rik van Riel<riel@redhat.com>

The missing codepaths pointed out by Christoph either
create new anonymous pages, or mark ptes pointing at
existing page cache pages writeable.

Either way, those should not need __GFP_WRITE.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
