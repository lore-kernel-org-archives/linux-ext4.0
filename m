From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch 3/5] mm: try to distribute dirty pages fairly across zones
Date: Fri, 30 Sep 2011 10:35:25 +0300
Message-ID: <CAOJsxLFWfH5zDG8ui=yQyOcZY_nXhK6r+ziapLg9Zhmb3ibuWQ@mail.gmail.com>
References: <1317367044-475-1-git-send-email-jweiner@redhat.com>
	<1317367044-475-4-git-send-email-jweiner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
	Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
	Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@redhat.com>,
	Minchan Kim <minchan.kim@gmail.com>, Chris Mason <chris.mason@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
	Shaohua Li <shaohua.li@intel.com>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Johannes Weiner <jweiner@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1317367044-475-4-git-send-email-jweiner@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Hi Johannes!

On Fri, Sep 30, 2011 at 10:17 AM, Johannes Weiner <jweiner@redhat.com> wrot=
e:
> But there is a flaw in that we have a zoned page allocator which does
> not care about the global state but rather the state of individual
> memory zones. =A0And right now there is nothing that prevents one zone
> from filling up with dirty pages while other zones are spared, which
> frequently leads to situations where kswapd, in order to restore the
> watermark of free pages, does indeed have to write pages from that
> zone's LRU list. =A0This can interfere so badly with IO from the flusher
> threads that major filesystems (btrfs, xfs, ext4) mostly ignore write
> requests from reclaim already, taking away the VM's only possibility
> to keep such a zone balanced, aside from hoping the flushers will soon
> clean pages from that zone.

The obvious question is: how did you test this? Can you share the results?

                        Pekka

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
