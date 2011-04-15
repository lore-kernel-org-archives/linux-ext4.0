From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH V8 1/8] mm/fs: cleancache documentation
Date: Sat, 16 Apr 2011 03:54:39 +0900
Message-ID: <87mxjr4a6o.fsf@devron.myhome.or.jp>
References: <20110414211601.GA27691@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com,
        jlbec@evilplan.org, matthew@wil.cx, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-mm@kvack.org, hch@infradead.org, ngupta@vflare.org,
        jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com,
        npiggin@kernel.dk, dave.mccracken@oracle.com, riel@redhat.com,
        avi@redhat.com, konrad.wilk@oracle.com, mel@csn.ul.ie,
        yinghan@google.com, gthelen@google.com, torvalds@linux-foundation.org
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20110414211601.GA27691@ca-server1.us.oracle.com> (Dan
	Magenheimer's message of "Thu, 14 Apr 2011 14:16:01 -0700")
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Dan Magenheimer <dan.magenheimer@oracle.com> writes:

> [PATCH V8 1/8] mm/fs: cleancache documentation
>
> This patchset introduces cleancache, an optional new feature exposed
> by the VFS layer that potentially dramatically increases page cache
> effectiveness for many workloads in many environments at a negligible
> cost.  It does this by providing an interface to transcendent memory,
> which is memory/storage that is not otherwise visible to and/or directly
> addressable by the kernel.
>
> Instead of being discarded, hooks in the reclaim code "put" clean
> pages to cleancache.  Filesystems that "opt-in" may "get" pages 
> from cleancache that were previously put, but pages in cleancache are 
> "ephemeral", meaning they may disappear at any time. And the size
> of cleancache is entirely dynamic and unknowable to the kernel.
> Filesystems currently supported by this patchset include ext3, ext4,
> btrfs, and ocfs2.  Other filesystems (especially those built entirely
> on VFS) should be easy to add, but should first be thoroughly tested to
> ensure coherency.
>
> Details and a FAQ are provided in Documentation/vm/cleancache.txt
>
> This first patch of eight in this cleancache series only adds two
> new documentation files.

Another question: why can't this enable/disable per sb, e.g. via mount
options? (I have the interest the cache stuff like this by SSD on
physical systems like dragonfly's swapcache.)

Well, anyway, I guess force enabling this for mostly unused sb can just
add cache-write overhead and call for unpleasing reclaim to backend
(because of limited space of backend) like updatedb.

And already there is in FAQ though, I also have interest about async
interface because of SDD backend (I'm not sure for now though). Is there
any plan like SSD backend?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
